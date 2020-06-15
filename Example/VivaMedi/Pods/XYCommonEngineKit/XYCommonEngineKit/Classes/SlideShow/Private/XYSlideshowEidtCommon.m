//
//  XYSlideshowEidtCommon.m
//  XYVivaSlideShowEdit
//
//  Created by 夏澄 on 2019/4/10.
//

#import "XYSlideshowEidtCommon.h"
#import <XYCommonEngineKit/XYCommonEngineKit.h>
#import "XYSlideShowSourceNode.h"
@interface XYSlideshowEidtCommon ()
@property (nonatomic, assign) NSInteger                          clipCheck;

@end

@implementation XYSlideshowEidtCommon

+ (NSArray <PHAsset *> *)getAssetsByAssetIDList:(NSArray <NSString *>*)idList {
   __block NSMutableArray *assets = [NSMutableArray new];
    if (idList.count > 0) {
        PHFetchResult *fecthResult = [PHAsset fetchAssetsWithLocalIdentifiers:idList options:nil];
        [fecthResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj) {
                [assets addObject:obj];
            }
        }];
    }
    return assets;
}

+ (PHAsset *)getAssetByAssetID:(NSString *)assetID {
    __block PHAsset *asset;
    if (assetID) {
            PHFetchResult *fecthResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil];
            [fecthResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                asset = obj;
            }];
    }
    return asset;
}


+ (NSArray <PHAsset *> *)getAssetByAssetURLs:(NSArray <NSURL *>*)assetURLs {
    __block NSMutableArray *assets = [NSMutableArray new];
    if (assetURLs.count > 0) {
        PHFetchResult *fecthResult = [PHAsset fetchAssetsWithALAssetURLs:assetURLs options:nil];
        [fecthResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj) {
                [assets addObject:obj];
            }
        }];
    }
    return assets;
}



+ (NSString *)getAssetIDByAssetPath:(NSString *)assetPath {
    NSString *assetID = assetPath;
    NSString *phAssetScheme = @"PHASSET";
    NSString *phAssetSchemeAndSeperater = @"PHASSET://";
    if (assetPath && [assetPath containsString:phAssetScheme]) {
        assetID = [assetPath stringByReplacingOccurrencesOfString:phAssetSchemeAndSeperater withString:@""];
        assetID = [assetID stringByDeletingPathExtension];
    }
    return assetID;
}

+ (PHAsset *)getAssetByAssetPath:(NSString *)assetPath {
    NSString *assetID = [self getAssetIDByAssetPath:assetPath];
    if (assetID) {
        return [self getAssetByAssetID:assetID];
    }else{
        return nil;
    }
}

- (int)calculateClipIndexByTime:(MDWord)time {
    NSArray <NSNumber *>* indexList = [[XYStoryboard sharedXYStoryboard] getClipIndexArrayByTime:time];//取出当前时间所有的clipIndx
    MDWord index = 0;
    if(indexList.count > 0){
        BOOL inIndexList = NO;
        for (NSNumber *num in indexList) {
            if([num intValue] == self.clipCheck){
                inIndexList = YES;
                break;
            }
        }
        if (self.clipCheck != -1 && inIndexList) {
            index = self.clipCheck;
            self.clipCheck = -1;
        }else{
            if (self.clipCheck != -1) {
                index = self.clipCheck;
            }else
            {
                if (time >= [[XYStoryboard sharedXYStoryboard] getDuration] - 50){//因为收到seek 无法seek到 尾 所以大致末尾的50毫秒就认为是最后一个 因为图片时长缩短 也是>= 200毫秒 视频基本不会小于 50毫秒
                    index = [indexList.lastObject intValue];
                }else{
                    index = [indexList.firstObject intValue];
                }
            }
        }
    }else{
        index = [[XYStoryboard sharedXYStoryboard] getClipIndexByTime:time];
    }
    
    NSInteger clipCount = [[XYStoryboard sharedXYStoryboard] getClipCount];
    if (index >= clipCount) {
        return clipCount > 0 ? (int)(clipCount - 1) : 0;
    }
    return index;
}

- (int)calculateClipIndexByTime:(MDWord)time virtualInfos:(NSArray <XYSlideShowSourceNode *> *)virtualInfos {
    __block NSUInteger index = 0;
    [virtualInfos enumerateObjectsUsingBlock:^(XYSlideShowSourceNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (time <= obj.previewPos) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}
@end
