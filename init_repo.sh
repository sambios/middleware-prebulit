DIR=`pwd`
INSTALL_DIR=$DIR/install
mkdir -p $INSTALL_DIR
export PKG_CONFIG_PATH=$INSTALL_DIR/lib/pkgconfig
CPU_TYPE=$1
if [ "$CPU_TYPE" == "sw_64" ];then

    #export CROSS_COMPILE=sw_64-sunway-linux-gnu-
    export CC=sw_64-sunway-linux-gnu-gcc
    export CXX=sw_64-sunway-linux-gnu-g++
    HOST=sw_64-sunway-linux-gnu
fi

# aarch64 platform example
if [ "$CPU_TYPE" == "aarch64" ]; then
    #export CROSS_COMPILE=sw_64-sunway-linux-gnu-
    export CC=aarch64-linux-gnu-gcc
    export CXX=aarch64-linux-gnu-g++
    HOST=aarch64-linux-gnu
fi

export PREFIX=$INSTALL_DIR

# get zlib 
function build_zlib() {
    if [ ! -e zlib ];then
       #rm -fr zlib
       git clone https://github.com/madler/zlib.git zlib
       git checkout v1.2.11
    fi
    
    cd zlib
    echo cc=$CC
    ./configure --prefix=$INSTALL_DIR --static
    make clean
    make -j4 && make install
    cd ..
}

#get osip
function build_osip()
{
    local OSIP_VERSION=5.2.0
    if [ ! -e osip ];then
        mkdir osip
    fi
    cd osip 
    if [ ! -e libosip2-$OSIP_VERSION.tar.gz ];then
        wget http://download.savannah.nongnu.org/releases/osip/libosip2-$OSIP_VERSION.tar.gz
    fi
    rm -fr libosip2-$OSIP_VERSION
    tar zxf libosip2-$OSIP_VERSION.tar.gz
    cd libosip2-$OSIP_VERSION
    ./configure --enable-static --disable-shared --prefix=$INSTALL_DIR --host=aarch64
    make clean
    make -j4 && make install
    cd ..
    # exosip2
    if [ ! -e libexosip2-$OSIP_VERSION.tar.gz ];then
        wget http://download.savannah.nongnu.org/releases/exosip/libexosip2-$OSIP_VERSION.tar.gz
    fi
    rm -fr libexosip2-$OSIP_VERSION
    tar zxf libexosip2-$OSIP_VERSION.tar.gz
    cd libexosip2-$OSIP_VERSION
    ./configure --enable-static --disable-shared --prefix=$INSTALL_DIR --host=aarch64
    make clean
    make -j4 && make install
    cd ..
}

# get freetype2
function build_freetype_no_harfbuzz()
{
    if [ ! -e freetype-2.9.1.tar.gz ];then
       wget https://download.savannah.gnu.org/releases/freetype/freetype-2.9.1.tar.gz
       tar zxf freetype-2.9.1.tar.gz
    fi
    
    cd freetype-2.9.1
    cp ../freetype/config.sub builds/unix/
    ./configure --prefix=$INSTALL_DIR --enable-static --disable-shared --with-harfbuzz=no --with-pic=no --with-zlib=no --with-png=no --host=$HOST
    make clean
    make -j4 && make install
    cd ..

}

function build_freetype_with_harfbuzz()
{
    if [ ! -e freetype-2.9.1.tar.gz ];then
       wget https://download.savannah.gnu.org/releases/freetype/freetype-2.9.1.tar.gz
       tar zxf freetype-2.9.1.tar.gz
    fi
    
    cd freetype-2.9.1
    cp ../freetype/config.sub builds/unix/
    ./configure --prefix=$INSTALL_DIR --enable-static --disable-shared --with-harfbuzz=yes --with-pic=yes --with-zlib=yes --with-png=yes --host=$HOST BZIP2_CFLAGS=-I$INSTALL_DIR/include BZIP2_LIBS=-L$INSTALL_DIR/lib 
    make clean
    make -j4 && make install
    cd ..

}

# build openssl
function build_openssl() 
{
    if [ ! -e openssl ]; then
        git clone https://github.com/openssl/openssl.git
    fi

    cd openssl
    git checkout OpenSSL_1_0_0-stable
    ./config --prefix=$INSTALL_DIR no-asm -DOPENSSL_NO_STATIC_ENGINE=1 os/compiler:sw_64-sunway-linux-gnu- 
    sed -i 's/-m64//g' Makefile
    make clean
    make && make install
    cd ..
}

# build python2.7
function build_python27()
{
    if [ ! -e Python-2.7.13.tgz ];then
        wget https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tgz
    fi

    tar zxf Python-2.7.13.tgz
    cd Python-2.7.13

    cd ..
}

function build_harfbuzz()
{
	if [ ! -e harfbuzz ]; then
		git clone https://github.com/harfbuzz/harfbuzz.git
		git checkout 2.1.1
	fi
    cd harfbuzz
    ./autogen.sh --prefix=$INSTALL_DIR --enable-static --disable-shared --host=$HOST --with-freetype=yes --with-glib=no --with-cairo=no --with-pic=yes
    make && make install
    cd ..
}

# download libpng
function build_png()  
{
if [ ! -e libpng-1.6.37.tar.gz ]; then
  wget https://nchc.dl.sourceforge.net/project/libpng/libpng16/1.6.37/libpng-1.6.37.tar.gz
  tar zxf libpng-1.6.37.tar.gz
fi

cd libpng-1.6.37
cp ../png/config.sub ./
./configure --enable-hardware-optimizations=no --host=$HOST CFLAGS=-I../install/include LDFLAGS="-L../install/lib"
make clean
cp ../png/Makefile.$CPU_TYPE ./Makefile
make -j4 PREFIX=$INSTALL_DIR
cp .libs/libpng* $INSTALL_DIR/lib/
cd ..
}

function build_bzip2()
{ 
    if [ ! -e bzip2-1.0.8 ]; then
      wget ftp://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz
      tar zxf bzip2-1.0.8.tar.gz
    fi

    cd bzip2-1.0.8
    make install PREFIX=$INSTALL_DIR
    cd ..

}


#build_zlib
#build_openssl
#build_bzip2
#build_osip
#build_png

build_freetype_no_harfbuzz
#build_harfbuzz
#build_freetype_with_harfbuzz

#build_python27


