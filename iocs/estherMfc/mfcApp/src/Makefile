# SPDX-FileCopyrightText: 2003 Argonne National Laboratory
#
# SPDX-License-Identifier: EPICS

TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

PROD_IOC = mfc
# mfc.dbd will be created and installed
DBD += mfc.dbd

# mfc.dbd will be made up from these files:
mfc_DBD += base.dbd

# Include dbd files from all support applications:
#mfc_DBD += xxx.dbd
mfc_DBD += asyn.dbd
mfc_DBD += stream.dbd
mfc_DBD += drvAsynSerialPort.dbd
mfc_DBD += drvAsynIPPort.dbd
mfc_DBD += modbusSupport.dbd
mfc_DBD += asSupport.dbd

# Add all the support libraries needed by this IOC
#mfc_LIBS += xxx
mfc_LIBS += asyn
mfc_LIBS += stream
mfc_LIBS += modbus
mfc_LIBS += autosave

# mfc_registerRecordDeviceDriver.cpp derives from mfc.dbd
mfc_SRCS += mfc_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
mfc_SRCS_DEFAULT += mfcMain.cpp
mfc_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#mfc_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

mfc_LIBS += qsrv
mfc_LIBS += $(EPICS_BASE_PVA_CORE_LIBS)
mfc_DBD += PVAServerRegister.dbd
mfc_DBD += qsrv.dbd

# Finally link to the EPICS Base libraries
mfc_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

