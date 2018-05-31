set -e -x

YASM_VERSION=yasm-1.3.0 
CMAKE_VERSION=cmake-2.8.12

# yasm on CentOS 5 is too old, install a newer version
curl -SLO http://www.tortall.net/projects/yasm/releases/$YASM_VERSION.tar.gz
tar -xvf $YASM_VERSION.tar.gz
cd $YASM_VERSION
./configure
make
make install
cd ..
rm -r $YASM_VERSION $YASM_VERSION.tar.gz

# cmake is also too old
# taglib requires CMake 2.8.0, chromaprint requires CMake 2.8.12
curl -SLO http://www.cmake.org/files/v2.8/$CMAKE_VERSION.tar.gz
tar -xvf $CMAKE_VERSION.tar.gz
cd $CMAKE_VERSION
./configure --prefix=/usr/local/$CMAKE_VERSION
make
make install
PATH=/usr/local/$CMAKE_VERSION/bin:$PATH
cd ..
rm -r $CMAKE_VERSION $CMAKE_VERSION.tar.gz


function lex_pyver {
     # Echoes Python version string padded with zeros
     # Thus:
     # 3.2.1 -> 003002001
     # 3     -> 003000000
     echo $1 | awk -F "." '{printf "%03d%03d%03d", $1, $2, $3}'
}


for PYBIN in /opt/python/*/bin; do

# Patch python-config scripts (https://github.com/pypa/manylinux/pull/87)
# Remove -lpython from the python-config script.

    if [ -e ${PYBIN}/python3 ]; then
        ln -sf python3 ${PYBIN}/python
        ln -sf python3-config ${PYBIN}/python-config
    fi

    py_ver="$(${PYBIN}/python -c 'import platform; print(platform.python_version())')"

    if [ $(lex_pyver $py_ver) -lt $(lex_pyver 3.4) ]; then
        echo "Patching python 2"
        sed -i "s/'-lpython' *+ *pyver\( *+ *sys.abiflags\)\?/''/" $(readlink -e ${PYBIN}/python-config)
    else
        echo "Patching python 3"
        sed -i 's/-lpython${VERSION}${ABIFLAGS}//' $(readlink -e ${PYBIN}/python-config)
    fi
done
