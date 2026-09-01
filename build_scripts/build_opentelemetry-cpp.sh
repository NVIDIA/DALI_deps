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

# OpenTelemetry C++. google-cloud-cpp always builds its `opentelemetry` feature
# (see google_cloud_cpp_enable_deps in cmake/GoogleCloudCppFeatures.cmake) and
# that feature requires the opentelemetry-cpp package.
#
# Only the API and the SDK are needed - the OTLP/Zipkin/Prometheus exporters
# would drag in their own transports, so they stay off.
#
# WITH_STL is what google-cloud-cpp's own reference builds use, and it is not
# optional: without it opentelemetry::nostd::variant is a vendored copy of
# absl::variant, and google-cloud-cpp's Cloud Trace and Cloud Monitoring
# exporters, which call std::visit on it, fail to compile.
export ROOT_DIR=$(realpath "${ROOT_DIR:-$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..}")
source "${ROOT_DIR}/build_scripts/validate_toolchain_env.sh"
source "${ROOT_DIR}/build_scripts/generate_toolchain_file.sh"
: "${INSTALL_PREFIX:=${HOST_INSTALL_PREFIX:-/usr/local}}"

pushd "${ROOT_DIR}/third_party/opentelemetry-cpp"
mkdir -p build
cd build
generate_toolchain_file toolchain.cmake
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake \
      -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
      -DCMAKE_PREFIX_PATH=${INSTALL_PREFIX} \
      -DCMAKE_CXX_STANDARD=17 \
      -DWITH_STL=CXX17 \
      -DBUILD_SHARED_LIBS=OFF \
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
      -DOPENTELEMETRY_INSTALL=ON \
      -DBUILD_TESTING=OFF \
      -DWITH_BENCHMARK=OFF \
      -DWITH_EXAMPLES=OFF \
      -DWITH_FUNC_TESTS=OFF \
      -DWITH_OTLP_GRPC=OFF \
      -DWITH_OTLP_HTTP=OFF \
      -DWITH_OTLP_FILE=OFF \
      -DWITH_PROMETHEUS=OFF \
      -DWITH_ZIPKIN=OFF \
      -DWITH_ELASTICSEARCH=OFF \
      ..
make -j"$(nproc)"
make install
popd
