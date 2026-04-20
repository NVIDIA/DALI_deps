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

## Patches

The `patches/` directory contains patches applied on top of upstream sources during the build scripts (e.g. CVE fixes for libsndfile, FFmpeg fixes, lmdb Makefile patch). Patches are applied by the individual `build_scripts/*.sh` scripts — do not apply them manually.
