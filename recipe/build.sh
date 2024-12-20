#!/bin/bash
set -ex

if [[ "${target_platform}" == osx-* ]]; then
    # CMAKE_CXX_STANDARD=17 does not work for osx
    # will set -std=gnu++17 which does not work
    # for this project
    CXXFLAGS="${CXXFLAGS} -DTARGET_OS_OSX=1 -std=c++17"
fi

mkdir build-cmake
pushd build-cmake

cmake ${CMAKE_ARGS} -GNinja \
  -DCMAKE_CXX_STANDARD=17 \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
  -DCMAKE_PREFIX_PATH=$PREFIX \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DENABLE_TESTING=OFF \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON \
  ..

ninja -v install

popd

# Also do this installation to get .pc files. This duplicates the compilation
# but gets us all necessary components without patching.
make -j "${CPU_COUNT}" prefix=${PREFIX} shared-install
