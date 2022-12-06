#!/bin/bash
#
#
JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
PATH=$JAVA_HOME/bin:$PATH

CSS_HOME=/home/esther/css-phoebus

$CSS_HOME/epics-archive-engine.sh -engine estherPulse -port 4812 -settings esther.ini &

echo "Archive Started. Check browser at  http://localhost:4812/main"

