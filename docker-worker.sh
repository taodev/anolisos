#!/bin/sh

docker compose --file=docker-copy-root.yml up

# 拷贝本机公钥
cat $HOME/.ssh/id_ed25519.pub >> volume/root/.ssh/authorized_keys

docker compose up -d
