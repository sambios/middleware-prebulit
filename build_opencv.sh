#set install dir
INSTALL_DIR=$HOME/install
wget https://github.com/opencv/opencv/archive/3.4.1.zip
unzip 3.4.1.zip

cd opencv-3.4.1
if [ -e build ];then
   rm -fr build
fi

mkdir  build
cd build

cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
   -DWITH_GTK=OFF -DWITH_JPEG=OFF -DWITH_OPEENJPEG=OFF -DWITH_JASPER=OFF -DWITH_IPP=OFF \
   -DBUILD_ZLIB=OFF -DWITH_PROTOBUF=OFF -DWITH_GSTREAMER=OFF -DWITH_FFMPEG=OFF -DWITH_EIGEN=OFF \
   -DWITH_QUIRC=OFF -DWITH_TBB=OFF -DWITH_ITT=OFF -DWITH_LAPACK=OFF -DWITH_HALIDE=OFF \
   -DBUILD_TEST=OFF \
  -DWITH_PNG=OFF -DWITH_WEBP=OFF -DWITH_TIFF=OFF -DWITH_OPENEXR=OFF -DBUILD_SHARED_LIBS=OFF  ..
make -j8 && make install
cd ../..

