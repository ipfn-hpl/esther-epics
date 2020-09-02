/*************************************************************************
 *
 * Project       : ESTHER IGNITION System  slow Control
 *
 * Description   : serialIustiAPDriverApp.cpp
 *              based on testAsynPortDriver.cpp
 *
 * Author        : Bernardo Carvalho (IPFN-IST)
 * Copyright 2015 IPFN-Instituto Superior Tecnico, Portugal
 * Creation Date 24/04/2015
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
 * $URL: http://metis.ipfn.ist.utl.pt:8888/svn/cdaq/ESTHER/Ignition-System/Software/EPICS/serialIusti/serialIustiTestApp/src/serialIustiAPDriver.cpp $
 *
 *
 ************************************************************************/
#include <epicsStdlib.h>
#include <string.h>
#include <epicsTimer.h>
//#include <epicsMutex.h>
//#include <epicsEvent.h>
#include <iocsh.h>

// #include "serialPicAPDriver.h"
#include "serialIustiAPDriver.h"
#include <epicsExport.h>
#include <asynOctetSyncIO.h>

#define BUFLEN 64
#define WRITE_TIMEOUT 2.0
//#define EOS_STR "\r\n"
#define EOS_STR "\n"
//#define NPAR 50    // max parameters in read message
#define PARMAX  20 // max no of chars per parameter

static const char *driverName="serialIustiAPDriver";
void blockReadTask(void *drvPvt);

/** Constructor for the serialIustiAPDriver class.
 * Calls constructor for the asynPortDriver base class.
 * \param[in] portName The name of the asyn port driver to be created.
 * \param[in] maxChars The maximum  number of .... */
serialIustiAPDriver::serialIustiAPDriver(const char *portName, const char *serialPortName, int maxChars)
  : asynPortDriver(portName,
		   1, /* maxAddr */
		   (int)NUM_PIC_PARAMS,
		   //   asynInt32Mask | asynFloat64Mask | asynFloat64ArrayMask | asynEnumMask | asynDrvUserMask, /* Interface mask */
		   //asynInt32Mask | asynFloat64Mask | asynFloat64ArrayMask | asynEnumMask,  /* Interrupt mask */
		   asynInt32Mask  | asynDrvUserMask, /* Interface mask */
		   asynInt32Mask  ,  /* Interrupt mask */
		   ASYN_CANBLOCK, /* asynFlags.  This driver does block and it is not multi-device, ASYN_MULTIDEVICE=0  */
		   1, /* Autoconnect */
		   0, /* Default priority */
		   0) /* Default stack size*/
{
  asynStatus status;
  //int i;
  const char *functionName = "serialIustiAPDriver";

  /* Connect to the port */
  status = pasynOctetSyncIO->connect(serialPortName, 0, &this->pasynUserSPort, NULL);
  if (status) {
    printf("%s:%s: pasynOctetSyncIO->connect failure, port:%s status=%d\n", driverName, functionName, serialPortName, status);
    return;
  }
  else
    printf("%s:%s: pasynOctetSyncIO->connect OK, status=%d\n", driverName, functionName, status);

  status = pasynOctetSyncIO->setInputEos(this->pasynUserSPort, EOS_STR, strlen(EOS_STR));
  if (status) {
    printf("%s:%s: pasynOctetSyncIO->setInputEos failure,  status=%d\n", driverName, functionName, status);
    return;
  }
  status = pasynOctetSyncIO->setOutputEos(this->pasynUserSPort, EOS_STR,  strlen(EOS_STR));
  if (status) {
    printf("%s:%s: pasynOctetSyncIO->setOutputEos failure,  status=%d\n", driverName, functionName, status);
    return;
  }

  eventId_ = epicsEventCreate(epicsEventEmpty);
  createParam(P_UpTimeString,             asynParamInt32,         &P_UpTime);
  /* r/w parameters*/
  createParam(P_PulseTimeString,          asynParamInt32,         &P_PulseTime);
  createParam(P_VchargeString,            asynParamInt32,         &P_Vcharge);
  createParam(P_ActionString,         asynParamInt32,         &P_Action);

  /* r/o parameters*/
  createParam(P_PsStateString,          asynParamInt32,         &P_PsState);
  createParam(P_Wire1StateString,       asynParamInt32,         &P_Wire1State);
  createParam(P_Wire2StateString,       asynParamInt32,         &P_Wire2State);
  createParam(P_Wire3StateString,       asynParamInt32,         &P_Wire3State);
  createParam(P_CapVoltageString,       asynParamInt32,         &P_CapVoltage);

  /*
    createParam(P_Temperature0String,       asynParamFloat64,       &P_Temperature0);
    createParam(P_Temperature1String,       asynParamFloat64,       &P_Temperature1);
    createParam(P_Temperature2String,       asynParamFloat64,       &P_Temperature2);
    createParam(P_Pressure4String,          asynParamFloat64,       &P_Pressure4);*/
  //createParam(P_TimePerDivString,         asynParamFloat64,       &P_TimePerDiv);

  /* Set the initial values of some parameters */
  //  setIntegerParam(P_MaxPoints,         maxPoints);
  //setIntegerParam(P_Run,               0);

  //This seet forces d value of 1, sending one message to Command Modules to open 
  //This happens always in the startup of ioc program
  setIntegerParam(P_PulseTime,  0);
  setIntegerParam(P_Vcharge,  0);
  setIntegerParam(P_Action,  0);
  //setIntegerParam(P_CapVoltage,  0);
  //setIntegerParam(P_Valve4,  1);
  //chargeVoltsVal = 0;

  /* Create the thread that computes the waveforms in the background */
  status = (asynStatus)(epicsThreadCreate("serialIustiAPDriverTask",
					  epicsThreadPriorityMedium,
					  epicsThreadGetStackSize(epicsThreadStackMedium),
					  (EPICSTHREADFUNC)::blockReadTask,
					  this) == NULL);
  if (status) {
    printf("%s:%s: epicsThreadCreate failure\n", driverName, functionName);
    return;
  }
}

void blockReadTask(void *drvPvt)
{
  serialIustiAPDriver *pPvt = (serialIustiAPDriver *)drvPvt;

  pPvt->blockReadTask();
}

/** Serial blocking read task to receive status data from dsPIC
 *
 *
 */

void serialIustiAPDriver::blockReadTask(void)
{
  /* This thread process received data packages from dsPIC  and does callbacks with it */
  char buf[BUFLEN];
  char subbuff[5];
  //  char chr;

  //int time =0;
  int readTimeout= 2;
  size_t nread;
  int eomReason;
  asynStatus status;
  asynUser *pasynUserSP = this->pasynUserSPort;

  //  char tfld[20], vfld[20];
  int val =0;
  //  int npar=0;
  //int i;

  /* Flush any stale input, since the next operation is likely to be a read */
  status = pasynOctetSyncIO->flush(pasynUserSP);

  // TODO check initial read
  status = pasynOctetSyncIO->read(pasynUserSP, buf, 10, // message size = 10 char ( no EOL ?)   BUFLEN,
				    readTimeout, &nread, &eomReason);

  printf("%s: pasynOctetSyncIO->read Initial: eomReason:%d, %c, %c, nread=%ld, %s_ end\n", driverName, eomReason, buf[0], buf[1], nread, buf);
  
  while (1) {
  //  Clear buffer
    memset(&buf, 0, BUFLEN);
    status = pasynOctetSyncIO->read(pasynUserSP, buf, 10, // message size = 10 char ( no EOL ?)   BUFLEN,
				    readTimeout, &nread, &eomReason);
    if (status) {
      printf("%s: pasynOctetSyncIO->read failure,  eomReason:%d, status=%d\n", driverName, eomReason, status);
    }
    else{
      // TODO check if initil == "CB"
      if((buf[0]!='C') ||  (buf[1]!='B') )
	printf("%s: pasynOctetSyncIO->read Error: eomReason:%d, %c, %c, nread=%ld, %s_ end\n", driverName, eomReason, buf[0], buf[1], nread, buf);
      else {
	memcpy(subbuff, &buf[2], 1 );
	subbuff[1] = '\0';
	val =atoi(subbuff);
	printf("etat-8:%d ,", val);
	setIntegerParam(P_PsState, val);
	
	memcpy(subbuff, &buf[3], 1 );
	subbuff[1] = '\0';
	val =atoi(subbuff);
	setIntegerParam(P_Wire1State, val);
	printf("wire 1 chr7:%d ,", val);
	
	memcpy(subbuff, &buf[4], 1);
	subbuff[1] = '\0';
	val =atoi(subbuff);
	setIntegerParam(P_Wire2State, val);
	printf("chr6:%d ,", val);
	
	memcpy(subbuff, &buf[5], 1);
	subbuff[1] = '\0';
	val =atoi(subbuff);
	setIntegerParam(P_Wire3State, val);
	
	memcpy(subbuff, &buf[6], 4 );
	subbuff[4] = '\0';
	val =atoi(subbuff);
	setIntegerParam(P_CapVoltage, val);      
	printf("volt7:%d \n", val);

	callParamCallbacks();
      }
    }
    epicsThreadSleep(0.08);//POLL_DELAY give time for other serial I/O ops
  }
}


/** Called when asyn clients call pasynInt32->write().
 * This function sends a signal to the blockReadTask thread if the value of P_Run has changed.
 * For all parameters it sets the value in the parameter library and calls any registered callbacks..
 * \param[in] pasynUser pasynUser structure that encodes the reason and address.
 * \param[in] value Value to write. */
asynStatus serialIustiAPDriver::writeInt32(asynUser *pasynUser, epicsInt32 value)
{
  int function = pasynUser->reason;
  asynStatus status = asynSuccess;
  asynUser *pasynUserSP = this->pasynUserSPort;

  const char *paramName;
  char buf[BUFLEN];
  const char *functionName = "writeInt32";
  //  const char *VL1_str[]  = {"VL1_0\r", "VL1_1\r"};
  //  const char *VL1_str[]  = {"VL1_0\r\n", "VL1_1\r\n"};
  //  const char *VL2_str[]  = {"VL2_0\r\n", "VL2_1\r\n"};
  //const char *VL3_str[]  = {"VL3_0\r\n", "VL3_1\r\n"};
  //const char *VL4_str[]  = {"VL4_0\r\n", "VL4_1\r\n"};
  //const char *VL1_str[]  = {"VL1_0", "VL1_1"};

  int pulseTime, vCharge;
  size_t nwrite =0;

  /* Set the parameter in the parameter library. */
  status = (asynStatus) setIntegerParam(function, value);

  /* Fetch the parameter string name for possible use in debugging */
  getParamName(function, &paramName);

  /*
  if (function == P_Vcharge) {
    // TODO check -1 < value < 2
    //chargeVoltsVal = value;
  }

  else if (function == P_PulseTime) {
    // TODO check -1 < value < 2
    //    status = pasynOctetSyncIO->write(pasynUserSP, VL2_str[value], strlen(VL2_str[value]),
    //				     WRITE_TIMEOUT, &nwrite);
    //    printf("OctetWrite:%d %s", (int) nwrite, VL2_str[value]);
    //    printf("%d %2f %d\n", (int ) strlen(VL1_str[value]), WRITE_TIMEOUT, (int) nwrite);
    if (status) {
      printf("OctetWrite ERROR\n");
      //      asynPrint(pasynUser, ASYN_TRACE_ERROR,
      //		"echoListener: write buffer: %s: nwrite:%d %s\n",
      //		VL2_str[value], (int) nwrite, pasynUser->errorMessage);
      //      goto done;
    }
  }

  else */
  /* Send comnad only on change action*/
  if (function == P_Action) {

    getIntegerParam(P_PulseTime,  &pulseTime);
    getIntegerParam(P_Vcharge,  &vCharge);
    //    getIntegerParam(P_Action,  &action);
    sprintf(buf, "SET%04d%02d%1d", vCharge, pulseTime, value);
    printf("P_Action str:%s\n", buf);
    // TODO check -1 < value < 2
    if((value>=0)&&(value<3)){
      status = pasynOctetSyncIO->write(pasynUserSP, buf, 10, //strlen(VL2_str[value]),
				     WRITE_TIMEOUT, &nwrite);
    }
    printf("OctetWrite:val:%d sz:%ld _%s_\n", value, nwrite, buf);
    //    printf("%d %2f %d\n", (int ) strlen(VL1_str[value]), WRITE_TIMEOUT, (int) nwrite);
    if (status) {
      printf("OctetWrite ERROR\n");
      //asynPrint(pasynUser, ASYN_TRACE_ERROR,
      //	"echoListener: write buffer: %s: nwrite:%d %s\n",
      //	VL3_str[value], (int) nwrite, pasynUser->errorMessage);
      //      goto done;
    }
  }

  // }
  // if (function == P_Run) {
  //   /* If run was set then wake up the simulation task */
  //   if (value) epicsEventSignal(eventId_);
  // }

  /* Do callbacks so higher layers see any changes */
  status = (asynStatus) callParamCallbacks();

  if (status)
    epicsSnprintf(pasynUser->errorMessage, pasynUser->errorMessageSize,
		  "%s:%s: status=%d, function=%d, name=%s, value=%d",
		  driverName, functionName, status, function, paramName, value);
  else
    asynPrint(pasynUser, ASYN_TRACEIO_DRIVER,
	      "%s:%s: function=%d, name=%s, value=%d\n",
	      driverName, functionName, function, paramName, value);
  return status;
}


/* Configuration routine.  Called directly, or from the iocsh function below */

extern "C" {

  /** EPICS iocsh callable function to call constructor for the serialIustiAPDriver class.
   * \param[in] portName The name of the asyn port driver to be created.
   * \param[in] maxChars The maximum  number of  */
  int serialIustiAPDriverConfigure(const char *portName, const char *serialPortName, int maxChars)
  {
    new serialIustiAPDriver(portName, serialPortName, maxChars);
    return(asynSuccess);
  }

  /* EPICS iocsh shell commands */

  static const iocshArg initArg0 = { "portName",      iocshArgString};
  static const iocshArg initArg1 = { "serialPortName",iocshArgString};
  static const iocshArg initArg2 = { "max points",    iocshArgInt};
  static const iocshArg * const initArgs[] = {&initArg0, &initArg1, &initArg2};
  static const iocshFuncDef initFuncDef = {"serialIustiAPDriverConfigure",3,initArgs};
  static void initCallFunc(const iocshArgBuf *args)
  {
    serialIustiAPDriverConfigure(args[0].sval, args[1].sval, args[2].ival);
  }

  void serialIustiAPDriverRegister(void)
  {
    iocshRegister(&initFuncDef,initCallFunc);
  }

  epicsExportRegistrar(serialIustiAPDriverRegister);

}

