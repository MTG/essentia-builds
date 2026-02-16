set -e -x

# Uninstall CUDA and cuDNN so after TensorFlow is built.
yum -y remove \
  cuda-nvcc-12-8 \
  cuda-cudart-devel-12-8 \
  cuda-libraries-devel-12-8 \
  libcudnn8 \
  libcudnn8-devel &&
  yum autoremove -y &&
  yum clean all &&
  rm -rf /var/cache/yum /usr/local/cuda*
