TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

PROD_IOC = vac
# vac.dbd will be created and installed
DBD += vac.dbd

# vac.dbd will be made up from these files:
vac_DBD += base.dbd

# Include dbd files from all support applications:
#vac_DBD += xxx.dbd
vac_DBD += asyn.dbd
vac_DBD += drvAsynSerialPort.dbd
vac_DBD += drvAsynIPPort.dbd
vac_DBD += calc.dbd
vac_DBD += stream.dbd
vac_DBD += modbusSupport.dbd
vac_DBD += asSupport.dbd

# Add all the support libraries needed by this IOC
#vac_LIBS += xxx
vac_LIBS += asyn
vac_LIBS += calc
vac_LIBS += stream
vac_LIBS += modbus
vac_LIBS += autosave

# vac_registerRecordDeviceDriver.cpp derives from vac.dbd
vac_SRCS += vac_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
vac_SRCS_DEFAULT += vacMain.cpp
vac_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#vac_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

vac_LIBS += qsrv
vac_LIBS += $(EPICS_BASE_PVA_CORE_LIBS)
vac_DBD += PVAServerRegister.dbd
vac_DBD += qsrv.dbd

# Finally link to the EPICS Base libraries
vac_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

