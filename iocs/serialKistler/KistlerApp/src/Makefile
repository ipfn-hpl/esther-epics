TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

PROD_IOC = Kistler
# Kistler.dbd will be created and installed
DBD += Kistler.dbd

# Kistler.dbd will be made up from these files:
Kistler_DBD += base.dbd

# Include dbd files from all support applications:
Kistler_DBD += asyn.dbd
Kistler_DBD += stream.dbd
Kistler_DBD += drvAsynSerialPort.dbd

# Add all the support libraries needed by this IOC
Kistler_LIBS += stream
Kistler_LIBS += asyn

# Kistler_registerRecordDeviceDriver.cpp derives from Kistler.dbd
Kistler_SRCS += Kistler_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
Kistler_SRCS_DEFAULT += KistlerMain.cpp
Kistler_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#Kistler_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
Kistler_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

