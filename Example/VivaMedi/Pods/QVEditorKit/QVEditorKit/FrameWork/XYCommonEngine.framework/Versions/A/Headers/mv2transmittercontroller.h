/*----------------------------------------------------------------------------------------------
*
* This file is ArcSoft's property. It contains ArcSoft's trade secret, proprietary and 		
* confidential information. 
* 
* The information and code contained in this file is only for authorized ArcSoft employees 
* to design, create, modify, or review.
* 
* DO NOT DISTRIBUTE, DO NOT DUPLICATE OR TRANSMIT IN ANY FORM WITHOUT PROPER AUTHORIZATION.
* 
* If you are not an intended recipient of this file, you must not copy, distribute, modify, 
* or take any action in reliance on it. 
* 
* If you have received this file in error, please immediately notify ArcSoft and 
* permanently delete the original and any copy of any file and any printout thereof.
*
*-------------------------------------------------------------------------------------------------*/
/*
 * MV2TransmitterController.h
 *
 * The interface of transmitter controller in MVLIB2.0
 *
 * This interface provides the media transmitter controlling functionality for some remote source
 * such as RTP 
 *
 * Code History
 *    
 * --2005-05-27 Qiu Hao  (hqiu@arcsoft.com.cn)
 * - initial version 
 */

#ifndef _MV2TRANSMITTERCONTROLLER_H_
#define _MV2TRANSMITTERCONTROLLER_H_


#include "mv2comdef.h"
#include "mv2error.h"
#include "amoperatornew.h"

//////////macro for transmitter status
#define MV2_MEDIASTATUS_NULL		0
#define MV2_MEDIASTATUS_OPENING		1
#define MV2_MEDIASTATUS_READY		2
#define MV2_MEDIASTATUS_STOPPING	5
#define MV2_MEDIASTATUS_STOPPED		6



class MMV2MediaTransmitterController
{
OVERLOAD_OPERATOR_NEW
public:
	virtual MRESULT Start() = 0;
	virtual MRESULT Pause() = 0;
	virtual MRESULT Stop() = 0;
	virtual MRESULT QueryStatus(MDWord* pdwStatus , MLong * plParam1 , MLong * plParam2) = 0;

};


#endif //_MV2TRANSMITTERCONTROLLER_H_