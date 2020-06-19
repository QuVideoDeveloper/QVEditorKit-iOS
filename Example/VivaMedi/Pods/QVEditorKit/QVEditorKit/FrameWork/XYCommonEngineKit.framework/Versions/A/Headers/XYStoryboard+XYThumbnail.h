//
//  XYStoryboard+XYThumbnail.h
//  XYCommonEngineKit
//
//  Created by lizitao on 2019/9/17.
//

#import "XYStoryboard.h"

@interface XYStoryboard (aThumbnail)
    
- (void)prepareThumbnailManager:(CXiaoYingClip *)clip
                  dwThumbPixelW:(MDWord)dwThumbPixelW
                  dwThumbPixelH:(MDWord)dwThumbPixelH
                      PimalFlag:(MBool)pimalFlag
               onlyOriginalClip:(MBool)onlyOriginalClip;

- (UIImage *)createThumbnail:(CXiaoYingClip *)clip
                  dwPosition:(MDWord)dwPosition
               dwThumbPixelW:(MDWord)dwThumbPixelW
               dwThumbPixelH:(MDWord)dwThumbPixelH
              skipBlackFrame:(MBool)skipBlackFrame;

- (void)destroyThumbnailManager:(CXiaoYingClip *)clip;
    
- (UIImage *)createThumbnail:(MDWord)dwPosition
               dwThumbPixelW:(MDWord)dwThumbPixelW
               dwThumbPixelH:(MDWord)dwThumbPixelH;

- (UIImage *)createThumbnail:(MDWord)dwPosition
               dwThumbPixelW:(MDWord)dwThumbPixelW
               dwThumbPixelH:(MDWord)dwThumbPixelH
                   PimalFlag:(MBool)pimalFlag
            onlyOriginalClip:(MBool)onlyOriginalClip;

- (void)createThumbnails:(MDWord)dwThumbPixelW
           dwThumbPixelH:(MDWord)dwThumbPixelH
             dwPositions:(NSArray *)dwPositions
               PimalFlag:(MBool)pimalFlag
        onlyOriginalClip:(MBool)onlyOriginalClip
                   block:(void (^)(UIImage *image, int index))block;

- (void)createThumbnails:(MDWord)dwThumbPixelW
           dwThumbPixelH:(MDWord)dwThumbPixelH
             dwPositions:(NSArray *)dwPositions
               PimalFlag:(MBool)pimalFlag
        onlyOriginalClip:(MBool)onlyOriginalClip
      skipBlackFrameFlag:(MBool)skipBlackFrameFlag
                   block:(void (^)(UIImage *image, int index))block;

- (void)createClipThumbnails:(MDWord)dwClipIndex
                 dwPositions:(NSArray *)dwPositions
               dwThumbPixelW:(MDWord)dwThumbPixelW
               dwThumbPixelH:(MDWord)dwThumbPixelH
                   PimalFlag:(MBool)pimalFlag
                       block:(void (^)(UIImage *image, int index))block;

- (void)createClipThumbnailsByClip:(CXiaoYingClip *)trimedClip
                       dwPositions:(NSArray *)dwPositions
                     dwThumbPixelW:(MDWord)dwThumbPixelW
                     dwThumbPixelH:(MDWord)dwThumbPixelH
                         PimalFlag:(MBool)pimalFlag
                             block:(void (^)(UIImage *image, int index))block;

- (UIImage *)createClipThumbnail:(MDWord)dwClipIndex
                      dwPosition:(MDWord)dwPosition
                   dwThumbPixelW:(MDWord)dwThumbPixelW
                   dwThumbPixelH:(MDWord)dwThumbPixelH
                       PimalFlag:(MBool)pimalFlag;

- (UIImage *)createClipThumbnailByClip:(CXiaoYingClip *)trimedClip
                            dwPosition:(MDWord)dwPosition
                         dwThumbPixelW:(MDWord)dwThumbPixelW
                         dwThumbPixelH:(MDWord)dwThumbPixelH
                             PimalFlag:(MBool)pimalFlag;

- (UIImage *)getStickerThumb:(StickerInfo *)stickerInfo;


#pragma mark - 通过关键帧拿缩略图
- (UIImage *)createThumbnailByKeyFrame:(CXiaoYingClip *)clip
                            dwPosition:(MDWord)dwPosition
                         dwThumbPixelW:(MDWord)dwThumbPixelW
                         dwThumbPixelH:(MDWord)dwThumbPixelH
                        skipBlackFrame:(MBool)skipBlackFrame;

- (UIImage *)createThumbnailByKeyFrame:(MDWord)dwPosition
                         dwThumbPixelW:(MDWord)dwThumbPixelW
                         dwThumbPixelH:(MDWord)dwThumbPixelH;

@end

