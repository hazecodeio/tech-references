#!/bin/bash

#sudo update-alternatives --remove-all scala3
#sudo update-alternatives --remove-all scalac3
#sudo update-alternatives --remove-all scaladoc3
#sudo update-alternatives --remove-all common3


suffix=2_12
sdk_home=/opt/langs/scala/scala2_12-current/
sdk_bin=$sdk_home/bin

find $sdk_bin -type f -regextype posix-extended -regex '(./|/).*' | grep --color -iE '[a-Z]+\.[a-Z]+$' -v | grep --color -iE '[a-Z]+$' -o | xargs echo -n | jq --arg suffix $suffix -R 'split(" ") | .[]' | xargs -i update-alternatives --remove-all {}$suffix
