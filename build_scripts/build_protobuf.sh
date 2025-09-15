#!/bin/bash -xe

# Copyright (c) 2021-2025, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
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
# Dprotobuf_FORCE_FETCH_DEPENDENCIES to ensure we don't use host dependencies
    CFLAGS="-fPIC" \
    CXXFLAGS="-fPIC -std=c++17" \
cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=${HOST_INSTALL_PREFIX} \
      -DBUILD_SHARED_LIBS=OFF \
      -Dprotobuf_BUILD_TESTS=OFF \
      -Dprotobuf_FORCE_FETCH_DEPENDENCIES=ON \
      ..
make -j"$(grep ^processor /proc/cpuinfo | wc -l)"
make install
# only when cross compiling
if [ "${CC_COMP}" != "gcc" ]; then
  rm -rf *
  echo "set(CMAKE_SYSTEM_NAME Linux)" > toolchain.cmake
  echo "set(CMAKE_SYSTEM_PROCESSOR ${CMAKE_TARGET_ARCH})" >> toolchain.cmake
  echo "set(CMAKE_C_COMPILER ${CC_COMP})" >> toolchain.cmake
  echo "set(CMAKE_CXX_COMPILER ${CXX_COMP})" >> toolchain.cmake
  echo "set(CMAKE_FIND_ROOT_PATH ${INSTALL_PREFIX})" >> toolchain.cmake
  echo "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)" >> toolchain.cmake
  echo "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)" >> toolchain.cmake
  echo "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)" >> toolchain.cmake
  # use ' to avoid bash substitution for CMAKE_C* variables
  echo 'set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")' >> toolchain.cmake
  echo 'set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -std=c++17")' >> toolchain.cmake
  # Dprotobuf_FORCE_FETCH_DEPENDENCIES to ensure we don't use host dependencies
  cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake \
        -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
        -DBUILD_SHARED_LIBS=OFF \
        -Dprotobuf_BUILD_TESTS=OFF \
        -Dprotobuf_FORCE_FETCH_DEPENDENCIES=ON \
        -DWITH_PROTOC=${HOST_INSTALL_PREFIX}/bin/protoc \
        ..
  make -j"$(grep ^processor /proc/cpuinfo | wc -l)"
  make install
fi
popd
