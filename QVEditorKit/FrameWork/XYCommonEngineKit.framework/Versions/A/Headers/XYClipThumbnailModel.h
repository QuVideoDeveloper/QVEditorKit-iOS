//
//  XYThumbnailModel.h
//  XYVivaEditor
//
//  Created by 徐新元 on 2019/12/20.
//

#import <Foundation/Foundation.h>
#import "XYClipThumbnailCompleteModel.h"
#import "XYClipThumbnailInputModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYClipThumbnailModel : NSObject

@property (nonatomic, copy) NSString *key;

@property (nonatomic, assign) BOOL isPaused;

@property (nonatomic, strong) XYClipThumbnailInputModel *inputModel;

@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;

- (void)cancelAllOperations;

- (void)resumeAllOperations;

- (void)createThumbnailManager;

- (void)destroyThumbnailManager;

- (void)rebuildThumbnailManager;

- (void)thumbnailWithCompleteBlock:(void (^)(XYClipThumbnailCompleteModel *completeModel))completeBlock
                  placeholderBlock:(void (^)(XYClipThumbnailCompleteModel *completeModel))placeholderBlock;

@end

NS_ASSUME_NONNULL_END
