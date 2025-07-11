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

PROD_IOC = vrs53
# vrs53.dbd will be created and installed
DBD += vrs53.dbd

# vrs53.dbd will be made up from these files:
vrs53_DBD += base.dbd
vrs53_DBD += asyn.dbd
vrs53_DBD += stream.dbd
vrs53_DBD += drvAsynSerialPort.dbd
#vac_DBD += drvAsynIPPort.dbd


# Include dbd files from all support applications:
#vrs53_DBD += xxx.dbd

# Add all the support libraries needed by this IOC
#vrs53_LIBS += xxx

# vrs53_registerRecordDeviceDriver.cpp derives from vrs53.dbd
vrs53_SRCS += vrs53_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
vrs53_SRCS_DEFAULT += vrs53Main.cpp
vrs53_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#vrs53_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

vrs53_LIBS += asyn
vrs53_LIBS += stream

# Link QSRV (pvAccess Server) if available
ifdef EPICS_QSRV_MAJOR_VERSION
    vrs53_LIBS += qsrv
    vrs53_LIBS += $(EPICS_BASE_PVA_CORE_LIBS)
    vrs53_DBD += PVAServerRegister.dbd
    vrs53_DBD += qsrv.dbd
endif
# Finally link to the EPICS Base libraries
vrs53_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

