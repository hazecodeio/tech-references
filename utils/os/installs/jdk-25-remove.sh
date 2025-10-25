#!/bin/bash

suffix=25
sdk_home=/opt/_langs/java/jdk25-current
sdk_bin="${sdk_home}"/bin

find "${sdk_bin}" -type f -regextype posix-extended -regex '(./|/).*' | grep --color -iE '[a-Z]+\.[a-Z]+$' -v | grep --color -iE '[a-Z]+$' -o | xargs echo -n | jq --arg suffix "${suffix}" -R 'split(" ") | .[]' | sudo -- xargs -i update-alternatives --remove-all {}"${suffix}"
