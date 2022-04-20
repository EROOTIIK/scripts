#!/bin/bash

apt install openssh-server -y
sed -i '/#PermitRootLogin prohibit-password/a PermitRootLogin yes' /etc/ssh/sshd_config
service sshd restart
