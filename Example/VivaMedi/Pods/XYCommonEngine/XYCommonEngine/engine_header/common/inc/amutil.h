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

#ifndef __AMUTIL_H__
#define __AMUTIL_H__

#include "amcomdef.h"
#include "merror.h"

typedef MHandle HMFIND;

#define ATTRIB_FILE 			0
#define ATTRIB_PATH 			1
#define ATTRIB_FILEANDPATH  	2


typedef struct __tag_find_attrib
{
	MLong	nFindFlag;
}MFINDATTRIB, *LPMFINDATTRIB;

#define ATTRIB_FILE_READONLY             0x00000001  
#define ATTRIB_FILE_HIDDEN               0x00000002  
#define ATTRIB_FILE_SYSTEM               0x00000004  
#define ATTRIB_FILE_DIRECTORY            0x00000008  
#define ATTRIB_FILE_NORMAL               0x00000010

typedef struct __tag_file_info
{  
	MDWord		dwFileAttributes;  		
	MDWord		dwFileSize; 
	MDWord		dwCreationTime;
	MDWord		dwLastAccessTime;
	MDWord		dwLastWriteTime; 
} MFILEINFO, *LPMFILEINFO;

typedef struct __tag_system_time
{
	MWord  wYear;
	MWord  wMonth;
	MWord  wDay;
	MWord  wHour;
	MWord  wMinute;
	MWord  wSecond;
	MWord  wMilliseconds;
	MWord  wReserved;
} MSYSTEMTIME, *LPMSYSTEMTIME;


#ifdef __cplusplus
extern "C" {
#endif


#ifdef		M_WIDE_CHAR 
	#define	MIsDirectory		MIsDirectoryW
	#define	MDirectoryCreate	MDirectoryCreateW
	#define	MDirectoryRemove	MDirectoryRemoveW
	#define	MDirStartFind		MDirStartFindW
	#define	MDirStartFindEx		MDirStartFindExW
	#define	MDirFindNext		MDirFindNextW
	#define	MDirFindNextEx		MDirFindNextExW
	#define	MGetFileInfo		MGetFileInfoW
	#define	MGetUniID			MGetUniIDW
	#define	MIsSameFile			MIsSameFileW
	#define MGetFreeSpaceDisk   MGetFreeSpaceDiskW
	#define	MGetModulePath		MGetModulePathW
#else
	#define	MIsDirectory		MIsDirectoryS
	#define	MDirectoryCreate	MDirectoryCreateS
	#define	MDirectoryRemove	MDirectoryRemoveS
	#define	MDirStartFind		MDirStartFindS
	#define	MDirStartFindEx		MDirStartFindExS
	#define	MDirFindNext		MDirFindNextS
	#define	MDirFindNextEx		MDirFindNextExS
	#define	MGetFileInfo		MGetFileInfoS
	#define	MGetUniID			MGetUniIDS
	#define	MIsSameFile			MIsSameFileS
	#define MGetFreeSpaceDisk   MGetFreeSpaceDiskS
	#define	MGetModulePath		MGetModulePathS
#endif



MBool		MIsDirectoryS(const MVoid * directory_para);
MBool		MIsDirectoryW(const MVoid * directory_para);

MBool		MDirectoryCreateS(const MVoid * directory_para);
MBool		MDirectoryCreateW(const MVoid * directory_para);


MBool		MDirectoryRemoveS(const MVoid * directory_para);
MBool		MDirectoryRemoveW(const MVoid * directory_para);


HMFIND		MDirStartFindS(const MVoid * directory_para, LPMFINDATTRIB pAtt);
HMFIND		MDirStartFindW(const MVoid * directory_para, LPMFINDATTRIB pAtt);

HMFIND		MDirStartFindExS(const MVoid * directory_para, LPMFINDATTRIB pAtt);
HMFIND		MDirStartFindExW(const MVoid * directory_para, LPMFINDATTRIB pAtt);


MBool		MDirFindNextS(HMFIND hMFind, MChar*  szFound, LPMFINDATTRIB pAtt);
MBool		MDirFindNextW(HMFIND hMFind, MWChar* szFound, LPMFINDATTRIB pAtt);


MBool		MDirFindNextExS(HMFIND hMFind, MChar*  szFound, LPMFILEINFO pMFileInfo);
MBool		MDirFindNextExW(HMFIND hMFind, MWChar* szFound, LPMFILEINFO pMFileInfo);


MVoid		MDirEndFind(HMFIND hMFind);
MVoid		MDirEndFindEx(HMFIND hMFind);

MBool		MGetFileInfoS(LPMFILEINFO pMFileInfo,const MVoid * file_para);
MBool		MGetFileInfoW(LPMFILEINFO pMFileInfo,const MVoid * file_para);

MBool		MGetUniIDS(MChar*  szIMEI);
MBool		MGetUniIDW(MWChar* szIMEI);

MBool		MIsSameFileS(const MVoid * file_para1, const MVoid * file_para2);
MBool		MIsSameFileW(const MVoid * file_para1, const MVoid * file_para2);

MRESULT		MGetFreeSpaceDiskS(const MVoid* directory_para, MUInt64* pSize);
MRESULT		MGetFreeSpaceDiskW(const MVoid* directory_para, MUInt64* pSize);

MRESULT		MGetModulePathS(MVoid* pDirectory_para, MDWord dwBufSize);
MRESULT		MGetModulePathW(MVoid* pDirectory_para, MDWord dwBufSize);


MDWord		MGetDaysFrom1970();
MRESULT		MSrand(MDWord dwSeed);
MDWord		MGetRandomNumber();
MBool		MFileTimeToLocalFileTime(MDWord* pdwFileTime, MDWord* pdwLocalFileTime);

MDWord		MGetSecondsFrom1970();
MRESULT		MGetSystemTime(LPMSYSTEMTIME lpSystemTime);

MRESULT		MFileTimeToSystemTime(MDWord dwSeconds, LPMSYSTEMTIME lpSystemTime);
MDWord		MSystemTimeToFileTime(const LPMSYSTEMTIME lpSystemTime);

MRESULT     QVET_iOS_DoesAssetLibraryFileExit(MTChar *pszURL, MBool *pbExit);
    
    
#ifdef __cplusplus
}
#endif


#endif

