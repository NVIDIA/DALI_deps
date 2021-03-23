NVIDIA DALI
===========
This repository contains extra dependencies required to setup a whole development
environment for NVIDIA DALI project.

To obtain only the required code for DALI build (without unnecessary git history) please:

.. code-block:: bash

  git clone https://github.com/NVIDIA/DALI_deps
  git submodule init
  git submodule update --depth 1 --recursive

The repository comprises mostly from externally hosted subrepositories of:

- libsndfile_ - |libsndfilelic|_
- vorbis_, |vorbislic|_
- ogg_, |ogglic|_
- flac_, |flaclic|_
- FFmpeg_, |FFmpeglic|_
- opencv_, |opencvlic|_
- openjpeg_, |openjpeglic|_
- libtiff_, |libtifflic|_
- zstd_, |zstdlic|_
- libjpeg-turbo_, |libjpeg-turbolic|_
- lmdb_, |lmdblic|_
- protobuf_, |protobuflic|_
- CMake_, |CMakelic|_
- zlib_, |zliblic|_


.. _libsndfile: https://github.com/libsndfile/libsndfile
.. |libsndfilelic| replace:: LGPL v2.1 license
.. _libsndfilelic: https://github.com/libsndfile/libsndfile/blob/master/COPYING

.. _vorbis: https://github.com/xiph/vorbis
.. |vorbislic| replace:: BSD-3 license
.. _vorbislic: https://github.com/xiph/vorbis/blob/master/COPYING

.. _ogg: https://github.com/xiph/ogg
.. |ogglic| replace:: BSD-3 license
.. _ogglic: https://github.com/xiph/ogg/blob/master/COPYING

.. _flac: https://github.com/xiph/flac
.. |flaclic| replace:: LGPL v2.1 license
.. _flaclic: https://github.com/xiph/flac/blob/master/COPYING.LGPL

.. _FFmpeg: https://github.com/FFmpeg/FFmpeg
.. |FFmpeglic| replace:: LGPL v2.1 license
.. _FFmpeglic: https://github.com/FFmpeg/FFmpeg/blob/master/LICENSE.md

.. _opencv: https://github.com/opencv/opencv/
.. |opencvlic| replace:: Apache License 2.0
.. _opencvlic: https://github.com/opencv/opencv/blob/master/LICENSE

.. _openjpeg: https://github.com/uclouvain/openjpeg
.. |openjpeglic| replace:: BSD-2 license
.. _openjpeglic: https://github.com/uclouvain/openjpeg/blob/master/LICENSE

.. _libtiff: https://gitlab.com/libtiff/libtiff
.. |libtifflic| replace:: BSD-2 license
.. _libtifflic: https://gitlab.com/libtiff/libtiff/-/blob/master/README.md

.. _zstd: https://github.com/facebook/zstd
.. |zstdlic| replace:: BSD-3 license
.. _zstdlic: https://github.com/facebook/zstd/blob/dev/LICENSE

.. _libjpeg-turbo: https://github.com/libjpeg-turbo/libjpeg-turbo/
.. |libjpeg-turbolic| replace:: BSD-3 license, IJG license, zlib license
.. _libjpeg-turbolic: https://github.com/libjpeg-turbo/libjpeg-turbo/blob/master/LICENSE.md

.. _lmdb: https://github.com/LMDB/lmdb/blob/mdb.master/libraries/liblmdb/
.. |lmdblic| replace::	OpenLDAP Public License
.. _lmdblic: https://github.com/libjpeg-turbo/libjpeg-turbo/blob/master/LICENSE.md

.. _protobuf: https://github.com/protocolbuffers/protobuf/
.. |protobuflic| replace:: BSD-3 license
.. _protobuflic: https://github.com/protocolbuffers/protobuf/blob/master/LICENSE

.. _CMake: https://github.com/Kitware/CMake/
.. |CMakelic| replace:: BSD-3 license
.. _CMakelic: https://github.com/Kitware/CMake/blob/master/Copyright.txt

.. _zlib: https://github.com/madler/zlib
.. |zliblic| replace:: zlib License
.. _zliblic: https://github.com/madler/zlib/blob/master/README
