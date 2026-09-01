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

# libcurl, installed into the shared prefix as a static, position independent
# library. It is the HTTP transport of google-cloud-cpp's REST layer, which is
# what the GCS client is built on.
#
# The build directory is not the one used by build_aws-sdk-cpp.sh: that build
# caches OpenSSL paths pointing into the AWS SDK's private prefix.
export ROOT_DIR=$(realpath "${ROOT_DIR:-$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..}")
source "${ROOT_DIR}/build_scripts/validate_toolchain_env.sh"
source "${ROOT_DIR}/build_scripts/generate_toolchain_file.sh"
: "${INSTALL_PREFIX:=${HOST_INSTALL_PREFIX:-/usr/local}}"

pushd "${ROOT_DIR}/third_party/curl"
mkdir -p build-prefix
cd build-prefix
generate_toolchain_file toolchain.cmake
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake \
      -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
      -DCMAKE_PREFIX_PATH=${INSTALL_PREFIX} \
      -DBUILD_SHARED_LIBS=OFF \
      -DBUILD_STATIC_LIBS=ON \
      -DBUILD_CURL_EXE=OFF \
      -DCURL_USE_OPENSSL=ON \
      -DOPENSSL_ROOT_DIR=${INSTALL_PREFIX} \
      -DOPENSSL_USE_STATIC_LIBS=ON \
      -DCURL_CA_PATH_AUTODETECT=ON \
      -DCURL_CA_BUNDLE_AUTODETECT=ON \
      -DCURL_USE_LIBPSL=OFF \
      ..
make -j"$(nproc)"
make install
popd
