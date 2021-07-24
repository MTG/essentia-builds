set -e -x

# Install CUDA and CuDNN so that TensorFlow can be built with GPU support.
CUDA_VERSION=11.2.2-1
CUDNN_VERSION=8.1.0.77-1

# First download the latest Nvidia CUDA from official repository and install CUDA
CUDA_REPO_VERSION=10.1.243-1
curl -SLO https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-repo-rhel7-${CUDA_REPO_VERSION}.x86_64.rpm
rpm -i cuda-repo-rhel7-${CUDA_REPO_VERSION}.x86_64.rpm
yum install -y cuda-${CUDA_VERSION}

# Install CuDNN and put it in the CUDA path
curl -SLO https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/libcudnn8-${CUDNN_VERSION}.cuda${CUDA_VERSION::4}.x86_64.rpm
curl -SLO https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/libcudnn8-devel-${CUDNN_VERSION}.cuda${CUDA_VERSION::4}.x86_64.rpm
rpm -i libcudnn8-${CUDNN_VERSION}.cuda${CUDA_VERSION::4}.x86_64.rpm
rpm -i libcudnn8-devel-${CUDNN_VERSION}.cuda${CUDA_VERSION::4}.x86_64.rpm

cp -P /usr/include/cudnn* /usr/local/cuda/include
cp -P /usr/lib64/libcudnn* /usr/local/cuda/lib64/

# Clean Up
rm cuda-repo-rhel7-${CUDA_REPO_VERSION}.x86_64.rpm
rm libcudnn8-${CUDNN_VERSION}.cuda${CUDA_VERSION::4}.x86_64.rpm
rm libcudnn8-devel-${CUDNN_VERSION}.cuda${CUDA_VERSION::4}.x86_64.rpm
