#!/bin/bash

#export SCALA3_HOME=/opt/langs/scala/scala3-current/
#
#sudo update-alternatives --install "/usr/bin/scala3" "scala3" "$SCALA3_HOME/bin/scala" 1
#sudo update-alternatives --install "/usr/bin/scalac3" "scalac3" "$SCALA3_HOME/bin/scalac" 1
#sudo update-alternatives --install "/usr/bin/scaladoc3" "scaladoc3" "$SCALA3_HOME/bin/scaladoc" 1
#sudo update-alternatives --install "/usr/bin/common3" "common3" "$SCALA3_HOME/bin/common" 1


#!/bin/bash

suffix=3
jdk_home=/opt/langs/scala/scala3-current
jdk_bin=$jdk_home/bin
dst=/usr/bin

find $jdk_bin -type f -regextype posix-extended -regex '(./|/).*' | grep --color -iE '[a-Z]+$' -o | xargs echo -n | jq --arg suffix $suffix -R 'split(" ") | .[]' | xargs -i update-alternatives --install $dst/{}$suffix {}$suffix $jdk_bin/{} 1
