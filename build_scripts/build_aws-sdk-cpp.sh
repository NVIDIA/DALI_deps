#!/bin/bash -xe

# Copyright (c) 2024, NVIDIA CORPORATION. All rights reserved.
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

mkdir -p ${ROOT_DIR}/third_party/openssl/build
mkdir -p ${ROOT_DIR}/third_party/curl/build
mkdir -p ${ROOT_DIR}/third_party/aws-sdk-cpp/build
mkdir -p ${ROOT_DIR}/third_party/aws-sdk-cpp/deps
mkdir -p ${ROOT_DIR}/third_party/aws-sdk-cpp/openssldir

export DEPS_PREFIX=${ROOT_DIR}/third_party/aws-sdk-cpp/deps
export DEPS_OPENSSLDIR=${ROOT_DIR}/third_party/aws-sdk-cpp/openssldir
export TOOLCHAIN_FILE=${ROOT_DIR}/third_party/aws-sdk-cpp/toolchain.cmake

echo "set(CMAKE_SYSTEM_NAME Linux)" > ${TOOLCHAIN_FILE}
echo "set(CMAKE_SYSTEM_PROCESSOR ${CMAKE_TARGET_ARCH})" >> ${TOOLCHAIN_FILE}
echo "set(CMAKE_C_COMPILER ${CC_COMP})" >> ${TOOLCHAIN_FILE}
echo "set(CMAKE_CXX_COMPILER ${CXX_COMP})" >> ${TOOLCHAIN_FILE}
# only when cross compiling
if [ "${CC_COMP}" != "gcc" ]; then
    echo "set(CMAKE_FIND_ROOT_PATH ${INSTALL_PREFIX})" >> ${TOOLCHAIN_FILE}
    echo "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)" >> ${TOOLCHAIN_FILE}
    echo "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)" >> ${TOOLCHAIN_FILE}
    echo "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)" >> ${TOOLCHAIN_FILE}
fi
echo "set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")" >> ${TOOLCHAIN_FILE}
echo "set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")" >> ${TOOLCHAIN_FILE}

# Build and install static OpenSSL libs to a temporary dir
pushd ${ROOT_DIR}/third_party/openssl
CFLAGS="$CFLAGS -fPIC -Wa,--noexecstack"
declare -a OPTS
OPTS+=(no-shared)
OPTS+=(no-tests)
OPTS+=(--libdir=lib)
OPTS+=(--prefix=${DEPS_PREFIX})
OPTS+=(--openssldir=${DEPS_OPENSSLDIR})
_CONFIGURATOR="./Configure"
case "$CMAKE_TARGET_ARCH" in
  x86_64)
    OPTS+=(linux-x86_64)
    ;;
  aarch64)
    OPTS+=(linux-aarch64)
    ;;
esac
CC=${CC_COMP} CXX=${CXX_COMP}" ${CPPFLAGS} ${CFLAGS}" \
  ${_CONFIGURATOR} ${OPTS[@]} ${LDFLAGS}
make -j"$(grep ^processor /proc/cpuinfo | wc -l)"
make install_sw install_ssldirs

popd
# OpenSSL done

# Build and install static libcurl library to a temporary dir
pushd ${ROOT_DIR}/third_party/curl/build
cmake -DCMAKE_BUILD_TYPE=Release \
      -DOPENSSL_INCLUDE_DIR="${DEPS_PREFIX}/include" \
      -DOPENSSL_SSL_LIBRARY="${DEPS_PREFIX}/lib/libssl.a" \
      -DOPENSSL_CRYPTO_LIBRARY="${DEPS_PREFIX}/lib/libcrypto.a" \
      -DCURL_CA_PATH_AUTODETECT=ON \
      -DCURL_CA_BUNDLE_AUTODETECT=ON \
      -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE} \
      -DCMAKE_INSTALL_PREFIX=${DEPS_PREFIX} \
      -DBUILD_SHARED_LIBS=OFF \
      -DBUILD_CURL_EXE=OFF \
      -DBUILD_STATIC_LIBS=ON \
      ..
make -j"$(grep ^processor /proc/cpuinfo | wc -l)"
make install
popd
# libcurl done

# Build AWS SDK libs, link statically with libcurl and OpenSSL
pushd ${ROOT_DIR}/third_party/aws-sdk-cpp/build
cmake -DCMAKE_BUILD_TYPE=Release \
      -DLEGACY_MODE=OFF \
      -DCMAKE_SYSTEM_INCLUDE_PATH="${DEPS_PREFIX}/include" \
      -DCMAKE_SYSTEM_PREFIX_PATH="${DEPS_PREFIX}" \
      -DCURL_INCLUDE_DIR="${DEPS_PREFIX}/include" \
      -DCURL_LIBRARY_RELEASE="${DEPS_PREFIX}/lib/libcurl.a" \
      -DCURL_LIBRARIES="${DEPS_PREFIX}/lib/libcurl.a" \
      -Dcrypto_INCLUDE_DIR="${DEPS_PREFIX}/include" \
      -Dcrypto_SHARED_LIBRARY="${DEPS_PREFIX}/lib/libcrypto.a" \
      -Dcrypto_STATIC_LIBRARY="${DEPS_PREFIX}/lib/libcrypto.a" \
      -DOPENSSL_INCLUDE_DIR="${DEPS_PREFIX}/include" \
      -DOPENSSL_SSL_LIBRARY="${DEPS_PREFIX}/lib/libssl.a" \
      -DOPENSSL_CRYPTO_LIBRARY="${DEPS_PREFIX}/lib/libcrypto.a" \
      -DOPENSSL_LIBRARIES="${DEPS_PREFIX}/lib/libssl.a;${DEPS_PREFIX}/lib/libcrypto.a" \
      -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE} \
      -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
      -DBUILD_ONLY='s3;core' \
      -DCMAKE_POLICY_DEFAULT_CMP0075=NEW \
      -DENABLE_TESTING=OFF \
      ..
make -j"$(grep ^processor /proc/cpuinfo | wc -l)"
make install

popd
