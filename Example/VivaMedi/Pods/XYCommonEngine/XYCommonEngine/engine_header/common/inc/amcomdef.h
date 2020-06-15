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

#ifndef __AMCOMDEF_H__
#define __AMCOMDEF_H__

#if	defined(WINCE) || defined(WIN32)

#ifndef _WCHAR_T_DEFINED
typedef unsigned short wchar_t;
#define _WCHAR_T_DEFINED
#endif//#ifndef _WCHAR_T_DEFINED

#elif (defined(EKA2) && defined(__GCCE__))
#ifndef _STDDEF_H_
#ifndef __cplusplus
typedef unsigned short wchar_t;
#define __wchar_t_defined
#endif
#endif


#elif defined(__GCCE__) || defined(__GCC32__)
#ifndef _STDDEF_H_
typedef unsigned short wchar_t;
#endif

#endif//#if	defined(WINCE)


#if	defined(__GCC32__)  || defined(__GCCE__) || defined(WINCE) || defined(WIN32)
typedef wchar_t			MWChar;
#else
typedef unsigned short	MWChar;
#endif

#if defined(_SUPPORT_64BITS_)
typedef int					    MLong;
#else
typedef long					MLong;
#endif
typedef float					MFloat;
typedef double					MDouble;
typedef unsigned char			MByte;
typedef unsigned short	MWord;

#if defined(_SUPPORT_64BITS_)
typedef unsigned int			MDWord;
#else
typedef unsigned long			MDWord;
#endif
typedef void*					MHandle;
typedef char					MChar;
#if defined(_SUPPORT_64BITS_)
typedef int                     MBool;
#else
typedef long					MBool;
#endif
typedef void					MVoid;
typedef void*					MPVoid;
typedef char*					MPChar;
typedef short					MShort;
typedef const char*				MPCChar;
typedef	MLong					MRESULT;
typedef unsigned long           MCOLORREF;


typedef	signed		char		MInt8;
typedef	unsigned	char		MUInt8;
typedef	signed		short		MInt16;
typedef	unsigned	short		MUInt16;

#if defined(_SUPPORT_64BITS_)
typedef signed		int		    MInt32;
typedef unsigned	int		    MUInt32;
#else
typedef signed		long		MInt32;
typedef unsigned	long		MUInt32;
#endif

#if !defined(M_UNSUPPORT64)
#if defined(_MSC_VER)
typedef signed		__int64		MInt64;
typedef unsigned	__int64		MUInt64;
#else
typedef signed		long long	MInt64;
typedef unsigned	long long	MUInt64;
#endif
#endif

typedef unsigned long           MIntPtr;


typedef struct __tag_rect
{
	MLong left;
	MLong top;
	MLong right;
	MLong bottom;
} MRECT, *PMRECT;

typedef struct
{
	MFloat left;
	MFloat top;
	MFloat right;
	MFloat bottom;
} MRECTF;


#define RECT_WIDTH(rect) ((rect).right-(rect).left)
#define RECT_HEIGHT(rect) ((rect).bottom-(rect).top)

#define RECT_MIDX(rect) ( (	(rect).right + (rect).left)/2 )
#define RECT_MIDY(rect) ( ( (rect).bottom + (rect).top )/2 )

typedef struct __tag_CamCapturePara
{
	MBool bCaptureFlag;
	MChar *exportPicturePath;
	MBool bWithoutEffects;
} CamCapturePara, *PCamCapturePara;


/*
 *	MSIZE_FLOAT 是MSIZE的扩展
 */
typedef struct __tagMSIZE_FLOAT
{
	MFloat	cx;
	MFloat	cy;
}MSIZE_FLOAT;

typedef struct __tagMPOINT_FLOAT
{
	MFloat x;
	MFloat y;
}MPOINT_FLOAT;


typedef struct __tagMPOINT_FLOAT_3D
{
	MFloat x;
	MFloat y;
	MFloat z;
}MPOINT_FLOAT_3D;


typedef struct __tag_point
{ 
	MLong x; 
	MLong y; 
} MPOINT, *PMPOINT;

#define MNull		0
#define MFalse		0
#define MTrue		1



#ifndef MAX_PATH
#if defined (_LINUX_) || (__IPHONE__)
#define MAX_PATH 1024
#elif defined(_WINCE_)
#define MAX_PATH 260
#else
#define MAX_PATH 256
#endif //(_LINUX_)
#endif	//MAX_PATH



#ifdef M_WIDE_CHAR
#define MTChar MWChar
#else 
#define MTChar MChar
#endif


//if\s*\(MNull\s*!=\s*(.+)\s*\)\s*{\r\n\s*MMemFree\(MNull,\s*\1\);\s*\r\n\s*\1\s*=\s*MNull;\s*\r\n\s*}  FREE_POINTER($1);
#define FREE_POINTER(p)		\
		if (p)				\
		{					\
			MMemFree(MNull, p);	\
			p = MNull;		\
		}

#define REALLOC_POINTER_ARRAY(p,type,cnt)					\
		{													\
			FREE_POINTER(p)									\
			p = (type*)MMemAlloc(MNull,sizeof(type)*(cnt));	\
			MMemSet(p,0,sizeof(type)*(cnt));				\
		}

#define EXPAND_POINTER_ARRAY(srcptr, type, scnt, dcnt)						\
		if(srcptr)													\
		{																	\
			type* newArr = (type*)MMemAlloc(MNull, sizeof(type)* (dcnt));	\
			MMemSet(newArr, 0, sizeof(type)*(dcnt));						\
			MMemCpy(newArr, srcptr , sizeof(type)*(scnt));					\
			MMemFree(MNull, srcptr);										\
			srcptr = newArr;												\
		}																	\

#define DEL_INSTANCE(i)	\
		if (i)	{delete i; i=MNull;}


		
#define DEL_LOCAL_REF(r)		\
		if (r)					\
		{						\
			env->DeleteLocalRef(r);	\
			r = MNull;			\
		}




#endif
