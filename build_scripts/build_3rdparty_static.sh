set -e -x

# Check out a particular commit for building dependencies
curl -SLO https://github.com/MTG/essentia/archive/$ESSENTIA_3RDPARTY_VERSION.zip
unzip $ESSENTIA_3RDPARTY_VERSION.zip

cp /build_zlib.sh essentia-*/packaging/debian_3rdparty/
chmod +x /build_onnx.sh
cp /build_onnx.sh essentia-*/packaging/debian_3rdparty/
cp /build_3rdparty_static_debian.sh /build_config.sh essentia-*/packaging/
cp /build_chromaprint.sh essentia-*/packaging/debian_3rdparty/
cp /build_taglib.sh essentia-*/packaging/debian_3rdparty/

cd essentia-*/

if [[ ${WITH_TENSORFLOW} ]] ; then
    with_tensorflow=--with-tensorflow
fi

# Install dependencies to /usr/local; force --static flag to pickup private libraries for Qt
PKGCONFIG="/usr/bin/pkg-config --static" ./packaging/build_3rdparty_static_debian.sh

cd ..
rm -r essentia-* $ESSENTIA_3RDPARTY_VERSION.zip
