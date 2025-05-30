#!/bin/sh
# To replace engine:
# ./archive-engine.sh -import ./xml/estherEngineConfigPulse.xml -replace_engine -engine estherPulse -settings esther.ini

# To run:
# ./epics-archive-engine.sh -engine estherPulse -settings esther.ini
#
# Archive Engine launcher for Linux or Mac OS X
# get latest at:
# https://controlssoftware.sns.ornl.gov/css_phoebus/nightly
#
# When deploying, change "TOP"
# to the absolute installation path
#TOP="./archive-engine"
#TOP="/opt/epics/archive-engine"
TOP="/opt/epics/archive-engine-4.7.3-SNAPSHOT"

# Ideally, assert that Java is found
# export JAVA_HOME=/opt/jdk-9
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH="$JAVA_HOME/bin:$PATH"

if [ -d $TOP/target ]
then
  TOP="$TOP/target"
fi

JAR=`echo "${TOP}/service-archive-engine-*.jar"`

#java -jar $JAR $OPT "$@"
$JAVA_HOME/bin/java -jar $JAR -engine estherPulse -settings esther.ini


echo "Archive Started. Check browser at  http://localhost:4812/main"

