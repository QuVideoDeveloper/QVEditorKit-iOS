//
//  XYSlideShowSourceInfoMgr.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/30.
//

#import "XYSlideShowClipMgr.h"
#import "XYAutoEditMgr.h"
#import "XYPlayerView.h"
#import "XYPlayerViewConfiguration.h"
#import "XYSlideShowEnum.h"
#import "XYSlideShowMedia.h"
#import "XYSlideShowSourceNode.h"

@implementation XYSlideShowClipMgr

/// 添加源的节点
/// @param media 图片视频媒体资源
- (void)insertSource:(XYSlideShowMedia *)media {
    [[XYAutoEditMgr sharedInstance] insertImage:media];
}

/// 获取原始的图片视频媒体列表
- (NSArray <XYSlideShowMedia *> *)fetchMedias {
    return [[XYAutoEditMgr sharedInstance] getSourceInfoNodeArray];
}

/// 获取所有源的列表
- (NSArray<XYSlideShowSourceNode *> *)fetchSlideShowSourceNodes {
  return [[XYAutoEditMgr sharedInstance] getVirtualImgInfoNodeArray];
}

/// 删除源的节点
/// @param srcIndex 源的index
- (void)removeSource:(NSInteger)srcIndex {
    [[XYAutoEditMgr sharedInstance].slideShowSession RemoveSource:srcIndex];
}

/// 交换源
/// @param srcIndex 起始index
/// @param dstIndex 目标index
- (void)moveSource:(UInt32)srcIndex dstIndex:(UInt32)dstIndex {
    [[XYAutoEditMgr sharedInstance].editorPlayerView pause];
    [[XYAutoEditMgr sharedInstance] moveVirtualSource:srcIndex dwDstIndex:dstIndex];
    [[XYAutoEditMgr sharedInstance] refreshVirtualSourceInfo];
    NSInteger seekPosition = [XYAutoEditMgr sharedInstance].editorPlayerView.playerConfig.seekPosition;
    // 销毁播放器数据源
    [[XYAutoEditMgr sharedInstance].editorPlayerView destroySource];
    // 重新刷新播放器
    [[XYAutoEditMgr sharedInstance].editorPlayerView refreshWithConfig:^XYPlayerViewConfiguration *(XYPlayerViewConfiguration * config) {
        config = [XYPlayerViewConfiguration currentStoryboardSourceConfig];
        config.needRebuildStram = YES;
        config.seekPosition = seekPosition;
        return config;
    }];
}

///  替换源的视频和图片
/// @param idx 源对象idx
/// @param media 媒体资源对象
/// @param success 成功回调 主线程
/// @param failure 错误回调 主线程 code为-1时 不能再添加视频的源
- (void)replaceSourceIdx:(NSInteger)idx
                   media:(XYSlideShowMedia *)media
                 success:(void (^)(void))success
                 failure:(void(^)(NSError *error, NSInteger code))failure {
    NSArray *medias = [self fetchMedias];
    XYSlideShowSourceNode *sourceNode;
    if (idx < medias.count) {
       sourceNode = medias[idx];
    } else {
        if (failure) {
            failure([NSError errorWithDomain:@"com.sdk.engine" code:-2 userInfo:@{NSLocalizedDescriptionKey: @"idx 越界"}], -2);
        }
    }
    if (XYSlideShowMediaTypeVideo == media.mediaType) {
        if (![[XYAutoEditMgr sharedInstance] canInsertVideo:sourceNode]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"com.sdk.engine" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"can not insert Video"}], -1);
                }
            });
            return;
        }
    }
    NSInteger seekPosition = [XYAutoEditMgr sharedInstance].editorPlayerView.playerConfig.seekPosition;
    // 销毁播放器数据源
    [[XYAutoEditMgr sharedInstance].editorPlayerView destroySource];
    [[XYAutoEditMgr sharedInstance] updateVirtualSource:sourceNode sourceInfo:media];
    [[XYAutoEditMgr sharedInstance] refreshVirtualSourceInfo];
    [sourceNode updateTransformWithMedia:media];
    // 重新刷新播放器
    [[XYAutoEditMgr sharedInstance].editorPlayerView refreshWithConfig:^XYPlayerViewConfiguration *(XYPlayerViewConfiguration * config) {
        config = [XYPlayerViewConfiguration currentStoryboardSourceConfig];
        config.needRebuildStram = YES;
        config.seekPosition = seekPosition;
        return config;
    }];
}
        


/// 修改源的修剪范围
/// @param sourceNode 源对象
/// @param trimRange 修剪范围
- (void)updateSourceInfoNodeTrimRange:(XYSlideShowSourceNode *)sourceNode
                            trimRange:(XYVeRangeModel *)trimRange {
    
}

/// 更新源的缩放、移动、旋转、模糊、背景颜色等参数
/// @param sourceNode 对象
/// @param transform 缩放、移动、旋转、模糊、背景颜色等参数对象
- (void)updateSourcePanzoom:(XYSlideShowSourceNode *)sourceNode
                  transform:(XYSlideShowTransformModel *)transform {
    
}


@end
