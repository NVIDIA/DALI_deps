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

# For a snapshot of the code, see the README.rst
pushd third_party/libsndfile
patch -p1 < ${ROOT_DIR}/patches/0001-ms_adpcm-Fix-and-extend-size-checks.patch
./autogen.sh
./configure \
    CFLAGS="-fPIC ${EXTRA_LIBSND_FLAGS}" \
    CXXFLAGS="-fPIC ${EXTRA_LIBSND_FLAGS}" \
    CC=${CC_COMP} \
    CXX=${CXX_COMP} \
    ${HOST_ARCH_OPTION} \
    --prefix=${INSTALL_PREFIX}
make -j"$(grep ^processor /proc/cpuinfo | wc -l)"
make install
popd
