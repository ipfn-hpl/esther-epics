#!/bin/sh
# Launch CS-Studio GUI
#
CSS_HOME=/opt/epics/cs-studio
#cd /opt/epics/cs-studio
#cd Projects/CSS/cs-studio
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

$CSS_HOME/cs-studio&

