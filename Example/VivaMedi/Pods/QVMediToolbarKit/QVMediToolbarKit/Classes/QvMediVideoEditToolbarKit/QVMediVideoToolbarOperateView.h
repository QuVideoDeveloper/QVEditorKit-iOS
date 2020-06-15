//
//  XYVideoToolbarOperateView.h
//  Pods-XYToolbarKit_Example
//
//  Created by chaojie zheng on 2020/4/16.
//
//三级页面
#import <UIKit/UIKit.h>

typedef void(^QVMediVideoToolbarOperateBlock)(id _Nullable toobarType, id _Nullable value);

typedef NS_ENUM(NSUInteger, VideoEditToolbarTypeAudioType) {
    VideoEditToolbarTypeAudioTypeSong,
    VideoEditToolbarTypeAudioTypeSoundEffects,
    VideoEditToolbarTypeAudioTypeRrecording,
};

NS_ASSUME_NONNULL_BEGIN

@interface QVMediVideoToolbarOperateView : UIView

@property (nonatomic, strong)  id effectModel;

- (void)creatOperateViewWithItemInfo:(NSDictionary *)itemInfo changeValue:(QVMediVideoToolbarOperateBlock)changeValue finish:(QVMediVideoToolbarOperateBlock)finish;

@end

NS_ASSUME_NONNULL_END
