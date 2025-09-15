NVIDIA DALI
===========
This repository contains extra dependencies required to setup a whole development
environment for NVIDIA DALI project.

To obtain only the required code for DALI build (without unnecessary git history) please:

.. code-block:: bash

  git clone https://github.com/NVIDIA/DALI_deps
  git submodule init
  git submodule update --depth 1 --recursive

The repository consists mostly of externally hosted subrepositories:

+------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------+
| Repository                                                                   | Version                                                                                                           | License                                                                                                             |
+==============================================================================+===================================================================================================================+=====================================================================================================================+
| `libsndfile <https://github.com/libsndfile/libsndfile>`_                     | `1.2.2 <https://github.com/libsndfile/libsndfile/releases/tag/1.2.2>`_                                            | `LGPL v2.1 license <https://github.com/libsndfile/libsndfile/blob/master/COPYING>`_                                 |
|                                                                              | `(Source Snapshot) <https://developer.download.nvidia.com/compute/redist/nvidia-dali/libsndfile-1.2.2.tar.gz>`_   |                                                                                                                     |
+------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------+
| `vorbis <https://github.com/xiph/vorbis>`_                                   | `1.3.7 <https://github.com/xiph/vorbis/releases/tag/v1.3.7>`_                                                     | `BSD-3 license <https://github.com/xiph/vorbis/blob/master/COPYING>`_                                               |
+------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------+
| `ogg <https://github.com/xiph/ogg>`_                                         | `1.3.6 <https://github.com/xiph/ogg/releases/tag/v1.3.6>`_                                                        | `BSD-3 license <https://github.com/xiph/ogg/blob/master/COPYING>`_                                                  |
+------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------+
| `flac <https://github.com/xiph/flac>`_                                       | `1.5.0 with cross-compilation patch <https://github.com/xiph/flac/releases/tag/1.5.0>`_                           | `BSD-3 license (+ GPL for utils, not used by DALI) <https://github.com/xiph/flac/blob/master/COPYING.Xiph>`_        |
+------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------+
| `opus <https://github.com/xiph/opus>`_                                       | `1.5.2 <https://github.com/xiph/opus/releases/tag/v1.5.2>`_                                                       | `BSD-3 license <https://github.com/xiph/opus/blob/master/COPYING>`_                                                 |
+------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------+
| `FFmpeg <https://github.com/FFmpeg/FFmpeg>`_                                 | `7.1.1 <https://github.com/FFmpeg/FFmpeg/releases/tag/n7.1.1>`_                                                   | `LGPL v2.1 license <https://github.com/FFmpeg/FFmpeg/blob/master/LICENSE.md>`_                                      |
|                                                                              | `(Source Snapshot) <https://developer.download.nvidia.com/compute/redist/nvidia-dali/FFmpeg-n7.1.1.tar.gz>`_      |                                                                                                                     |
+------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------+
| `OpenCV <https://github.com/opencv/opencv/>`_                                | `4.12.0 <https://github.com/opencv/opencv/releases/tag/4.12.0>`_                                                  | `Apache License 2.0 <https://github.com/opencv/opencv/blob/master/LICENSE>`_                                        |
+------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------+
| `openjpeg <https://github.com/uclouvain/openjpeg>`_                          | `2.5.3 <https://github.com/uclouvain/openjpeg/releases/tag/v2.5.3>`_                                              | `BSD-2 license <https://github.com/uclouvain/openjpeg/blob/master/LICENSE>`_                                        |
+------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------+
| `libtiff <https://gitlab.com/libtiff/libtiff>`_                              | `4.7.0 (+ Build System Patch) <https://gitlab.com/libtiff/libtiff/-/tree/v4.7.0>`_                                | `BSD-2 license <https://gitlab.com/libtiff/libtiff/-/blob/master/README.md>`_                                       |
+------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------+
| `zstd <https://github.com/facebook/zstd>`_                                   | `1.5.7 <https://github.com/facebook/zstd/releases/tag/v1.5.7>`_                                                   | `BSD-3 license <https://github.com/facebook/zstd/blob/dev/LICENSE>`_                                                |
+------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------+
| `libjpeg-turbo <https://github.com/libjpeg-turbo/libjpeg-turbo/>`_           | `3.1.2 <https://github.com/libjpeg-turbo/libjpeg-turbo/releases/tag/3.1.2>`_                                      | `BSD-3 license, IJG license, zlib license <https://github.com/libjpeg-turbo/libjpeg-turbo/blob/master/LICENSE.md>`_ |
+------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------+
| `liblmdb <https://github.com/LMDB/lmdb/blob/mdb.master/libraries/liblmdb/>`_ | `0.9.31 <https://github.com/LMDB/lmdb/releases/tag/LMDB_0.9.31>`_                                                 | `OpenLDAP Public License <https://github.com/LMDB/lmdb/blob/mdb.master/libraries/liblmdb/LICENSE>`_                 |
+------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------+
| `protobuf <https://github.com/protocolbuffers/protobuf/>`_                   | `32.0 <https://github.com/protocolbuffers/protobuf/releases/tag/v32.0>`_                                          | `BSD-3 license <https://github.com/protocolbuffers/protobuf/blob/master/LICENSE>`_                                  |
+------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------+
| `zlib <https://github.com/madler/zlib>`_                                     | `1.3.1 <https://github.com/madler/zlib/releases/tag/v1.3.1>`_                                                     | `zlib License <https://github.com/madler/zlib/blob/master/README>`_                                                 |
+------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------+
| `libtar <https://github.com/tklauser/libtar.git>`_                           | `1.2.20 + patches (master) <https://github.com/tklauser/libtar/commit/6379b5d2ae777dad576aeae70566740670057821>`_ | `BSD-3 license <https://github.com/tklauser/libtar/blob/master/COPYRIGHT>`_                                         |
+------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------+
| `cfitsio <https://github.com/HEASARC/cfitsio>`_                              | `4.6.2 <https://github.com/HEASARC/cfitsio/releases/tag/cfitsio-4.6.2>`_                                          | `MIT-like license (NASA) <https://github.com/healpy/cfitsio/blob/master/License.txt>`_                              |
+------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------+
| `curl <https://github.com/curl/curl.git>`_                                   | `8.15.0 <https://github.com/curl/curl/releases/tag/curl-8_15_0>`_                                                 | `CURL license <https://github.com/curl/curl/blob/master/LICENSES/curl.txt>`_                                        |
+------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------+
| `OpenSSL <https://github.com/openssl/openssl.git>`_                          | `3.5.2 <https://github.com/openssl/openssl/releases/tag/openssl-3.5.2>`_                                          | `Apache 2.0 license <https://github.com/openssl/openssl/blob/master/LICENSE.txt>`_                                  |
+------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------+
| `aws_sdk_cpp <https://github.com/aws/aws-sdk-cpp.git>`_                      | `1.11.642 <https://github.com/aws/aws-sdk-cpp/tree/1.11.642>`_                                                    | `Apache 2.0 license <https://github.com/aws/aws-sdk-cpp/blob/main/LICENSE.txt>`_                                    |
+------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------+

Installing dependencies locally
===============================

In order to conduct `Bare Metal DALI build <https://docs.nvidia.com/deeplearning/dali/main-user-guide/docs/compilation.html#bare-metal-build>`_,
you need to install all the above dependencies (or turn off particular features with CMake variables like ``BUILD_NVDEC=OFF`` etc...).
``build_scripts`` folder contains the recipes, how to build every particular dependency.


This is automated using ``build_deps.sh``, which will build all the dependencies and install them to the local environment. We recommend not
running this script as sudo. Instead, you can specify a prefix path:
```
export HOST_INSTALL_PREFIX=$HOME/prefix/
export PATH=$HOME/prefix/bin:$PATH
export LD_LIBRARY_PATH=$HOME/prefix/lib:$LD_LIBRARY_PATH
export CPATH=$HOME/prefix/include:$CPATH
bash -ex build_scripts/build_deps.sh
```
