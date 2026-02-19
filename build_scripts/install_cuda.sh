#!/bin/bash
set -euox pipefail

CUDA_VERSION=12.2
CUDNN_VERSION=8.9.5.29-1

# ----------------------------
# Add NVIDIA CUDA repo
# ----------------------------
curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/cuda-rhel8.repo -o /etc/yum.repos.d/cuda.repo
yum clean all
yum makecache

# ----------------------------
# Install minimal CUDA toolkit and cuDNN
# ----------------------------
yum -y install \
  cuda-nvcc-12-8 \
  cuda-cudart-devel-12-8 \
  cuda-libraries-devel-12-8 \
  libcudnn8 \
  libcudnn8-devel \
  --exclude=cuda-drivers &&
  yum clean all &&
  rm -rf /var/cache/yum

# ----------------------------
# Environment setup
# ----------------------------
export CUDA_HOME=/usr/local/cuda
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH

# ----------------------------
# Verify installation
# ----------------------------
nvcc --version || echo "⚠️ nvcc not found (maybe install cuda-nvcc package)"
ldconfig -p | grep cudnn || echo "⚠️ cuDNN not found in linker cache"

# ----------------------------
# Downgrade GCC - CUDA 12.8 only supports GCC ≤ 12
# Requirement for ONNXRUNTIME using CUDA
# ----------------------------
yum install -y gcc-toolset-12 &&
  yum clean all &&
  rm -rf /var/cache/yum

source /opt/rh/gcc-toolset-12/enable
gcc --version

# ----------------------------
# Clean yum cache again to save space
# ----------------------------
yum clean all
rm -rf /var/cache/yum /var/cache/dnf
rm -rf /root/.cache /tmp/* /var/tmp/*
rm -f *.rpm
