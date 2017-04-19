#!/bin/bash

# Must have swiftenv installed here. Default for homebrew

set -e

export SDKROOT=$(xcrun --show-sdk-path --sdk macosx)

base_dir=$(pwd)

c_flags="-Xcc -I/usr/local/include"

swiftc_flags="-Xswiftc -static-executable -Xswiftc -static-stdlib"
linker_flags="-Xlinker -L/usr/local/lib -Xlinker -lglfw"

target_dir="${base_dir}/bin"

sdk_path=$(xcrun --show-sdk-path --sdk 'macosx')

case "$1" in
build)
    swift build $c_flags $swiftc_flags $linker_flags

    mkdir -p ${target_dir}

    cp -f .build/debug/LoopStatic         ${target_dir}
    cp -f .build/debug/LoopDynamic        ${target_dir}
    cp -f .build/debug/libAsteroids.dylib ${target_dir}
;;
xcode)
    swift package generate-xcodeproj
;;
*)
    echo "Missing argument [build|xcode]"
    exit 1
esac


swift build $c_flags $swiftc_flags $linker_flags &&
  echo "Build Succeeded!" || echo "Build Failed!"

