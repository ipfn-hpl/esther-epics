TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS BELOW HERE

# Use typed rset structure (see 3.16.1 release notes)
USR_CPPFLAGS += -DUSE_TYPED_RSET

# xxxRecord.h will be created from xxxRecord.dbd
#DBDINC += xxxRecord

# Install xxxSupport.dbd into <top>/dbd
#DBD += xxxSupport.dbd

# Build an IOC support library
LIBRARY_IOC += vacSupport

# Compile and add code to the support library
#vacSupport_SRCS += xxxRecord.c
#vacSupport_SRCS += devXxxSoft.c

# Link locally-provided code into the support library,
# rather than directly into the IOC application, that
# causes problems on Windows DLL builds
#vacSupport_SRCS += dbSubExample.c
#vacSupport_SRCS += devvacVersion.c
#vacSupport_SRCS += vacHello.c
vacSupport_SRCS += initTrace.c

vacSupport_LIBS += $(EPICS_BASE_IOC_LIBS)

# Auto-generate a header file containing a version string.
# Version comes from the VCS if available, else date+time.
#GENVERSION = vacVersion.h
# Macro name
#GENVERSIONMACRO = vacVERSION

# Build the IOC application
PROD_IOC = vac

# vac.dbd will be created and installed
DBD += vac.dbd

# vac.dbd will include these files:
vac_DBD += base.dbd
vac_DBD += asyn.dbd
vac_DBD += drvAsynSerialPort.dbd
vac_DBD += calc.dbd
vac_DBD += stream.dbd
vac_DBD += s7nodave.dbd
#vac_DBD += modbusSupport.dbd

vac_DBD += initTrace.dbd

# vac_registerRecordDeviceDriver.cpp derives from vac.dbd
vac_SRCS += vac_registerRecordDeviceDriver.cpp

# Build the main IOC entry point where needed
vac_SRCS_DEFAULT += vacMain.cpp
vac_SRCS_vxWorks += -nil-

# Link in the code from our support library
vac_LIBS += vacSupport

# Add all the support libraries needed by this IOC
vac_LIBS += asyn
vac_LIBS += calc
vac_LIBS += stream
vac_LIBS += s7nodave
#vac_LIBS += modbus


# To build SNL programs, SNCSEQ must be defined
# in the <top>/configure/RELEASE file
ifneq ($(SNCSEQ),)
    # Build sncEstherVacuum into vacSupport
    sncEstherVacuum += +r
    vac_DBD += sncEstherVacuum.dbd
    # A .stt sequence program is *not* pre-processed:
    vacSupport_SRCS += sncEstherVacuum.stt
    vacSupport_LIBS += seq pv
    vac_LIBS += seq pv
endif

# Link QSRV (pvAccess Server) if available
ifdef EPICS_QSRV_MAJOR_VERSION
    vac_LIBS += qsrv
    vac_LIBS += $(EPICS_BASE_PVA_CORE_LIBS)
    vac_DBD += PVAServerRegister.dbd
    vac_DBD += qsrv.dbd
endif

# Finally link IOC to the EPICS Base libraries
vac_LIBS += $(EPICS_BASE_IOC_LIBS)

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD EXTRA GNUMAKE RULES BELOW HERE

# Explicit dependency needed for generated header file
devvacVersion$(DEP): $(COMMON_DIR)/$(GENVERSION)
