#!/bin/bash
set -euox pipefail

CUDA_VERSION=12.2
CUDNN_VERSION=8.9.5.29-1

check_rpm() {
  local file="$1"
  if ! file "$file" | grep -q "RPM"; then
    echo "❌ Download failed: $file is not a valid RPM package"
    exit 1
  fi
}

# ----------------------------
# Add NVIDIA CUDA repo
# ----------------------------
curl -sSLO https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/cuda-rhel8.repo
mv cuda-rhel8.repo /etc/yum.repos.d/cuda.repo
yum clean all
yum makecache

# ----------------------------
# Install minimal CUDA toolkit
# ----------------------------
yum -y install cuda-toolkit-12-2

# ----------------------------
# Download cuDNN runtime and dev packages
# ----------------------------
CUDNN_RPM="libcudnn8-${CUDNN_VERSION}.cuda${CUDA_VERSION}.x86_64.rpm"
CUDNN_DEV_RPM="libcudnn8-devel-${CUDNN_VERSION}.cuda${CUDA_VERSION}.x86_64.rpm"

curl -sSLO "https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/${CUDNN_RPM}"
curl -sSLO "https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/${CUDNN_DEV_RPM}"

# Check downloads
check_rpm "$CUDNN_RPM"
check_rpm "$CUDNN_DEV_RPM"

# ----------------------------
# Install cuDNN
# ----------------------------
yum -y localinstall "$CUDNN_RPM" "$CUDNN_DEV_RPM"

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
# Clean yum cache again to save space
# ----------------------------
yum clean all
rm -rf /var/cache/yum /tmp/*

