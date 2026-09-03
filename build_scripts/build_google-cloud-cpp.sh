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

# Google Cloud C++ client libraries. DALI only uses Google Cloud Storage, so
# `storage` is the single entry in GOOGLE_CLOUD_CPP_ENABLE - the ~200 other GA
# libraries are left out. google_cloud_cpp_enable_deps() then adds monitoring,
# trace, opentelemetry and universe_domain on top of whatever was asked for, which
# is where the gRPC and opentelemetry-cpp dependencies come from. They can be
# turned off by listing them as `-monitoring` and so on, at the cost of the
# storage client's tracing support.
#
# The googleapis protobuf definitions are not vendored here: google-cloud-cpp
# downloads the pinned, checksummed tarball while configuring. Point
# GOOGLE_CLOUD_CPP_OVERRIDE_GOOGLEAPIS_URL at a local copy to build offline.
export ROOT_DIR=$(realpath "${ROOT_DIR:-$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..}")
source "${ROOT_DIR}/build_scripts/validate_toolchain_env.sh"
source "${ROOT_DIR}/build_scripts/generate_toolchain_file.sh"
: "${HOST_INSTALL_PREFIX:=/usr/local}"
: "${INSTALL_PREFIX:=${HOST_INSTALL_PREFIX}}"

declare -a EXTRA_CMAKE_ARGS
# Cross compilation only: protoc and grpc_cpp_plugin have to be the host builds,
# the ones installed next to the target libraries cannot be executed here.
if [[ -n ${CC_COMP:-} && ${CC_COMP} != gcc ]]; then
  EXTRA_CMAKE_ARGS+=(-DProtobuf_PROTOC_EXECUTABLE=${HOST_INSTALL_PREFIX}/bin/protoc)
  EXTRA_CMAKE_ARGS+=(-DGOOGLE_CLOUD_CPP_GRPC_PLUGIN_EXECUTABLE=${HOST_INSTALL_PREFIX}/bin/grpc_cpp_plugin)
fi

pushd "${ROOT_DIR}/third_party/google-cloud-cpp"
mkdir -p build
cd build
generate_toolchain_file toolchain.cmake
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake \
      -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
      -DCMAKE_PREFIX_PATH=${INSTALL_PREFIX} \
      -DCMAKE_CXX_STANDARD=17 \
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
      -DBUILD_SHARED_LIBS=OFF \
      -DBUILD_TESTING=OFF \
      -DGOOGLE_CLOUD_CPP_ENABLE=storage \
      -DGOOGLE_CLOUD_CPP_ENABLE_EXAMPLES=OFF \
      -DOPENSSL_ROOT_DIR=${INSTALL_PREFIX} \
      -DOPENSSL_USE_STATIC_LIBS=ON \
      "${EXTRA_CMAKE_ARGS[@]}" \
      ..
make -j"$(nproc)"
make install
popd
