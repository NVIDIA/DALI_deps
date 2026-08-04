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
if [ ${WITH_FFMPEG} -gt 0 ]; then
    pushd third_party/FFmpeg
    patch -p1 < ${ROOT_DIR}/patches/ffmpeg/ffmpeg-01-CVE-2026-66037-iamf-count-label.patch
    patch -p1 < ${ROOT_DIR}/patches/ffmpeg/ffmpeg-02-CVE-2026-64834-rtpdec-asf-infinite-loop.patch
    patch -p1 < ${ROOT_DIR}/patches/ffmpeg/ffmpeg-03-CVE-2026-64830-vobsub-stream-count.patch
    patch -p1 < ${ROOT_DIR}/patches/ffmpeg/ffmpeg-04-CVE-2026-64835-adx-channel-state.patch
    patch -p1 < ${ROOT_DIR}/patches/ffmpeg/ffmpeg-05-CVE-2026-66039-mace-decode-int-overflow.patch
    patch -p1 < ${ROOT_DIR}/patches/ffmpeg/ffmpeg-06-CVE-2026-66038-lcldec-heap-disclosure.patch
    patch -p1 < ${ROOT_DIR}/patches/ffmpeg/ffmpeg-07-CVE-2026-65703-tdsc-refframe-size-change.patch
    patch -p1 < ${ROOT_DIR}/patches/ffmpeg/ffmpeg-08-CVE-2026-65704-ty-ac3-size-underflow.patch
    ./configure \
        --prefix=${INSTALL_PREFIX} \
        --disable-static \
        --disable-programs \
        --disable-doc \
        --disable-avdevice \
        --disable-swresample \
        --disable-w32threads \
        --disable-os2threads \
        --disable-dwt \
        --disable-error-resilience \
        --disable-lsp \
        --disable-faan \
        --disable-pixelutils \
        --disable-autodetect \
        --disable-iconv \
        --enable-shared \
        --enable-avformat \
        --enable-avcodec \
        --enable-avfilter \
        --disable-encoders \
        --disable-hwaccels \
        --disable-muxers \
        --disable-protocols \
        --enable-protocol=file \
        --disable-indevs \
        --disable-outdevs  \
        --disable-devices \
        --disable-filters \
        --disable-bsfs \
        --disable-decoder=ipu \
        --disable-decoder=hevc \
        --disable-decoder=h264 \
        --disable-decoder=aac \
        --disable-decoder=aac_fixed \
        --disable-decoder=aac_latm \
        --enable-bsf=h264_mp4toannexb,hevc_mp4toannexb,mpeg4_unpack_bframes \
        --disable-lzma
    # adds | sed 's/\(.*{\)/DALI_\1/' | to the version file generation command - it prepends "DALI_" to the symbol version
    sed -i 's/\$\$(M)sed '\''s\/MAJOR\/\$(lib$(NAME)_VERSION_MAJOR)\/'\'' \$\$< | \$(VERSION_SCRIPT_POSTPROCESS_CMD) > \$\$\@/\$\$(M)sed '\''s\/MAJOR\/\$(lib$(NAME)_VERSION_MAJOR)\/'\'' \$\$< | sed '\''s\/\\(\.*{\\)\/DALI_\\1\/'\'' | \$(VERSION_SCRIPT_POSTPROCESS_CMD) > \$\$\@/' ffbuild/library.mak
    make -j"$(grep ^processor /proc/cpuinfo | wc -l)"
    make install
    popd
fi
