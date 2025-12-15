#!/bin/bash

set -e

mkdir -p _build
pushd _build

# configure
cmake \
  ${SRC_DIR} \
  ${CMAKE_ARGS} \
  -DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo \
  -DCMAKE_CROSSCOMPILING_EMULATOR:STRING="${CMAKE_CROSSCOMPILING_EMULATOR}" \
  -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen:BOOL=true \
  -DCMAKE_OSX_ARCHITECTURES:STRING="${OSX_ARCH}" \
  -DCMAKE_POLICY_VERSION_MINIMUM:STRING=3.5 \
;

# build
cmake --build . --parallel ${CPU_COUNT} --verbose

# test (flaky on osx-64)
if [[ "${target_platform}" == "linux-64" ]]; then
  ctest --parallel ${CPU_COUNT} --verbose
fi

# install
cmake --build . --parallel ${CPU_COUNT} --verbose --target install
