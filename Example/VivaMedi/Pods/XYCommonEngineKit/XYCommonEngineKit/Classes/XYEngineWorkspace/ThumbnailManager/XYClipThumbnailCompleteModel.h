//
//  XYThumbnailCompleteModel.h
//  XYVivaEditor
//
//  Created by 徐新元 on 2019/12/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYClipThumbnailCompleteModel : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) NSInteger seekPosition;

@property (nonatomic, assign) NSInteger beginTime;
@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, assign) NSInteger clipIndex;

@end

NS_ASSUME_NONNULL_END
