#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake    \
    glew     \
    libdecor \
    sdl2     \
    tinyxml2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package rsdkv4-git

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of RSDKv4 Decompilation..."
echo "---------------------------------------------------------------"
REPO="https://github.com/RSDKModding/RSDKv4-Decompilation"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --recursive --depth 1 "$REPO" ./RSDKv4
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./RSDKv4
cmake -S ./ -B build -D CMAKE_BUILD_TYPE=Release -D USE_SDL_AUDIO=ON
cmake --build build -j$(nproc)
mv -v ./build/RSDKv4 ../AppDir/bin
