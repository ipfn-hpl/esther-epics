# SPDX-FileCopyrightText: 1998 Argonne National Laboratory
#
# SPDX-License-Identifier: EPICS

TOP=../..
include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE

#----------------------------------------------------
# Create and install (or just install) into <top>/db
# databases, templates, substitutions like this
#DB += xxx.db
DB += S7-opcua-PT.db
DB += S7-opcua-Alarms.db
DB += S7-opcua-PT-sp.db
DB += S7-opcua-PV-master.db
DB += S7-opcua-PV.db
DB += S7-opcua-MFC.db
DB += S7-opcua-Control.db
DB += nWRG.db
DB += nWRG.proto
DB += ambient.db

#----------------------------------------------------
# If <anyname>.db template is not named <anyname>*.template add
# <anyname>_template = <templatename>

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

