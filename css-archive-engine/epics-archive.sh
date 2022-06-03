#!/bin/bash
#
# To replace engine:
# /opt/css-phoebus/archive-engine-4.6.10/archive-engine.sh -settings esther.ini -engine estherPulse -delete_config
# /opt/css-phoebus/archive-engine-4.6.10/archive-engine.sh -settings esther.ini -engine estherPulse -import xml/estherEngineConfigPulse.xml
#
JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
PATH=$JAVA_HOME/bin:$PATH
CSS_HOME="/opt/css-phoebus/archive-engine-4.6.10"
#/archive-engine.sh -engine estherPulse -port 4812 -settings esther.ini &

TOP="/home/bernardo/EPICS/esther-epics/css-archive-engine"
#TOP="/home/bernardo/EPICS/esther-epics/css-archive-engines-archive-engine"
cd $TOP
#JAR=`echo "${TOP}/service-archive-engine-*.jar"`
#JAR=$(ls service-archive-engine-*.jar)
JAR=$CSS_HOME/service-archive-engine-last.jar
#$JAVA_HOME/bin/java -jar $JAR $OPT "$@"
$JAVA_HOME/bin/java -jar $JAR  -engine estherPulse -port 4812 -settings esther.ini -noshell

#sleep 2s

echo "Archive Started. Check browser at  http://localhost:4812/main"

