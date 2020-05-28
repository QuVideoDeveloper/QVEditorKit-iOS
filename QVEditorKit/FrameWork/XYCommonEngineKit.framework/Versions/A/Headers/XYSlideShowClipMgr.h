//
//  XYSlideShowSourceInfoMgr.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/30.
//

#import <Foundation/Foundation.h>

@class XYSlideShowMedia, XYSlideShowSourceNode, XYVeRangeModel, XYSlideShowTransformModel;

NS_ASSUME_NONNULL_BEGIN

@interface XYSlideShowClipMgr : NSObject

/// 获取原始的图片视频媒体列表
- (NSArray <XYSlideShowMedia *> *)fetchMedias;

/// 获取所有源的列表
- (NSArray<XYSlideShowSourceNode *> *)fetchSlideShowSourceNodes;

/// 交换源
/// @param srcIndex 起始index
/// @param dstIndex 目标index
- (void)moveSource:(UInt32)srcIndex dstIndex:(UInt32)dstIndex;

/// 替换源的视频和图片
/// @param sourceNode 源对象
/// @param media 媒体资源对象

///  替换源的视频和图片
/// @param sourceNode 源对象
/// @param media 媒体资源对象
/// @param success 成功回调 主线程
/// @param failure 错误回调 主线程 code为-1时 不能再添加视频的源
- (void)replaceSource:(XYSlideShowSourceNode *)sourceNode
                media:(XYSlideShowMedia *)media
              success:(void (^)(void))success
              failure:(void(^)(NSError *error, NSInteger code))failure;

@end

NS_ASSUME_NONNULL_END
