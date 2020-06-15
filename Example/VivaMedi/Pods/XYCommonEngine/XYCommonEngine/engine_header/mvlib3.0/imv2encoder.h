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
 * imv2encoder.h
 *
 * the interface of media codec( encoder) module in MVLIB2.0
 *
 * In this file, the interface IMV2Encoder has been defined. 
 * IMV2Encoder is a abstract interface for Media CODEC encoder. 
 * all the media codec should implement this interface
 *
 * Code History
 *    
 * --2004-07-26 Sh.F.Guo  (sguo@arcsoft.com.cn)
 * - initial version 
 *
 * --2004-07-27 Sheng Han  (shan@arcsoft.com.cn)
 * - Review and modify 
 */

#ifndef _IMV2ENCODER_H_
#define _IMV2ENCODER_H_
#include "amoperatornew.h"

 class IMV2Encoder 
 { 
 OVERLOAD_OPERATOR_NEW
 public: 
	 IMV2Encoder(){}
	 virtual ~IMV2Encoder(){}

	 /* EncodeFrame 
	 * 
	 *	Description: 
	 *		Call this function to Encode one raw media data to a frame. 
	 *		It is a memory buffer to memory buffer operation. 
	 *
	 *	Parameters: 
	 *		pIn  				[in] 			Pointer to the buffer containing the raw media data to be encoded, pass as NULL if want to encode an empty frame
	 *		lInSize 			[in] 			Number of bytes to encode
	 *		pOut				[out] 		Pointer to the buffer that receives the encoded data  from the input buffer.
	 *		lOutBufferSize		[in] 			The byte size of the output buffer pointed by pOut. 
	 *		plOutSize			[out] 		Pointer to the number of bytes encoded. 
	 *			 	 					EncodeFrame sets this value to zero before doing any work or error checking
	 *		pbIsSyncFrame 	[out] 		The Boolean var which to specify if encoding this frame as a sync frame
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
	 virtual MRESULT EncodeFrame( MByte * pIn, MLong lInSize, MByte * pOut,  
                     				MLong lOutBufferSize, MLong * plOutSize ,
                     				MBool * pbIsSyncFrame) =0; 

 
	 /* SetParam
	 * 
	 *	Description: 
	 *		Call this function to set encoder's Param 
	 *
	 *	Parameters: 
	 *		dwParamID 			[in] 				the parameter type ID 
	 *		value				[in]				the value of specified parameter type
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	*/
	 virtual MRESULT SetParam ( MDWord dwParamID, MVoid* value )=0 ; 

	 /* GetParam
	 * 
	 *	Description: 
	 *		Call this function to get encoder's Param ,Outside will maybe use the param
	 *		from the codec
	 *
	 *	Parameters: 
	 *		dwParamID 			[in] 				the parameter type ID 
	 *		value				[out]			the value of specified parameter type
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 */
	 virtual MRESULT GetParam ( MDWord dwParamID, MVoid* value ) = 0 ; 


 
	 /* Reset 
	 * 
	 *	Description: 
	 *		Call this function to set encoder to init state .
	 *
	 *	Parameters: 
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 */
	 virtual MRESULT Reset( ) =0 ; 
 
	 /* QueryType 
	 * 
	 *	Description: 
	 *		Call this function to query this module whether supports the specified codec type.
	 *
	 *	Parameters: 
	 *		pdwCodecType 		[in/out] 		codec type which wants to query if it is supported, pass as NULL to get the codec type on return
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 */
	 virtual MRESULT QueryType( MDWord * pdwCodecType ) =0 ; 
}; 

#endif //_IMV2DECODER_H_
