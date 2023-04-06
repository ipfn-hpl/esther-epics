#!/bin/sh
# Launch CS-Studio GUI version 4.6.x (Phoebus)
# https://controlssoftware.sns.ornl.gov/css_phoebus/
JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
PATH=$JAVA_HOME/bin:$PATH
echo $PATH
#cd /home/esther/GIT_REPOS/esther-epics/phoebus-display-builder
cd $HOME/git-repos/esther-epics/phoebus-display-builder
# /home/esther/CSS/phoebus-4.6.6/phoebus.sh
/opt/epics/phoebus.sh

