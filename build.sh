#!/bin/bash

# Must have swiftenv installed here. Default for homebrew

set -e

c_flags="-Xcc -I/usr/local/include"
swiftc_flags="-Xswiftc -no-link-objc-runtime"
linker_flags="-Xlinker -L/usr/local/lib -Xlinker -lglfw"

target_dir="$(pwd)/bin"

swift build $c_flags $swiftc_flags $linker_flags

mkdir -p ${target_dir}

cp -f .build/debug/libmuse.dylib      ${target_dir}
cp -f .build/debug/Asteroids          ${target_dir}
cp -f .build/debug/LoopDynamic        ${target_dir}

# Tweak the outputted binary to search the bin directory alongside itself for libmuse.dylib
#install_name_tool -change $(pwd)/.build/debug/libmuse.dylib @executable_path/libmuse.dylib $(pwd)/bin/Asteroids

