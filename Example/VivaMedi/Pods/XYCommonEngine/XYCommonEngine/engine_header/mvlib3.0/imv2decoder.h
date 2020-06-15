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
 * imv2decoder.h
 *
 * The interface of media Codec(decoder) module in MVLIB2.0
 *
 * In this file, the interface IMV2Decoder has been defined. 
 * IMV2Decoder is a abstract interface for Media CODEC decoder. 
 * all the decoder media codec should implement this interface
 *
 * Code History
 *    
 * --2004-07-26 Sh.F.Guo  (sguo@arcsoft.com.cn)
 * - initial version 
 * --2004-07-27 Sheng Han  (shan@arcsoft.com.cn)
 * - Review and modify
 */

#ifndef _IMV2DECODER_H_
#define _IMV2DECODER_H_
#include "amoperatornew.h"


 class IMV2Decoder
 { 
 OVERLOAD_OPERATOR_NEW
 public: 
	 IMV2Decoder(){}
	 virtual ~IMV2Decoder(){}

	 /*	DecodeFrame 
	 * 
	 *	Description: 
	 *		Call this function to decode one encoded media data frame. 
	 *		It is a memory buffer to memory buffer operation. 
	 *
	 *	Parameters: 
	 *		pIn : 			[in] 			Pointer to the buffer containing the media data to be decoded.
	 *		lInSize: 		[in] 			Number of bytes to decode
	 *		plInSize		[out]			pointer to bytes that have been deocded of the pIn buffer
	 *		pOut: 			[out] 			Pointer to the buffer that receives the data decode from the input buffer.
	 *		lOutBufferSize: 	[in] 			The byte size of the output buffer pointed by pOut. 
	 *		plOutSize:		[out] 			Pointer to the number of bytes raw data that decodeframe() filled in the output buff. 
	 *	
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
	 virtual MRESULT DecodeFrame( MByte * pIn, MLong lInSize, MLong * plInSize, 
	 			      MByte * pOut,MLong lOutBufferSize, MLong * plOutSize ) = 0 ; 
 
	 /* SetParam
	 * 
	 *	Description: 
	 *		Call this function to set decoder's Param 
	 *
	 *	Parameters: 
	 *		dwParamID 			[in] 				the parameter type ID 
	 *		value				[in]				the value of specified parameter type
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
	 virtual MRESULT SetParam ( MDWord dwParamID, MVoid* value )= 0 ; 

	 /* GetParam
	 * 
	 *	Description: 
	 *		Call this function to get decoder's Param ,Outside will maybe use the param
	 *		from the codec
	 *
	 *	Parameters: 
	 *		dwParamID 			[in] 				the parameter type ID 
	 *		value				[out]			the value of specified parameter type
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */

	 virtual MRESULT GetParam (	MDWord dwParamID, MVoid* value ) = 0 ; 
	 
	 /* Reset 
	 * 
	 *	Description: 
	 *		Call this function to set decoder to init state .
	 *
	 *	Parameters: 
	 *		None
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
	 virtual MRESULT Reset(  ) = 0 ; 
 
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
	 virtual MRESULT QueryType( MDWord * pdwCodecType ) = 0 ;

	 
}; 
#endif