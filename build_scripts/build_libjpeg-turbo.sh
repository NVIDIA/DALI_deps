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

# libjpeg-turbo
pushd third_party/libjpeg-turbo/
echo "set(CMAKE_SYSTEM_NAME Linux)" > toolchain.cmake
echo "set(CMAKE_SYSTEM_PROCESSOR ${CMAKE_TARGET_ARCH})" >> toolchain.cmake
echo "set(CMAKE_C_COMPILER ${CC_COMP})" >> toolchain.cmake
    CFLAGS="-fPIC" \
    CXXFLAGS="-fPIC" \
    CC=${CC_COMP} \
    CXX=${CXX_COMP} \
cmake -G"Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake -DENABLE_SHARED=TRUE -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} . 2>&1 >/dev/null
    CFLAGS="-fPIC" \
    CXXFLAGS="-fPIC" \
    CC=${CC_COMP} \
    CXX=${CXX_COMP} \
make -j"$(grep ^processor /proc/cpuinfo | wc -l)" 2>&1 >/dev/null
make install 2>&1 >/dev/null
popd
