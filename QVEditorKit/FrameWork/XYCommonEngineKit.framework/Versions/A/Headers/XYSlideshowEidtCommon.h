//
//  XYSlideshowEidtCommon.h
//  XYVivaSlideShowEdit
//
//  Created by 夏澄 on 2019/4/10.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN
@class XYSlideShowSourceNode;
@interface XYSlideshowEidtCommon : NSObject

+ (NSArray <PHAsset *> *)getAssetsByAssetIDList:(NSArray <NSString *>*)idList;
+ (NSString *)getAssetIDByAssetPath:(NSString *)assetPath;
+ (PHAsset *)getAssetByAssetID:(NSString *)assetID;
+ (PHAsset *)getAssetByAssetPath:(NSString *)assetPath;

- (int)calculateClipIndexByTime:(MDWord)time;
- (int)calculateClipIndexByTime:(MDWord)time virtualInfos:(NSArray <XYSlideShowSourceNode *> *)virtualInfos;

@end

NS_ASSUME_NONNULL_END
