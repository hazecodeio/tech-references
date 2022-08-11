#!/bin/bash

suffix=_17
jdk_home=/opt/langs/java/jdk17-current
jdk_bin=$jdk_home/bin

find $jdk_bin -type f -regextype posix-extended -regex '(./|/).*' | grep --color -iE '[a-Z]+$' -o | xargs echo -n | jq --arg suffix $suffix -R 'split(" ") | .[]' | xargs -i update-alternatives --remove-all {}$suffix
