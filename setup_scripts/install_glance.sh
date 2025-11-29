#!/bin/bash
curl -OL https://github.com/glanceapp/glance/releases/latest/download/glance-linux-amd64.tar.gz
sudo tar -C $HOME/opt/glance/ -xzf glance-linux-amd64.tar.gz
rm glance-linux-amd64.tar.gz
cp ./glance/glance.yml $HOME/opt/glance/
cp ./glance/glance.service /etc/systemd/system/
