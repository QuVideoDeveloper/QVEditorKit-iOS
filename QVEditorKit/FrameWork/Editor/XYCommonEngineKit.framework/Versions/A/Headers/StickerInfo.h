//
//  StickerInfo.h
//  XYVivaVideoEngineKit
//
//  Created by 徐新元 on 2018/7/9.
//

#import <Foundation/Foundation.h>

@interface StickerInfo : NSObject

@property (nonatomic, copy) NSString *identifier;//唯一标志
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *xytFilePath;
@property (nonatomic, assign) MDWord startPos;
@property (nonatomic, assign) MRECT rcDispRegion;
@property (nonatomic, assign) MDWord dwCurrentDuration;
@property (nonatomic, assign) MDWord dwDefaultDuration;
@property (nonatomic, assign) MDWord dwExamplePos;
@property (nonatomic, assign) MBool bHasAudio;
@property (nonatomic, assign) CGRect stickerRect;
@property (nonatomic, assign) MDWord dwFrameWidth;
@property (nonatomic, assign) MDWord dwFrameHeight;

@property (nonatomic, assign) MFloat layerID;

@property (nonatomic, assign) MFloat fRotateAngle;//度数
//@property (nonatomic, assign) MPOINT ptRotateCenter;
@property (nonatomic, assign) MRECT rcRegionRatio;
@property (nonatomic, assign) MBool bVerReversal;
@property (nonatomic, assign) MBool bHorReversal;
@property (nonatomic, assign) BOOL isFrameMode;     //isFrameMode为YES的情况下，贴纸应用到全透明的Storyboard上也是透明的，否则背景会变黑
@property (nonatomic, assign) BOOL isStaticPicture; //isStaticPicture为YES的情况下，动画贴纸的将会静态展示
//@property (nonatomic, assign) BOOL isInstantRefresh;

@property (nonatomic, assign) MFloat mosaicRatio;
@property (nonatomic, assign) MFloat alpha;
@property (nonatomic, strong) CXiaoYingClip *pClip;

@property (nonatomic, assign) MDWord dwSourceStartPos;
@property (nonatomic, assign) MDWord dwSourceDuration;

@property (nonatomic, assign) MDWord dwTrimStartPos;
@property (nonatomic, assign) MDWord dwTrimDuration;

@property (nonatomic, assign) NSInteger volume;//效果的音量（只有特效和视频画中画才有作用）

@property (nonatomic, copy) NSString *userData; //自定义数据

@end
