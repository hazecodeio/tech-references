#!/bin/bash

sudo update-alternatives --install "/usr/bin/fsc" "fsc" "$SCALA_HOME/bin/fsc" 1
sudo update-alternatives --install "/usr/bin/scala" "scala" "$SCALA_HOME/bin/scala" 1
sudo update-alternatives --install "/usr/bin/scalac" "scalac" "$SCALA_HOME/bin/scalac" 1
sudo update-alternatives --install "/usr/bin/scaladoc" "scaladoc" "$SCALA_HOME/bin/scaladoc" 1
sudo update-alternatives --install "/usr/bin/scalap" "scalap" "$SCALA_HOME/bin/scalap" 1