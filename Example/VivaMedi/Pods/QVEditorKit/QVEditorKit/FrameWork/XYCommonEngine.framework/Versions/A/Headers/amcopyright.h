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

#ifndef __AMCOPYRIGHT_H__
#define __AMCOPYRIGHT_H__

#include "amcomdef.h"


#define	MCRP_FLAG				0xFFFFFFFF 
#define	MCRP_FLAG_NOLIMIT		MCRP_FLAG	
			
#define	MCRP_FLAG_FIRSTRUN		0x80000000   


typedef struct _tagMCRPAtt {
	MDWord nDateToExpire;
	MDWord nUseTimeToExpire;
	MDWord nDateLeft;
	MDWord nUseTimeLeft;
}MCRPATT,*LPMCRPATT;

typedef enum {
	MCRP_ERR_NONE				= 0,
	MCRP_ERR_PARA,
	MCRP_ERR_WRITE_FILE,
	MCRP_ERR_READ_FILE,	
	MCRP_ERR_EXPIRED,
	MCRP_ERR_NO_MEM,
	MCRP_ERR_WRONG_REG_NO,
	MCRP_ERR_CANNOT_GET_UNIID,
	MCRP_ERR_DAYS_OVERFLOW,
	MCRP_ERR_UNKNOWN
}MCRP_ERR;


#ifdef __cplusplus
extern "C" {
#endif

MLong	MCRP_Create(const MVoid* pProtectionFilePara ,LPMCRPATT pMCRPAtt);
MLong	MCRP_Update(const MVoid* pProtectionFilePara);
MLong	MCRP_Check(const MVoid* pProtectionFilePara ,LPMCRPATT pMCRPAtt);
MLong	MCRP_Register(const MVoid* pProtectionFilePara, MTChar* szRegisterNo, MTChar* szUniID); 
MBool	MGetRegNo(MTChar* szIMEI, MTChar* szKey);

#ifdef __cplusplus
}
#endif


#endif

