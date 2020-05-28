//
//  XYVivaEditorThumbnailManager.h
//  XYVivaEditor
//
//  Created by 徐新元 on 2019/12/19.
//

#import <Foundation/Foundation.h>
@class XYClipThumbnailCompleteModel, XYClipThumbnailInputModel;


NS_ASSUME_NONNULL_BEGIN

@interface XYClipThumbnailManager : NSObject


/// 根据ClipIdentifier请求缩略图
/// @param clipIdentifier Clip的ID
/// @param inputBlock 在inputBlock中修改inputModel的对外参数
/// @param completeBlock 取缩略图完成回调
/// @param placeholderBlock 占位图回调（暂时没用）
- (void)thumbnailWithClipIdentifier:(NSString *)clipIdentifier
                         inputBlock:(void (^)(XYClipThumbnailInputModel *inputModel))inputBlock
                      completeBlock:(void (^)(XYClipThumbnailCompleteModel *completeModel))completeBlock
                   placeholderBlock:(void (^)(XYClipThumbnailCompleteModel *completeModel))placeholderBlock;

/// 根据ClipIdentifier请求缩略图
/// @param clipIdentifier Clip的ID
/// @param isTempWorkSpace 是否临时Storyboard
/// @param inputBlock 在inputBlock中修改inputModel的对外参数
/// @param completeBlock 取缩略图完成回调
/// @param placeholderBlock 占位图回调（暂时没用）
- (void)thumbnailWithClipIdentifier:(NSString *)clipIdentifier
                    isTempWorkSpace:(BOOL)isTempWorkSpace
                         inputBlock:(void (^)(XYClipThumbnailInputModel *inputModel))inputBlock
                      completeBlock:(void (^)(XYClipThumbnailCompleteModel *completeModel))completeBlock
                   placeholderBlock:(void (^)(XYClipThumbnailCompleteModel *completeModel))placeholderBlock;

/// 根据EffectIdentifier请求缩略图（只支持画中画Effect）
/// @param effectIdentifier Effect的ID
/// @param inputBlock 在inputBlock中修改inputModel的对外参数
/// @param completeBlock 取缩略图完成回调
/// @param placeholderBlock 占位图回调（暂时没用）
- (void)thumbnailWithEffectIdentifier:(NSString *)effectIdentifier
                           inputBlock:(void (^)(XYClipThumbnailInputModel *inputModel))inputBlock
                        completeBlock:(void (^)(XYClipThumbnailCompleteModel *completeModel))completeBlock
                     placeholderBlock:(void (^)(XYClipThumbnailCompleteModel *completeModel))placeholderBlock;


/// 清除内存缓存
- (void)cleanMemoryCache;

/// 清除磁盘缓存
/// @param completeBlock 清除完成后的回调
- (void)cleanDiskCache:(void (^)(void))completeBlock;


/// 监听正式工程相关变化
- (void)addRealTaskObserver;

/// 监听临时工程相关变化
- (void)addTempTaskObserver;

/// 销毁
- (void)destroyThumbnailManager;

- (void)rebuildThumbnailManagerWithEffectIdentifier:(NSString *)effectIdentifier;

@end

NS_ASSUME_NONNULL_END
