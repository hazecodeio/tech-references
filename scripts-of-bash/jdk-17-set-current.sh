#!/bin/bash

source /etc/profile.d/jdk.sh

find $JAVA_HOME/bin -type f -regextype posix-extended -regex '(./|/).*' | grep --color -iE '[a-Z]+\.[a-Z]+$' -v | grep --color -iE '[a-Z]+$' -o | xargs echo -n | jq -R 'split(" ") | .[]' | xargs -i update-alternatives --remove-all {}

ln -snf /opt/langs/java/jdk17-current /opt/langs/java/jdk-current

sdk_home=/opt/langs/java/jdk17-current
sdk_bin=$sdk_home/bin
dst=/usr/bin

find $sdk_bin -type f -regextype posix-extended -regex '(./|/).*' | grep --color -iE '[a-Z]+\.[a-Z]+$' -v | grep --color -iE '[a-Z]+$' -o | xargs echo -n | jq -R 'split(" ") | .[]' | xargs -i update-alternatives --install $dst/{} {} $sdk_bin/{} 1
