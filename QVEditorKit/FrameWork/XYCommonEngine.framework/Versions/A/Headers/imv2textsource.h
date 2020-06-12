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
 * IMV2TextSource.h
 *
 * The interface of media file text extend interface in MVLIB2.0
 *
 * In this file, the interface IMV2TextSource has been defined. 
 * IMV2TextSource is a abstract interface for text extend interface 
 *
 * Code History
 *    
 * --2005-1-25 Weigang Guan(wGuan@arcsoft.com.cn)
 *   initial version  
 */

#ifndef  _IMV2TEXTSOURCE_H_
#define  _IMV2TEXTSOURCE_H_

#include "mv2comdef.h"
#include "mv2timedtext_comdef.h"
#include "amoperatornew.h"
class COutPutTextSource 
{
OVERLOAD_OPERATOR_NEW
public:
	COutPutTextSource() {};
	virtual ~COutPutTextSource(){};

//interface:
/**
*	GetTextInfo
*		this function is used to get the text info from the  spliter.
*	
*	Parameter:
*		pTextInfo	[in]	pointer to receive the text info from the spliter.
*
*	Return:
*		MV2_ERR_NONE	success
*		!MV2_ERR_NONE	fail
*				
*/
virtual MRESULT GetTextInfo(LPMV2TEXTINFO pTextInfo) = 0;
	
/* ReadTextFrame 
* 
*	Description: 
*		Call this function to read one  text frame data sequentially
*
*	Parameters: 
*		pFrameBuf		[in/out] 		the frame buffer which stores the text frame which is MTChar
*		lBufSize		[in] 			the size of buffer
*		plReadSize	    [out]  			the actually read MTChar Count
*		pdwCurrentTimestamp 	[out] 	the timestamp of current read text frame. 
*		pdwTimeSpan	    [out] 			the time span of this text frame
*      pAttachInfo      [out]           Attach information of the text frame
*  
*	Return:
*		MV2_ERR_NONE	success
*		!MV2_ERR_NONE	fail
*/
virtual MRESULT ReadTextFrame(MTChar * pFrameBuf, MLong lBufSize ,MLong * plReadSize,MDWord * pdwCurrentTimestamp , 
								MDWord * pdwTimeSpan,LPMV2TFATTACHINFO pAttachInfo) = 0;
		
/* SeekTextFrame 
* 
*	Description: 
*		Call this function to seek the spliter  to the position of next text frame or the specifed frame
*
*	Parameters: 
*		pdwTimestamp	[in/out]the in value of pdwTimeStamp as following	
*				    SEEK_NEXT_FRAME:specify that this function seek to next 
*					text frame ,and return this frame's timestamp to pdwTimestamp
*				    other value:specify that this function seek to nearest
*					frame before *pdwTimestamp if there is a frame on the *pdwTimestamp,
*					or after *pdwTimestamp if there is no frame on *pdwTimestamp,
*					and return this frame's timestamp to pdwTimestampthe 
*	
*
*	Return:
*		MV2_ERR_NONE	success
*		!MV2_ERR_NONE	fail
*
*	Remark:
*		return MV2_ERR_SPLITER_SEEKTOEND to specify that have seek to file end
*
*/ 

virtual MRESULT SeekTextFrame(MDWord * pdwTimestamp ) = 0;
	
};

class CInPutTextSource 
{
	OVERLOAD_OPERATOR_NEW
public: 
	CInPutTextSource(){};
	virtual ~CInPutTextSource(){};

//interface
/**
*	SetTextInfo
*		this function is used to set the text info to the muxer.
*	
*	Parameter:
*		pTextInfo	[in]	pointer to pass the text info to the muxer.
*
*	Return:
*		MV2_ERR_NONE	success
*		!MV2_ERR_NONE	fail
*				
*/
	virtual MRESULT SetTextInfo(LPMV2TEXTINFO pTextInfo) = 0;
	
/* DumpTextFrame
* 
*	Description: 
*		Call this function to dump text data sequentially
*
*	Parameters: 
*		pTextData		[in/out] 		the frame buffer which pass text ,which is MTChar
*		lDataSize		[in] 			the MTChar count of the text frame 
*		dwTimestamp 	[in] 		    the timestamp of current dump text frame. 
*		dwTimeSpan		[in] 		    the spantime of current dump text frame. 
*		pAttachInfo     [in/out]        the attached information of the text frame
*	Return:
*		MV2_ERR_NONE	success
*		!MV2_ERR_NONE	fail
*/
	virtual MRESULT DumpTextFrame(MTChar * pTextData, MLong lDataSize, MDWord dwTimestamp, 
										MDWord dwTimeSpan, LPMV2TFATTACHINFO pAttachInfo) = 0;

};

#endif //_IMV2TEXTSOURCE_H_