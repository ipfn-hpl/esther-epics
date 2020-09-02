/*************************************************************************
 *
 * Project       : ESTHER IGNITION System  slow Control
 *
 * Description   : serialIustiAPDriverApp.h
 *              based on testAsynPortDriver.cpp
 *
 * Author        : Bernardo Carvalho (IPFN-IST)
 * Copyright 2015 IPFN-Instituto Superior Tecnico, Portugal
 * Creation Date 24/04/2015
 *
 * Licensed under the EUPL, Version 1.1 or - as soon they
 * will be approved by the European Commission - subsequent  
 * versions of the EUPL (the "Licence");
 * You may not use this work except in compliance with the
 * Licence.
 * You may obtain a copy of the Licence at:
 *  
 * http://ec.europa.eu/idabc/eupl
 *
 * Unless required by applicable law or agreed to in
 * writing, software distributed under the Licence is
 * distributed on an "AS IS" basis,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied.
 * See the Licence for the specific language governing
 * permissions and limitations under the Licence. 
 *
 *
 * SVN keywords
 * $Date: 2015-04-24 19:35:48 +0100 (Fri, 24 Apr 2015) $
 * $Revision: 7321 $
 * $URL: http://metis.ipfn.ist.utl.pt:8888/svn/cdaq/ESTHER/Ignition-System/Software/EPICS/serialIusti/serialIustiTestApp/src/serialIustiAPDriver.h $
 *
 *
 ************************************************************************/


#include "asynPortDriver.h"

/* These are the drvInfo strings that are used to identify the parameters.
 * They are used by asyn clients, including standard asyn device support */

#define P_UpTimeString            "PIC_UPTIME"        /* asynInt32,    r/o */
#define P_VchargeString           "PIC_VOLT_CHARGE"   /* asynInt32,    r/w */
#define P_PulseTimeString         "PIC_PULSE_TIME"    /* asynInt32,    r/w */
#define P_PsStateString           "PIC_PS_STATE"      /* asynInt32,    r/o */
#define P_Wire1StateString        "PIC_WIRE_1_STATE"  /* asynInt32,    r/o */
#define P_Wire2StateString        "PIC_WIRE_2_STATE"  /* asynInt32,    r/o */
#define P_Wire3StateString        "PIC_WIRE_3_STATE"  /* asynInt32,    r/o */
#define P_CapVoltageString        "PIC_CAP_VOLTAGE"   /* asynInt32,    r/o */
#define P_ActionString            "PIC_ACTION"   /* asynInt32,    r/w */

/** Class that demonstrates the use of the asynPortDriver base class to greatly simplify the task
 * of writing an asyn port driver.
 * This class does a simple simulation of a digital oscilloscope.  It computes a waveform, computes
 * statistics on the waveform, and does callbacks with the statistics and the waveform data itself.
 * I have made the methods of this class public in order to generate doxygen documentation for them,
 * but they should really all be private. */
class serialIustiAPDriver : public asynPortDriver {
 public:
  serialIustiAPDriver(const char *portName, const char *serialportName, int maxArraySize);

  /* These are the methods that we override from asynPortDriver */
  virtual asynStatus writeInt32(asynUser *pasynUser, epicsInt32 value);
  //  virtual asynStatus writeFloat64(asynUser *pasynUser, epicsFloat64 value);
  //virtual asynStatus readFloat64Array(asynUser *pasynUser, epicsFloat64 *value,
  //      size_t nElements, size_t *nIn);
  //virtual asynStatus readEnum(asynUser *pasynUser, char *strings[], int values[], int severities[],
  //      size_t nElements, size_t *nIn);

  /* These are the methods that are new to this class */
  void blockReadTask(void);

 protected:
  /** Values used for pasynUser->reason, and indexes into the parameter library. */
  int P_UpTime;
#define FIRST_PIC_COMMAND P_UpTime
  int  P_Vcharge, P_PulseTime, P_CapVoltage, P_PsState, P_Wire1State, P_Wire2State, P_Wire3State, P_Action;
#define LAST_PIC_COMMAND P_Action

 private:
  /* Our data */
  epicsEventId eventId_;
  asynUser *pasynUserSPort;
  //  epicsInt32 chargeVoltsVal;
  //  int vCharge, pulseTime, action;
  //  const char *outputString_;
  //  epicsFloat64 *pData_;
  /* epicsFloat64 *pTimeBase_; */
  /* // Actual volts per division are these values divided by vertical gain */
  /* char *voltsPerDivStrings_[NUM_VERT_SELECTIONS]; */
  /* int voltsPerDivValues_[NUM_VERT_SELECTIONS]; */
  /* int voltsPerDivSeverities_[NUM_VERT_SELECTIONS]; */
  /* void setVertGain(); */
  /* void setVoltsPerDiv(); */
  /* void setTimePerDiv(); */
};

#define NUM_PIC_PARAMS (&LAST_PIC_COMMAND - &FIRST_PIC_COMMAND + 1)

