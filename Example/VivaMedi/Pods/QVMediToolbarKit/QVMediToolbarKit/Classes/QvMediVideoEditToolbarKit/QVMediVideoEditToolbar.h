//
//  XYVideoEditToolbar.h
//  Pods
//
//  Created by chaojie zheng on 2020/4/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark- Trim
extern NSString * const VideoTrimBeginDuration;
extern NSString * const VideoTrimEndDuration;
extern NSString * const VideoCutDuration;
extern NSString * const VideoVolumeValue;
extern NSString * const VideoVoiceChangeValue;
extern NSString * const VideoTotalDuration;
extern NSString * const VideoSpeedChangeValue;
extern NSString * const VideoParameterAdjustment;

typedef NS_ENUM(NSUInteger, QVMediVideoEditToolbarType) {
    QVMediVideoEditToolbarTypeEdit,
    QVMediVideoEditToolbarTypeSticker,
    QVMediVideoEditToolbarTypeSpecialEffects,//特效
    QVMediVideoEditToolbarTypePictureInPicture,
    QVMediVideoEditToolbarTypeWatermark,
    QVMediVideoEditToolbarTypeMosaic,
    QVMediVideoEditToolbarTypeSubtitle,
    QVMediVideoEditToolbarTypeTheme,
    QVMediVideoEditToolbarTypeAudio,
    QVMediVideoEditToolbarTypeScale,
    QVMediVideoEditToolbarTypeTTS
};


typedef NS_ENUM(NSUInteger, QVMediVideoEditScaleType) {
    QVMediVideoEditScaleTypeDefault = 0,
    QVMediVideoEditScaleType_1_1 = 1,
    QVMediVideoEditScaleType_3_4 = 2
};


typedef NS_ENUM(NSUInteger, QVMediVideoEditToolbarTypeEdit_toobarType) {
    QVMediVideoEditToolbarTypeEdit_toobarTypeTrim = 0,
    QVMediVideoEditToolbarTypeEdit_toobarTypeSplit,
    QVMediVideoEditToolbarTypeEdit_toobarTypeDelete,
    QVMediVideoEditToolbarTypeEdit_toobarTypeVolume,
    QVMediVideoEditToolbarTypeEdit_toobarTypeFilter,
    QVMediVideoEditToolbarTypeEdit_toobarTypeTransition,
    QVMediVideoEditToolbarTypeEdit_toobarTypeVoiceChange,
    QVMediVideoEditToolbarTypeEdit_toobarTypeVariableSpeed,
    QVMediVideoEditToolbarTypeEdit_toobarTypeParameterAdjustment,
    QVMediVideoEditToolbarTypeEdit_toobarTypeMirror,
    QVMediVideoEditToolbarTypeEdit_toobarTypeReverse,
    QVMediVideoEditToolbarTypeEdit_toobarTypeRotate
};

typedef NS_ENUM(NSUInteger, QVMediVideoEditToolbarTypeSticker_toobarType) {
    QVMediVideoEditToolbarTypeSticker_toobarTypeModifyText = 0,
    QVMediVideoEditToolbarTypeSticker_toobarTypeModifyStyle,
    QVMediVideoEditToolbarTypeSticker_toobarTypeTrim,
    QVMediVideoEditToolbarTypeSticker_toobarTypeVolume,
    QVMediVideoEditToolbarTypeSticker_toobarTypeOpacity,
    QVMediVideoEditToolbarTypeSticker_toobarTypeZoom,
    QVMediVideoEditToolbarTypeSticker_toobarTypeDelete,
    QVMediVideoEditToolbarTypeSticker_toobarTypeMirror,
    QVMediVideoEditToolbarTypeSticker_toobarTypeRotate,

};


/// 视频处理主 toolbar
@interface QVMediVideoEditToolbar : UIView

@property (nonatomic, assign) NSInteger videoTotalDuration;

@property (nonatomic, assign) BOOL isUpdate;

@property (nonatomic, assign) CGFloat volumeValue;

@property (nonatomic, assign) CGFloat voiceChangeValue;

@property (nonatomic, assign) CGFloat voiceSpeedValue;

@property (nonatomic, strong) NSMutableDictionary *parameterAdjustmentDic;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) NSMutableArray *iconImageArray;

@property (nonatomic,   copy) void(^addClipActionBlock)(NSInteger curSelectIndex);

@property (nonatomic,   copy) void(^selectClipActionBlock)(NSInteger curSelectIndex, BOOL autoRefresh);

- (void)createVideoEditToolbarWithData:(NSArray *)dataArray toolbarClick:(void(^)(QVMediVideoEditToolbarType toolbarType))toolbarClick;

- (void)defaultCreateToolbarClick:(void(^)(QVMediVideoEditToolbarType toolbarType, NSDictionary *toolbarTypeInfoDic, id params, BOOL executionEvent))toolbarClick;

@end

NS_ASSUME_NONNULL_END
