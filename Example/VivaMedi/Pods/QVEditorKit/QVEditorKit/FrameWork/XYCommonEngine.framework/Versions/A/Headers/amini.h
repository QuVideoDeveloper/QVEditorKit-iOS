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

#ifndef __AMINI_H__
#define __AMINI_H__

#include "amcomdef.h"

typedef	MVoid*	HMINI;

#define		MINI_INT		0x00000001
#define		MINI_STRING		0x00000002

typedef	struct _tagMIniFileS {
	MChar*		szCategory;
	MChar*		szValueName;
	MVoid*		pData;
	MDWord		dwDataType;
	MDWord		dwDataCount;
}MINIPARAS,*LPMINIPARAS;

typedef	struct _tagMIniFileW {
	MWChar*		szCategory;
	MWChar*		szValueName;
	MVoid*		pData;
	MDWord		dwDataType;
	MDWord		dwDataCount;
}MINIPARAW,*LPMINIPARAW;

#ifdef __cplusplus
extern "C" {
#endif


#ifdef		M_WIDE_CHAR
	#define MIniStart		MIniStartW
	#define MIniEnd			MIniEndW
	#define MIniWrite		MIniWriteW
	#define MIniRead		MIniReadW
	#define MIniRemove		MIniRemoveW
	#define MIniWriteSingle	MIniWriteSingleW
	#define MIniReadSingle	MIniReadSingleW
	#define	MINIPARA		MINIPARAW
	#define	LPMINIPARA		LPMINIPARAW
	#define	MIniFindNextCategory	MIniFindNextCategoryW
	#define	MIniFindFirstCategory	MIniFindFirstCategoryW
#else
	#define MIniStart		MIniStartS
	#define MIniEnd			MIniEndS
	#define MIniWrite		MIniWriteS
	#define MIniRead		MIniReadS
	#define MIniRemove		MIniRemoveS
	#define MIniWriteSingle	MIniWriteSingleS
	#define MIniReadSingle	MIniReadSingleS
	#define	MINIPARA		MINIPARAS
	#define	LPMINIPARA		LPMINIPARAS
	#define	MIniFindNextCategory	MIniFindNextCategoryS
	#define	MIniFindFirstCategory	MIniFindFirstCategoryS
#endif

	

HMINI		MIniStartS(const MVoid *pFilePara); 
HMINI		MIniStartW(const MVoid *pFilePara);

MBool		MIniWriteS(HMINI hIni, LPMINIPARAS pIniPara);
MBool		MIniWriteW(HMINI hIni, LPMINIPARAW pIniPara);


MBool		MIniReadS(HMINI hIni, LPMINIPARAS pIniPara);
MBool		MIniReadW(HMINI hIni, LPMINIPARAW pIniPara);

MBool		MIniRemoveS(HMINI hIni, LPMINIPARAS pIniPara);
MBool		MIniRemoveW(HMINI hIni, LPMINIPARAW pIniPara);


MVoid		MIniEndS(HMINI hIni);
MVoid		MIniEndW(HMINI hIni);


MBool		MIniWriteSingleS(const MVoid *pFilePara, LPMINIPARAS pIniPara);
MBool		MIniWriteSingleW(const MVoid *pFilePara, LPMINIPARAW pIniPara);


MBool		MIniReadSingleS(const MVoid *pFilePara, LPMINIPARAS pIniPara);
MBool		MIniReadSingleW(const MVoid *pFilePara, LPMINIPARAW pIniPara);

MBool		MIniFindNextCategoryS(HMINI hIni, MChar* szCategory, MLong* pnBuffSize);
MBool		MIniFindNextCategoryW(HMINI hIni, MWChar* szCategory, MLong* pnBuffSize);

MBool		MIniFindFirstCategoryS(HMINI hIni, MChar* szCategory, MLong* pnBuffSize);
MBool		MIniFindFirstCategoryW(HMINI hIni, MWChar* szCategory, MLong* pnBuffSize);

#ifdef __cplusplus
}
#endif

#endif

