set -e -x

# Uninstall CUDA and cuDNN so after TensorFlow is built.
rpm -e libcudnn8-devel
rpm -e libcudnn8
yum autoremove -y cuda

# Remove missing cuDNN libs
rm -rf /usr/local/cuda-*
