set -e -x

# Uninstall CUDA and cuDNN so after TensorFlow is built (~GB).
rpm -e libcudnn8-devel
rpm -e libcudnn8
yum autoremove -y cuda
