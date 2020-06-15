//
//  XYVideoThumbnailManager.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/21.
//

#import "XYVideoThumbnailManager.h"
#import "XYCommonEngineTaskMgr.h"
#import "XYEngineWorkspace.h"
#import "XYStoryboard+XYThumbnail.h"
#import "XYStoryboardUtility.h"
#import "XYBaseEffectTask.h"
#import <ReactiveObjC/ReactiveObjC.h>

typedef NS_ENUM(NSInteger, QClipThumbnailManagerType) {
    QClipThumbnailManagerTypeNone = 0,
    QClipThumbnailManagerTypePrepared,
    QClipThumbnailManagerTypePause,
};

@interface XYVideoThumbnailManager ()

@property (strong, nonatomic) CXiaoYingClip *pDuplicatedStbClip;
@property (nonatomic, strong) dispatch_queue_t dispatchQueue;
@property (nonatomic, assign) QClipThumbnailManagerType thumbnailManagerType;
@end


@implementation XYVideoThumbnailManager

+ (XYVideoThumbnailManager *)manager {
    static XYVideoThumbnailManager *manager;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
      manager = [[XYVideoThumbnailManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.thumbnailManagerType = QClipThumbnailManagerTypeNone;
        [self addRealTaskObserver];
        _dispatchQueue = dispatch_queue_create("com.quvideo.serial.common.engine.videoThembnail.queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)fetchVideoCoverThumbnailsWithThumbnailSize:(CGSize)thumbnailSize block:(void (^)(UIImage *image))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *posArray = @[@([self thumbPos])];
            [[XYEngineWorkspace currentStoryboard] createThumbnails:thumbnailSize.width
                                                      dwThumbPixelH:thumbnailSize.height
                                                        dwPositions:posArray
                                                          PimalFlag:MFalse
                                                   onlyOriginalClip:MFalse
                                                 skipBlackFrameFlag:MTrue
                                                              block:^(UIImage *image, int index) {
                if (block) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(image);
                    });
                }
            }];
    });
}

- (void)fetchThumbnailsWithThumbnailSize:(CGSize)thumbnailSize seekPosition:(NSInteger)seekPosition block:(void (^)(UIImage *image))block {
    dispatch_async(self.dispatchQueue, ^{
        CXiaoYingClip *pStbClip = [[XYEngineWorkspace currentStoryboard] getDataClip];
        if (QClipThumbnailManagerTypeNone == self.thumbnailManagerType) {
            if (self.pDuplicatedStbClip) {
                [self.pDuplicatedStbClip destroyThumbnailManager];
                [self.pDuplicatedStbClip UnInit];
            }
            self.pDuplicatedStbClip = [[CXiaoYingClip alloc] init];
            [self.pDuplicatedStbClip duplicate:pStbClip];
            [[XYEngineWorkspace currentStoryboard] prepareThumbnailManager:self.pDuplicatedStbClip
                                                             dwThumbPixelW:thumbnailSize.width
                                                             dwThumbPixelH:thumbnailSize.height
                                                                 PimalFlag:MTrue
                                                          onlyOriginalClip:MFalse];
            self.thumbnailManagerType = QClipThumbnailManagerTypePrepared;
        }
        if (QClipThumbnailManagerTypePause == self.thumbnailManagerType) {
            return;
        }
        UIImage *thumbImage = [[XYEngineWorkspace currentStoryboard] createThumbnailByKeyFrame:self.pDuplicatedStbClip dwPosition:seekPosition dwThumbPixelW:thumbnailSize.width dwThumbPixelH:thumbnailSize.height skipBlackFrame:MTrue];
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(thumbImage);
            });
        }
    });
}

//缩略图截取时间点计算
- (UInt64)thumbPos{
    UInt64 themeId = [[XYStoryboard sharedXYStoryboard] getThemeID];
    UInt64 thumPos = 0;
    if (themeId == 0) {
        thumPos = [XYStoryboardUtility getStoryboardFirstVideoTimestamp:[XYStoryboard sharedXYStoryboard]];
    }else{
        thumPos = [[XYStoryboard sharedXYStoryboard].templateDelegate onGetThemeCoverPositionByThemeId:themeId];
    }
    if (thumPos > [[XYStoryboard sharedXYStoryboard] getDuration]) {
        thumPos = 0;
    }
    return thumPos;
}

- (void)addRealTaskObserver {
    @weakify(self);
    [XYEngineWorkspace addObserver:self taskID:XYCommonEngineTaskIDObserverEveryTaskFinish block:^(id obj) {
        @strongify(self);
        XYBaseEngineTask *task = obj;
        [self postProcessEngineTask:task isTempWorkSpace:NO];
    }];
    
    [XYEngineWorkspace addObserver:self taskID:XYCommonEngineTaskIDObserverEveryTaskStart block:^(id obj) {
        @strongify(self);
        XYBaseEngineTask *task = obj;
        [self preProcessEngineTask:task isTempWorkSpace:NO];
    }];
}

- (void)preProcessEngineTask:(XYBaseEngineTask *)task isTempWorkSpace:(BOOL)isTemp{
    if (task.dataClipReinitThumbnailManager) {
        //Undo Redo操作先停止所有取缩略图操作
        self.thumbnailManagerType = QClipThumbnailManagerTypePause;
    }
}

- (void)postProcessEngineTask:(XYBaseEngineTask *)task isTempWorkSpace:(BOOL)isTemp {

    if (task.dataClipReinitThumbnailManager) {
        //Undo Redo 切主题操作完成后重新创建取缩略图的ThumbnailManager
        self.thumbnailManagerType = QClipThumbnailManagerTypeNone;
    }
 
}

@end
