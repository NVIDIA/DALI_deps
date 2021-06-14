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
    echo "--- a/libavcodec/exr.c
+++ b/libavcodec/exr.c
@@ -1062 +1062 @@ static int dwa_uncompress(EXRContext *s, const uint8_t *src, int compressed_size
-    if (dc_size > 0) {
+    {
@@ -1066 +1066 @@ static int dwa_uncompress(EXRContext *s, const uint8_t *src, int compressed_size
-        if (dc_count > (6LL * td->xsize * td->ysize + 63) / 64)
+        if (dc_count != dc_w * dc_h * 3)" | patch -p 1
    ./configure \
        --prefix=${INSTALL_PREFIX} \
        --disable-static \
        --disable-programs \
        --disable-doc \
        --disable-avdevice \
        --disable-swresample \
        --disable-swscale \
        --disable-postproc \
        --disable-w32threads \
        --disable-os2threads \
        --disable-dct \
        --disable-dwt \
        --disable-error-resilience \
        --disable-lsp \
        --disable-lzo \
        --disable-mdct \
        --disable-rdft \
        --disable-fft \
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
        --enable-bsf=h264_mp4toannexb,hevc_mp4toannexb,mpeg4_unpack_bframes
    # adds | sed 's/\(.*{\)/DALI_\1/' | to the version file generation command - it prepends "DALI_" to the symbol version
    sed -i 's/\$\$(M)sed '\''s\/MAJOR\/\$(lib$(NAME)_VERSION_MAJOR)\/'\'' \$\$< | \$(VERSION_SCRIPT_POSTPROCESS_CMD) > \$\$\@/\$\$(M)sed '\''s\/MAJOR\/\$(lib$(NAME)_VERSION_MAJOR)\/'\'' \$\$< | sed '\''s\/\\(\.*{\\)\/DALI_\\1\/'\'' | \$(VERSION_SCRIPT_POSTPROCESS_CMD) > \$\$\@/' ffbuild/library.mak
    make -j"$(grep ^processor /proc/cpuinfo | wc -l)"
    make install
    popd
fi
