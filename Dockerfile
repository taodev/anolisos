FROM openanolis/anolisos:8.6
LABEL Author="taodev@qq.com"
LABEL Version="v0.1.0"

USER root
WORKDIR /root

# # 安装基础包
RUN dnf install -y wget curl vim git make telnet unzip \
  redis mysql openssh openssh-server openssh-clients \
  util-linux-user zsh \
  gcc gcc-c++ gdb
  
# RUN dnf groupinstall -y "Development Tools"

COPY . /build/

RUN /build/script/build_image.sh

# 清除缓存
RUN dnf clean all && rm -fr /build

# sshd端口
EXPOSE 22
