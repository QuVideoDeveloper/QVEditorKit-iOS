//
//  XYSlideShowEditor.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/30.
//

#import <Foundation/Foundation.h>

@class XYSlideShowConfiguration, XYSlideShowMedia, XYSlideShowClipMgr, XYSlideShowEffectMgr;

NS_ASSUME_NONNULL_BEGIN

@interface XYSlideShowEditor : NSObject

@property (nonatomic, strong) CXiaoYingSlideShowSession * _Nullable slideShowSession;
@property (nonatomic, strong) XYSlideShowClipMgr * _Nullable clipMgr;
@property (nonatomic, strong) XYSlideShowEffectMgr * _Nullable effctMgr;

+ (XYSlideShowEditor *)sharedInstance;

/// 初始化slideShow
/// @param config 初始化配置
- (void)initializeWithConfig:(XYSlideShowConfiguration *)config;

/// 根据主题及媒体资源创建工程
/// @param themeId 主题id
/// @param medias 媒体资源对象
/// @param complete 结束回调 主线程
- (void)createProjectWithThemeId:(UInt64)themeId
                          medias:(NSArray <XYSlideShowMedia *> *)medias
                         complete:(void (^)(BOOL success))complete;

/// 保存工程
/// @param projectFilePath 保存工程的路径
/// @param success 成功的回调 在主线程回调
/// @param failure 失败的回调 在主线程回调
- (void)saveProject:(NSString *)projectFilePath
            success:(void(^)(void))success
            failure:(void(^)(NSError *error))failure;

/// 加载草稿的工程
/// @param projectFilePath 工程路径
/// @param success 成功的回调 在主线程回调
/// @param failure 失败的回调 在主线程回调
- (void)loadProject:(NSString *)projectFilePath
            success:(void(^)(void))success
            failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
