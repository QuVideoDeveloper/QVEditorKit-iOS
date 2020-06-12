#ifndef _PLATFORM_EXPORT_H_
#define _PLATFORM_EXPORT_H_

#if defined(__SYMBIAN32__)
#include <e32def.h>
#endif

#ifdef USE_PLATFORM_DLL
#   if (defined(WIN32) || defined(WINCE))
#      ifdef PLATFORM_EXPORTS
#          define PLATFORM_EXPORT __declspec(dllexport)
#      else
#          define PLATFORM_EXPORT __declspec(dllimport)
#      endif
#   elif (defined(__SYMBIAN32__))
#      define PLATFORM_EXPORT		IMPORT_C
#      define PLATFORM_EXPORT_SRC	EXPORT_C
#   else
#      define PLATFORM_EXPORT
#   endif
#else
#   define PLATFORM_EXPORT
#	if defined(__SYMBIAN32__)
#		define PLATFORM_EXPORT_SRC
#	endif
#endif

#ifndef PLATFORM_EXPORT
#   define PLATFORM_EXPORT
#endif

#ifndef PLATFORM_EXPORT_SRC
#	define PLATFORM_EXPORT_SRC
#endif

#endif /*_PLATFORM_EXPORT_H_*/
