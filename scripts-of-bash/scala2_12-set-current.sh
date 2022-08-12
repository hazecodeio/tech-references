#!/bin/bash

source /etc/profile.d/scala.sh

find $SCALA_HOME/bin -type f -regextype posix-extended -regex '(./|/).*' | grep --color -iE '[a-Z]+\.[a-Z]+$' -v | grep --color -iE '[a-Z]+$' -o | xargs echo -n | jq -R 'split(" ") | .[]' | xargs -i update-alternatives --remove-all {}

ln -snf /opt/langs/scala/scala2_12-current /opt/langs/scala/scala-current

sdk_home=/opt/langs/scala/scala-current
sdk_bin=$sdk_home/bin
dst=/usr/bin

find $sdk_bin -type f -regextype posix-extended -regex '(./|/).*' | grep --color -iE '[a-Z]+\.[a-Z]+$' -v | grep --color -iE '[a-Z]+$' -o | xargs echo -n | jq -R 'split(" ") | .[]' | xargs -i update-alternatives --install $dst/{} {} $sdk_bin/{} 1
