# QVEditorKit

[![CI Status](https://img.shields.io/travis/Sunshine/QVEditorKit.svg?style=flat)](https://travis-ci.org/Sunshine/QVEditorKit)
[![Version](https://img.shields.io/cocoapods/v/QVEditorKit.svg?style=flat)](https://cocoapods.org/pods/QVEditorKit)
[![License](https://img.shields.io/cocoapods/l/QVEditorKit.svg?style=flat)](https://cocoapods.org/pods/QVEditorKit)
[![Platform](https://img.shields.io/cocoapods/p/QVEditorKit.svg?style=flat)](https://cocoapods.org/pods/QVEditorKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

QVEditorKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'QVEditorKit'
```
## 开发指南

1.新建工程(如已经有工程无需新建)
(a)选择File->New->Project来新建工程
(b)在工程类型界面选择适合的工程类型，点击“Next”
(c)输入工程名，点击“Next”
(d)输入工程路径，点击”Create“
![Alt text](./1591065544786.jpg)

2.禁用Bitcode
(a)在工程设置界面，选择“Build Settings”。
(b)在搜索框输入“bitcode”。
(c)在“Enable Bitcode”选项卡中选择“No”
![Alt text](./1591065749093.png)
3.添加SDK
Podfile 文件中添加后执行pod update
pod 'QVEditorKit'
## 开发引导
### 1 概述

SDK致力于解决移动端视频开发的技术门槛，使仅有iOS界面开发经验的程序员，都可以开发出性能优异、渲染效果丰富的的视频录制、编辑功能。

####  1.1 支持格式
* 输入规范：

视频格式：MP4、MOV、WMV
音频格式：MP3、AAC、M4A
图片格式：JPG、PNG
视频编码：H264、WMV、MPEG4
音频编码：MP3、AAC
* 输出规范：

视频格式：MP4、MOV
视频编码：H264
音频编码：AAC

####  1.2 运行环境
运行环境如下：iOS 9.0以上

####  1.3  前期准备
1. 向小影对接人申请license
2. 申请最新版本的小影编辑sdk。

### 2 使用说明
#### 2.1 初始化
2.1.1  QVEditor类
QVEditor是趣维SDK的初始化类。 
QVEditor初始化代码如下：
```
//editor sdk 初始化
    QVEditorConfiguration *editorConfig = [[QVEditorConfiguration alloc] init];
    editorConfig.licensePath = [[NSBundle mainBundle] pathForResource:@"license" ofType:@"txt"];
    editorConfig.corruptImgPath = [[NSBundle mainBundle] pathForResource:@"vivavideo_default_corrupt_image" ofType:@"png"];
```
2.1.2 QVEditorConfiguration类
QVEditorConfiguration是初始化配置参数类
| 名称  | 解释 | 类型 | 是否必须 |
| :-: | :-: | :-: | :-: |
| licensePath  | 证书路径 | String | 是 |
| corruptImgPath  | clip错误时显示图片的地址。如相册的图片被删除或者上传到iCloud等 | NSString | 是 |

2.1.3 QVEngineDataSourceProtocol协议
QVEngineDataSourceProtocol 提供用户实现设置国家码、语言代码、及主题的字幕的转译。
代码如下:
```
/// 可选参数 默认获取系统的国家码
- (NSString *)countryCode {
    return @"CN";
}

/// 可选参数 默认获取系统的语言编码
- (NSString *)languageCode {
    return @"zh-Hans";
}

/// 主题的字幕的转译
/// @param textPrepareMode 根据textPrepareMode类型设置参数
- (QVTextPrepareModel *)textPrepare:(QVTextPrepareMode)textPrepareMode {
    QVTextPrepareModel *textModel = [QVTextPrepareModel new];
    if (QVTextPrepareModeLocation == textPrepareMode) {
         textModel.location = @"location";
    }
    return textModel;
}
```
2.2 工程管理接口
2.2.1 创建工程
代码如下：
```
 XYQprojectModel *newProject = [[XYQprojectModel alloc] init];
 newProject.taskID = XYCommonEngineTaskIDQProjectCreate;
 [[XYEngineWorkspace projectMgr] runTask:newProject];
```
2.2.2 加载已保存的工程
代码如下：
```
 XYQprojectModel *newProject = [[XYQprojectModel alloc] init];
 newProject.prjFilePath = @"draftProjectFilePath"//保存工程的路径
 newProject.taskID = XYCommonEngineTaskIDQProjectLoadProject;
 [[XYEngineWorkspace projectMgr] runTask:newProject];
```
2.2.3 保存工程
代码如下：
```
 XYQprojectModel *newProject = [[XYQprojectModel alloc] init];
  newProject.prjFilePath = @"draftProjectFilePath"//保存工程的路径
 newProject.taskID = XYCommonEngineTaskIDQProjectSaveProject;
 [[XYEngineWorkspace projectMgr] runTask:newProject];
```
2.2.3 删除已保存的工程
代码如下：
```
 [[NSFileManager defaultManager] removeItemAtPath:prjFilePath error:nil]
```
2.3 播放器 
XYPlayerView类
用于播放预览剪辑后的视频
2.3.1 初始化代码：
```
XYPlayerView *editorPlayerView = [[XYPlayerView alloc] initWithFrame:CGRectMake(0, 0, wdith, height)];
 [editorPlayerView addPlayDelegate:self];//设置播放器回调的代理
 editorPlayerView.backgroundColor = [UIColor blackColor];
 [self addSubview:editorPlayerView];
[editorPlayerView initializeWithConfig:^XYPlayerViewConfiguration *(XYPlayerViewConfiguration *config) {
        config = [XYPlayerViewConfiguration currentStoryboardSourceConfig];
        config.videoRatio = [XYEngineWorkspace stordboardMgr].currentStbModel.ratioValue;
        return config;
    }];
```
2.3.2 播放回调
代码如下：
```
#pragma mark - 播放器的回调
- (void)playbackStateCallBack:(XYPlayerCallBackData *)playbackData {
    if ((playbackData.state == XYPlayerStatePaused
    || playbackData.state == XYPlayerStateStopped)) {
        //暂停 和 停止
    }
    NSInteger seekPos = playbackData.position;//当前的播放时间点

}
```
2.3.3 暂停播放
代码如下：
```
[]editorPlayerView pause]
```
2.3.4 播放
代码如下：
```
[]editorPlayerView play]
```
2.3.5 seek操作
代码如下：
```
 NSInteger pos = 1000;
 [editorPlayerView seekToPosition:pos async:NO];
```

2.3.6 设置播放时间段
代码如下：

```
    XYVeRangeModel *range = [XYVeRangeModel VeRangeModelWithPosition:0 length:1000];
    [editorPlayerView setPlaybackRange:range];
```

2.3.7 判断是否在播放
具体代码：
```
 BOOL isPlaying = [editorPlayerView isPlaying]
```

2.3.8 监听播放回调
具体代码：
```
 [editorPlayerView addPlayDelegate:self];//设置播放器回调的代理
```

2.3.9  移除监听播放回调
具体代码：
```
[editorPlayerView removePlayDelegate:self]//移除监听播放回调
```
2.4 Clip剪辑功能接口
2.4.1 添加片段
具体代码：

```
__block NSMutableArray <XYClipModel *> *clipArr = [[NSMutableArray alloc] initWithCapacity:mediaList.count];
    [mediaList enumerateObjectsUsingBlock:^(XYAlbumMediaItem * _Nonnull mediaItem, NSUInteger idx, BOOL * _Nonnull stop) {
        XYClipModel *clipModel = [[XYClipModel alloc] init];
        clipModel.sourceVeRange.dwPos = mediaItem.startPoint;
        clipModel.sourceVeRange.dwLen = mediaItem.endPoint - mediaItem.startPoint;
        clipModel.clipFilePath = mediaItem.filePath;
        clipModel.rotation = [mediaItem angleDegreeFormOrientation:mediaItem.orientation];
        clipModel.clipIndex = idx;
        [clipArr addObject:clipModel];
    }];
    XYClipModel *taskModel = [[XYClipModel alloc] init];
    taskModel.taskID = XYCommonEngineTaskIDClipAddClip;
    taskModel.clipModels = clipArr;
    [[XYEngineWorkspace clipMgr] runTask:taskModel];
}
```
XYClipModel参数说明：
 | 名称 | 解释 | 类型 | 是否必须 |
  | :-: | :-: | :-: | :-: | 
  | clipFilePath | 文件地址 | String | 必须 | 
  | sourceVeRange |源的长度 | XYVeRangeModel | 非必须 | 
  | trimVeRange | 切入点 | XYVeRangeModel | 非必须 | 
  | cropRect | 裁切区域 | CGRect | 非必须 | 
  | rotation | 旋转角度 | int | 非必须 |
  | filterFilePath | 滤镜 | String | 非必须 |


## Author

Sunshine, cheng.xia@quvideo.com

## License

QVEditorKit is available under the MIT license. See the LICENSE file for more info.
