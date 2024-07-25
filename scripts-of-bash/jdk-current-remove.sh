#!/bin/bash

sdk_home=/opt/langs/java/jdk-current
sdk_bin=$sdk_home/bin

find $sdk_bin -type f -regextype posix-extended -regex '(./|/).*' | grep --color -iE '[a-Z]+\.[a-Z]+$' -v | grep --color -iE '[a-Z]+$' -o | xargs echo -n | jq -R 'split(" ") | .[]' | sudo -- xargs -i update-alternatives --remove-all {}
