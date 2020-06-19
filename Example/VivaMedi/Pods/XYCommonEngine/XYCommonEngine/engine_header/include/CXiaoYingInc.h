
#if !defined(_SUPPORT_64BITS_) || !defined(__IPHONE__)
//#error "please define _SUPPORT_64BITS_ and __IPHONE__ in project configuration"
#define _SUPPORT_64BITS_
#define __IPHONE__ 1
#endif


/**
 *  HeadFile for iOS System API
 **/
#ifdef MSIZE
#undef MSIZE
#endif

typedef struct
{
    UInt32 uiPosition;
    UInt32 uiLen;
}CXIAOYING_POSITION_RANGE_TYPE;

typedef struct
{
    SInt32 x;
    SInt32 y;
}CXIAOYING_SIZE;

typedef struct
{
    SInt32 siLeft;
    SInt32 siTop;
    SInt32 siRight;
    SInt32 siBottom;
}CXIAOYING_RECT;


typedef struct
{
    int     effectTransformType;
    int 	blurLenV;
	int 	blurLenH;

	float	scaleX;
	float	scaleY;
    float   scaleZ;

    int     angleX;
    int     angleY;
	int     angleZ;

	float	shiftX;
	float	shiftY;
    float	shiftZ;

    float	rectL;
    float	rectT;
    float	rectR;
    float	rectB;

    int	clearR;
    int	clearG;
    int	clearB;
    int	clearA;
} CXIAOYING_TRANSFORM_PARAMETERS;

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>



/*
 *   Headfile for common part
 */
#import "amcomdef.h"
#import "amstream.h"
#import "amcm.h"
#import "merror.h"
#import "amstream.h"
#import "ammem.h"
#import "amdisplay.h"
#import "amstring.h"
#import "amkernel.h"

/*
 *  Headfile for engine core
 */
#import "amveerrdef.h"
#import "amvedef.h"
#import "amvesession.h"
#import "amvestyleutils.h"
#import "etposterengine.h"
#import "etpipparamobject.h"
//#import "eteffectprocessor.h"
#import "stylefilehead.h"
#import "etfacedtutils.h"

/*
 *  Headfile for engine OC-layer
 */

#import "basic_class.h"

#import "QCamDef.h"
#import "QCamEffect.h"
#import "QCamEffectUpdateItem.h"
#import "QFilterParam.h"
#import "QPIPSrc.h"
#import "QPIPSrcMode.h"
#import "QTimeInfo.h"
#import "QViewAngles.h"
#import "QCamEffectInquiryItem.h"
#import "QCamEffectInquiryResult.h"
#import "QCamEffectPasterInfo.h"

#import "CXiaoYingEffectSubItemSource.h"
#import "CXiaoYingEngine.h"
#import "CXiaoYingEffect.h"
#import "CXiaoYingCamExportEffectData.h"
#import "CXiaoYingClip.h"
#import "CXiaoYingStream.h"
#import "CXiaoYingSession.h"
#import "CXiaoYingPlayerSession.h"
#import "CXiaoYingPoster.h"
#import "CXiaoYingProducerSession.h"
#import "CXiaoYingStoryBoardSession.h"
#import "CXiaoYingCover.h"
#import "CXiaoYingEffectSwitchInfo.h"
#import "CXiaoYing3DMaterialItem.h"
#import "CXiaoYingTextMulInfo.h"
#import "CXiaoYingSlideShowSceCfgInfo.h"
#import "CXiaoYingStyle.h"
#import "CXiaoYingUtils.h"
#import "CXiaoYingPIPPO.h"
#import "QCamBasicClassesInc.h"
#import "QCamEngineV4.h"
#import "CXiaoYingAnimatePointOperator.h"
#import "CXiaoYingSourceInfoNode.h"
#import "CXiaoYingTextAnimationInfo.h"
#import "CXiaoYingVirtualSourceInfoNode.h"
#import "CXiaoYingSlideShowSession.h"
#import "CXiaoYingLyricData.h"
#import "etwatermark.h"
#import "etavadapter.h"
#import "CWMDCallbackData.h"
#import "IWMDDelegate.h"
#import "CWMDParameter.h"
#import "CWMD.h"
#import "CXiaoYingFaceDTUtils.h"

#import "CSDCallbackData.h"
#import "ISDDelegate.h"
#import "CSDParameter.h"
#import "CSD.h"
#import "qvmonitorcomdef.h"
#import "QMonitor.h"


#import "QPCMETurboSetting.h"
#import "QPCMEData.h"
#import "QPCMECallbackData.h"
#import "QPCMEDelegate.h"
#import "QPCMEParam.h"
#import "QPCMExtractor.h"
#import "QBenchLogger.h"
#import "CXiaoYingAudioProvider.h"





#define QVET_RENDER_TARGET_SCREEN   0x00000001
#define QVET_RENDER_TARGET_BUFFER   0x00000002



