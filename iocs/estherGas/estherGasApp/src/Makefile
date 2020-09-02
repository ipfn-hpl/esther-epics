TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC support library

LIBRARY_IOC += IUSTISupport

# Compile and add the code to the support library
#IUSTISupport_SRCS += serialIustiAPDriver.cpp

IUSTISupport_LIBS += asyn
ISTTOKSupport_LIBS += $(EPICS_BASE_IOC_LIBS)

#=============================
# Build the IOC application

PROD_IOC = estherGas
# estherGas.dbd will be created and installed
DBD += estherGas.dbd

# estherGas.dbd will be made up from these files:
estherGas_DBD += base.dbd

# Include dbd files from all support applications:
estherGas_DBD += s7nodave.dbd 
#estherGas_DBD +=  IUSTISupport.dbd

# Add all the support libraries needed by this IOC
estherGas_LIBS += s7nodave asyn 
#estherGas_LIBS += IUSTISupport s7nodave asyn 

# estherGas_registerRecordDeviceDriver.cpp derives from estherGas.dbd
estherGas_SRCS += estherGas_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
estherGas_SRCS_DEFAULT += estherGasMain.cpp
estherGas_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#estherGas_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
estherGas_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

