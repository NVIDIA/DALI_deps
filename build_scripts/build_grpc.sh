#!/bin/bash -xe

# Copyright (c) 2026, NVIDIA CORPORATION. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# gRPC. google-cloud-cpp needs it for the always-enabled monitoring, trace and
# opentelemetry features that its GCS client pulls in, and for the grpc_cpp_plugin
# used to generate the stubs.
#
# Protobuf, Abseil (installed together with protobuf), zlib and OpenSSL are taken
# from the install prefix rather than from gRPC's own submodules - building them
# again here would install a second, differently versioned copy over the one the
# rest of DALI's dependencies were compiled against. c-ares and re2 have no such
# counterpart, so they do come from the submodules.
export ROOT_DIR=$(realpath "${ROOT_DIR:-$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..}")
source "${ROOT_DIR}/build_scripts/validate_toolchain_env.sh"
source "${ROOT_DIR}/build_scripts/generate_toolchain_file.sh"
: "${HOST_INSTALL_PREFIX:=/usr/local}"
: "${INSTALL_PREFIX:=${HOST_INSTALL_PREFIX}}"

JOBS=$(nproc)

pushd "${ROOT_DIR}/third_party/grpc"

# c-ares and re2 live in gRPC's own submodules and, unlike gRPC's proto
# dependencies, have no download fallback in its CMake files. The recursive
# clone described in README.rst brings them in; fetch them here as well so that
# a checkout that only went one level deep still builds.
for GRPC_SUBMODULE in third_party/cares/cares third_party/re2; do
  if [[ -z $(ls -A "${GRPC_SUBMODULE}" 2>/dev/null) ]]; then
    git submodule update --init --depth 1 "${GRPC_SUBMODULE}"
  fi
done

# Cross compilation only: the target grpc_cpp_plugin cannot run on the host, so
# build a host one first. gRPC picks it up with find_program(), and protoc comes
# from the host stage of build_protobuf.sh the same way.
if [[ -n ${CC_COMP:-} && ${CC_COMP} != gcc ]]; then
  mkdir -p build-host
  pushd build-host
  cmake -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=${HOST_INSTALL_PREFIX} \
        -DCMAKE_PREFIX_PATH=${HOST_INSTALL_PREFIX} \
        -DCMAKE_CXX_STANDARD=17 \
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
        -DBUILD_SHARED_LIBS=OFF \
        -DgRPC_INSTALL=OFF \
        -DgRPC_BUILD_TESTS=OFF \
        -DgRPC_PROTOBUF_PROVIDER=package \
        -DgRPC_ABSL_PROVIDER=package \
        ..
  make -j"${JOBS}" grpc_cpp_plugin
  install -D -m 755 grpc_cpp_plugin "${HOST_INSTALL_PREFIX}/bin/grpc_cpp_plugin"
  popd
fi

mkdir -p build
cd build
generate_toolchain_file toolchain.cmake
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake \
      -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
      -DCMAKE_PREFIX_PATH=${INSTALL_PREFIX} \
      -DCMAKE_CXX_STANDARD=17 \
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
      -DBUILD_SHARED_LIBS=OFF \
      -DgRPC_INSTALL=ON \
      -DgRPC_BUILD_TESTS=OFF \
      -DgRPC_ZLIB_PROVIDER=package \
      -DgRPC_PROTOBUF_PROVIDER=package \
      -DgRPC_ABSL_PROVIDER=package \
      -DgRPC_SSL_PROVIDER=package \
      -DgRPC_CARES_PROVIDER=module \
      -DgRPC_RE2_PROVIDER=module \
      -DOPENSSL_ROOT_DIR=${INSTALL_PREFIX} \
      -DOPENSSL_USE_STATIC_LIBS=ON \
      -DgRPC_BUILD_GRPC_CSHARP_PLUGIN=OFF \
      -DgRPC_BUILD_GRPC_NODE_PLUGIN=OFF \
      -DgRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN=OFF \
      -DgRPC_BUILD_GRPC_PHP_PLUGIN=OFF \
      -DgRPC_BUILD_GRPC_PYTHON_PLUGIN=OFF \
      -DgRPC_BUILD_GRPC_RUBY_PLUGIN=OFF \
      ..
make -j"${JOBS}"
make install
popd
