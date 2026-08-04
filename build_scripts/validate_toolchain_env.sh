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

export CC_COMP=${CC_COMP:-gcc}
export CXX_COMP=${CXX_COMP:-g++}
export CMAKE_TARGET_ARCH=${CMAKE_TARGET_ARCH:-$(uname -m)}

for toolchain_var in CC_COMP CXX_COMP CMAKE_TARGET_ARCH; do
  if [[ ! ${!toolchain_var} =~ ^[a-zA-Z0-9/_.+-]+$ ]]; then
    echo "ERROR: ${toolchain_var} contains invalid characters" >&2
    exit 1
  fi
done
