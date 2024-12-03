#!/bin/bash

# gum install for fedora.

echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo &> /dev/null

sudo yum install --assumeyes gum &> /dev/null