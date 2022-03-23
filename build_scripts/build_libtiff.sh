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
patch -p1 < ${ROOT_DIR}/patches/libtiff-CVE-2022-22844.patch
patch -p1 < ${ROOT_DIR}/patches/libtiff-CVE-2022-0561.patch
patch -p1 < ${ROOT_DIR}/patches/libtiff-CVE-2022-0865.patch
patch -p1 < ${ROOT_DIR}/patches/libtiff-CVE-2022-0924.patch
patch -p1 < ${ROOT_DIR}/patches/libtiff-CVE-2022-0891.patch
patch -p1 < ${ROOT_DIR}/patches/libtiff-CVE-2022-0908.patch
patch -p1 < ${ROOT_DIR}/patches/libtiff-CVE-2022-0909.patch
patch -p1 < ${ROOT_DIR}/patches/libtiff-CVE-2022-0907.patch
./autogen.sh
./configure \
    CFLAGS="-fPIC" \
    CXXFLAGS="-fPIC" \
    CC=${CC_COMP} \
    CXX=${CXX_COMP} \
    ${HOST_ARCH_OPTION} \
    --with-zstd-include-dir=${INSTALL_PREFIX}/include \
    --with-zstd-lib-dir=${INSTALL_PREFIX}/lib         \
    --with-zlib-include-dir=${INSTALL_PREFIX}/include \
    --with-zlib-lib-dir=${INSTALL_PREFIX}/lib         \
    --prefix=${INSTALL_PREFIX}
make -j"$(grep ^processor /proc/cpuinfo | wc -l)"
make install
popd
