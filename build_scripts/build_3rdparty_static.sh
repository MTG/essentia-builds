set -e -x

# Check out a particular commit for building dependencies
curl -SLO https://github.com/MTG/essentia/archive/$ESSENTIA_3RDPARTY_VERSION.zip
unzip $ESSENTIA_3RDPARTY_VERSION.zip
cd essentia-*/

# Install dependencies to /usr/local; force --static flag to pickup private libraries for Qt
PKGCONFIG="/usr/bin/pkg-config --static" ./packaging/build_3rdparty_static_debian.sh --with-gaia

cd ..
rm -r essentia-* $ESSENTIA_3RDPARTY_VERSION.zip
