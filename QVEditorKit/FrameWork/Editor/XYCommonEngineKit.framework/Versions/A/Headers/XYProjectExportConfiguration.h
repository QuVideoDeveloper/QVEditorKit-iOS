//
//  XYProjectExportConfiguration.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/14.
//

#import <Foundation/Foundation.h>

@class XYVe3DDataF;

typedef NS_ENUM(NSInteger, XYEngineResolution) {
    XYEngineResolution480 = 0,
    XYEngineResolution720,
    XYEngineResolution1080,
    XYEngineResolution4k,
};

@class XYVeRangeModel, XYStoryboard;

typedef NS_ENUM(NSInteger, XYProjectType) {
    XYProjectTypeNormal = 0,//普通的编辑工程
    XYProjectTypeSlideShow,//幻灯片
};

typedef NS_ENUM(NSInteger, XYProjectExportType) {
    XYProjectExportTypeVideo = 0,//导出视频
    XYProjectExportTypeGIF,//导出GIF
    XYProjectExportTypeWebp,//导出webp
    XYProjectExportTypeAudio,//导出音频

};

NS_ASSUME_NONNULL_BEGIN

@interface XYProjectExportConfiguration : NSObject

/// 导出类型 默认导出视频
@property (nonatomic, assign) XYProjectExportType exportType;

/// 工程的类型 默认是正常的编辑工程
@property (nonatomic, assign) XYProjectType projectType;

/// 导出的路径 需要创建文件夹及导出对应文件的后缀名，如导出mp4 格式是**/filename.mp4, 导出GIF 格式是**/filename.GIF
@property (nonatomic, copy) NSString *exportFilePath;

/// 导出分辨率类型
@property (nonatomic, assign) XYEngineResolution resolution;

/// 自定义的导出分辨率限制，使用自定义的话，expType就不重要了
@property (nonatomic, assign) CGSize customLimitSize;


/// 导出的视频的range 默认是全长 如导出GIF 需要设置trimRange
@property (nonatomic, strong) XYVeRangeModel *trimRange;

/// 导出视频填充背景颜色 默认是黑色 格式是 0x000000
@property (nonatomic, assign) NSInteger bgColor;

/// 水印显示的区域
@property (nonatomic, assign) CGRect watermarkDisplayRect;

/// 是否隐藏水印
@property (nonatomic, assign) BOOL hideWatermark;

/// 水印的样式 对应的水印样式模版的id
@property (nonatomic, assign) long long llWaterMarkID;

/// 导出的fps 默认30
@property (nonatomic, assign) NSInteger fps;

/// 昵称水印，为空不显示
@property (nonatomic, copy) NSString *nickNameWatermark;

/// 比特率系数；在原计算出来的BitRate基础上乘以该系数 值范围 [1, 10] 默认值为1
@property (nonatomic) CGFloat bitRate;

/// 用于提取音频
@property (nonatomic, strong) XYStoryboard *storyboard;

/// 导出时水印的尺寸
@property (nonatomic, strong) XYVe3DDataF *watermarkSize;

/// 导出时水印的中心点位置
@property (nonatomic, strong) XYVe3DDataF *watermarkCenter;

/// 是否开启恒定帧率
@property (nonatomic, assign) BOOL constRateEnable;

@end

NS_ASSUME_NONNULL_END
