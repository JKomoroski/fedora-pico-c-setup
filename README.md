# Setting Up Pico Development in Fedora

This repo contains a simple script which will initialize a very basic development environment 
for writing C based firmware to a raspberry pi pico. Below is a summary of the commands and 
changes the script makes:

Things to install:
```
dnf install gcc gcc-c++ cmake arm-none-eabi-*
```

Directories and workspaces:
```
mkdir "${HOME}/pico-repos"
mkdir "${HOME}/pico-repos/my-pico-dir"
mkdir "${HOME}/pico-repos/my-pico-dir/build"
```

Clone the following repositories:
```
git clone https://github.com/raspberrypi/pico-examples.git
git clone https://github.com/raspberrypi/pico-sdk.git
```

Export the following environment variable to point to the pico sdk location:
```
export PICO_SDK_PATH="${HOME}/pico-repos/pico-sdk"
```

Copy simple example from the examples and sdk repositories:
```
cp "${HOME}/pico-repos/pico-sdk/pico-examples/blink/blink.c" "${HOME}/pico-repos/my-pico-dir"
cp "${PICO_SDK_PATH}/external/pico_sdk_import.cmake" "${HOME}/pico-repos/my-pico-dir" 
```

Create a cmake file:
```
cat <<EOF > "${HOME}/pico-repos/my-pico-dir/CMakeLists.txt"
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
```

Make a build directory for cmake and initialize cmake:
```
cd "${HOME}/pico-repos/my-pico-dir/build"
cmake ..
```

Build the blink project:
```
cd "${HOME}/pico-repos/my-pico-dir/build"
make blink
```

Copy the blink uf2 output to the pico:
```
cp blink.uf2 /run/media/MY_USER_NAME/RPI-RP2
```
