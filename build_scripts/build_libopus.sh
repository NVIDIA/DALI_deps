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

export ROOT_DIR=$(pwd)

# libopus
pushd third_party/opus

# Configure step relies on the git tag to generate the version
# Since we only have a shallow copy of the submodule, without tags, the version can't be determined
# This is a workaround, parsing the README file to get the tag used, and create a tag in the local repo
# before calling configure
OPUS_VERSION=$(grep https://github.com/xiph/opus/releases/tag ${ROOT_DIR}/README.rst  | grep -Eo 'v[0-9]+.[0-9]+.[0-9]+')
git tag $OPUS_VERSION || true

./autogen.sh
./configure \
    CFLAGS="-fPIC" \
    CXXFLAGS="-fPIC" \
    CC=${CC_COMP} \
    CXX=${CXX_COMP} \
    ${HOST_ARCH_OPTION} \
    --prefix=${INSTALL_PREFIX}

make -j"$(grep ^processor /proc/cpuinfo | wc -l)"
make install
popd
