DIR=`pwd`

export PKG_CONFIG_PATH=$DIR/install/lib/pkgconfig

# get zlib 
function build_zlib() {
    if [ -e zlib ];then
       rm -fr zlib
    fi
    
    git clone https://github.com/madler/zlib.git zlib
    cd zlib
    git checkout v1.2.8
    ./configure --prefix=$DIR/install
    make -j4 && make install
    cd ..
}

#get osip
function build_osip()
{
    if [ ! -e osip ];then
        mkdir osip
    fi
    cd osip
    if [ ! -e libosip2-5.2.1.tar.gz ];then
        wget http://download.savannah.nongnu.org/releases/osip/libosip2-5.2.1.tar.gz
    fi
    rm -fr libosip2-5.2.1
    tar zxf libosip2-5.2.1.tar.gz
    cd libosip2-5.2.1
    ./configure --enable-static --disable-shared --prefix=$DIR/install --includedir=$DIR/install/include/osip --libdir=$DIR/install/lib/osip
    make -j4 && make install
    cd ..
    # exosip2
    if [ ! -e libexosip2-5.2.1.tar.gz ];then
        wget http://download.savannah.nongnu.org/releases/exosip/libexosip2-5.2.1.tar.gz
    fi
    rm -fr libexosip2-5.2.1
    tar zxf libexosip2-5.2.1.tar.gz
    cd libexosip2-5.2.1
    ./configure --enable-static --disable-shared --prefix=$DIR/install --includedir=$DIR/install/include/osip --libdir=$DIR/install/lib/osip
    make -j4 && make install
    cd ..
}

#build_zlib
build_osip
