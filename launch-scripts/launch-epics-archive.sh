#!/bin/bash
#
# To import engine:
# /opt/epics7/archive-engine-4.6.6/archive-engine.sh -settings esther.ini -engine estherPulse -delete_config
# /opt/epics7/archive-engine-4.6.6/archive-engine.sh -settings esther.ini -engine estherPulse -import estherEngineConfigPulse.xml
#
JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
PATH=$JAVA_HOME/bin:$PATH
/opt/epics7/archive-engine-4.6.6/archive-engine.sh -engine estherPulse -port 4812 -settings esther.ini &

echo "Archive Started. Check browser at  http://localhost:4812/main"

