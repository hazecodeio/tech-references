#!/bin/bash

source /etc/profile.d/jdk.sh

find $JAVA_HOME/bin -type f -regextype posix-extended -regex '(./|/).*' | grep --color -iE '[a-Z]+$' -o | xargs echo -n | jq -R 'split(" ") | .[]' | xargs -i update-alternatives --remove-all {}

ln -snf /opt/langs/java/jdk11-current /opt/langs/java/jdk-current

jdk_home=/opt/langs/java/jdk11-current
jdk_bin=$jdk_home/bin
dst=/usr/bin

find $jdk_bin -type f -regextype posix-extended -regex '(./|/).*' | grep --color -iE '[a-Z]+$' -o | xargs echo -n | jq -R 'split(" ") | .[]' | xargs -i update-alternatives --install $dst/{} {} $jdk_bin/{} 1
