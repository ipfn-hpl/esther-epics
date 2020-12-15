#!/bin/bash
#
cd /home/esther/EPICS/archive-engine-4.1.0
./ArchiveEngine -pluginCustomization esther.ini -engine estherPulse -port 4812&
sleep 2s
echo "Archive Started. Check browser at  http://localhost:4812/main"
