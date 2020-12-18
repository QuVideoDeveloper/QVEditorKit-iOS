//
//  QVEditor.h
//  QVEditor
//
//  Created by 夏澄 on 2020/4/23.
//

#import <Foundation/Foundation.h>
#import <XYCommonEngineKit/XYCommonEngineKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface QVEditorConfiguration : NSObject

/// 证书路径
@property (nonatomic, copy) NSString *licensePath;

///人体扣像文件路径
@property (nonatomic, copy) NSString *portraitModelPath;

/// clip错误时显示图片的地址。如相册的图片被删除或者上传到iCloud等
@property (nonatomic, copy) NSString *corruptImgPath;

/// 默认素材的版本 如果有升级素材 需要修改版好 加1往上升即可 默认值是1
@property (nonatomic, assign) NSInteger defaultTemplateVersion;

/// 默认素材文件夹路径
@property (nonatomic, copy) NSString *defaultTemplateFilePath;

/// 是否末尾补黑帧,默认false（详解【高级玩法-自由黑帧模式】一章说明）
@property (nonatomic, assign) BOOL isUseStuffClip;

/// 是否开启引擎日志写入到本地 默认关闭
@property (nonatomic, assign) BOOL isSaveLog;

/// 是否开启metal 默认关闭
@property (nonatomic, assign) BOOL metalEnable;

/// 输出终端输出日志等级
@property (nonatomic, assign) XYMonLogLevelType logLevel;

/// 是否开启Benchlog的输出 默认不开启
@property (nonatomic, assign) BOOL isPrintBenchlog;

/// 播放器分辨率的宽 输出会基于宽根据比例计算出高 默认值 640
@property (nonatomic, assign) NSInteger outputResolutionWidth;

/// 是否开启抗锯齿
@property (nonatomic, assign) BOOL openAntiJagged;

/// 分割精度
@property (nonatomic, assign) XYSegPrecisionMode segPrecisionMode;

@end

@interface QVEditor : NSObject

+ (void)initializeWithConfig:(QVEditorConfiguration *)config delegate:(id <QVEngineDataSourceProtocol>)delegate;

+ (NSString *)getCatchLog;

@end

NS_ASSUME_NONNULL_END
