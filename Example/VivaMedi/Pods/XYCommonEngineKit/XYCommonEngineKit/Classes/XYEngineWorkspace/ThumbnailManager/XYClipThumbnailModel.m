//
//  XYThumbnailModel.m
//  XYVivaEditor
//
//  Created by 徐新元 on 2019/12/20.
//

#import "XYClipThumbnailModel.h"
#import "XYClipThumbnailOperation.h"
#import <XYToolKit/XYToolKit.h>
#import "XYCommonEngineKit.h"
#import <SDWebImage/SDWebImage.h>
#import "XYStoryboard+XYThumbnail.h"

@implementation XYClipThumbnailModel

#pragma mark - Public
- (void)thumbnailWithCompleteBlock:(void (^)(XYClipThumbnailCompleteModel *completeModel))completeBlock
                  placeholderBlock:(void (^)(XYClipThumbnailCompleteModel *completeModel))placeholderBlock {
    if (self.isPaused) {
        return;
    }
    
    XYClipThumbnailOperation *thumbnailOperation = [XYClipThumbnailOperation new];
    thumbnailOperation.inputModel = [self.inputModel copy];
    @weakify(self);
    thumbnailOperation.completeBlock = ^(XYClipThumbnailCompleteModel * _Nonnull completeModel) {
        @strongify(self);
        completeBlock(completeModel);
        [self fillAllPlaceholders];
    };
    thumbnailOperation.queuePriority = NSOperationQueuePriorityVeryHigh;
    [thumbnailOperation syncReturnPlaceholderThumbnail];
    if (![thumbnailOperation isFilledCorrectImage]) {//没有拿到正确缓存的情况下才需要丢线程里去取图
        NSLog(@"【Thumbnail】addOperation %p",self);
        [self.thumbnailQueue addOperation:thumbnailOperation];
    }
    
}

- (void)cancelAllOperations {
    self.isPaused = YES;
    NSLog(@"【Thumbnail】waitUntilAllOperationsAreFinished thumbnailQueue=%p key=%@ <-- %d",self.thumbnailQueue,self.key,[self.thumbnailQueue operationCount]);
    [self.thumbnailQueue cancelAllOperations];
    [self.thumbnailQueue waitUntilAllOperationsAreFinished];
    NSLog(@"【Thumbnail】waitUntilAllOperationsAreFinished -->");
}

- (void)resumeAllOperations {
    self.isPaused = NO;
}

- (void)createThumbnailManager {
    self.isPaused = YES;
    [self.thumbnailQueue cancelAllOperations];
    [self.thumbnailQueue waitUntilAllOperationsAreFinished];
    @weakify(self);
    [self.thumbnailQueue addOperationWithBlock:^{
        @strongify(self);
        [self.inputModel.storyboard prepareThumbnailManager:self.inputModel.clip
                                              dwThumbPixelW:self.inputModel.thumbnailWidth
                                              dwThumbPixelH:self.inputModel.thumbnailHeight
                                                  PimalFlag:MTrue
                                           onlyOriginalClip:MFalse];
    }];
    [self.thumbnailQueue waitUntilAllOperationsAreFinished];
    self.isPaused = NO;
}

- (void)destroyThumbnailManager {
    self.isPaused = YES;
    [self.thumbnailQueue cancelAllOperations];
    [self.thumbnailQueue waitUntilAllOperationsAreFinished];
    @weakify(self);
    [self.thumbnailQueue addOperationWithBlock:^{
        @strongify(self);
        [self.inputModel.clip destroyThumbnailManager];
    }];
    [self.thumbnailQueue waitUntilAllOperationsAreFinished];
}

- (void)rebuildThumbnailManager {
    self.isPaused = YES;
    [self.thumbnailQueue cancelAllOperations];
    [self.thumbnailQueue waitUntilAllOperationsAreFinished];
    @weakify(self);
    [self.thumbnailQueue addOperationWithBlock:^{
        @strongify(self);
        [self.inputModel.clip destroyThumbnailManager];
        [self.inputModel.storyboard prepareThumbnailManager:self.inputModel.clip
           dwThumbPixelW:self.inputModel.thumbnailWidth
           dwThumbPixelH:self.inputModel.thumbnailHeight
               PimalFlag:MTrue
        onlyOriginalClip:MFalse];
    }];
    [self.thumbnailQueue waitUntilAllOperationsAreFinished];
    self.isPaused = NO;
}

- (void)fillAllPlaceholders {
    NSArray <XYClipThumbnailOperation *> *operations = [self.thumbnailQueue operations];
    NSInteger operationCount = [operations count];
    NSLog(@"【Thumbnails】operations=%d", operationCount);
    [operations enumerateObjectsUsingBlock:^(XYClipThumbnailOperation * _Nonnull operation, NSUInteger idx, BOOL * _Nonnull stop) {
        [operation syncReturnPlaceholderThumbnail];
        if ((operationCount > operation.inputModel.maxOperationCount) && (idx < operationCount/2)) {
            [operation cancel];
        }
    }];
}

#pragma mark - Lazy Init
- (NSOperationQueue *)thumbnailQueue {
    if (!_thumbnailQueue) {
        _thumbnailQueue = [[NSOperationQueue alloc] init];
        _thumbnailQueue.maxConcurrentOperationCount = 1;
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
        _thumbnailQueue.name = [NSString stringWithFormat:@"com.quvideo.XiaoYing.thumbOperationQueue.%p",self];
    }
    NSLog(@"【Thumbnail】thumbnailQueue=%p key=%@",_thumbnailQueue,self.key);
    return _thumbnailQueue;
}

@end
