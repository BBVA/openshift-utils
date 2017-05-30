#!/bin/sh -e

### Pre-installation actions
yum install -y gcc
yum install -y kernel-devel-$(uname -r) kernel-headers-$(uname -r)
yum install -y epel-release

### Runtime
CUDA_CHECKSUM=da1b936d19b904413a17661b61d0140f
CUDA_RPM=cuda-repo-rhel7-8.0.61-1.x86_64.rpm

curl -fsSL http://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/$CUDA_RPM -O
if [ "$(md5sum $CUDA_RPM | awk '{print $1}')" != $CUDA_CHECKSUM ]; then
    exit 1
fi

rpm -i $CUDA_RPM
yum clean expire-cache
yum install cuda -y

export PATH=/usr/local/cuda-8.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64\${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

if [[ "${install-example}" == 'true' ]];then
  cuda-install-samples-8.0.sh $(pwd)
fi

setenforce 0

rpm -ivh --nodeps https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.1/nvidia-docker-1.0.1-1.x86_64.rpm
yum -y install xorg-x11-drv-nvidia xorg-x11-drv-nvidia-devel
modprobe -r nouveau
nvidia-modprobe
systemctl restart nvidia-docker
systemctl enable nvidia-docker
systemctl enable docker