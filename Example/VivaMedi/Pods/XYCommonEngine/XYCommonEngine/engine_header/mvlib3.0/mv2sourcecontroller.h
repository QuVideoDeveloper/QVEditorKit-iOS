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
 * MV2SourceController.h
 *
 * The interface of source controller in MVLIB2.0
 *
 * This interface provides the media source controlling functionality for some remote source
 * such as RTSP source
 *
 * Code History
 *    
 * --2004-08-18 Sheng Han  (shan@arcsoft.com.cn)
 * - initial version 
 */

#ifndef _MMV2MEDIASOURCECONTROLLER_H_
#define _MMV2MEDIASOURCECONTROLLER_H_


#include "mv2comdef.h"
#include "mv2error.h"
#include "amoperatornew.h"

//////////marco for source status
#define MV2_SOURCESTATUS_NULL		0
#define MV2_SOURCESTATUS_OPENING	1
#define MV2_SOURCESTATUS_OPENED		2
#define MV2_SOURCESTATUS_PLAYING	3
#define MV2_SOURCESTATUS_BUFFERING	4
#define MV2_SOURCESTATUS_STOPPING	5
#define MV2_SOURCESTATUS_STOPPED	6



class MMV2MediaSourceController
{
OVERLOAD_OPERATOR_NEW
public:
	virtual MRESULT Play() = 0;
	virtual MRESULT Pause() = 0;
	virtual MRESULT Stop() = 0;
	virtual MRESULT QueryStatus(MDWord* pdwStatus , MLong * plParam1 , MLong * plParam2) = 0;

};


#endif //_MMV2MEDIASOURCECONTROLLER_H_