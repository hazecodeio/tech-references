#!/bin/bash

suffix=_11
jdk_home=/opt/langs/java/jdk11-current
jdk_bin=$jdk_home/bin
dst=/usr/bin

find $jdk_bin -type f -regextype posix-extended -regex '(./|/).*' | grep --color -iE '[a-Z]+$' -o | xargs echo -n | jq --arg suffix $suffix -R 'split(" ") | .[]' | xargs -i update-alternatives --install $dst/{}$suffix {}$suffix $jdk_bin/{} 1
