#!/bin/bash
set -euo pipefail

CUDA_VERSION=12-3
CUDA_MAJOR=12.3

# ----------------------------
# Add NVIDIA CUDA RHEL8 repo
# ----------------------------
curl -fsSL \
  https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/cuda-rhel8.repo \
  -o /etc/yum.repos.d/cuda.repo

yum clean all
yum makecache

# ----------------------------
# Install minimal CUDA 12.3 toolkit
# (no drivers inside container)
# ----------------------------
yum -y install \
  cuda-nvcc-${CUDA_VERSION} \
  cuda-cudart-devel-${CUDA_VERSION} \
  cuda-libraries-devel-${CUDA_VERSION} \
  cuda-toolkit-${CUDA_VERSION} \
  --exclude=cuda-drivers

# ----------------------------
# Install cuDNN 9.x for CUDA 12.3
# (TensorFlow 2.17 requirement)
# ----------------------------
yum -y install \
  libcudnn9-cuda-12 \
  libcudnn9-devel-cuda-12

# ----------------------------
# Cleanup yum cache
# ----------------------------
yum clean all
rm -rf /var/cache/yum /var/cache/dnf

# ----------------------------
# Environment setup
# ----------------------------
export CUDA_HOME=/usr/local/cuda-${CUDA_MAJOR}
export PATH=${CUDA_HOME}/bin:${PATH}
export LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}

# Optional: symlink for compatibility
ln -sfn /usr/local/cuda-${CUDA_MAJOR} /usr/local/cuda

# ----------------------------
# Verify installation
# ----------------------------
echo "=== NVCC ==="
nvcc --version

echo "=== cuDNN ==="
ldconfig -p | grep cudnn || echo "cuDNN not visible in linker cache"

# ----------------------------
# Final cleanup to reduce image size
# ----------------------------
rm -rf /root/.cache /tmp/* /var/tmp/*
