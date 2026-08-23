#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake    \
    glew     \
    sdl2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

echo "Building RSDKv4 Decompilation..."
echo "---------------------------------------------------------------"
REPO="https://github.com/RSDKModding/RSDKv4-Decompilation"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --recursive --depth 1 "$REPO" ./RSDKv4
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./RSDKv4
cmake -S ./ -B build -D CMAKE_BUILD_TYPE=Release
cmake --build build -j$(nproc)
mv -v ./build/RSDKv4 ../AppDir/bin
