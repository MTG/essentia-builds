set -e -x

# Check out a particular commit for building dependencies
curl -SLO https://github.com/MTG/essentia/archive/$ESSENTIA_3RDPARTY_VERSION.zip
unzip $ESSENTIA_3RDPARTY_VERSION.zip
cd essentia-*/

if [[ "${WITH_TENSORFLOW}" == "true" ]]; then
  with_tensorflow=--with-tensorflow
fi

PKGCONFIG="/usr/bin/pkg-config" ./packaging/build_3rdparty_static_debian.sh --with-gaia ${with_tensorflow}

cd ..
rm -r essentia-* $ESSENTIA_3RDPARTY_VERSION.zip
