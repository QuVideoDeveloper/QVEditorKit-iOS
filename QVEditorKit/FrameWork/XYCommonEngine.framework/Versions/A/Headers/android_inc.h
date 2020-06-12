#ifndef	ANDROID_COMMON_HEADERS
#define ANDROID_COMMON_HEADERS

#define AND_REL_11		2
#define AND_REL_CUPCAKE	3
#define AND_REL_DONUT	4
#define AND_REL_ECLAIR	5
#define AND_REL_ECLAIR_0_1 6
#define AND_REL_ECLAIR_MR1 7
#define	AND_REL_FROYO	8
#define AND_REL_GINGERBREAD	9
#define AND_REL_GINGERBREAD_MR1 10
#define	AND_REL_HONEYCOMB	11
#define AND_REL_HONEYCOMB_MR1 12
#define AND_REL_HONEYCOMB_MR2 13
#define	AND_REL_ICS		14
#define AND_REL_ICS_MR1 15
#define AND_REL_JB 16
#define AND_REL_JB_MR1 17
#define AND_REL_JB_MR2 18
#define AND_REL_KITKAT 19

//Define DSP chipset
#define DSP_TYPE_UNKNOW 0
#define DSP_QCOM_7227 1
#define DSP_QCOM_7225 2
#define DSP_QCOM_8250 3
#define DSP_QCOM_8255 4
#define DSP_QCOM_8260 5
#define DSP_TEGRA2    6
#define DSP_OMAP4     7
#define DSP_S5PC110   8
#define DSP_S5PC210   9
#define DSP_TEGRA3    10
#define DSP_QCOM_8960 11
#define DSP_S5PC4412  12
#define DSP_APQ8064   13



#ifndef ANDROID_VERSION
#ifdef	SDK_1_1	//
#define ANDROID_VERSION	AND_REL_11
#elif defined SDK_1_5	//cupcake
#define ANDROID_VERSION	AND_REL_CUPCAKE
#elif defined SDK_2_0	//eclair
#define ANDROID_VERSION	AND_REL_ECLAIR
#elif defined SDK_2_2	//froyo
#define ANDROID_VERSION	AND_REL_FROYO
#elif defined SDK_2_3	//gingerbread
#define ANDROID_VERSION	AND_REL_GINGERBREAD
#elif defined SDK_3_0	//honeycomb
#define ANDROID_VERSION	AND_REL_HONEYCOMB
#elif defined SDK_4_0	//icecream sandwich
#define ANDROID_VERSION	AND_REL_ICS
#elif defined SDK_4_1
#define ANDROID_VERSION AND_REL_JB
#else
#error "unsupported SDK version"
#endif
#endif

#include <stdio.h>
#include <stdarg.h>
#include <assert.h>
#include <limits.h>
#include <unistd.h>
#include <math.h>
#include <fcntl.h>
#include <jni.h>
#include <dlfcn.h>


#endif
