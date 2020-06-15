//
//  XYToolbarManager.h
//  Pods-XYToolbarKit_Example
//
//  Created by chaojie zheng on 2020/4/14.
//

#import <Foundation/Foundation.h>
#import "QVMediCameraToolbar.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QVMediToolbarType) {
    QVMediToolbarTypeCamera,            /* 录制 Camera toolbar */
    QVMediToolbarTypeVideoMain,         /* 视频处理主 toolbar */
    QVMediToolbarTypeVideoSubtitles,    /* 视频字幕 toolbar */
    QVMediToolbarTypeVideoEdit,         /* 视频编辑 toolbar */
    QVMediToolbarTypeVideoSticker       /* 贴纸 toolbar */
};

@interface QVMediToolbarManager : NSObject

@property (nonatomic) NSInteger clipSeletedIdx;

+ (id)createToolbarWithType:(QVMediToolbarType)toolbarType;
+ (QVMediToolbarManager *)manager;
@end

NS_ASSUME_NONNULL_END
