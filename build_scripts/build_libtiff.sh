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

# libtiff
pushd third_party/libtiff
patch -p1 < ${ROOT_DIR}/patches/0001-Fix-wget-complaing-about-expired-git.savannah.gnu.or.patch
patch -p1 < ${ROOT_DIR}/patches/libtiff/CVE-2025-8176.patch
patch -p1 < ${ROOT_DIR}/patches/libtiff/CVE-2025-8177.patch

mkdir -p build
cd build
echo "set(CMAKE_SYSTEM_NAME Linux)" > toolchain.cmake
echo "set(CMAKE_SYSTEM_PROCESSOR ${CMAKE_TARGET_ARCH})" >> toolchain.cmake
echo "set(CMAKE_C_COMPILER ${CC_COMP})" >> toolchain.cmake
echo "set(CMAKE_CXX_COMPILER ${CXX_COMP})" >> toolchain.cmake
# only when cross compiling
if [ "${CC_COMP}" != "gcc" ]; then
    echo "set(CMAKE_FIND_ROOT_PATH ${INSTALL_PREFIX})" >> toolchain.cmake
    echo "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)" >> toolchain.cmake
    echo "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)" >> toolchain.cmake
    echo "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)" >> toolchain.cmake
fi
# use ' to avoid bash substitution for CMAKE_C* variables
echo 'set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")' >> toolchain.cmake
echo 'set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")' >> toolchain.cmake
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake \
      -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
      -Djbig=OFF \
      -Dtiff-docs=OFF \
      -Dlzma=OFF \
      ..
make -j"$(grep ^processor /proc/cpuinfo | wc -l)"
make install
popd
