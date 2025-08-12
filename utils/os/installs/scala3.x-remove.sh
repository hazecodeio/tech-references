#!/bin/bash

suffix=3.x
sdk_home=/opt/_langs/scala/scala3.x-current
sdk_bin="${sdk_home}"/bin

find "${sdk_bin}" -type f -regextype posix-extended -regex '(./|/).*' | grep --color -iE '[a-Z]+\.[a-Z]+$' -v | grep --color -iE '[a-Z]+[a-Z|_-]*[a-Z]+$' -o | xargs echo -n | jq -R 'split(" ") | .[]' | sudo -- xargs -i update-alternatives --remove-all {}"${suffix}"
