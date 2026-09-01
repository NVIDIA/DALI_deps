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

# GoogleTest/GoogleMock. google-cloud-cpp builds its mocking libraries by
# default (GOOGLE_CLOUD_CPP_WITH_MOCKS) and requires GTest for them, so it has
# to be installed into the prefix even though DALI itself does not use it.
export ROOT_DIR=$(realpath "${ROOT_DIR:-$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..}")
source "${ROOT_DIR}/build_scripts/validate_toolchain_env.sh"
source "${ROOT_DIR}/build_scripts/generate_toolchain_file.sh"
: "${INSTALL_PREFIX:=${HOST_INSTALL_PREFIX:-/usr/local}}"

pushd "${ROOT_DIR}/third_party/googletest"
mkdir -p build
cd build
generate_toolchain_file toolchain.cmake
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake \
      -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
      -DCMAKE_CXX_STANDARD=17 \
      -DBUILD_SHARED_LIBS=OFF \
      -DBUILD_GMOCK=ON \
      -DINSTALL_GTEST=ON \
      ..
make -j"$(nproc)"
make install
popd
