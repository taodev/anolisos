#!/bin/sh

# 安装oh-my-zsh
if [ ! -f "/build/pkg/ohmyzsh-master.zip" ]; then 
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
  # 判断下载是否成功
  if [ ! -d "~/.oh-my-zsh" ]; then 
    exit 1
  fi 
else 
  unzip /build/pkg/ohmyzsh-master.zip -d /root/
  mv ~/ohmyzsh-master ~/.oh-my-zsh
fi 

cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
chsh -s $(which zsh)
# 打开golang插件
sed -i "/.*plugins=(*/c\plugins=(git golang)" .zshrc

# 安装nvm
if [ ! -f "/build/pkg/nvm-master.zip" ]; then 
  git clone --depth=1 https://github.com/nvm-sh/nvm.git ~/.nvm
  # 判断下载是否成功
  if [ ! -d "~/.nvm" ]; then 
    exit 1
  fi 
else 
  unzip /build/pkg/nvm-master.zip -d ~/
  mv ~/nvm-master ~/.nvm
fi

# 安装git lfs
rpm -ivh /build/pkg/git-lfs-3.2.0-1.x86_64.rpm
git lfs install

# 下载golang 
wget https://dl.google.com/go/go1.19.2.linux-amd64.tar.gz
tar -C /usr/local -zxf ./go1.19.2.linux-amd64.tar.gz
rm -f ./go1.19.2.linux-amd64.tar.gz

mkdir -p /gopkg/bin
cat /build/script/environment >> ~/.bash_profile
cat /build/script/environment >> ~/.zshrc

# golang环境变量
/usr/local/go/bin/go env -w GO111MODULE=on
/usr/local/go/bin/go env -w GOPROXY=https://goproxy.cn,direct
/usr/local/go/bin/go env -w GOROOT=/usr/local/go
/usr/local/go/bin/go env -w GOPATH=/gopkg
/usr/local/go/bin/go env -w GOBIN=$HOME/bin

# sshd配置
mkdir -p ~/.ssh
chmod 600 ~/.ssh

sed -i "s#/etc/ssh/ssh_host_rsa_key#~/.ssh/ssh_host_rsa_key#" /etc/ssh/sshd_config
sed -i "s#/etc/ssh/ssh_host_ecdsa_key#~/.ssh/ssh_host_ecdsa_key#" /etc/ssh/sshd_config
sed -i "s#/etc/ssh/ssh_host_ed25519_key#~/.ssh/ssh_host_ed25519_key#" /etc/ssh/sshd_config
cp /etc/ssh/sshd_config ~/.ssh/

ssh-keygen -t rsa -f ~/.ssh/ssh_host_rsa_key
ssh-keygen -t ecdsa -f ~/.ssh/ssh_host_ecdsa_key
ssh-keygen -t ed25519 -f ~/.ssh/ssh_host_ed25519_key

touch /root/.ssh/authorized_keys

echo "root:admin" | chpasswd 


wget -O- https://aka.ms/install-vscode-server/setup.sh | bash

code-server --version

# 创建工作目录
mkdir -p /code
