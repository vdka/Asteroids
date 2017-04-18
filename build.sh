#!/bin/bash

# Must have swiftenv installed here. Default for homebrew

set -e

export SDKROOT=$(xcrun --show-sdk-path --sdk macosx)

base_dir=$(pwd)

c_flags="-Xcc -I/usr/local/include"

swiftc_flags=""
linker_flags="-Xlinker -L/usr/local/lib -Xlinker -lglfw3"

target_dir="${base_dir}/bin"

sdk_path=$(xcrun --show-sdk-path --sdk 'macosx')

swift build $c_flags $swiftc_flags $linker_flags &&
  echo "Build Succeeded!" || echo "Build Failed!"

mkdir -p ${target_dir}

cp -f .build/debug/libAsteroids.dylib bin

