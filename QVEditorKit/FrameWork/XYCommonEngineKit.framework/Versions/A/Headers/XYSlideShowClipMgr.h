//
//  XYSlideShowSourceInfoMgr.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/30.
//

#import <Foundation/Foundation.h>

@class XYSlideShowMedia, XYSlideShowSourceNode, XYVeRangeModel, XYSlideShowTransformModel, XYSlideShowThemeTextScene, XYSlideShowSourceNodeScene;

NS_ASSUME_NONNULL_BEGIN

@interface XYSlideShowClipMgr : NSObject

/// 获取工程场景数量
- (NSInteger)fetchSceneCount;


/// 获取原始的图片视频媒体列表
- (NSArray <XYSlideShowMedia *> *)fetchMedias;

/// 获取所有源的列表
- (NSArray<XYSlideShowSourceNode *> *)fetchSlideShowSourceNodes;

/// 获取工程场景Node信息
- (NSArray<XYSlideShowSourceNodeScene *> *)fetchSlideShowSourceNodeScenes;

/// 交换源
/// @param srcIndex 起始index
/// @param dstIndex 目标index
- (void)moveSource:(UInt32)srcIndex dstIndex:(UInt32)dstIndex;

///  替换源的视频和图片
/// @param sourceNode 源对象sourceNode
/// @param media 媒体资源对象
/// @param success 成功回调 主线程
/// @param failure 错误回调 主线程 code为-1时 不能再添加视频的源
- (void)replaceSourceWithSourceNode:(XYSlideShowSourceNode *)sourceNode
                   media:(XYSlideShowMedia *)media
                 success:(void (^)(void))success
                 failure:(void(^)(NSError *error, NSInteger code))failure;

/// 更新源的缩放、移动、旋转、模糊、背景颜色等参数
/// @param sourceNode 对象
- (void)updateSourcePanzoom:(XYSlideShowSourceNode *)sourceNode;

@end

NS_ASSUME_NONNULL_END
