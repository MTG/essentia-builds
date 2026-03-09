set -e -x

# Uninstall CUDA and cuDNN so after TensorFlow is built.
yum remove -y 'libcudnn9-devel-cuda-12'
yum remove -y \
  cuda-nvcc-* \
  cuda-cudart-devel-* \
  cuda-libraries-devel-* \
  cuda-toolkit-*

# Autoclean unused deps
yum autoremove -y
yum clean all
rm -rf /var/cache/yum /var/Cache/dnf

# Remove missing cuDNN libs
rm -rf /usr/local/cuda-*
