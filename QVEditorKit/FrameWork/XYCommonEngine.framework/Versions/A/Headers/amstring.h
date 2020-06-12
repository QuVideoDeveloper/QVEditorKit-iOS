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

#ifndef __AMSTRING_H__
#define __AMSTRING_H__

#define		MSTRING_CODEPAGE_ANSI		0
#define		MSTRING_CODEPAGE_OEM		1

#define		_MTEXT(x)					L##x

#ifdef __cplusplus
extern "C" {
#endif


#ifdef				M_WIDE_CHAR
	#define _MMT(x)						_MTEXT(x)
	#define MStrLen						MWCsLen
	#define MStrCat						MWCsCat
	#define MStrCmp						MWCsCmp
	#define MStrCpy						MWCsCpy
	#define MAtol						MWtol
	#define	MAtoi						MWtoi
	#define	MAtoi64						MWtoi64
	#define	Mi64toS						Mi64tow
	#define	MStrStr						MWCsStr
	#define	MStrChr						MWCsChr
	#define	MStrRChr					MWCsRChr
	#define MStrNCpy					MWCsNCpy
	#define	MStrNCmp					MWCsNCmp
	#define	MStrICmp					MWCsICmp
	#define MSprintf					MWSprintf
	#define	MStrNICmp					MWCsNICmp
	#define MStrToUL					MWCsToUL
	#define	MStrMakeLower				MWCsMakeLower
	#define MStrMakeUpper				MWCsMakeUpper
	#define MAtof						
#else
	#define _MMT(x)						x
	#define MStrLen						MSCsLen
	#define MStrCat						MSCsCat
	#define MStrCmp						MSCsCmp
	#define MStrCpy						MSCsCpy
	#define MAtol						MStol
	#define	MAtoi						MStoi
	#define	MAtoi64						MStoi64
	#define	Mi64toS						Mi64toa
	#define	MStrStr						MSCsStr
	#define	MStrChr						MSCsChr
	#define	MStrRChr					MSCsRChr
	#define MStrNCpy					MSCsNCpy
	#define	MStrNCmp					MSCsNCmp
	#define	MStrICmp					MSCsICmp
	#define MSprintf					MSSprintf
	#define	MStrNICmp					MSCsNICmp
	#define MStrToUL					MSCsToUL
	#define	MStrMakeLower				MSCsMakeLower
	#define MStrMakeUpper				MSCsMakeUpper
	#define MAtof						MStof
#endif

MChar*	MSCsStr(const MChar*  szString, const MChar*  szCharSet);
MWChar*	MWCsStr(const MWChar* szString, const MWChar* szCharSet);

MChar*	MSCsChr(const MChar*  szString, MChar  c);
MWChar*	MWCsChr(const MWChar* szString, MWChar c);

MChar*	MSCsRChr(const MChar*  szString, MChar  c);
MWChar*	MWCsRChr(const MWChar* szString, MWChar c);

MChar* 	MSCsCat(MChar*  szDst, const MChar*  szSrc);
MWChar* MWCsCat(MWChar* szDst, const MWChar* szSrc);

MChar* 	MSCsCpy(MChar*  szDst, const MChar*  szSrc);
MWChar* MWCsCpy(MWChar* szDst, const MWChar* szSrc);

MChar* 	MSCsNCpy(MChar*  szDst, const MChar*  szSrc, MDWord dwCount);
MWChar* MWCsNCpy(MWChar* szDst, const MWChar* szSrc, MDWord dwCount);

MIntPtr	MStol(const MChar*  szString);
MIntPtr	MWtol(const MWChar* szString);

MLong	MStoi(const MChar*  szString);
MLong	MWtoi(const MWChar* szString);

MInt64	MStoi64(const MChar*  szString);
MInt64	MWtoi64(const MWChar* szString);

MChar*  Mi64toa(MInt64 value, MChar* string, MShort radix);
MWChar* Mi64tow(MInt64 value, MWChar* string, MShort radix);

MLong	MSCsLen(const MChar*  szString);
MLong	MWCsLen(const MWChar* szString);

MLong	MSCsCmp(const MChar*  szString1, const MChar*  szString2);
MLong	MWCsCmp(const MWChar* szString1, const MWChar* szString2);

MLong	MSCsNCmp(const MChar*  szString1, const MChar*  szString2, MDWord dwCount);
MLong	MWCsNCmp(const MWChar* szString1, const MWChar* szString2, MDWord dwCount);

MLong	MSCsICmp(const MChar*  szString1, const MChar*  szString2);
MLong	MWCsICmp(const MWChar* szString1, const MWChar* szString2);

MLong	MSCsNICmp(const MChar*  szString1, const MChar*  szString2, MDWord dwCount);
MLong	MWCsNICmp(const MWChar* szString1, const MWChar* szString2, MDWord dwCount);

MLong	MSSprintf(MChar*  szString, const MChar*  szFormat, ...);
MLong	MWSprintf(MWChar* szString, const MWChar* szFormat, ...);

MLong	MCharToWChar(MChar* szA, MWChar* szW, MLong lLenW);
MLong	MWCharToChar(MWChar* szW, MChar* szA, MLong lLenA);

MLong	MUTF8ToUnicode(MByte* szA, MWChar* szW, MLong lLenW);
MLong	MUnicodeToUTF8(MWChar* szW, MByte* szA, MLong lLenA);

MLong	MMultiByteToWideChar(MDWord dwCodePage, MChar* szMultiByteStr, MLong lMultiByteLen, MWChar* pWideCharStr, MLong lWideCharLen);
MLong	MWideCharToMultiByte(MDWord dwCodePage, MWChar* szWideCharStr, MLong lWideCharLen,  MChar* pMultiByteStr, MLong lMultiByteLen);

MRESULT MSCsMakeLower(MChar*  szString);
MRESULT MWCsMakeLower(MWChar* szString);

MRESULT MSCsMakeUpper(MChar*  szString);
MRESULT MWCsMakeUpper(MWChar* szString);

MDWord	MSCsToUL(const MChar*  szString, MChar**  ppEndPtr, MLong lBase);
MDWord	MWCsToUL(const MWChar* szString, MWChar** ppEndPtr, MLong lBase);

MDouble MStof(const MChar* szString);

#ifdef __cplusplus
}
#endif

#endif

