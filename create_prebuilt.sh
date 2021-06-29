PREBUILT_DIR=out_prebuilt
INSTALL_DIR=install
ARCH=sw64
AR=sw_64-sunway-linux-gnu-ar
RANLIB=sw_64-sunway-linux-gnu-ranlib

rm -fr $PREBUILT_DIR
mkdir -p $PREBUILT_DIR/$ARCH/lib

# combline osip.a
pushd $INSTALL_DIR/lib
rm -fr osip_allinone
mkdir  osip_allinone
cd osip_allinone
$AR x ../libosip2.a
$AR x ../libosipparser2.a
$AR x ../libeXosip2.a
$AR cru libosip.a *.o
$RANLIB libosip.a
cd ..
popd

# combline freetype.a
pushd $INSTALL_DIR/lib
rm -fr freetype_allinone
mkdir  freetype_allinone
cd freetype_allinone
$AR x ../libfreetype.a
$AR x ../libharfbuzz.a
$AR x ../libpng.a
$AR x ../libz.a
$AR x ../libbz2.a
$AR cru libfreetype.a *.o
$RANLIB libfreetype.a
cd ..
popd



# copy libcrypto.a  libfreetype.a  libosip.a  libssl.a  libz.a
cp -f $INSTALL_DIR/lib/libssl.a $PREBUILT_DIR/$ARCH/lib/
cp -f $INSTALL_DIR/lib/libcrypto.a $PREBUILT_DIR/$ARCH/lib/
cp -f $INSTALL_DIR/lib/osip_allinone/libosip.a $PREBUILT_DIR/$ARCH/lib/
cp -f $INSTALL_DIR/lib/freetype_allinone/libfreetype.a $PREBUILT_DIR/$ARCH/lib/




