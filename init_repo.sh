DIR=`pwd`
INSTALL_DIR=$DIR/install
mkdir -p $INSTALL_DIR
export PKG_CONFIG_PATH=$INSTALL_DIR/lib/pkgconfig
export CROSS_COMPILE=aarch64-linux-gnu-
export CC=aarch64-linux-gnu-gcc
export CXX=aarch64-linux-gnu-g++
HOST=arm

# get zlib 
function build_zlib() {
    if [ ! -e zlib ];then
       #rm -fr zlib
       git clone https://github.com/madler/zlib.git zlib
    fi
    
    cd zlib
    git checkout v1.2.8
    ./configure --prefix=$INSTALL_DIR --host=$HOST --static
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
    ./configure --enable-static --disable-shared --prefix=$INSTALL_DIR --host=$HOST
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
    ./configure --enable-static --disable-shared --prefix=$INSTALL_DIR --host=$HOST
    make clean
    make -j4 && make install
    cd ..
}

# get freetype2
function build_freetype()
{
    if [ ! -e freetype-2.9.1.tar.gz ];then
       wget https://download.savannah.gnu.org/releases/freetype/freetype-2.9.1.tar.gz
    fi
    
    rm -fr freetype-2.9.1
    tar zxf freetype-2.9.1.tar.gz
    cd freetype-2.9.1
    ./configure --prefix=$INSTALL_DIR --enable-static --disable-shared
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
    ./config --prefix=$INSTALL_DIR 
    sed -i 's/-m64//g' Makefile
    make clean
    make -j4 && make install
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





#build_zlib
build_openssl
#build_osip
#build_freetype
#build_python27

