//
//  XYThumbnailOperation.h
//  XYVivaEditor
//
//  Created by 徐新元 on 2019/12/19.
//

#import <Foundation/Foundation.h>
#import "XYClipThumbnailCompleteModel.h"
#import "XYClipThumbnailInputModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYClipThumbnailOperation : NSOperation

@property (nonatomic, assign) BOOL isFilledPlaceholder;
@property (nonatomic, assign) BOOL isFilledCorrectImage;
@property (nonatomic, strong) XYClipThumbnailInputModel *inputModel;
@property (nonatomic, copy) void(^completeBlock)(XYClipThumbnailCompleteModel *completeModel);
@property (nonatomic, copy) void(^placeholderBlock)(XYClipThumbnailCompleteModel *completeModel);

- (void)syncReturnPlaceholderThumbnail;


@end

NS_ASSUME_NONNULL_END
