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

# OpenSSL, installed into the shared prefix as static, position independent
# libraries. google-cloud-cpp and gRPC locate it with find_package(OpenSSL) and
# so does DALI, through google_cloud_cpp_storage's exported CMake config.
#
# build_aws-sdk-cpp.sh builds this submodule too, but into a private prefix of
# its own, so both builds configure the source tree in place and the second one
# simply reconfigures and rebuilds it.
export ROOT_DIR=$(realpath "${ROOT_DIR:-$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..}")
source "${ROOT_DIR}/build_scripts/validate_toolchain_env.sh"
: "${INSTALL_PREFIX:=${HOST_INSTALL_PREFIX:-/usr/local}}"

pushd "${ROOT_DIR}/third_party/openssl"
declare -a OPTS
OPTS+=(no-shared)
OPTS+=(no-tests)
OPTS+=(--libdir=lib)
OPTS+=(--prefix=${INSTALL_PREFIX})
OPTS+=(--openssldir=${INSTALL_PREFIX}/ssl)
OPENSSL_TARGET_ARCH=${CMAKE_TARGET_ARCH:-$(uname -m)}
case "$OPENSSL_TARGET_ARCH" in
  x86_64)
    OPTS+=(linux-x86_64)
    ;;
  aarch64)
    OPTS+=(linux-aarch64)
    ;;
esac
CC="${CC_COMP:-gcc}" CXX="${CXX_COMP:-g++}" CPPFLAGS="${CPPFLAGS:-}" \
  CFLAGS="${CFLAGS:-} -fPIC -Wa,--noexecstack" \
  CXXFLAGS="${CXXFLAGS:-} -fPIC -Wa,--noexecstack" LDFLAGS="${LDFLAGS:-}" \
  ./Configure "${OPTS[@]}"
make -j"$(nproc)"
make install_sw install_ssldirs
popd
