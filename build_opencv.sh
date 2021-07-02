BUILD_DIR=build
MM_TOP_DIR=$HOME/middleware-soc
INSTALL_DIR=$HOME/bm_prebuilt_toolchains/sw_64/opencv-4.1.1

if [ ! -e 4.1.1.zip ]; then
   wget https://github.com/opencv/opencv/archive/4.1.1.zip
   unzip 4.1.1.zip
fi

cd opencv-4.1.1

rm -fr $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR

PWD_DIR=`pwd`
echo "$PWD_DIR"

cmake -DHAVE_opencv_python3=OFF -DBUILD_opencv_python3=OFF \
          -DPYTHON3_INCLUDE_PATH=$MM_TOP_DIR/prebuilt/x86_64/python3.5/include/python3.5m \
          -DPYTHON3_LIBRARIES=$MM_TOP_DIR/prebuilt/x86_64/python3.5/lib/libpython3.5m.so \
          -DPYTHON3_EXECUTABLE=$MM_TOP_DIR/prebuilt/x86_64/python3.5/bin\
          -DPYTHON3_NUMPY_INCLUDE_DIRS=$MM_TOP_DIR/prebuilt/x86_64/python3.5/dist-packages/numpy/core/include \
          -DPYTHON3_PACKAGES_PATH=$MM_OUTPUT_DIR/opencv-python \
          -DHAVE_opencv_python2=OFF -DBUILD_opencv_python2=OFF \
          -DPYTHON2_INCLUDE_PATH=$MM_TOP_DIR/prebuilt/x86_64/python2.7/include/python2.7 \
          -DPYTHON2_LIBRARIES=$MM_TOP_DIR/prebuilt/x86_64/python2.7/lib/libpython2.7.so \
          -DPYTHON2_NUMPY_INCLUDE_DIRS=$MM_TOP_DIR/prebuilt/x86_64/python2.7/dist-packages/numpy/core/include \
          -DPYTHON2_EXECUTABLE=$MM_TOP_DIR/prebuilt/x86_64/python2.7/bin\
          -DPYTHON2_PACKAGES_PATH=$MM_OUTPUT_DIR/opencv-python/python2 \
          -DPYTHON_DEFAULT_EXECUTABLE=/usr/bin/python \
          -DOPENCV_SKIP_PYTHON_LOADER=ON \
          -DWITH_FFMPEG=ON -DWITH_GSTREAMER=OFF \
          -DWITH_GTK=OFF -DWITH_1394=OFF -DWITH_V4L=ON \
          -DWITH_CUDA=OFF -DWITH_OPENCL=OFF -DWITH_LAPACK=OFF \
          -DWITH_TBB=ON -DBUILD_TBB=ON \
          -DWITH_TIFF=ON -DBUILD_TIFF=ON \
          -DWITH_JPEG=ON -DBUILD_JPEG=ON \
          -DOPENCV_FORCE_3RDPARTY_BUILD=ON \
          -DFREETYPE_LIBRARY=$MM_TOP_DIR/prebuilt/sw_64/lib/libfreetype.a \
          -DFREETYPE_INCLUDE_DIRS=$MM_TOP_DIR/prebuilt/include/freetype2 \
          -DHARFBUZZ_INCLUDE_DIRS=$MM_TOP_DIR/prebuilt/include/harfbuzz \
          -DCMAKE_TOOLCHAIN_FILE=../platforms/linux/sw_64.toolchain.cmake \
          -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
	  -DCMAKE_MAKE_PROGRAM=make ..

make -j4 && make install
cd ..


