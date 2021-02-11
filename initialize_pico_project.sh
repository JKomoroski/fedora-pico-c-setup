#!/usr/bin/env bash
set -e

sudo dnf install "gcc" "gcc-c++" "cmake" "arm-none-eabi-*"

mkdir "${HOME}/pico-repos"
cd "${HOME}/pico-repos"

git clone https://github.com/raspberrypi/pico-examples.git
git clone https://github.com/raspberrypi/pico-sdk.git

export PICO_SDK_PATH="/home/${USER}/pico-repos/pico-sdk"

mkdir my-pico-dir
cd my-pico-dir
mkdir build

cp ../pico-examples/blink/blink.c .
cp ../pico-sdk/external/pico_sdk_import.cmake .

cat <<EOF > CMakeLists.txt
cmake_minimum_required(VERSION 3.13)

include(pico_sdk_import.cmake)

project(blink)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

pico_sdk_init()

add_executable(blink
    blink.c
)

target_link_libraries(blink pico_stdlib)

pico_add_extra_outputs(blink)

EOF

cd build
cmake ..

make blink

printf "%s\n" "Copy blink.uf2 to the pico device, either drag and drop or with a simple cp command"
printf "%s\n" "Example cp command:"
printf "%s\n" '"cp blink.uf2 "/run/media/${USERNAME}/RPI-RP2"'

printf "%s\n" "Add the following line to your bashrc or invoke it before building your project"
printf "%s\n" 'export PICO_SDK_PATH="/home/${USER}/pico-sdk"'

printf "%s\n" "All pico project files are located in /home/${USER}/pico-repos"
