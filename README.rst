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

+----------------+---------------------+---------------------+
| Repository     | Version             | License             |
+================+=====================+=====================+
| libsndfile_    | |libsndfilever|_    | |libsndfilelic|_    |
|                | |libsndfilesrc|_    |                     |
+----------------+---------------------+---------------------+
| vorbis_        | |vorbisver|_        | |vorbislic|_        |
+----------------+---------------------+---------------------+
| ogg_           | |oggver|_           | |ogglic|_           |
+----------------+---------------------+---------------------+
| flac_          | |flacver|_          | |flaclic|_          |
+----------------+---------------------+---------------------+
| opus_          | |opusver|_          | |opuslic|_          |
+----------------+---------------------+---------------------+
| FFmpeg_        | |FFmpegver|_        | |FFmpeglic|_        |
|                | |FFmpegsrc|_        |                     |
+----------------+---------------------+---------------------+
| opencv_        | |opencvver|_        | |opencvlic|_        |
+----------------+---------------------+---------------------+
| openjpeg_      | |openjpegver|_      | |openjpeglic|_      |
+----------------+---------------------+---------------------+
| libtiff_       | |libtiffver|_       | |libtifflic|_       |
+----------------+---------------------+---------------------+
| zstd_          | |zstdver|_          | |zstdlic|_          |
+----------------+---------------------+---------------------+
| libjpeg-turbo_ | |libjpeg-turbover|_ | |libjpeg-turbolic|_ |
+----------------+---------------------+---------------------+
| lmdb_          | |lmdbver|_          | |lmdblic|_          |
+----------------+---------------------+---------------------+
| protobuf_      | |protobufver|_      | |protobuflic|_      |
+----------------+---------------------+---------------------+
| CMake_         | |CMakever|_         | |CMakelic|_         |
+----------------+---------------------+---------------------+
| zlib_          | |zlibver|_          | |zliblic|_          |
+----------------+---------------------+---------------------+
| libtar_        | |libtarver|_        | |libtarlic|_        |
+----------------+---------------------+---------------------+

.. _libsndfile: https://github.com/libsndfile/libsndfile
.. |libsndfilever| replace:: 1.0.31
.. _libsndfilever: https://github.com/libsndfile/libsndfile/releases/tag/1.0.31
.. |libsndfilelic| replace:: LGPL v2.1 license
.. _libsndfilelic: https://github.com/libsndfile/libsndfile/blob/master/COPYING
.. |libsndfilesrc| replace:: (Source Snapshot)
.. _libsndfilesrc: https://developer.download.nvidia.com/compute/redist/nvidia-dali/libsndfile-1.0.31.tar.gz

.. _vorbis: https://github.com/xiph/vorbis
.. |vorbislic| replace:: BSD-3 license
.. _vorbislic: https://github.com/xiph/vorbis/blob/master/COPYING
.. |vorbisver| replace:: 1.3.7
.. _vorbisver: https://github.com/xiph/vorbis/releases/tag/v1.3.7

.. _ogg: https://github.com/xiph/ogg
.. |ogglic| replace:: BSD-3 license
.. _ogglic: https://github.com/xiph/ogg/blob/master/COPYING
.. |oggver| replace:: 1.3.5
.. _oggver: https://github.com/xiph/ogg/releases/tag/v1.3.5

.. _flac: https://github.com/xiph/flac
.. |flaclic| replace:: BSD-3 license (+ GPL for utils, not used by DALI)
.. _flaclic: https://github.com/xiph/flac/blob/master/COPYING.Xiph
.. |flacver| replace:: 1.3.3 (+ Security Patch)
.. _flacver: https://github.com/xiph/flac/releases/tag/1.3.3

.. _opus: https://github.com/xiph/opus
.. |opuslic| replace:: BSD-3 license
.. _opuslic: https://github.com/xiph/opus/blob/master/COPYING
.. |opusver| replace:: 1.3.1
.. _opusver: https://github.com/xiph/opus/releases/tag/v1.3.1

.. _FFmpeg: https://github.com/FFmpeg/FFmpeg
.. |FFmpeglic| replace:: LGPL v2.1 license
.. _FFmpeglic: https://github.com/FFmpeg/FFmpeg/blob/master/LICENSE.md
.. |FFmpegver| replace:: 4.4 (+ Security Patch)
.. _FFmpegver: https://github.com/FFmpeg/FFmpeg/releases/tag/n4.4
.. |FFmpegsrc| replace:: (Source Snapshot)
.. _FFmpegsrc: https://developer.download.nvidia.com/compute/redist/nvidia-dali/FFmpeg-n4.4_v2.tar.gz

.. _opencv: https://github.com/opencv/opencv/
.. |opencvlic| replace:: Apache License 2.0
.. _opencvlic: https://github.com/opencv/opencv/blob/master/LICENSE
.. |opencvver| replace:: 4.5.3
.. _opencvver: https://github.com/opencv/opencv/releases/tag/4.5.3

.. _openjpeg: https://github.com/uclouvain/openjpeg
.. |openjpeglic| replace:: BSD-2 license
.. _openjpeglic: https://github.com/uclouvain/openjpeg/blob/master/LICENSE
.. |openjpegver| replace:: 2.4.0
.. _openjpegver: https://github.com/uclouvain/openjpeg/releases/tag/v2.4.0

.. _libtiff: https://gitlab.com/libtiff/libtiff
.. |libtifflic| replace:: BSD-2 license
.. _libtifflic: https://gitlab.com/libtiff/libtiff/-/blob/master/README.md
.. |libtiffver| replace:: 4.3.0
.. _libtiffver: https://gitlab.com/libtiff/libtiff/-/tree/v4.3.0

.. _zstd: https://github.com/facebook/zstd
.. |zstdlic| replace:: BSD-3 license
.. _zstdlic: https://github.com/facebook/zstd/blob/dev/LICENSE
.. |zstdver| replace:: 1.5.0
.. _zstdver: https://github.com/facebook/zstd/releases/tag/v1.5.0

.. _libjpeg-turbo: https://github.com/libjpeg-turbo/libjpeg-turbo/
.. |libjpeg-turbolic| replace:: BSD-3 license, IJG license, zlib license
.. _libjpeg-turbolic: https://github.com/libjpeg-turbo/libjpeg-turbo/blob/master/LICENSE.md
.. |libjpeg-turbover| replace:: 2.1.0
.. _libjpeg-turbover: https://github.com/libjpeg-turbo/libjpeg-turbo/releases/tag/2.1.0

.. _lmdb: https://github.com/LMDB/lmdb/blob/mdb.master/libraries/liblmdb/
.. |lmdblic| replace::	OpenLDAP Public License
.. _lmdblic: https://github.com/LMDB/lmdb/blob/mdb.master/libraries/liblmdb/LICENSE
.. |lmdbver| replace:: 0.9.29
.. _lmdbver: https://github.com/LMDB/lmdb/releases/tag/LMDB_0.9.29

.. _protobuf: https://github.com/protocolbuffers/protobuf/
.. |protobuflic| replace:: BSD-3 license
.. _protobuflic: https://github.com/protocolbuffers/protobuf/blob/master/LICENSE
.. |protobufver| replace:: 3.17.3
.. _protobufver: https://github.com/protocolbuffers/protobuf/releases/tag/v3.17.3

.. _CMake: https://github.com/Kitware/CMake/
.. |CMakelic| replace:: BSD-3 license
.. _CMakelic: https://github.com/Kitware/CMake/blob/master/Copyright.txt
.. |CMakever| replace:: 3.13.5
.. _CMakever: https://github.com/Kitware/CMake/releases/tag/v3.13.5

.. _zlib: https://github.com/madler/zlib
.. |zliblic| replace:: zlib License
.. _zliblic: https://github.com/madler/zlib/blob/master/README
.. |zlibver| replace:: 1.2.11
.. _zlibver: https://github.com/madler/zlib/releases/tag/v1.2.11

.. _libtar: https://repo.or.cz/libtar.git
.. |libtarlic| replace:: BSD-3 license
.. _libtarlic: https://repo.or.cz/libtar.git/blob/HEAD:/COPYRIGHT
.. |libtarver| replace:: 1.2.20 + patches (master)
.. _libtarver: https://repo.or.cz/libtar.git/tree/6d0ab4c78e7a8305c36a0c3d63fd25cd1493de65
