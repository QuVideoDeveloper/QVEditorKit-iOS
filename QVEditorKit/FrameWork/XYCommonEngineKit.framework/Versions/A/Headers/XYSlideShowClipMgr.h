//
//  XYSlideShowSourceInfoMgr.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/30.
//

#import <Foundation/Foundation.h>
#import "XYCommonEngineDefileHeader.h"

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
/// @param sourceNodeIdx 源对象 Idx
/// @param media 媒体资源对象
/// @param success 成功回调 主线程
/// @param failure 错误回调 主线程 code为-1时 不能再添加视频的源
- (void)replaceSourceWithSourceNode:(NSInteger)sourceNodeIdx
                   media:(XYSlideShowMedia *)media
                 success:(void (^)(void))success
                 failure:(void(^)(NSError *error, NSInteger code))failure;

/// 更新源的缩放、移动、旋转、模糊、背景颜色等参数
/// @param sourceNode 对象
- (void)updateSourcePanzoom:(XYSlideShowSourceNode *)sourceNode;

/// 更新扣像mask 如果需要支持panzoom 需要设置mask 引擎默认扣像是AMVE_PROP_CLIP_RESET_SEG_MASK 不支持移动缩放等
/// @param mask mask
/// @param clipIdx clipIdx
- (void)updateMask:(XYMBITMAP)mask clipIdx:(NSInteger)clipIdx;

/// 删除外部设置的涂抹后的mask,恢复自动抠像
/// @param clipIdx clipIdx
- (void)resetMaskWithClipIdx:(NSInteger)clipIdx;

@end

NS_ASSUME_NONNULL_END
