set -e -x

# Check out a particular commit for building dependencies
curl -SLO https://github.com/MTG/essentia/archive/$ESSENTIA_3RDPARTY_VERSION.zip
unzip $ESSENTIA_3RDPARTY_VERSION.zip
cd essentia-*/

if [ ${WITH_TENSORFLOW} = true ] ; then
    with_tensorflow=--with-tensorflow
fi

# Install dependencies to /usr/local; force --static flag to pickup private libraries for Qt
PKGCONFIG="/usr/bin/pkg-config --static" ./packaging/build_3rdparty_static_debian.sh --with-gaia ${with_tensorflow}

cd ..
rm -r essentia-* $ESSENTIA_3RDPARTY_VERSION.zip
