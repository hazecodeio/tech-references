#!/bin/bash

#sudo update-alternatives --remove-all scala3
#sudo update-alternatives --remove-all scalac3
#sudo update-alternatives --remove-all scaladoc3
#sudo update-alternatives --remove-all common3


suffix=3
jdk_home=/opt/langs/scala/scala3-current
jdk_bin=$jdk_home/bin

find $jdk_bin -type f -regextype posix-extended -regex '(./|/).*' | grep --color -iE '[a-Z]+$' -o | xargs echo -n | jq --arg suffix $suffix -R 'split(" ") | .[]' | xargs -i update-alternatives --remove-all {}$suffix
