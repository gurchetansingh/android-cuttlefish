#!/usr/bin/env bash

# Copyright (C) 2026 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Build and install gfxstream_backend via Meson (https://github.com/google/gfxstream)

set -e

GFXSTREAM_COMMIT=ececb7a28b4e9fd12700cee5d5e4976e81ac60c1

apt install -y build-essential git meson ninja-build pkgconf python3
tmpdir="$(mktemp -t -d gfxstream_installer_XXXXXX)"
trap "rm -rf $tmpdir" EXIT
pushd "${tmpdir}"
git init gfxstream
git -C gfxstream remote add origin https://github.com/google/gfxstream.git
git -C gfxstream fetch --depth 1 origin "${GFXSTREAM_COMMIT}"
git -C gfxstream checkout FETCH_HEAD
meson setup --buildtype=release -Ddecoders=auto build gfxstream
ninja -C build install
ldconfig
popd
