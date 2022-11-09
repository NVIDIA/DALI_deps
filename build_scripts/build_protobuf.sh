#!/bin/bash -xe

# Copyright (c) 2021, NVIDIA CORPORATION. All rights reserved.
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

# protobuf, make two steps for cross compilation if needed
pushd third_party/protobuf
mkdir -p build
cd build
    CFLAGS="-fPIC" \
    CXXFLAGS="-fPIC" \
cmake -DCMAKE_BUILD_TYPE=Release -Dprotobuf_BUILD_TESTS=OFF \
      -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=${HOST_INSTALL_PREFIX} ..
    CFLAGS="-fPIC" \
    CXXFLAGS="-fPIC" \
make -j"$(grep ^processor /proc/cpuinfo | wc -l)"
make install
# only when cross compiling
if [ "${CC_COMP}" != "gcc" ]; then
  rm -rf *
  echo "set(CMAKE_SYSTEM_NAME Linux)" > toolchain.cmake
  echo "set(CMAKE_SYSTEM_PROCESSOR ${CMAKE_TARGET_ARCH})" >> toolchain.cmake
  echo "set(CMAKE_C_COMPILER ${CC_COMP})" >> toolchain.cmake
      CFLAGS="-fPIC" \
      CXXFLAGS="-fPIC" \
      CC=${CC_COMP} \
      CXX=${CXX_COMP} \
  cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake \
        -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
        -DWITH_PROTOC=${HOST_INSTALL_PREFIX}/bin/protoc -Dprotobuf_BUILD_TESTS=OFF \
        -DCMAKE_SYSROOT=${SYSROOT_ARG} ..
      CFLAGS="-fPIC" \
      CXXFLAGS="-fPIC" \
      CC=${CC_COMP} \
      CXX=${CXX_COMP} \
  make -j"$(grep ^processor /proc/cpuinfo | wc -l)"
  make install
fi
popd
