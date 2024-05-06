#!/bin/bash

# Setting ENV
export KEYRING_DIR=/usr/share/keyrings
export APT_LIST_DIR=/etc/apt/sources.list.d

# Provided from the user
export GPG_URL=https://packages.element.io/debian/element-io-archive-keyring.gpg
export APT_REPO_URL=https://packages.element.io/debian/
export APT_LIST_NAME=element-io.list

# Constructed from above
export GPG_FILENAME=${GPG_URL##*/}
export GPG_PATH=$KEYRING_DIR/$GPG_FILENAME




sudo wget -O $GPG_PATH $GPG_URL

echo "deb [signed-by=$GPG_PATH] $APT_REPO_URL default main" | sudo tee $APT_LIST_DIR/$APT_LIST_NAME

sudo apt update

sudo apt install element-desktop


#echo $GPG_PATH
#echo $GPG_URL
#echo $APT_REPO_URL
#echo $APT_LIST_DIR/$APT_LIST_NAME
#echo "deb [signed-by=$GPG_PATH] $APT_REPO_URL default main | sudo tee $APT_LIST_DIR/$APT_LIST_NAME"