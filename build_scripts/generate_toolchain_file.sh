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

# Writes the CMake toolchain file used by the dependency build scripts.
#
#   generate_toolchain_file <output-file> [extra-cxx-flags]
#
# The file pins the target system and compilers, keeps find_package() inside the
# install prefix when cross compiling, and always appends -fPIC so that the
# resulting static libraries can be linked into DALI's shared objects.
#
# CMAKE_SYSTEM_NAME is written only when actually cross compiling. Presetting it
# makes CMake report CMAKE_CROSSCOMPILING even for a host build, and gRPC and
# google-cloud-cpp then look for protoc and grpc_cpp_plugin with find_program()
# instead of using the ones the build itself produces.
#
# validate_toolchain_env.sh must be sourced first - it rejects the compiler and
# architecture values that would otherwise be interpolated into CMake code here.
generate_toolchain_file() {
  local toolchain_file="$1"
  local extra_cxx_flags="${2:-}"

  : > "${toolchain_file}"
  if [[ -n ${CC_COMP:-} ]]; then
    echo "set(CMAKE_C_COMPILER ${CC_COMP})" >> "${toolchain_file}"
  fi
  if [[ -n ${CXX_COMP:-} ]]; then
    echo "set(CMAKE_CXX_COMPILER ${CXX_COMP})" >> "${toolchain_file}"
  fi
  # only when cross compiling
  if [[ -n ${CC_COMP:-} && ${CC_COMP} != gcc ]]; then
    echo "set(CMAKE_SYSTEM_NAME Linux)" >> "${toolchain_file}"
    if [[ -n ${CMAKE_TARGET_ARCH:-} ]]; then
      echo "set(CMAKE_SYSTEM_PROCESSOR ${CMAKE_TARGET_ARCH})" >> "${toolchain_file}"
    fi
    echo "set(CMAKE_FIND_ROOT_PATH ${INSTALL_PREFIX})" >> "${toolchain_file}"
    echo "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)" >> "${toolchain_file}"
    echo "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)" >> "${toolchain_file}"
    echo "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)" >> "${toolchain_file}"
  fi
  # use ' to avoid bash substitution for CMAKE_C* variables
  echo 'set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")' >> "${toolchain_file}"
  echo "set(CMAKE_CXX_FLAGS \"\${CMAKE_CXX_FLAGS} -fPIC ${extra_cxx_flags}\")" >> "${toolchain_file}"
}
