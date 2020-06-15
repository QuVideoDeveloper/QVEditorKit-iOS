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
 * amcm.h
 *
 * Component Manager definition uses C language syntax for easy-to-porting proposes. 
 * But it is object based and fully inheritable and extensible.
 * 
 * 
 */

#ifndef _AMCM_H_
#define _AMCM_H_

#include "merror.h"	

#ifdef __cplusplus
extern "C" {
#endif

//////////////////////////////////////////////////////////////////////////

#define AMGDT_GENERAL_MEM_CONTEXT			0X80000001
#define AMGDT_GENERAL_TEMP_PATH				0X80000002
	
/////////////////////////////////////////////////////////////////////////////
// macro & structure define about virtual func
	
#define VFPTR(IName)       IName##VFPtr

#define MINF(IName) \
	typedef struct _tag##IName \
	{ \
		struct VFPTR(IName)  *__vfptr; \
	}IName; \
	typedef struct VFPTR(IName) VFPTR(IName); \
	struct VFPTR(IName)

#define GET_VFPTR(h, IName)       ((IName*)h)->__vfptr

#define CALL_FUNC(h, IName, fnFunc) \
	(MNull == (h))?MERR_INVALID_PARAM:GET_VFPTR(h, IName)->fnFunc

#define MINH_MBase() \
	MRESULT (*fnInit)			(MHandle, MVoid*); \
	MRESULT (*fnDestroy)		(MHandle); \
	MRESULT (*fnGetTypeID)		(MHandle, MDWord*); \
	MRESULT (*fnGetVersionInfo)	(MHandle, MDWord*, MDWord*, MDWord*, MTChar*, MDWord)

MINF(MBase)
{
	MINH_MBase();
};

#define AMCM_BEGIN_REGISTER(hCMgr) \
{ \
	MHandle __hCMgr = (hCMgr)

#define AMCM_END_REGISTER() }

//////////////////////////////////////////////////////////////////////////
// macro & stucture define for component creation

// Begin declare Component type struct by interface name 
#define MBEGIN_DECLARE_COMPONENT(IName) \
typedef struct _tag##IName##Component\
{\
	IName	__IComponent;\
	MHandle hComponentMgr;

// End declare Component type struct by interface name 
#define MEND_DECLARE_COMPONENT(IName) \
}IName##Component, *LP##IName##Component;

#define AMCM_COMPONENTSIZE(IName)		(sizeof(IName##Component) + sizeof(VFPTR(IName)))
#define AMCM_CMPTYPE(IName)				IName##Component
#define AMCM_CMPPOINTERTYPE(IName)		LP##IName##Component

//////////////////////////////////////////////////////////////////////////

typedef MRESULT(*AM_FNCREATECOMPONENT) (MHandle hCMgr, MHandle* phComponent);

typedef struct _tagComponentInfo
{
	MDWord		id;
	MDWord		dwMainType;
	MDWord		dwSubType;
	MDWord		dwPriority;
}AMCM_COMPONENT_INFO, *LPAMCM_COMPONENT_INFO;

//////////////////////////////////////////////////////////////////////////
// interface for the inheritting component

// MRESULT MBase_Init(MHandle hComponent, MVoid* pInitParam);
#define MBase_Init(hComponent, pInitParam)	\
		(CALL_FUNC(hComponent, MBase, fnInit)(hComponent, (MVoid*)pInitParam))

// MRESULT MBase_Destroy(MHandle hComponent);
#define MBase_Destroy(hComponent) \
		(CALL_FUNC(hComponent, MBase, fnDestroy)(hComponent))

// MRESULT MBase_GetTypeID(MHandle hComponent, MDWord* pID);
#define MBase_GetTypeID(hComponent, pID) \
		(CALL_FUNC(hComponent, MBase, fnGetTypeID)(hComponent, pID))

// MRESULT MBase_GetVersionInfo(MHandle hComponent, MDWord* pdwRelease, MDWord* pdwMajor,
//         MDWord* pdwMinor, MTChar* pszVersion, MDWord dwVersionLen);
#define MBase_GetVersionInfo(hComponent, pdwRelease, pdwMajor, pdwMinor, pszVersion, dwVersionLen) \
		(CALL_FUNC(hComponent, MBase, fnGetVersionInfo)(hComponent, pdwRelease, pdwMajor, pdwMinor, pszVersion, dwVersionLen))

//////////////////////////////////////////////////////////////////////////
// APIs definition

MRESULT	AMCM_Create(MHandle hMemContext, MHandle* phCMgr); 

MRESULT AMCM_Destroy(MHandle hCMgr); 

MRESULT AMCM_RegisterEx(MHandle hCMgr, MDWord uid, 
						MDWord dwMainType, 
						MDWord dwSubType, 
						MDWord dwPriority, 
						AM_FNCREATECOMPONENT fnCreate);	

MRESULT AMCM_SetDynComponentRegPath(MHandle hCMgr, MTChar* pszRegPath);

MRESULT AMCM_CreateComponent(MHandle hCMgr, MDWord id, MHandle* phComponent);

MRESULT AMCM_EnumComponentStart(MHandle hCMgr, MHandle* phEnum );

MRESULT AMCM_EnumComponentNext(MHandle hCMgr, MHandle hEnum, 
							   LPAMCM_COMPONENT_INFO pComponentInfo);

MRESULT AMCM_EnumComponentEnd(MHandle hCMgr, MHandle hEnum);

MRESULT AMCM_GetComponentInfo( MHandle hCMgr, MDWord id, 
							  LPAMCM_COMPONENT_INFO pComponentInfo) ; 

MRESULT	AMCM_GetGlobalData(MHandle hCMgr, MDWord id, MVoid* pBuf, MLong lLen); 

MRESULT AMCM_GetGlobalDataPtr(MHandle hCMgr, MDWord id, MVoid** ppBuf, MLong lLen);

MRESULT	AMCM_SetGlobalData(MHandle hCMgr, MDWord id, MVoid* pBuf, MLong lLen);

MRESULT AMCM_RemoveGlobalData(MHandle hCMgr, MDWord id);

MRESULT AMCM_GetVersionInfo(MDWord* pdwRelease, MDWord* pdwMajor, MDWord* pdwMinor,
						   MTChar* pszVersion, MDWord  dwVersionLen);

//////////////////////////////////////////////////////////////////////////

#ifdef __cplusplus
}
#endif

#endif	  

