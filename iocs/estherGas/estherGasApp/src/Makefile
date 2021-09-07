TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE

#=============================
# Build the IOC support library

LIBRARY_IOC += estherGasSupport

# xxxRecord.h will be created from xxxRecord.dbd
#DBDINC += xxxRecord
# Install devXxxSoft.dbd into <top>/dbd
#DBD += xxxSupport.dbd

# Compile and add the code to the support library
#estherGasSupport_SRCS += xxxRecord.c
#estherGasSupport_SRCS += devXxxSoft.c

# Link locally-provided code into the support library,
# rather than directly into the IOC application.
#estherGasSupport_SRCS += dbSubExample.c
#estherGasSupport_SRCS += estherGasHello.c
estherGasSupport_SRCS += initTrace.c

estherGasSupport_LIBS += $(EPICS_BASE_IOC_LIBS)

#=============================
# Build the IOC application

PROD_IOC = estherGas
# estherGas.dbd will be created and installed
DBD += estherGas.dbd

# estherGas.dbd will be made up from these files:
estherGas_DBD += base.dbd
#estherGas_DBD += xxxSupport.dbd
#estherGas_DBD += dbSubExample.dbd
#estherGas_DBD += estherGasHello.dbd
estherGas_DBD += initTrace.dbd
estherGas_DBD += s7nodave.dbd

# estherGas_registerRecordDeviceDriver.cpp derives from estherGas.dbd
estherGas_SRCS += estherGas_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
estherGas_SRCS_DEFAULT += estherGasMain.cpp
estherGas_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#estherGas_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Link in the code from the support library
estherGas_LIBS += estherGasSupport
estherGas_LIBS += asyn 
estherGas_LIBS += s7nodave

# NOTE: To build SNL programs, SNCSEQ must be defined
# in the <top>/configure/RELEASE file


# Finally link to the EPICS Base libraries
estherGas_LIBS += $(EPICS_BASE_IOC_LIBS)

#=============================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

