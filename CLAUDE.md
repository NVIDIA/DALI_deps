# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

DALI_deps provides the build scripts and source snapshots (as git submodules) for all third-party C/C++ dependencies required for a bare-metal NVIDIA DALI build. It has no DALI source code itself.

Dependencies managed here are outlined in README.rst

## Cloning

Use shallow submodule clones to avoid fetching full upstream histories:

```bash
git clone https://github.com/NVIDIA/DALI_deps
git submodule init
git submodule update --depth 1 --recursive
```

## Building all dependencies

```bash
export HOST_INSTALL_PREFIX=$HOME/prefix
export PATH=$HOME/prefix/bin:$PATH
export LD_LIBRARY_PATH=$HOME/prefix/lib:$LD_LIBRARY_PATH
export CPATH=$HOME/prefix/include:$CPATH
bash -ex build_scripts/build_deps.sh
```

Do not run as `sudo` — use a user-writable prefix instead.

Key env vars for `build_deps.sh`:
- `HOST_INSTALL_PREFIX` / `INSTALL_PREFIX` — installation prefix (default `/usr/local`)
- `CC_COMP` / `CXX_COMP` — compiler selection (default `gcc`/`g++`)
- `CMAKE_TARGET_ARCH` — target architecture (default: host arch)
- `WITH_FFMPEG` — set to `0` to skip FFmpeg (default `1`)
- `CLEANUP=1` — runs `git clean -fdx` on all submodules before building

## Building a single dependency

Each dependency has its own script in `build_scripts/`:

```bash
bash -ex build_scripts/build_opencv.sh
bash -ex build_scripts/build_ffmpeg.sh
# etc.
```

## Dependency-specific build notes

Notes here cover build decisions that aren't obvious from the script alone. Most
dependencies don't need an entry; add one when a build script relies on a
non-obvious workaround or constraint future changes need to preserve.

### Google Cloud Storage

`build_google-cloud-cpp.sh` passes `-DGOOGLE_CLOUD_CPP_ENABLE=storage`, so only the
GCS client is built out of the ~200 libraries in the SDK. google-cloud-cpp always adds
`monitoring`, `trace`, `opentelemetry` and `universe_domain` on top of that, which is
why gRPC and opentelemetry-cpp are dependencies even though the GCS client itself talks
REST.

Abseil (`third_party/abseil-cpp`) is built and installed by `build_protobuf.sh` as part of
protobuf (via `FETCHCONTENT_SOURCE_DIR_ABSL`, overriding the version protobuf pins, as gRPC
needs a newer one), and `build_grpc.sh` reuses that copy (along with protobuf, zlib and OpenSSL)
via `gRPC_*_PROVIDER=package` so that no second, differently versioned copy is installed
over it. The googleapis protobuf definitions are downloaded by google-cloud-cpp while
configuring; `GOOGLE_CLOUD_CPP_OVERRIDE_GOOGLEAPIS_URL` points that at a local copy.

## Patches

The `patches/` directory contains patches applied on top of upstream sources during the build scripts (e.g. CVE fixes for libsndfile, FFmpeg fixes, lmdb Makefile patch). Patches are applied by the individual `build_scripts/*.sh` scripts — do not apply them manually.
