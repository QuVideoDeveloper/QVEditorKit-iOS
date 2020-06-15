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

#ifndef __AMOPERATORNEW_H__
#define __AMOPERATORNEW_H__

#include "amcomdef.h"
#include "ammem.h"
 
#if defined (_SUPPORT_LINUX_)
#include <cstddef>
#endif
#if defined(M_OVERLOAD_OPERATOR_NEW) || defined(_CUST_PLAT_) || defined(_AGERE_)

    #if defined(__IPHONE__) || defined(__aarch64__)
        #define OVERLOAD_OPERATOR_NEW \
            public:\
            void* operator new(unsigned long size) \
            {\
                return MMemAlloc(MNull, size);\
            };\
            void operator delete(void* p) \
            {\
                if(MNull != p)\
                {\
                    MMemFree(MNull, p); \
                }\
            };
   #elif defined (_SUPPORT_LINUX_)
        #define OVERLOAD_OPERATOR_NEW \
            public:\
            void* operator new(size_t size) \
            {\
                return MMemAlloc(MNull, size);\
            };\
            void operator delete(void* p) \
            {\
                if(MNull != p)\
                {\
                    MMemFree(MNull, p); \
                }\
            };
    #else
        #define OVERLOAD_OPERATOR_NEW \
            public:\
            void* operator new(unsigned int size) \
            {\
                return MMemAlloc(MNull, size);\
            };\
            void operator delete(void* p) \
            {\
                if(MNull != p)\
                {\
                    MMemFree(MNull, p); \
                }\
            };
    #endif

//	#define OVERLOAD_OPERATOR_NEW


#else

    #define OVERLOAD_OPERATOR_NEW
#endif





#endif

