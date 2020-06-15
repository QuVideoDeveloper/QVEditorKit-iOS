//
//  XYThumbnailOperation.m
//  XYVivaEditor
//
//  Created by 徐新元 on 2019/12/19.
//

#import "XYClipThumbnailOperation.h"
#import "XYCommonEngineKit.h"
#import <SDWebImage/SDWebImage.h>
#import "XYStoryboard+XYThumbnail.h"

@implementation XYClipThumbnailOperation

- (void)main {
    NSInteger fixedSeekPosition = [self fixedSeekPosition:self.inputModel.seekPosition];
    NSString *cacheKey = [self cacheKey:fixedSeekPosition];
    NSLog(@"【Thumbnail】 cacheKey=%@, fixedSeekPosition=%d, seekPosition=%d, trimLen=%d",cacheKey,fixedSeekPosition,self.inputModel.seekPosition,self.inputModel.trimVeRange.dwLen);
    UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:cacheKey];
    
    if (self.inputModel.seekPosition != 0 && !image) {
        //非第0帧的图如果还没拿到，先用0帧的缓存填充
        NSString *placeHolderKey = [self cacheKey:0];
        UIImage *placeHolderImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:placeHolderKey];
        if (placeHolderImage) {
            [self finishGetThumbnail:placeHolderImage isPlaceHolder:YES isAsync:YES];
        }
    }
    
    if (image) {
        [self finishGetThumbnail:image isPlaceHolder:NO isAsync:YES];
        return;
    }
    
    if ([XYStoryboard sharedXYStoryboard].isInBackground) {
        return;
    }
//    NSDate *startTime = [NSDate date];
    if (!self.inputModel.isPrepareThumbnailManager) {
         [[XYEngineWorkspace currentStoryboard] prepareThumbnailManager:self.inputModel.clip
            dwThumbPixelW:self.inputModel.thumbnailWidth
            dwThumbPixelH:self.inputModel.thumbnailHeight
                PimalFlag:MTrue
         onlyOriginalClip:MFalse];
        self.inputModel.isPrepareThumbnailManager = YES;
     }
    //    NSLog(@"【Thumbnail】[TIME COST1]: %f ---------------", -[startTime timeIntervalSinceNow]);
//    startTime = [NSDate date];
    image = [[XYEngineWorkspace currentStoryboard] createThumbnailByKeyFrame:self.inputModel.clip
                                                                  dwPosition:fixedSeekPosition
                                                               dwThumbPixelW:self.inputModel.thumbnailWidth
                                                               dwThumbPixelH:self.inputModel.thumbnailHeight
                                                              skipBlackFrame:self.inputModel.skipBlackFrame];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"XY_EditConfig_Thumbnail_Debug"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"XY_EditConfig_Thumbnail_Debug"] boolValue] == YES) {
        image = [self createThumbnailWithBeginTime:fixedSeekPosition endTime:fixedSeekPosition image:image clipIndex:self.inputModel.clipIndex];
    }
    
//    NSLog(@"【Thumbnail】[TIME COST2]: %f ---------------", -[startTime timeIntervalSinceNow]);
    [self finishGetThumbnail:image isPlaceHolder:NO isAsync:YES];
//    startTime = [NSDate date];
    [[XYEngineWorkspace currentStoryboard] destroyThumbnailManager:self.inputModel.clip];
//    NSLog(@"【Thumbnail】[TIME COST3]: %f ---------------", -[startTime timeIntervalSinceNow]);
    
//    startTime = [NSDate date];
    [[SDImageCache sharedImageCache] storeImage:image forKey:cacheKey completion:nil];
//    NSLog(@"【Thumbnail】[TIME COST4]: %f ---------------", -[startTime timeIntervalSinceNow]);
    
    
}

//计算缓存用的Key
- (NSString *)cacheKey:(NSInteger)fixedSeekPosition {
    NSString *cacheKey = nil;
    
    //计算CacheKey用的相关参数
    NSString *filePath = self.inputModel.clipFilePath;//物理文件路径
    float speed = self.inputModel.speedValue;//变速值
    speed = ((speed==0)?1.0:speed);
    NSInteger trimStartPos = self.inputModel.trimVeRange.dwPos;//Trim起点
    NSInteger sourceStartPos = self.inputModel.sourceVeRange.dwPos;//Source起点
    BOOL isReversed = self.inputModel.isReversed;//是否倒放
    
    NSInteger phisicalClipSeekPosition = (fixedSeekPosition + trimStartPos) * speed + sourceStartPos;//相对于物理文件上的时间点
    
    if (self.inputModel.clipType == XYCommonEngineClipModuleThemeCoverFront
        ||self.inputModel.clipType == XYCommonEngineClipModuleThemeCoverBack) {//封面封底没有filepath，根据主题ID建一个
        filePath = [NSString stringWithFormat:@"0x%lx_%d",self.inputModel.themeID,self.inputModel.clipType];
    }
    
    cacheKey = [NSString stringWithFormat:@"%@_%i_%i",filePath,phisicalClipSeekPosition,isReversed];

    return cacheKey;
}

- (void)finishGetThumbnail:(UIImage *)image isPlaceHolder:(BOOL)isPlaceHolder isAsync:(BOOL)isAsync {
    if (!image) {
        return;
    }

    if (isPlaceHolder) {
        self.isFilledPlaceholder = YES;
    } else {
        self.isFilledCorrectImage = YES;
    }
    
    XYClipThumbnailCompleteModel *completeModel = [XYClipThumbnailCompleteModel new];
    completeModel.image = image;
    completeModel.identifier = self.inputModel.identifier;
    completeModel.seekPosition = self.inputModel.seekPosition;
    
    completeModel.beginTime = self.inputModel.beginTime;
    completeModel.endTime = self.inputModel.endTime;
    completeModel.clipIndex = self.inputModel.clipIndex;
    
    if (isAsync) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.completeBlock) {
                self.completeBlock(completeModel);
            }
        });
    } else {
        if (self.completeBlock) {
            self.completeBlock(completeModel);
        }
    }
}

- (void)syncReturnPlaceholderThumbnail {
    if (self.isFilledPlaceholder) {
        return;
    }
    
    if (self.isFilledCorrectImage) {
        return;
    }
    
    NSInteger fixedSeekPosition = [self fixedSeekPosition:self.inputModel.seekPosition];
    NSString *cacheKey = [self cacheKey:fixedSeekPosition];
    NSLog(@"【Thumbnail】 cacheKey=%@, fixedSeekPosition=%d, seekPosition=%d, trimLen=%d",cacheKey,fixedSeekPosition,self.inputModel.seekPosition,self.inputModel.trimVeRange.dwLen);
    UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:cacheKey];
    
    if (image) {//能拿到准确的缓存就直接返回
        [self finishGetThumbnail:image isPlaceHolder:NO isAsync:NO];
        return;
    }
    
    if (self.inputModel.seekPosition == 0) {
        return;//没拿到准确的图，而且是第一帧的，直接return，因为后面会异步从引擎获取
    }
    
    //没拿到准确的图，不是第一帧，尝试拿第一帧的缓存
    cacheKey = [self cacheKey:0];
    image = [[SDImageCache sharedImageCache] imageFromCacheForKey:cacheKey];
    [self finishGetThumbnail:image isPlaceHolder:YES isAsync:NO];
}

// 对传进来的seekPosition进行一系列修正处理
- (NSInteger)fixedSeekPosition:(NSInteger)originalSeekPosition {
    if (self.inputModel.clipType == XYCommonEngineClipModuleImage
        ||self.inputModel.clipType == XYCommonEngineClipModuleGif) {
       return 0;//图片或Gif镜头始终取第0帧就可以了
    }
    
    originalSeekPosition += self.inputModel.fixTime;//有转场的情况下会有一个偏移量，需要校准
    
    if (originalSeekPosition < 0) {
        originalSeekPosition = 0;
    }
    
    NSInteger trimEndPos = self.inputModel.trimVeRange.dwPos + self.inputModel.trimVeRange.dwLen;
    if (originalSeekPosition > trimEndPos) {//防止传进来的时间超过TrimRange的末尾
        return trimEndPos;
    }
        
    return originalSeekPosition;
}

- (UIImage *)createThumbnailWithBeginTime:(NSInteger)beginTime endTime:(NSInteger)endTime image:(UIImage *)image clipIndex:(NSInteger)clipIndex {
    srandom(time(NULL));
//    绘制图片上下文

    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [image drawInRect:CGRectMake(0,0, image.size.width, image.size.height)];
    
    CGFloat y = image.size.height * 0.5 + 4;
    //字体绘制到图片的位置和字体属性
//    NSString * text = [NSString stringWithFormat:@"%ld", beginTime];
//    [text drawInRect:CGRectMake(10, y, image.size.width, 20 * 2) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:25], NSForegroundColorAttributeName : [UIColor redColor]}];

    NSString * endText = [NSString stringWithFormat:@"%ld", endTime];
    [endText drawInRect:CGRectMake(10, y, image.size.width, 25) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:25], NSForegroundColorAttributeName : [UIColor purpleColor]}];
//
    NSString * clipText = [NSString stringWithFormat:@"%ld", clipIndex];
    [clipText drawInRect:CGRectMake(10, y + (25) + 4, image.size.width, 25) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:25], NSForegroundColorAttributeName : [UIColor purpleColor]}];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
