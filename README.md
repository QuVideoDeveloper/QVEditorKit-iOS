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
Podfile 文件中加上：
inhibit_all_warnings!
pod 'QVEditorKit'
pod 'SSZipArchive'
pod 'YYImage/WebP'
pod 'PromisesObjC'

```
## 小影 iOS 剪辑SDK 接入文档
### 一、名词解释
1. 工程：分为剪辑工程（XYEngineWorkspace）和卡点视频工程（XYSlideShowEditor），后续统称workspace。其中小影提供的所有剪辑玩法，都是针对剪辑工程进行的操作。卡点视频即使用素材一键生成大片，目前仅支持片段替换和片段排序。
2. 播放流：每个工程会独立的播放流，将播放器View和工程绑定后，即可完成视频流的显示。同时可以对工程的播放器做相关操作。
3. 主题：theme，一系列效果的合集，包括片头、片尾、转场、音乐、滤镜等。对工程设置主题，可以实现模板视频功能。
4. 片段：Clip，片段可以是图片或视频，是工程的基础组成部分。工程将按片段顺序生成一段视频。
5. 转场：Transition, 转场效果是设定在两个片段之间的，是两个片段的切换效果。
6. 滤镜/特效滤镜：Filter/FxFilter，是添加给单个片段的，覆盖整个片段，可以实现调色滤镜、边框滤镜、特效滤镜等。
7. 效果：Effect，贴纸、画中画、字幕、特效、马赛克，都属于效果，是直接在工程上增加的效果。水印也是一种特殊的效果。
8. 图层：Layer，Clip都在同一个图层中，效果和音频可以设置自己的图层，图层的层级大小将影响工程视频的实际效果。详情可以参考【基础结构和概念】中的【图层轨道】一节。
9. 音频：Audio，音频也是一种特殊的效果。分为背景音乐、音效和录音。背景音乐都在同一图层中，即一个时间点不可同时存在多个音频；音效和录音则可以单独设置图层，即一个时间点可以同时存在多个音频。
10. 源文件区间：sourceVeRange，片段中表示加入片段源文件的起始点和长度，效果中表示效果裁剪的起始点和长度。详情可以参考【基础结构和概念】中的【Range相关】一节。
11. 裁剪区间：trimVeRange，裁剪片段的起始点和长度。详情可以参考【基础结构和概念】中的【Range相关】一节。
12. 出入区间：destVeRange，效果在工程上的起始点和长度。详情可以参考【基础结构和概念】中的【Range相关】一节。
13. 导出：Export，将工程以指定分辨率、码率、帧速率和压缩格式输出文件。
14. 码率：Bitrate，每秒传送的比特数，码率越高，导出视频质量越好。
15. 帧速率：FPS，每秒刷新图像的帧数，帧速率越高，视频的连续性越好。
16. 素材包：一种资源文件，用于给工程添加效果使用。特地效果有特地的素材包，主题和卡点视频主题也都有素材包。详情可以参考【素材管理】一节。
17. 素材包ID：素材包的唯一标识，安装素材后，可以通过解析素材获取。详情可以参考【素材管理】一节。


### 二、基础结构与概念
####  1. 支持格式
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

#### 2. 模块结构
剪辑SDK核心模块包括剪辑工程、片段、音频、效果、播放器等。

剪辑工程是SDK中最基础的模块，它负责生成、保存并维护SDK引擎剪辑的上下文环境。片段是工程的基础，是导出视频的组成元素。效果包括贴纸、画中画、字幕、特效、水印、马赛克等，各种效果、音频和片段共同组合形成最终的视频输出。片段上可以添加各种滤镜，片段之间可以设置不同的转场效果。
<img src="https://github.com/QuVideoDeveloper/QVEditor-Android/blob/master/IMG/image_module.png" width="631" height="655" align="center">

#### 3. 图层轨道
效果和音频可以在指定区间设置自己的图层（水印和背景音乐除外），高图层的效果可以对低图层的效果起作用或遮挡低图层效果。当两个效果在同一图层时，如果出入点时间不覆盖，则不互相影响；如果出入点时间覆盖，则覆盖时间区间的效果将无法预期。所以尽量给每个效果设定独立的图层，以免最终视频效果不符合预期。

图层限制区间：
音效/录音图层：[10,10000)，左边闭区间，右边开区间。
效果图层：[10000,1000000)，左边闭区间，右边开区间。(贴纸、字幕、画中画、特效、马赛克)

例：
1）贴纸1在图层100000，贴纸2在图层90000，如果贴纸1和贴纸2的位置和时间相同时，则贴纸1会遮挡贴纸2。
2）特效1在图层100000，贴纸1在图层90000，贴纸2在图层110000，如果特效1、贴纸1和贴纸2的时间相同，则特效对贴纸1产生影响，不对贴纸2产生影响。

#### 4. 区间Range相关：
srcRange:：源文件区间，视频源文件选择的时间区间。
trimRange：裁剪区间，裁剪片段的起始点和长度。
destRange：出入区间，效果在工程上的起始点和长度。
<img src="https://github.com/QuVideoDeveloper/QVEditor-Android/blob/master/IMG/image_range.png" width="637" height="441" align="center">

#### 5. 坐标系：
剪辑中使用的坐标系，统一使用视频流(stream)的坐标系，即视频流的左上角为（0, 0），右下角为（stream.width，stream.height）。角度水平向右为0度，顺时针为增大。


<img src="https://github.com/QuVideoDeveloper/QVEditor-Android/blob/master/IMG/image_xyz.png" width="574" height="542" align="center">

####  2 运行环境
运行环境如下：iOS 9.0以上

####  3  前期准备
1. 向小影对接人申请license
2. 申请最新版本的小影编辑sdk。

### 三、项目搭建
 
####  1.新建工程(如已经有工程无需新建)
(a)选择File->New->Project来新建工程
(b)在工程类型界面选择适合的工程类型，点击“Next”
(c)输入工程名，点击“Next”
(d)输入工程路径，点击”Create“

<img src="https://github.com/QuVideoDeveloper/QVEditorKit-iOS/blob/master/IMG/112.png" width="768" height="418" align="center">

#### 2.禁用Bitcode
(a)在工程设置界面，选择“Build Settings”。
(b)在搜索框输入“bitcode”。
(c)在“Enable Bitcode”选项卡中选择“No”
<img src="https://github.com/QuVideoDeveloper/QVEditorKit-iOS/blob/master/IMG/EnableBitcode_ios.png" width="400" height="132" align="center">

3.添加SDK

Podfile 文件中添加 pod 'QVEditorKit'

后执行pod update


#### 3. 剪辑SDK初始化
QVEditor是趣维SDK的初始化类。 
QVEditor初始化代码如下：
```
//editor sdk 初始化
     QVEditorConfiguration *editorConfig = [[QVEditorConfiguration alloc] init];
    editorConfig.licensePath = [[NSBundle mainBundle] pathForResource:@"license" ofType:@"txt"];
        editorConfig.defaultTemplateVersion = 1;//默认是1 如果有升级默认素材 往上升级
    editorConfig.corruptImgPath = [[NSBundle mainBundle] pathForResource:@"vivavideo_default_corrupt_image" ofType:@"png"];
    [QVEditor initializeWithConfig:editorConfig delegate:self];
```
2.1.2 QVEditorConfiguration类
QVEditorConfiguration是初始化配置参数类
| 名称  | 解释 | 类型 | 是否必须 |
| :-: | :-: | :-: | :-: |
| licensePath  | 证书路径 | NSString | 是 |
| corruptImgPath  | clip错误时显示图片的地址。如相册的图片被删除或者上传到iCloud等 | NSString | 是 |
| isUseStuffClip  | 是否末尾补黑帧,默认false（详解【高级玩法-自由黑帧模式】一章说明） | BOOL | 非 |
| defaultTemplateVersion  | 默认素材的版本 如果有升级素材 需要修改版好 加1往上升即可 默认值是1| NSInteger | 非 |

2.1.3 QVEngineDataSourceProtocol协议
QVEngineDataSourceProtocol 提供用户实现设置语言代码、及主题的字幕的转译。
代码如下:
```
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

### 四、素材管理开发接入
#### 1. 素材安装
* 默认的本地素材和引擎的模板安装

1.在工程目录下建立private实际目录文件夹的名字一定要是private这个名字

2.引擎的模板放在Engine目录下 此目录可自定义

3.将默认的本地素材放在DefaultTemplate目录下 此目录可自定义

结构如下图：
<img src="https://github.com/QuVideoDeveloper/QVEditorKit-iOS/blob/master/IMG/3.png" width="768" height="418" align="center">


```
/** 安装单个素材文件 */
 [[XYTemplateDataMgr sharedInstance] install:strTemplateFile];
```

#### 2. 素材信息查询
```
/**
* 通过素材id查询素材信息
*/
XYTemplateItemData *itemData = [[XYTemplateDataMgr sharedInstance] getByID:ttId]
/**
* 通过素材路径查询素材信息
*/
XYTemplateItemData *itemData = [[XYTemplateDataMgr sharedInstance] getByPath:xytPath]
```

XYTemplateItemData参数说明：

| 名称  | 解释 | 类型 |
| :-: | :-: | :-: |
| lID | 素材id| NSInteger |
| strPath | 素材路径 | NSString |
| strTitle | 素材名称 | NSString |

### 五、剪辑功能开发接入

* taskID 操作id说明
1. taskID是每个操作的唯一id
2.  与runTask配套使用  每次runTask都需要传是什么操作，如添加主题
```
// themePath表示主题素材路径
	 XYStoryboardModel *sbModel = [XYEngineWorkspace stordboardMgr].currentStbModel;
     sbModel.taskID = XYCommonEngineTaskIDStoryboardAddTheme;
     sbModel.themePath = themePath;
     [[XYEngineWorkspace stordboardMgr] runTask:sbModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {
    }];
```

效果分类groupId说明

```
typedef NS_ENUM(MDWord, XYCommonEngineGroupID) {
    XYCommonEngineGroupIDBgmMusic = GROUP_ID_BGMUSIC,//背景音乐分类
    XYCommonEngineGroupIDDubbing = GROUP_ID_DUBBING,//音效分类
    XYCommonEngineGroupIDRecord = GROUP_ID_RECORD,//录音分类
    XYCommonEngineGroupIDSticker = GROUP_STICKER,//贴纸
    XYCommonEngineGroupIDMosaic = GROUP_ID_MOSAIC,//马赛克
    XYCommonEngineGroupIDWatermark = GROUP_ID_WATERMARK,//水印
    XYCommonEngineGroupIDText = GROUP_TEXT_FRAME,//字幕
    XYCommonEngineGroupIDCollage = GROUP_ID_COLLAGE,//画中画
    XYCommonEngineGroupIDAnimatedFrame = GROUP_ANIMATED_FRAME,//特效 全屏的特效。
    XYCommonEngineGroupIDColorFilter = GROUP_IMAGING_EFFECT,//调色滤镜
    XYCommonEngineGroupIDThemeFilter = GROUP_ID_THEME_FILTER,//主题滤镜group
    XYCommonEngineGroupIDFXFilter = GROUP_ID_FX_FILTER,//特效滤镜。
};

```
#### 1. 剪辑工程
##### 创建、保存和加载工程
###### 加在工程如果失败 需要处理错误吗 error.code
错误码说明
```
typedef NS_ENUM(UInt64,  XYTaskLoadProjectErrorCode) {

    /// 素材丢失
    
    XYTaskLoadProjectStateTemplateMissing = QVET_ERR_COMMON_TEMPLATE_MISSING;
    
    /// 镜头源文件丢失
    
    XYTaskLoadProjectStateClipFileMissing = QVET_ERR_COMMON_PRJLOAD_CLIPFILE_MISSING;

};
```
```
  /**
   * 创建新的工程
   */
 XYQprojectModel *newProject = [[XYQprojectModel alloc] init];
 newProject.taskID = XYCommonEngineTaskIDQProjectCreate;
 [[XYEngineWorkspace projectMgr] runTask:newProject completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {
    }];
 /**
   * 加载工程
   */
   XYQprojectModel *newProject = [[XYQprojectModel alloc] init];
 newProject.prjFilePath = @"draftProjectFilePath"//保存工程的路径
 newProject.taskID = XYCommonEngineTaskIDQProjectLoadProject;
 [[XYEngineWorkspace projectMgr] runTask:newProject completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {
    }];

 /**
   * 保存工程
   */
   XYQprojectModel *newProject = [[XYQprojectModel alloc] init];
 newProject.prjFilePath = @"draftProjectFilePath"//保存工程的路径
 newProject.taskID = XYCommonEngineTaskIDQProjectSaveProject;
 [[XYEngineWorkspace projectMgr] runTask:newProject completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {
    }];
```

##### 工程删除
方式一:
```
  /**
   * 删除工程
   */
            XYQprojectModel *project = [[XYQprojectModel alloc] init];
            project.prjFilePath = projectFilePath;
            project.taskID = XYCommonEngineTaskIDQProjectRemoveProject;
            [[XYEngineWorkspace projectMgr] runTask:project];
```


#### 2. 播放器
 播放器 
XYPlayerView类
用于播放预览剪辑后的视频
其中有属性streamSize 如下：
```
@interface XYPlayerView : UIView
@property (nonatomic, assign) CGSize streamSize;

```
这个streamSize是播放器中引擎内容真正渲染的区域，引擎的坐标都相对于这个区域来计算，这个区域的位置是相对于XYPlayerView的位置居中的，如计算区域手势可通过这里转换得到，图层结构如图所示：蓝色边框区域为引擎渲染区域，灰色边框区域为XYPlayerView区域，其中擎渲染蓝色区域相对XYPlayerView灰色边框居中

<img src="https://github.com/QuVideoDeveloper/QVEditorKit-iOS/blob/master/IMG/55.png" width="562" height="794" align="center">

1）在工程加载成功后，可以绑定工程和播放器
代码如下：
```
XYPlayerView *editorPlayerView = [[XYPlayerView alloc] initWithFrame:CGRectMake(0, 0, wdith, height)];
 [editorPlayerView addPlayDelegate:self];//设置播放器回调的代理
 editorPlayerView.backgroundColor = [UIColor blackColor];
 [appView addSubview:editorPlayerView];
[editorPlayerView refreshWithConfig:^XYPlayerViewConfiguration *(XYPlayerViewConfiguration *config) {
        config = [XYPlayerViewConfiguration currentStoryboardSourceConfig];
        config.playViewSize = playSize;
        return config;
    }];
```
2）播放回调
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
3）暂停播放
代码如下：
```
[]editorPlayerView pause]
```
4）播放
代码如下：
```
[]editorPlayerView play]
```
5） seek操作
代码如下：
```
 NSInteger pos = 1000;
 [editorPlayerView seekToPosition:pos async:NO];
```

6）设置播放时间区域
代码如下：

```
    XYVeRangeModel *range = [XYVeRangeModel VeRangeModelWithPosition:0 length:1000];
    [editorPlayerView setPlaybackRange:range];
```

7）获取播放时间区域
```
    [editorPlayerView getPlaybackRange];
```
8）判断是否在播放
具体代码：
```
 BOOL isPlaying = [editorPlayerView isPlaying]
```
9）获取播放的真实区域大小
具体代码：
```
editorPlayerView.playStreamBounds
```
10）设置播放器声音
具体代码：
```
[]editorPlayerView setVolume:1];
```
11  监听播放回调
具体代码：
```
 [editorPlayerView addPlayDelegate:self];//设置播放器回调的代理
```

12）移除监听播放回调
具体代码：
```
[editorPlayerView removePlayDelegate:self]//移除监听播放回调
```
13) 销毁播放器
```
/// 销毁
- (void)destroySource;
```
##### 3. 获取工程相关信息

```
@interface XYClipOperationMgr : XYOperationMgrBase

/** 获取所有clip信息 */
@property (nonatomic, copy) NSArray <XYClipModel *> *clipModels

  /** 通过当前时间，获取Clip */ 
- (XYClipModel *)fetchClipModelWithPosition:(NSInteger)position;
```

XYEffectOperationMgr信息:
```
@interface XYEffectOperationMgr : XYOperationMgrBase

/** 获取所有效果的信息 */
@property (nonatomic, copy) NSArray <XYEffectModel *> *allEffects;

/** 根据groupID 获取效果列表 */ 
- (NSArray <XYEffectModel *> *)effectModels:(XYCommonEngineGroupID)groupType;//根据groupID 获取效果列表

/** 根据时间和位置来获取效果 */ 
- (XYEffectModel *)fetchEffectModelOnTopByTouchPoint:(CGPoint)touchPoint seekPosition:(NSInteger)seekPosition;
 
```

##### 数据结构说明
1) 片段Clip相关

XYClipModel参数说明：

| 名称 | 解释 | 类型 |
| :-: | :-: | :-: |
| identifier | clip的唯一识别码 | NSString |
| clipType | 类型{@see XYCommonEngineClipModuleType}  | XYCommonEngineClipModuleType |
| clipFilePath | 片段文件路径 | NSString |
| sourceVeRange | 源文件区间 | XYVeRangeModel |
| trimRange | 片段裁切区间 | XYVeRangeModel |
| destRange | 片段出入区间 | XYVeRangeModel |
| cropRect | 裁剪区域 | CGRect |
| sourceSize | 源视频宽高，相对streamSize的尺寸 | CGSize |
| rotation | 旋转角度 | NSInteger |
| isMute | 是否静音 | BOOL |
| volumeValue | 音量，默认100 范围 0- 200 | CGFloat |
| voiceChangeValue | 变声，-60~60，正常0。{@see XYDftSoundTone}类中有提供的特定音调 | CGFloat |
| speedValue | 变速值，默认1.0f，设置变速时，也会对音调产生影响 | CGFloat |
| iskeepTone | 是否保持原声调 | BOOL |
| mirrorMode | 镜像{@see XYClipMirrorMode} | XYClipMirrorMode |
| isReversed | 是否倒放 | BOOL |
| clipPropertyData | 图片动画 clip的手势 背景颜色 背景图片 属性 {@see XYEffectPropertyData}| XYEffectPropertyData |
| clipEffectModel | 转场，null表示无。当前片段和下一个片段的转场数据{@see XYClipEffectModel} | CrossInfo |
| clipEffectModel | 滤镜信息，null表示无{@see XYClipEffectModel} | XYClipEffectModel |
| clipEffectModel | 特效滤镜信息，null表示无{@see XYClipEffectModel} | XYClipEffectModel |
| adjustItems | 参数调节信息{@see XYAdjustItem} | NSArray <XYAdjustItem *>  |

XYEffectPropertyData参数说明：

| 名称  | 解释 | 类型 |
| :-: | :-: | :-: | 
| scale | 缩放 缩放是相对原始尺寸的比例 没有做缩放默认值是1| CGFloat | 
| angleZ |旋转角度 值范围是0-3360 | NSInteger  | 
| shiftX | X轴移动 没做移动默认值都是1,shiftX 是移动的X除以播放器的的宽(streamSize.width) + 原来的shiftX | CGFloat| 
| shiftX | Y轴移动 没做移动默认值都是1,shiftX 是移动的X除以播放器的的宽(streamSize.width) + 原来的shiftX| CGFloat | 

XYCommonEngineClipModuleType参数说明：
| 名称  | 解释 |
| :-: | :-: |
| XYCommonEngineClipModuleImage | 图片clip |
| XYCommonEngineClipModuleVideo | 视频clip |
| XYCommonEngineClipModuleGif | gif clip |
| XYCommonEngineClipModuleThemeCoverFront | 主题片头 |
| XYCommonEngineClipModuleThemeCoverBack |主题片尾 |

XYClipEffectModel参数说明：

| 名称  | 解释 | 类型 |
| :-: | :-: | :-: | 
| effectConfigIndex | 有些素材包含多种效果，表示使用第几个效果，默认0| NSInteger | 
| colorFilterFilePath |调色滤镜的路径 | NSString  | 
| colorFilterAlpha | 调色程度值 滤镜调节 范围 0-1 | colorFilterAlpha| 
| fxFilterFilePath |特效滤镜的路径 | NSString  | 
| fxFilterAlpha | 特效程度值 滤镜调节 范围 0-1 | colorFilterAlpha| 
| effectTransFilePath | 转场的路径| NSString | 
| transDuration | 转场时长| NSInteger | 

XYAdjustItem参数说明：

| 名称  | 解释 | 类型 |
| :-: | :-: | :-: | 
| adjustType | 调节类型，共有类型为（亮度、对比度、饱和度、锐度、色温、暗角、色调、阴影、高光、褪色、噪点） | XYCommonEngineAdjustType | 
| dwID | 唯一id | NSInteger  | 
| dwCurrentValue |当前的值 0~100,默认50 | NSInteger| 

XYCommonEngineClipModuleType参数说明：

| 名称  | 解释 |
| :-: | :-: |
| XYCommonEngineClipModuleImage | 图片clip |
| XYCommonEngineClipModuleVideo | 视频clip |
| XYCommonEngineClipModuleGif | gif clip |
| XYCommonEngineClipModuleThemeCoverFront | 主题片头 |
| XYCommonEngineClipModuleThemeCoverBack |主题片尾 |

2) 效果相关信息

XYEffectModel参数说明：
| 名称  | 解释 | 类型 |
| :-: | :-: | :-: | 
| taskID | 执行的操作类型 | XYCommonEngineTaskID | 
| groupID | effect的类型 | XYCommonEngineGroupID | 
| filePath | 素材资源路径 | NSString | 
| sourceVeRange | 效果选取的时长，可以选取某一部分，默认（0， -1） | VXYVeRangeModeleRange | 
| destVeRange | effect在storyboard上的 mVeRange（起始点，时长） | XYVeRangeModel | 
| trimVeRange | 对效果时长的裁剪 | destVeRange | 
| layerID | 效果的层级信息，是一个浮点数，数字越大 层级越高 | CGFloat | 
| horizontalPosition | 层级 范围 [0 - max]的整数 | NSInteger | 
| layerIdSetBySelf | 业务自己直接设置layerID 而不通过 horizontalPosition参数来设置 默认通过horizontalPosition 设置layerID | BOOL | 


XYEffectAudioModel参数说明：XYEffectAudioModel继承XYEffectModel

| 名称  | 解释 | 类型 |
| :-: | :-: | :-: | 
| isFadeOutON | 是否开启淡入 | BOOL |
| isFadeOutON | 是否开启淡出 | BOOL | 
| fadeDuration | 渐变时长,0则无效果 | CGFloat | 
| lyricPath | 歌曲字幕lyric文件路径 | NSString |
| lyricTtid | 歌词模板的素材id | NSInteger |

XYEffectVisionModel参数说明：XYEffectVisionModel继承XYEffectModel

| 名称  | 解释 | 类型 | 
| :-: | :-: | :-: | 
| size.width | 宽度 | CGFloat | 
| size.height | 高度 | CGFloat | 
| center | 相对于播放界面的中心点坐标 | XYVe3DDataF |
| degree | 旋转角度，顺时针 0 - 360| XYVe3DDataF | 
| propData | 程度调节，默认1.0，范围 0 -1  | CGFloat | 
| verticalReversal | 竖直翻转 | BOOL | 
| horizontalReversal | 水平翻转  | BOOL | 
| isStaticPicture | YES的情况下，该效果将会静态展示  | BOOL | 
| isInstantRefresh | YES的情况下，该效果将会快速刷新  | BOOL | 
| currentScale | 根据当前宽度和dafault宽度自动计算当前放大倍数，只读  | CGFloat | 
| previewDuration | 预览时长 | CGFloat | 
| volume | 效果的音量（只有特效和视频画中画才有作用） | NSInteger | 
| overlayInfo | 画中画 透明度 | XYEffectPicInPicOverlayInfo | 
| maskInfo | 画中画 蒙版 | XYEffectPicInPicMaskInfo | 
| chromaInfo | 画中画 抠色信息数据（绿幕） | XYEffectPicInPicChromaInfo | 
| filterInfo | 画中画 滤镜 | XYEffectPicInPicFilterInfo | 
| fxInfoList |画中画特效 | NSMutableArray < XYEffectPicInPicSubFx > | 
| adjustItems | 画中画 参数调节 | NSArray < XYAdjustItem > | 


XYEffectPicInPicOverlayInfo参数说明：
| 名称  | 解释 | 类型 | 
| :-: | :-: | :-: | 
| overlayPath |混合模式素材路径 | NSString | 
| level |混合程度，改参数和透明度一个效果,0~100 | CGFloat | 

XYEffectPicInPicMaskInfo参数说明：
| 名称  | 解释 | 类型 | 
| :-: | :-: | :-: | 
| maskType |蒙版类型 | XYEffectMaskType | 
| centerPoint |中心点 在streamSize的坐标系中，中心点尽量保持在素材位置内 | CGPoint | 
| radiusX |水平方向半径，在streamSize的坐标系中 | CGFloat | 
| radiusY |垂直方向半径，在streamSize的坐标系中 | CGFloat | 
| rotation | 旋转角度， 0~360 | CGFloat | 
| softness |羽化程度，取值范围：[0~10000] | NSInteger | 
| reverse |是否反选 | BOOL | 

XYEffectPicInPicChromaInfo参数说明：
| 名称  | 解释 | 类型 | 
| :-: | :-: | :-: | 
| enable |是否开启 | BOOL | 
| colorHexValue |抠色的颜色值, 如0xFFFFFF | NSInteger | 
| accuracy |抠色的精度（0~100） | CGFloat | 
| isAutoMaskBgColor |是否自动去除画中画纯背景色 | BOOL | 
| selectPoint | 画中画选中的坐标 相对画中画的坐标 | CGPoint | 

XYEffectPicInPicFilterInfo参数说明：
| 名称  | 解释 | 类型 | 
| :-: | :-: | :-: | 
| filterPath |滤镜路径 | NSString | 
| filterLevel | 滤镜程度,0~100 | NSInteger | 

XYEffectPicInPicSubFx参数说明：
| 名称  | 解释 | 类型 | 
| :-: | :-: | :-: | 
| subFxPath |子特效素材路径 | NSString | 
| subType | 子特效索引，不可修改 范围1000 - 2000 | NSInteger | 
| destRange | 子特效出入点区间，相对效果的时间 | XYVeRangeModel | 

XYEffectVisionTextModel参数说明：XYEffectVisionTextModel继承XYEffectVisionModel
| 名称  | 解释 | 类型 | 
| :-: | :-: | :-: | 
| isAnimatedText |是否动画字幕 | BOOL | 
| textTransparency |字幕不透明度 全透明0，不透明100 | NSInteger | 
| useCustomTextInfo |第一次添加 如果这个值是YES，则文字大小、颜色、字体、位置、阴影、描边、描边大小、对齐方式，都用外面传进来的值，否则用模版里的信息| BOOL |
| multiTextList |多行字幕标签信息列表， 单行字幕数组里只有一个 | XYEffectVisionSubTitleLabelInfoModel | 

XYEffectVisionSubTitleLabelInfoModel参数说明：

| 名称  | 解释 | 类型 | 
| :-: | :-: | :-: | 
| text | 字幕当前文字| NSString |
| textFontName |字幕字体名称 | NSString | 
| textColor | 字幕颜色 | UIColor | 
| textLine |字幕行数 | NSInteger | 
| textAlignment | 对齐方式| XYEffectVisionTextAlignment | 
| textStrokeColor | 描边颜色 | UIColor | 
| textShadowColor | 阴影颜色 | UIColor |
| textStrokeWPercent | 描边粗细，引擎那边限制可以认为是0.0～1.0，但取值范围建议 0.0～0.5| CGFloat |
| textShadowBlurRadius | 阴影模糊程度: 必须>=0| CGFloat |
| textShadowXShift | 阴影X轴偏移 | CGFloat |
| textShadowXShift | 阴影Y轴偏移| CGFloat |
| textRegionRect | 文字部分相对于整个字幕尺寸的万分比rect| CGRect |


XYEffectKeyFrameInfo参数说明：（由于功能复杂，后期可能调整数据结构）
| 名称  | 解释 | 类型 |
| :-: | :-: | :-: |
| positionList | 位置关键帧列表 {@see XYKeyPosInfo} | KeyPosInfo |
| scaleList | 缩放关键帧列表 {@see XYKeyScaleInfo}  | KeyScaleInfo |
| rotationList | 旋转角度关键帧列表{@see XYKeyRotationInfo}   | KeyRotationInfo |
| alphaList | 不透明度关键帧列表{@see XYKeyAlphaInfo} | KeyAlphaInfo |


XYBaseKeyFrame参数说明：
| 名称  | 解释 | 类型 |
| :-: | :-: | :-: |
| keyFrameType | 关键帧类型 | XYKeyFrameType |
| relativeTime | 相对于效果入点的时间 | NSInteger |
| isCurvePath | 关键帧是否曲线路径 | BOOL |
| mKeyBezierCurve | 关键帧缓动贝塞尔曲线点{@see XYKeyBezierCurve} | XYKeyBezierCurve |



XYKeyFrameType参数说明：
| 名称  | 解释 |
| :-: | :-: |
| XYKeyFrameTypePosition | 位置关键帧 |
| XYKeyFrameTypeRotation | 旋转关键帧 |
| XYKeyFrameTypeScale | 缩放关键帧 |
| XYKeyFrameTypeAlpha | 透明度关键帧 |


KeyBezierCurve参数说明：
| 名称  | 解释 | 类型 |
| :-: | :-: | :-: |
| bezierCurveId | 贝塞尔缓动曲线Id 业务如果需要可以自己定义一个值传进来 | NSInteger |
| start | 贝塞尔缓动曲线起点 | CGPoint |
| stop | 贝塞尔缓动曲线终点） | CGPoint |
| c0 | 贝塞尔缓动节点1 | CGPoint |
| c1 | 贝塞尔缓动节点2 | CGPoint |


XYKeyPosInfo参数说明：
| 名称  | 解释 | 类型 |
| :-: | :-: | :-: |
| centerPoint | 在streamSize的坐标系中的中心位置| CGPoint |


KeyScaleInfo参数说明：
| 名称  | 解释 | 类型 |
| :-: | :-: | :-: |
| widthScale | 宽相对于原始的宽的放大倍数 | CGFloat |
| heightScale | 宽相对于原始的高的放大倍数 | CGFloat |


KeyRotationInfo参数说明：
| 名称  | 解释 | 类型 |
| :-: | :-: | :-: |
| rotation | 旋转角度， 0~360 | CGFloat |


KeyAlphaInfo参数说明：
| 名称  | 解释 | 类型 |
| :-: | :-: | :-: |
| alpha | 不透明度 0~100 | NSInteger |

3) 工程相关信息
XYStoryboardModel参数说明：

| 名称  | 解释 | 类型 |
| :-: | :-: | :-: |
| outPutResolution | 分辨率 | CGSize |
| videoDuration | 视频总时长 | NSInteger |
| themeTextList | 主题字幕列表| TextInfo |
| themePath | 主题素材路径| NSArray |
| themeID | 主题id| NSInteger |
| ratioValue | 视频比例 | CGFloat |

XYClipOperationMgr信息:
#### 4. 主题剪辑功能接口
1）应用/切换主题
```
	// themePath表示主题素材路径
	 XYStoryboardModel *sbModel = [XYEngineWorkspace stordboardMgr].currentStbModel;
     sbModel.taskID = XYCommonEngineTaskIDStoryboardAddTheme;
     sbModel.themePath = themePath;
     [[XYEngineWorkspace stordboardMgr] runTask:sbModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {
    }];
```

2）恢复主题背景音乐设置
```
	// 该操作将删除自己应用的背景音乐，切回主题自带的背景音乐
	XYEffectModel *effectModel = [[XYEffectModel alloc] init];
    effectModel.taskID = XYCommonEngineTaskIDEffectResetThemeAudio;
    effectModel.groupID = XYCommonEngineGroupIDBgmMusic;
    [[XYEngineWorkspace effectMgr] runTask:effectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {
    }];
```


3）修改主题关联字幕文本
```
XYStoryboardModel *storyboardModel = [XYEngineWorkspace stordboardMgr].currentStbModel;
//获取所有的字幕
 [storyboardModel.themeTextList enumerateObjectsUsingBlock:^(TextInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.text = @"修改字幕";
  }];
[XYEngineWorkspace stordboardMgr].currentStbModel.taskID = XYCommonEngineTaskIDStoryboardUpdateThemeText;
 [[XYEngineWorkspace stordboardMgr] runTask:storyboardModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {
    }];
```
TextInfo 参数说明：
| 名称  | 解释 | 类型 | 是否必须 |
| :-: | :-: | :-: | :-: |
| text | 字幕文本 | String | 必须 | 


#### 5. Clip剪辑功能接口
1）添加
```
    XYClipModel *clipModel = [[XYClipModel alloc] init];
    clipModel.sourceVeRange.dwPos = 0;
    clipModel.sourceVeRange.dwLen = duration;
    clipModel.clipFilePath = [XYClipModel getClipFilePathForEngine:phAsset];
    clipModel.rotation = rotation;
    clipModel.clipIndex = idx;//idx 需要添加顺序 如第一个是0 第二是1 ....
    [clipArr addObject:clipModel];    
    XYClipModel *taskModel = [[XYClipModel alloc] init];
    taskModel.taskID = XYCommonEngineTaskIDClipAddClip;
    taskModel.clipModels = clipArr;
    [[XYEngineWorkspace clipMgr] runTask:taskModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {
    }];
}
```
XYClipModel参数说明：
 | 名称 | 解释 | 类型 | 是否必须 |
  | :-: | :-: | :-: | :-: | 
  | clipFilePath | 文件地址 如果是绝对路径直接赋值，如果是PHAsset 通过getClipFilePathForEngine 此法获取路径| NSString | 必须 | 
  | sourceVeRange |源的长度 | XYVeRangeModel | 非必须 | 
  | trimVeRange | 切入点 | XYVeRangeModel | 非必须 | 
  | cropRect | 裁切区域 | CGRect | 非必须 | 
  | rotation | 旋转角度 | NSInteger | 非必须 |
  | filterFilePath | 滤镜 | NSString | 非必须 |
2）复制
```
	// clipIndex表示第几个片段，从0开始
 XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:clipIndex];
    XYClipModel *newClipModel = [[XYClipModel alloc] init];
    clipModel.duplicateClipModel = newClipModel;
    clipModel.taskID = XYCommonEngineTaskIDClipDuplicate;
    [[XYEngineWorkspace clipMgr] runTask:clipModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];

```

3）删除
```
	// clipIndex表示第几个片段，从0开始
XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:clipIndex];
 clipModel.taskID = XYCommonEngineTaskIDClipDelete;
 [[XYEngineWorkspace clipMgr] runTask:clipModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```

4）排序
```
XYClipModel *clipModel = [XYClipModel new];
clipModel = fromIndex;
clipModel = toIndex;
[[XYEngineWorkspace clipMgr] runTask:clipModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```

5）静音
```
	// clipIndex表示第几个片段，从0开始
XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:clipIndex];
clipModel.taskID = XYCommonEngineTaskIDClipMuteState;
clipModel.isMute = isMute;
[[XYEngineWorkspace clipMgr] runTaskToMore:clipModel.isMute];

```

6）音量
```
	// clipIndex表示第几个片段，从0开始
XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:clipIndex];
clipModel.taskID = XYCommonEngineTaskIDClipUpdateVolume;
clipModel.volumeValue = volumeValue;
[[XYEngineWorkspace clipMgr] runTaskToMore:clipModel];

```

7）变声
```
	// clipIndex表示第几个片段，从0开始
// voiceChangeValue表示音调，从-60~60，{@see XYDftSoundTone}枚举中有提供的特定音调
XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:clipIndex];
clipModel.voiceChangeValue = value;
[XYEngineWorkspace clipMgr] runTask:clipModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```

8）镜像
```
	// clipIndex表示第几个片段，从0开始
YClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:clipIndex];
XYClipMirrorMode mirrorMode = XYClipMirrorModeX;
clipModel.mirrorMode = mirrorMode;
clipModel.taskID = XYCommonEngineTaskIDClipMirror;
[[XYEngineWorkspace clipMgr] runTask:clipModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```
clipModel.mirrorMode参数说明：
| 名称  | 解释  |
| :-: | :-: |
| XYClipMirrorModeNormal | 正常 | 
| XYClipMirrorModeX | 沿X方向镜像 | 
| XYClipMirrorModeY | 沿Y方向镜像 | 
| XYClipMirrorModeXY | 沿XY方向镜像 | 


9）旋转
```
	// clipIndex表示第几个片段，从0开始
XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:clipIndex];
clipModel.taskID = XYCommonEngineTaskIDClipRotation;
clipModel.rotation = rotation;
[XYEngineWorkspace clipMgr] runTask:clipModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```


10）分割
```
	// clipIndex表示第几个片段，从0开始
     XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:clipIndex];
clipModel.splitClipPostion = seekPosition;
clipModel.taskID = XYCommonEngineTaskIDClipSplit;
[[XYEngineWorkspace clipMgr] runTask:clipModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```



11）变速
```
	// clipIndex表示第几个片段，从0开始
    XYClipModel *clipModel = [[XYEngineWorkspace clipMgr]       fetchClipModelObjectAtIndex:clipIndex];
    clipModel.taskID = XYCommonEngineTaskIDClipSpeed;
    clipModel.speedValue = videoSpeedChangeValue;
    clipModel.iskeepTone = NO;//是否保持原声调
    [[XYEngineWorkspace clipMgr] runTask:clipModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```

12）倒放
```
	// clipIndex表示第几个片段，从0开始
	 XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:clipIndex];
    clipModel.taskID = XYCommonEngineTaskIDClipReverse;
    [[XYEngineWorkspace clipMgr] runTask:clipModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```


13）比例
```
	  XYStoryboardModel *sbModel = [XYEngineWorkspace stordboardMgr].currentStbModel;
    sbModel.taskID = XYCommonEngineTaskIDStoryboardRatio;
    sbModel.ratioValue = ratioValue;
    [[XYEngineWorkspace stordboardMgr] runTask:sbModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {
    }];
```


14）裁切
```
	// clipIndex表示第几个片段，从0开始
	 XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:clipIndex];
   clipModel.taskID = XYCommonEngineTaskIDClipCrop;
   clipModel.cropRecte =cropRect;
   [[XYEngineWorkspace clipMgr] runTask:clipModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];

```


15）视频裁剪
```
	// clipIndex表示第几个片段，从0开始
	 XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:clipIndex];
   clipModel.taskID = XYCommonEngineTaskIDClipTrim;
   clipModel.trimVeRange = trimVeRange;
   [[XYEngineWorkspace clipMgr] runTask:clipModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```

16）图片时长
```
	// clipIndex表示第几个片段，从0开始
	 XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:clipIndex];
   clipModel.taskID = XYCommonEngineTaskIDClipTrim;
   clipModel.trimVeRange = trimVeRange;
   [[XYEngineWorkspace clipMgr] runTask:clipModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```

17）图片动画
```
	// clipIndex表示第几个片段，从0开始
	 XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:clipIndex];
   clipModel.taskID = XYCommonEngineTaskIDClipPhotoAnimation;
clipModel.clipPropertyData.isAnimationON = !clipModel.clipPropertyData.isAnimationON;
   [[XYEngineWorkspace clipMgr] runTask:clipModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```

18）背景
```
// clipIndex表示第几个片段，从0开始
 XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:clipIndex];
clipModel.taskID = XYCommonEngineTaskIDClipBackgroundBlur;
clipModel.clipPropertyData = clipPropertyData;
```

XYEffectPropertyData参数说明：
| 名称  | 解释 | 类型 | 是否必须 |
| :-: | :-: | :-: | :-: |
| fitType | 背景类型 | XYCommonEngineRatioFitType | 非必须 | 
| backgroundColorList | color,最多可以支持三色渐变 | int[] 十六进制的颜色值| 非必须 | 
| linearGradientAngle | 颜色渐变角度：默认0-水平方向。0~360 | NSInteger | 非必须 | 
| backgroundBlurValue | 模糊程度：0~100 | CGFloat | 非必须 | 
| backImagePath | 图片背景，自定义图片背景使用 | String | 非必须 | 

taskID参数设置
```
  /**
   * 模糊背景
   */
 taskID = XYCommonEngineTaskIDClipBackgroundBlur;

  /**
   * 图片背景
   */
  taskID = XYCommonEngineTaskIDClipBackgroundImage;

  /**
   * 颜色背景
   *
   * @param backgroundColorList 最多支持三色。渐变色  0-1-2
   * @param linearGradientAngle 渐变色方向。默认为水平方向，取值范围：0~360，对应的角度：0~360，单位为°
   */
    taskID = XYCommonEngineTaskIDClipBackgroundColor;
```


19）位置修改
```
	// clipIndex表示第几个片段，从0开始
 XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:clipIndex];
clipModel.taskID = XYCommonEngineTaskIDClipGesturePan;
XYEffectPropertyData * clipPropertyData = clipModel.clipPropertyData;
clipPropertyData.centerPosX = centerPosX;
clipPropertyData.centerPosY = centerPosY;
```
taskID参数设置
```
  /**
   * 移动
   */
 taskID = XYCommonEngineTaskIDClipGesturePan;

  /**
   * 缩放
   */
  taskID = XYCommonEngineTaskIDClipGesturePinch;

  /**
   * 旋转
   */
    taskID = XYCommonEngineTaskIDClipGestureRotation;
```

20）镜头参数调节
```
	// clipIndex表示第几个片段，从0开始
    XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:clipIndex];
    // idx adjustItems数组中取一种参数调节对象
    XYAdjustItem *adjustItem = clipModel.adjustItems[idx];
    adjustItem.dwCurrentValue = 0-100;
    [[XYEngineWorkspace clipMgr] runTaskToMore:clipModel];
```

adjustItem参数说明：
| 名称  | 解释 | 类型 |
| :-: | :-: | :-: | 
| adjustType | 调节类型，共有类型为（亮度、对比度、饱和度、锐度、色温、暗角、色调、阴影、高光、褪色、噪点） | XYCommonEngineAdjustType | 
| dwID | 唯一id | NSInteger  | 
| dwCurrentValue |当前的值 0~100,默认50 | NSInteger| 

21）滤镜
```
	// clipIndex表示第几个片段，从0开始
    XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:clipIndex];
    clipModel.groupID = XYCommonEngineGroupIDColorFilter;
    clipModel.taskID = XYCommonEngineTaskIDClipFilterAdd;
    clipModel.clipEffectModel.colorFilterFilePath = filterPath;
    clipModel.clipEffectModel.colorFilterAlpha = colorFilterAlpha;
    [[XYEngineWorkspace clipMgr] runTask:clipModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```
clipEffectModel参数说明：
| 名称  | 解释 | 类型 |
| :-: | :-: | :-: | 
| colorFilterFilePath | 滤镜路径 | NSString | 
| colorFilterAlpha | 滤镜程度, 0～1.0 | CGFloat  | 
| taskID | XYCommonEngineTaskIDClipFilterAdd（添加滤镜）,  XYCommonEngineTaskIDClipFilterUpdateAlpha（修改滤镜程度 | XYCommonEngineTaskID  | 


22）特效滤镜
```
// clipIndex表示第几个片段，从0开始
    XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:clipIndex];
    clipModel.groupID = XYCommonEngineGroupIDFXFilter;
    clipModel.taskID = XYCommonEngineTaskIDClipFilterAdd;
    clipModel.clipEffectModel.fxFilterFilePath = fxFilterFilePath;
    [[XYEngineWorkspace clipMgr] runTask:clipModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```
clipEffectModel 参数说明：
| 名称  | 解释 | 类型 |
| :-: | :-: | :-: | 
| fxFilterFilePath | 特效滤镜路径 | NSString | 


23）转场
```
// clipIndex表示第几个片段，从0开始
    XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:clipIndex];
    clipModel.taskID = XYCommonEngineTaskIDClipTransition;
    clipModel.clipEffectModel.effectTransFilePath = effectTransFilePath;
    effectModel.transDuration = [XYCommonEngineRequest requestEffectTansDuration:effectModel.effectTransFilePath];
    [[XYEngineWorkspace clipMgr] runTask:clipModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```

23）修改转场时长
```
// clipIndex表示第几个片段，从0开始

BOOL editable = [XYCommonEngineRequest requestTranEditable:clipModel.clipEffectModel.effectTransFilePath];//判断是否可以修改转场时长
if (editable) {
    XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:clipIndex];
    clipModel.taskID = XYCommonEngineTaskIDClipTransition;
    clipModel.clipEffectModel.effectTransFilePath = effectTransFilePath;
    effectModel.transDuration = transDuration;
    [[XYEngineWorkspace clipMgr] runTask:clipModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
    }
```

clipEffectModel参数说明：
| 名称  | 解释 | 类型 |
| :-: | :-: | :-: | 
| effectTransFilePath | 转场路径 | NSString | 
| transDestRange | //转场在视频中的range | XYVeRangeModel | 
| effectConfigIndex | 转场效果样式，有些素材包含多种效果，表示使用第几个效果，默认0 | NSInteger | 

#### 6. Effect剪辑功能接口
效果目前分为两大类：
1.声音类的
2.视觉类的
* 声音类
6.1.1 添加 
```
	// groupId为effect的类型
	// effectAudioModel需要的effect {@see XYEffectAudioModel}
	XYEffectAudioModel *effectAudioModel = [[XYEffectAudioModel alloc] init];
      effectModel.taskID = XYCommonEngineTaskIDEffectAudioAdd;
      effectModel.groupID = XYCommonEngineGroupIDBgmMusic;
      effectModel.title = @"背景音乐1";
      effectModel.filePath = filePath;
XYVeRangeModel *sourceVeRange = [XYVeRangeModel VeRangeModelWithPosition:0 length:5000];
      effectModel.sourceVeRange = sourceVeRange;

      XYVeRangeModel *trimVeRange = [XYVeRangeModel VeRangeModelWithPosition:0 length:5000];
      effectModel.trimVeRange = trimVeRange;

      NSInteger dwPos = 0;
      NSInteger dwLen = 5000;
      XYVeRangeModel *destVeRange = [XYVeRangeModel VeRangeModelWithPosition:dwPos length:dwLen];
      effectModel.destVeRange = destVeRange;

      [[XYEngineWorkspace effectMgr] runTask:effectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {
    }];
```
XYEffectAudioModel参数说明：
| 名称  | 解释 | 类型 | 是否必须 |
| :-: | :-: | :-: | :-: |
| taskID | 执行的操作类型 | XYCommonEngineTaskID | 必须 | 
| groupID | effect的类型 | XYCommonEngineGroupID | 必须 | 
| filePath | 素材资源路径 | NSString | 必须 | 
| sourceVeRange | 效果选取的时长，可以选取某一部分，默认（0， -1） | VXYVeRangeModeleRange | 非必须 | 
| destVeRange | effect在storyboard上的 mVeRange（起始点，时长） | XYVeRangeModel | 非必须 | 
| trimVeRange | 对效果时长的裁剪 | destVeRange | 非必须 | 
| layerID | 效果的层级信息，是一个浮点数，数字越大 层级越高 | CGFloat | 非必须 | 
| isFadeOutON | 是否开启淡入 | BOOL | 非必须 | 
| isFadeOutON | 是否开启淡出 | BOOL | 非必须 | 
| fadeDuration | 渐变时长,0则无效果 | CGFloat | 必须 | 
6.1.2 复制
```
    // groupID为effect的类型
   // effectIndex为同类型中第几个效果
    XYEffectAudioModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
	XYEffectAudioModel *duplicateEffectModel = [[XYEffectAudioModel alloc] init];
    duplicateEffectModel.title = currentEffectModel.title;
    XYVeRangeModel *destVeRange = [XYVeRangeModel VeRangeModelWithPosition:startPosition length:valideLength];
    duplicateEffectModel.destVeRange = destVeRange;
    currentEffectModel.duplicateEffectModel = duplicateEffectModel;
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectAudioDuplicate;
    [[XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];

```
6.1.3 删除
```
    // groupID为effect的类型
	// effectIndex为同类型中第几个效果
    XYEffectAudioModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectAudioDelete;
    [[XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];

```
6.1.4 裁切区间
```
	// groupID为effect的类型
	// effectIndex为同类型中第几个效果
	// trimRange表示裁切区间
	  XYEffectAudioModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
	  currentEffectModel.trimVeRange = currentEffectModel.trimVeRange;
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectAudioUpdateTrimRange;
    [[XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```

6.1.5 出入区间
```
	// groupID为effect的类型
	// effectIndex为同类型中第几个效果
	// destRange表示切入切出区间
 XYEffectAudioModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
	  currentEffectModel.destRange = destRange;
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectAudioUpdateDestRange;
    [[XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```


6.1.6 源文件区间
```
	// groupID为effect的类型
	// effectIndex为同类型中第几个效果
	// sourceVeRange表示切入切出区间
 XYEffectAudioModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
	  currentEffectModel.sourceVeRange = sourceVeRange;
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectAudioUpdateSourceVeRange;
    [[XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```

6.1.7  音量
```
	// groupID为effect的类型
	// effectIndex为同类型中第几个效果
	// volumeValue表示声音大小值
 XYEffectAudioModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
	  currentEffectModel.volumeValue = volumeValue;
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectUpdateAudioVolume;
    [[XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```


6.1.8 音频渐入渐出
```
	// groupID为effect的类型
	// effectIndex为同类型中第几个效果
 XYEffectAudioModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
	  currentEffectModel.isFadeOutON = isFadeOutON;
	  currentEffectModel.fadeDuration = fadeDuration;
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectAudioFadeOut;
    [[XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```

6.1.9 音频循环
```
	// groupID为effect的类型
	// effectIndex为同类型中第几个效果
	// isRepeatON表示是否开启循环
 XYEffectAudioModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
	  currentEffectModel.isRepeatON = isRepeatON;
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectAudioUpdateRepeat;
    [[XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```


6.1.10 音频变声
```
	// groupID为effect的类型
	// effectIndex为同类型中第几个效果
	//  voiceChangeValue表示音调，从-60~60，
 XYEffectAudioModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
	  currentEffectModel.voiceChangeValue = voiceChangeValue;
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectAudioVoiceChange;
    [[XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```


6.1.11 替换音频
```
	// groupId为effect的类型
	// effectIndex为同类型中第几个效果
	// filePath表示音频路径
	
	XYEffectAudioModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
	  currentEffectModel.filePath = filePath;
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectAudioReplace;
    [[XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {
    }];
```
6.1.12 歌词文件生成字幕
```
	// groupId为effect的类型
	// effectIndex为同类型中第几个效果
	// lyric表示歌曲字幕lyric文件路径
	// lyricTtid表示歌词模板的素材id

	XYEffectAudioModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
	  currentEffectModel.lyric = lyric;
	  currentEffectModel.lyricTtid = lyricTtid;
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectAudioLyic;
    [[XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {
    }];
```

* 视觉类的分为普通类型和字幕类型两种，字幕继承了普通类型的属性
普通类型的,修改字幕对应的普通属性，只需将taskID 改成对应的字幕的taskID即可

6.2.1
XYEffectVisionModel参数说明：

| 名称  | 解释 | 类型 | 是否必须 |
| :-: | :-: | :-: | :-: |
| defaultWidth | 默认宽度，素材中提取| CGFloat | 非必须 | 
| defaultHeight |默认高度，素材中提取 | CGFloat | 非必须 | 
| size.width | 宽 | CGFloat | 必须 | 
| size.height | 高 | CGFloat | 必须 | 
| degree | 旋转角度， 0~360 | XYVe3DDataF | 非必须 | 
| horizontalReversal | 水平反转 | BOOL | 非必须 | 
| verticalReversal | 垂直反转 | BOOL | 非必须 | 
| centerPoint | 相对于播放StreamSize的中心点坐标 | CGPoint | 必须 | 
| alpha | 透明度，默认1.0 | CGFloat | 非必须 | 
| volume | 透明度，默认1.0 | CGFloat |非必须 | 
| isStaticPicture | YES的情况下，该效果将会静态展示| BOOL |非必须| 
| layerID | /效果的层级信息，是一个浮点数，数字越大 层级越高 值范围 10000 - 9999998| CGFloat |必须| 

添加
```
    // groupID为effect的类型
    // taskID为操作类型
XYEffectVisionModel * visionModel = [XYEffectVisionModel new];
        visionModel.taskID = XYCommonEngineTaskIDEffectVisionAdd;
        visionModel.groupID = XYCommonEngineGroupIDSticker;
        visionModel.filePath = pastePath;
        visionModel.isStaticPicture = YES;
        NSInteger beginTime = 0;
        visionModel.destVeRange = [XYVeRangeModel VeRangeModelWithPosition:beginTime length:length];
        [[XYEngineWorkspace effectMgr] runTask:visionModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {
    }];
```
6.2.2 复制
```
	// groupID为effect的类型
   // effectIndex为同类型中第几个效果
    XYEffectVisionModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
	XYEffectVisionModel *duplicateEffectModel = [[XYEffectVisionModel alloc] init];
    XYVeRangeModel *destVeRange = [XYVeRangeModel VeRangeModelWithPosition:startPosition length:valideLength];
    duplicateEffectModel.destVeRange = destVeRange;
    currentEffectModel.duplicateEffectModel = duplicateEffectModel;
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectVisionDuplicate;
    [[XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];

```

6.2.3 删除
```
	// groupID为effect的类型
   // effectIndex为同类型中第几个效果
    XYEffectVisionModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectVisionDelete;
    [[XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```

6.2.4 修改图层
```
	// groupId为effect的类型
	// effectIndex为同类型中第几个效果
	// layerId表示图层，float类型，各类型的图层有区间限制 值范围 10000 - 9999998
 XYEffectVisionModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectVisionUpdate;
  currentEffectModel.layerID = layerID;
   [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```

6.2.5 裁切区间
```
	// groupId为effect的类型
	// effectIndex为同类型中第几个效果
	// trimRange表示裁切区间
	XYEffectVisionModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectVisionUpdate;
  currentEffectModel.trimVeRange = trimVeRange;
   [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```

6.2.6 出入区间
```
	// groupId为effect的类型
	// effectIndex为同类型中第几个效果
	// destRange表示切入切出区间
	XYEffectVisionModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectVisionUpdate;
  currentEffectModel.destVeRange = destVeRange;
   [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```


6.2.7 源文件区间
```
	// groupId为effect的类型
	// effectIndex为同类型中第几个效果
	// sourceVeRange表示源文件区间信息
	XYEffectVisionModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectVisionUpdate;
  currentEffectModel.sourceVeRange = sourceVeRange;
   [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```


6.2.8 透明度
```
	// groupId为effect的类型
	// effectIndex为同类型中第几个效果
	// alpha表示透明度，0~1
	XYEffectVisionModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectVisionUpdate;
  currentEffectModel.alpha = alpha;
   [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```

6.2.9  锁定播放器刷新效果,用于实时快速刷新修改的位置，大小，旋转角度等信息
```
	// groupId为effect的类型
	// effectIndex为同类型中第几个效果
	// isInstantRefresh表示是否锁定
	XYEffectVisionModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectVisionUpdate;
  currentEffectModel.centerPoint = centerPoint;
    currentEffectModel.isInstantRefresh = isInstantRefresh;
   [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```
当需要快速刷新播放器某个效果位置时，需要先锁定该效果，当位置刷新结束后，需要对改效果解锁。

6.2.10 画中画混合模式设置
```
	// groupId为effect的类型
	// effectIndex为同类型中第几个效果
	// overlayInfo表示混合模式信息 {@see XYEffectPicInPicOverlayInfo}
		XYEffectVisionModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
       XYEffectPicInPicOverlayInfo *overlayInfo = [[XYEffectPicInPicOverlayInfo alloc] init];
        visionModel.overlayInfo = overlayInfo;
        visionModel.taskID = XYCommonEngineTaskIDEffectVisionPinInPicOverlayUpdate;
	 [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];

```


6.2.11 画中画蒙版设置
```
	// groupId为effect的类型
	// effectIndex为同类型中第几个效果
	// maskInfo表示混合模式信息 {@see XYEffectPicInPicMaskInfo}
		XYEffectVisionModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
        XYEffectPicInPicMaskInfo *maskInfo = [[XYEffectPicInPicMaskInfo alloc] init];
        visionModel.maskInfo = maskInfo;
        visionModel.taskID = XYCommonEngineTaskIDEffectVisionPinInPicMaskUpdate;
	 [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```


6.2.12 画中画抠色设置（绿幕）
```
	    // groupId为effect的类型
        // effectIndex为同类型中第几个效果
        // visionModel.chromaInfo表示混合模式信息 {@see XYEffectPicInPicChromaInfo}
        XYEffectVisionModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
        XYEffectPicInPicChromaInfo *chromaInfo = [[XYEffectPicInPicChromaInfo alloc] init];
        visionModel.chromaInfo = chromaInfo;
        visionModel.taskID = XYCommonEngineTaskIDEffectVisionPinInPicChromaUpdate;
        [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```


6.2.13 画中画滤镜设置
```
	     // groupId为effect的类型
        // effectIndex为同类型中第几个效果
        // maskInfo表示混合模式信息 {@see XYEffectPicInPicFilterInfo}
        XYEffectVisionModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
        XYEffectPicInPicFilterInfo *filterInfo = [[XYEffectPicInPicFilterInfo alloc] init];
        visionModel.filterInfo = filterInfo;
        visionModel.taskID = XYCommonEngineTaskIDEffectVisionPinInPicFilterUpdate;
        [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```


6.2.14 画中画参数调节设置
```
	    // groupId为effect的类型
        // effectIndex为同类型中第几个效果
        // adjustItems表示混合模式信息 {@see XYAdjustItem}
        XYEffectVisionModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
        NSArray <XYAdjustItem *> *adjustItems = list;
        visionModel.adjustItems = adjustItems;
        visionModel.taskID = XYCommonEngineTaskIDEffectVisionPinInPicSubAdjust;
        [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```



6.2.14 画中画添加子特效
```
	// groupId为effect的类型
        // effectIndex为同类型中第几个效果
        // fxInfoList表示混合模式信息 {@see XYEffectPicInPicSubFx}
        XYEffectVisionModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
        NSMutableArray <XYEffectPicInPicSubFx *> fxInfoList = list;
        visionModel.fxInfoList = fxInfoList;
        visionModel.taskID = XYCommonEngineTaskIDEffectVisionPinInPicSubFX;
        [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```



6.2.15 画中画修改子特效出入点时间区间
```
	// groupId为effect的类型
        // effectIndex为同类型中第几个效果
        // fxInfoList表示混合模式信息 {@see XYEffectPicInPicSubFx}
        XYEffectVisionModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
        NSMutableArray <XYEffectPicInPicSubFx *> fxInfoList = visionModel.fxInfoList;
        fxInfoList enumerateObjectsUsingBlock:^(XYEffectPicInPicSubFx * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.destRange = [XYVeRangeModel VeRangeModelWithPosition:start length:length];
        }
        visionModel.taskID = XYCommonEngineTaskIDEffectVisionPinInPicSubFX;
        [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```


6.2.16 画中画删除子特效
```
	// groupId为effect的类型
        // effectIndex为同类型中第几个效果
        // fxInfoList表示混合模式信息 {@see XYEffectPicInPicSubFx}
        XYEffectVisionModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
        NSMutableArray <XYEffectPicInPicSubFx *> fxInfoList = visionModel.fxInfoList;
        fxInfoList enumerateObjectsUsingBlock:^(XYEffectPicInPicSubFx * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.subFxPath = nil;
        }
        visionModel.taskID = XYCommonEngineTaskIDEffectVisionPinInPicSubFX;
        [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```


6.2.17 锚点修改
```
	// groupId为effect的类型
	// effectIndex为同类型中第几个效果
	// anchor锚点,(0,0)为效果的左上角位置，（0.5，0.5）表示效果的中心，（1.0，1.0）表示效果的右下角。默认是(0.5,0.5) 。取值范围是0~1
	XYEffectVisionModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectVisionUpdate;
  currentEffectModel.anchor = anchor;
   [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```


6.2.18 显示静态图片
```
	// groupId为effect的类型
	// effectIndex为同类型中第几个效果
	// isStaticPicture表示是否显示静态图片
	XYEffectVisionModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectVisionUpdate;
  currentEffectModel.isStaticPicture = isStaticPicture;
   [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```
备注：由于一些动态贴纸/字幕，有效果变化，可以通过该操作，使效果关闭动画显示固定效果。


6.2.19 马赛克模糊程度
```
	// groupId默认为XYCommonEngineGroupIDMosaic
	// effectIndex为同类型中第几个效果
	XYEffectVisionModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectVisionAdd;
    visionModel.filePath = mediaItem.filePath;
    visionModel.destVeRange = veRangeModel;
    visionModel.propData = 0.5;
   [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];

程度调节

// groupId默认为XYCommonEngineGroupIDMosaic
	// effectIndex为同类型中第几个效果
	XYEffectVisionModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectVisionUpdate;
    visionModel.propData = 0.5;
   [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];

```

6.2.20 关键帧设置
```
	// groupId为effect的类型
	// effectIndex为同类型中第几个效果
	// sourceVeRange表示源文件区间信息
	XYEffectVisionModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectVisionUpdate;
    XYEffectKeyFrameInfo *keyFrameInfo = [XYEffectKeyFrameInfo alloc] init];//@see{XYEffectKeyFrameInfo}
  currentEffectModel.keyFrameInfo = keyFrameInfo;
   [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```
6.2.21 设置位置 大小 旋转角度
```
            effectVisionModel.taskID = XYCommonEngineTaskIDEffectVisionUpdate3dInfo;
            effectVisionModel.size.x = x;
            effectVisionModel.size.y = y;
            effectVisionModel.degree.z = z
            effectVisionModel.center.x = x;
            effectVisionModel.center.y = y;
            [[XYEngineWorkspace effectMgr] runTask:effectVisionModel completionBlock:^(BOOL success, NSError * _Nullable error, id  _Nullable obj) {
                
            }];
```

* 字幕

XYEffectVisionTextModel参数说明
| 名称  | 解释 | 类型 | 是否必须 |
| :-: | :-: | :-: | :-: |
| isAnimatedText |是否动画字幕 | BOOL | 非必须| 
| textTransparency |字幕不透明度 全透明0，不透明100 | NSInteger | 非必须  | 
| useCustomTextInfo |第一次添加 如果这个值是YES，则文字大小、颜色、字体、位置、阴影、描边、描边大小、对齐方式，都用外面传进来的值，否则用模版里的信息| BOOL |非必须| 
| multiTextList |多行字幕标签信息列表， 单行字幕数组里只有一个 | XYEffectVisionSubTitleLabelInfoModel | 非必须  | 

XYEffectVisionSubTitleLabelInfoModel参数说明：
| 名称  | 解释 | 类型 | 是否必须 |
| :-: | :-: | :-: | :-: |
| text | 字幕当前文字| NSString | 非必须 | 
| textFontName |字幕字体名称 | NSString | 非必须 | 
| textColor | 字幕颜色 | UIColor | 非必须 | 
| textLine |字幕行数 | NSInteger | 非必须| 
| textAlignment | 对齐方式| XYEffectVisionTextAlignment | 非必须 | 
| textStrokeColor | 描边颜色 | UIColor | 非必须 | 
| textShadowColor | 阴影颜色 | UIColor |非必须 | 
| textStrokeWPercent | 描边粗细，引擎那边限制可以认为是0.0～1.0，但取值范围建议 0.0～0.5| CGFloat |非必须| 
| textShadowBlurRadius | 阴影模糊程度: 必须>=0| CGFloat |非必须| 
| textShadowXShift | 阴影X轴偏移 | CGFloat |非必须| 
| textShadowXShift | 阴影Y轴偏移| CGFloat |非必须| 

1）字幕添加

```
	XYEffectVisionTextModel * textModel = [XYEffectVisionTextModel new];
        textModel.taskID = XYCommonEngineTaskIDEffectVisionTextAdd;
        textModel.groupID = XYCommonEngineGroupIDText;
        textModel.filePath = filePath;
        textModel.templateID = templateID;
        XYEffectVisionSubTitleLabelInfoModel *subTextModel = [XYEffectVisionSubTitleLabelInfoModel new];
        subTextModel.text = text;
        textModel.multiTextList = @[subTextModel];
        NSInteger beginTime = 0;
        textModel.destVeRange = [XYVeRangeModel VeRangeModelWithPosition:beginTime length:length];
  [XYEngineWorkspace effectMgr] runTask:textModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```
2）字幕文本

```
	// groupId默认为GROUP_ID_SUBTITLE
	// effectIndex为同类型中第几个效果
	// textIndex表示组合字幕中的第几个字幕
	// text表示字幕文本
	XYEffectVisionTextModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectVisionTextUpdate;
    XYEffectVisionSubTitleLabelInfoModel *labelInfoModel = currentEffectModel.multiTextList[textIndex];
  labelInfoModel.text = text;
  [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```

3）字幕字体
```
	// groupId默认为GROUP_ID_SUBTITLE
	// effectIndex为同类型中第几个效果
	// textIndex表示组合字幕中的第几个字幕
	// textFontName表示字幕字体名称
	XYEffectVisionTextModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectVisionTextUpdate;
    XYEffectVisionSubTitleLabelInfoModel *labelInfoModel = currentEffectModel.multiTextList[textIndex];
  labelInfoModel.textFontName = textFontName;
  [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```


4）字幕文本颜色

```
	// groupId默认为GROUP_ID_SUBTITLE
	// effectIndex为同类型中第几个效果
	// textIndex表示组合字幕中的第几个字幕
	// textAlignment表示对齐方式
	XYEffectVisionTextModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectVisionTextUpdate;
   XYEffectVisionSubTitleLabelInfoModel *labelInfoModel = currentEffectModel.multiTextList[textIndex];
  labelInfoModel.textAlignment = textAlignment;
   [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```

5）字幕文本阴影

```
	// groupId默认为GROUP_ID_SUBTITLE
	// effectIndex为同类型中第几个效果
	// textIndex表示组合字幕中的第几个字幕
	XYEffectVisionTextModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectVisionTextUpdate;
  currentEffectModel.isTextExtraEffectEnabled = YES;
     XYEffectVisionSubTitleLabelInfoModel *labelInfoModel = currentEffectModel.multiTextList[textIndex];
    labelInfoModel.textShadowXShift = textShadowXShift;
  labelInfoModel.textShadowYShift = textShadowYShift;
  labelInfoModel.textShadowColor = textShadowColor;
  labelInfoModel.textShadowBlurRadius = textShadowBlurRadius;
   [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```

6）字幕文本描边
```
	// groupId默认为GROUP_ID_SUBTITLE
	// effectIndex为同类型中第几个效果
	// textIndex表示组合字幕中的第几个字幕
	XYEffectVisionTextModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectVisionTextUpdate;
      XYEffectVisionSubTitleLabelInfoModel *labelInfoModel = currentEffectModel.multiTextList[textIndex];
  labelInfoModel.textStrokeColor = textStrokeColor;
    labelInfoModel.textStrokeWPercent = textStrokeWPercent;
   [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```
7）字幕对齐方式
```
	// groupId默认为GROUP_ID_SUBTITLE
	// effectIndex为同类型中第几个效果
	// textIndex表示组合字幕中的第几个字幕
        // textAlignment XYEffectVisionTextAlignment
	XYEffectVisionTextModel *currentEffectModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
    currentEffectModel.taskID = XYCommonEngineTaskIDEffectVisionTextUpdate;
      XYEffectVisionSubTitleLabelInfoModel *labelInfoModel = currentEffectModel.multiTextList[textIndex];
  labelInfoModel.textAlignment = textAlignment;
   [XYEngineWorkspace effectMgr] runTask:currentEffectModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {     }];
```
8）获取字幕素材配置信息
```
NSArray <XYTemplateXtyInfo *>*list = [[XYTemplateDataMgr sharedInstance] requestTemplateTextInfoWithTemplateID:templateID];

```
#### 7. 导出
```
  /**
   * 开始导出
   *
   */
```
XYProjectExportConfiguration 参数说明：
| 名称  | 解释 | 类型 |
| :-: | :-: | :-: |
| projectType | 工程的类型 | XYProjectType |
| exportFilePath | 导出文件路径，需要带后缀，提取音频则只支持m4a | String |
| width | 导出宽 | NSInteger |
| height | 导出高 | NSInteger |
| isGIF | 是否导出Gif图片 | BOOL |
| bitrateRatio | 自定义比特率系数, [1, 10],默认1 | CGFloat |
| fps | 自定义帧率,  默认30 | int |
| isFullKeyFrame | 是否纯i帧，只支持转码时使用 | boolean |
| trimRange | 导出时间区域 | XYVeRangeModel |
| resolution |导出分辨率类型 | XYEngineResolution |


XYProjectExportMgr 导出管理类说明：
```
@interface XYProjectExportMgr : NSObject
 /// 导出视频
/// @param config 导出配置参数
/// @param start 导出开始 主线程
/// @param progress 导出进度 主线程
/// @param success 导出成功 主线程
/// @param failure 导出失败 主线程
- (void)exportWithConfig:(XYProjectExportConfiguration *)config
                   start:(export_start_block)start
                progress:(export_progress_block)progress
                 success:(export_success_block)success
                 failure:(export_failure_block)failure;
		 //
 XYProjectExportConfiguration *config = [[XYProjectExportConfiguration alloc] init];
   config.resolution = XYEngineResolution480;
        NSString *exportFolder = [NSString stringWithFormat:@"%@/public",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]];
        [NSFileManager qvmedi_createFolderWithPath:exportFolder];
    NSString *exportFileName = @"video.mp4";
    exportFileName = [NSString stringWithFormat:@"%@%@",[NSDate date],exportFileName];
        NSString *exportFileFullPath = [NSString stringWithFormat:@"%@/%@",exportFolder, exportFileName];
        config.exportFilePath = exportFileFullPath;
        [[XYEngineWorkspace exportMgr] exportWithConfig:config start:^{
            
        } progress:^(NSInteger currentTime, NSInteger totalTime) {
        } success:^{
            
        } failure:^(XYProjectExportResultType result, NSInteger errorCode, NSString *error) {
        }];	 

/// 取消导出
- (void)cancel;

```

### 六、卡点视频工程功能开发接入

#### 1. 卡点视频工程
##### 创建和加载
```
   /**
   * 创建新的卡点视频工程
   */
  __block NSMutableArray *medias = [NSMutableArray array];
  XYSlideShowMedia *mediaModel = [[XYSlideShowMedia alloc] initWithMediaPath:[XYSlideShowMedia getMediaPathForEngine:phAsset] mediaTyp:(XYAssetMediaTypeImage == obj.mediaType ? XYSlideShowMediaTypeImage : XYSlideShowMediaTypeVideo)];
  [medias addObject:mediaModel];

  [[XYSlideShowEditor sharedInstance] createProjectWithThemeId:templateID medias:medias complete:^(BOOL success) {
  }];

  /**
   * 加载卡点视频工程
   */
        [[XYSlideShowEditor sharedInstance] loadProject:projectFilePath success:^{
            
        } failure:^(NSError * _Nonnull error) {
            
        }];


```

##### 工程删除
【详情请参看剪辑工程工程删除相关。】

#### 2. 播放器
【详情请参看剪辑工程播放器相关。】

#### 3. 获取片段节点信息
NSArray XYSlideShowSourceNode *> *nodeList = [XYSlideShowEditor sharedInstance].clipMgr fetchSlideShowSourceNodes]

#### 4. 卡点视频剪辑功能接口
1）排序
```
	// 将from位置的片段移动到to位置
	    [[XYSlideShowEditor sharedInstance].clipMgr moveSource:from dstIndex:to];
```

2）替换
```
	// clipIndex表示第几个片段，从0开始
	 PHAsset *phAsset;
    XYSlideShowMedia *media = [[XYSlideShowMedia alloc] initWithMediaPath:[XYSlideShowMedia getMediaPathForEngine:phAsset] mediaTyp:XYSlideShowMediaTypeImage];
    [[XYSlideShowEditor sharedInstance].clipMgr replaceSourceIdx:clipIndex media:media success:^{
        
    } failure:^(NSError * _Nonnull error, NSInteger code) {
        
    }];
```

#### 5. 导出
【详情请参看剪辑工程导出相关。】


### 七、 缩略图获取
##### 1. 工程相关缩略图获取
```
  /**
   * 获取工程封面
   */
           [[XYVideoThumbnailManager manager] fetchVideoCoverThumbnailsWithThumbnailSize:CGSizeMake(320, 480) block:^(UIImage * _Nonnull image) {
            
        }];
 /**
   * 获取视频的缩略图
   */
   NSInteger seekPosition = 0;
[[XYVideoThumbnailManager manager] fetchThumbnailsWithThumbnailSize:CGSizeMake(60, 60) seekPosition:seekPosition block:^(UIImage * _Nonnull image) {
            }
        }];
        
 /**
   * 片段clip的缩略图
   * clipIdentifier clip的identifier
   */
   XYClipThumbnailManager *thumbnailManager = [XYClipThumbnailManager new];
   [thumbnailManager thumbnailWithClipIdentifier:identifier  inputBlock:^(XYVivaEditorThumbnailInputModel * _Nonnull inputModel) {
       inputModel.seekPosition = beginTime;
    } completeBlock:^(XYVivaEditorThumbnailCompleteModel * _Nonnull completeModel) {
      
        }
    } placeholderBlock:^(XYVivaEditorThumbnailCompleteModel * _Nonnull completeModel) {
    }];

```

##### 2.素材缩略图获取
```
	XYEffectVisionModel *visionModel = [[[XYEngineWorkspace effectMgr] effectModels:(groupID)] objectAtIndex:effectIndex];
  UIImage * decoratorImage = [XYCommonEngineRequest requestTemplateThumbnail:visionModel size:CGSizeMake(50, 50)];

  /**
   * 获取视频文件缩略图 如画中画
   * identifier effect的identifier
   */
      XYClipThumbnailManager *thumbnailManager = [XYClipThumbnailManager new];
  [thumbnailManager thumbnailWithEffectIdentifier:identifier inputBlock:^(XYVivaEditorThumbnailInputModel * _Nonnull inputModel) {
        inputModel.beginTime = beginTime;
        inputModel.endTime = endTime;
        inputModel.seekPosition = beginTime;
    } completeBlock:^(XYVivaEditorThumbnailCompleteModel * _Nonnull completeModel) {
    } placeholderBlock:^(XYVivaEditorThumbnailCompleteModel * _Nonnull completeModel) {
    }];
```
### 八、Camera接入文档
1. 初始化
1.1 初始化XYCameraDevice
```
#pragma mark - 初始化CameraDevice
- (void)initCameraDevice {
    if (self.cameraDevice) {
        return;
    }
    self.cameraDevice = [XYCameraDevice new];
    
    [self.cameraDevice initCameraDeviceWithParamMaker:^(XYCameraDeviceParamMaker * _Nonnull paramMaker) {
        paramMaker.captureSessionPreset(AVCaptureSessionPreset1280x720);//设置分辨率
        paramMaker.devicePosition(AVCaptureDevicePositionBack);//设置初始镜头方向
    }];
}
```
1.2 初始化XYCameraEngine
```
⚠️需要在能够拿到预览的view的frame size之后再初始化XYCameraEngine
#pragma mark - 初始化CameraEngine
- (void)initCameraEngine {
    if (self.cameraEngine) {
        return;
    }
    self.cameraEngine = [XYCameraEngine new];
    
    NSString *licensePath = [[NSBundle mainBundle] pathForResource:@"license" ofType:@"txt"];
    
    [self.cameraEngine initCameraEngineWithParamMaker:^(XYCameraEngineParamMaker * _Nonnull paramMaker) {
        paramMaker.cXiaoYingEngine([[XYEngine sharedXYEngine] getCXiaoYingEngine]);//传入CXiaoYingEngine
        paramMaker.enableMetal(YES);//是否启用Metal
	paramMaker.enableDepth(YES);//是否启用深度信息
        paramMaker.previewView(self.fullSceenPreviewView);//预览用的view
        paramMaker.inputResolutionSize(CGSizeMake(1280, 720)).outputResolutionSize(CGSizeMake(1280, 720));//设置输入输入的分辨率
        paramMaker.renderRegionRect(self.fullSceenPreviewView.bounds);//用于在预览view上渲染的区域
        paramMaker.deviceOrientation(UIDeviceOrientationPortrait);//设备方向
        paramMaker.templateAdapter([XYTemplateDataMgr sharedInstance]);//用于处理模版相关的回调
        paramMaker.fbTemplateFilepath([[XYTemplateDataMgr sharedInstance] getByID:0x4400000000180001].strPath);//美颜模版的路径
        paramMaker.fbTemplateID(0x4400000000180001);//美颜模版的ID
        paramMaker.licensePath(licensePath);//License路径
    }];
    self.cameraDevice.cameraDeviceDelegate = self.cameraEngine;//SampleBuffer的delegate由CameraEngine来处理
    self.cameraEngine.cameraEngineDelegate = self;//CameraEngine的回调处理
}

/// CameraEngine的状态回调
/// @param stateModel CameraEngine当前状态Model
- (void)onCameraEngineStateUpdate:(XYCameraEngineStateModel *)stateModel {
    //stateModel中主要关心2个数据
    //当前CameraEngine的状态信息: 预览中，录制中，暂停中
    XYCameraEngineRecordState stateModel.recordState = stateModel.recordState;
    //当前已录制视频总时长
    NSInteger totalDuration = stateModel. totalDuration;
}
```

1.3 启动CameraSession
在viewWillAppear的时候就可以启动CameraSession
```
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cameraDevice startSession];//启动CameraSession，成功后可看到画面
}
```
1.4 销毁CameraEngine
⚠️UIViewController dealloc的时候需要手动销毁CameraEngine
```
- (void)dealloc {
    NSLog(@"XYEngineCameraVC dealloc");
    [_cameraEngine uninitCameraEngine];
}
```
2. XYCameraDevice相关功能使用
2.1 切换前后摄像头
 
```
//切换前后摄像头
- (void)onSwapCameraBtnClick {
    if (self.cameraDevice.firstCameraParam.devicePosition == AVCaptureDevicePositionFront) {
        [self.cameraDevice swapCamera:AVCaptureDevicePositionBack];
    } else {
        [self.cameraDevice swapCamera:AVCaptureDevicePositionFront];
    }
}

```
2.2 设置对焦点
 
```
/// 点击屏幕设置对焦点
/// @param touchPoint 点击位置相对于预览区域的坐标
/// @param previewAreaRect 预览区域rect
- (void)setFocusPointWithTouchPoint:(CGPoint)touchPoint previewAreaRect:(CGRect)previewAreaRect;

//示例代码
- (void)onTapGesture:(UITapGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:[gesture view]];
    CGRect previewAreaRect = self.fullSceenPreviewView.frame;
    BOOL isTouchInThePreviewArea = CGRectContainsPoint(previewAreaRect, touchPoint);
    if (!isTouchInThePreviewArea) {//没有点在预览区域，忽略该点击
        return;
    }
    [self.cameraDevice setFocusPointWithTouchPoint:touchPoint previewAreaRect:previewAreaRect];
}

```
2.3 开关闪光灯
 
```
//开关闪光灯
- (void)onFlashBtnClick {
    if (self.cameraDevice.torchMode == AVCaptureTorchModeOff) {
        self.cameraDevice.torchMode = AVCaptureTorchModeOn;
    } else {
        self.cameraDevice.torchMode = AVCaptureTorchModeOff;
    }
}

```
2.4 调节曝光程度
 
```
#pragma mark - 调节曝光程度
- (void)onExposureBiasChanged:(float)level {
    self.cameraDevice.exposureBias = level;//调节范围[-2.0, 2.0]
}

```
3. XYCameraEngine相关功能使用
3.1 开始录制
 
```
   [self.cameraEngine startRecordWithParamMaker:^(XYCameraRecordParamMaker * _Nonnull paramMaker) {
   paramMaker.clipFilePath(self.videoClipFilePath);//录制文件保存路径
   paramMaker.hasAudioTrack(YES);//录制文件是否包含音轨
   paramMaker.PCMSampleRate(44100);//音频采样率
   paramMaker.PCMChannels(2);//音频声道数
   paramMaker.maxFrameRate(30);//最大帧率
        }];

```

3.2 暂停录制
 
```
   [self.cameraEngine pauseRecord];

```
3.3 继续录制
 
```
[self.cameraEngine resumeRecord];
```
3.4 停止录制
 
```
[self.cameraEngine stopRecord];

//完成录制后，可从self.cameraEngine.cameraClipModels获取数据，然后添加到工程中，可参考代码
- (void)insertClips:(NSArray<XYCameraClipModel *> *)cameraClipModels index:(NSInteger)index {
    NSMutableArray<XYClipModel *> *clipModels = [NSMutableArray array];
    [cameraClipModels enumerateObjectsUsingBlock:^(XYCameraClipModel * _Nonnull cameraClipModel, NSUInteger idx, BOOL * _Nonnull stop) {
        XYClipModel *clipModel = [[XYClipModel alloc] init];
        clipModel.sourceVeRange.dwPos = cameraClipModel.startPos;
        clipModel.sourceVeRange.dwLen = cameraClipModel.endPos - cameraClipModel.startPos;
        clipModel.clipFilePath = cameraClipModel.clipFilePath;
        clipModel.rotation = cameraClipModel.rotation;
        clipModel.clipIndex = index + idx;
        [clipModels addObject:clipModel];
    }];
    
    XYClipModel *taskModel = [[XYClipModel alloc] init];
    taskModel.taskID = XYCommonEngineTaskIDClipAddClip;
    taskModel.clipModels = clipModels;
    [[XYEngineWorkspace clipMgr] runTask:taskModel completionBlock:^(BOOL success, NSError * _Nonnull error, id  _Nonnull obj) {
    }];
    __weak typeof(self) weakSelf = self;
    [[XYEngineWorkspace clipMgr] addObserver:self observerID:XYCommonEngineTaskIDClipAddClip block:^(id  _Nonnull obj) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}
```
3.5 拍照
 
```
/// 拍照（分辨率等于录制视频的分辨率，也就是outPutResolution）
/// @param filePath 拍照文件保存地址
/// @param isOriginal 是否原始图像，不包括效果（滤镜，美颜等效果）
- (void)captureWithFilePath:(NSString *)filePath isOriginal:(BOOL)isOriginal;
```
3.6 删除最后一个已拍镜头
 
```
/// 删除最后一个镜头
- (void)deleteCameraClip;
```

3.7 设置滤镜
 
```
/// 设置滤镜模版
/// @param templateFilePath 模版文件地址
- (void)setFilterTemplate:(NSString *)templateFilePath;
```
3.8 设置美颜
3.8.1 启用美颜
 
```
self.cameraEngine.enableFaceBeauty
```

3.8.2 调节美颜程度
 
```
self.cameraEngine.faceBeautyLevel = 0.5;//[0, 1]
```
4.9 缩放
 
```
self.cameraEngine.zoomLevel = 2.0;//[1.0, 4.0]
```

### 九、其它
```
  /**
   * 视频倒放
   *
   * @param filePath 原始文件全路径。
   * exportFilePath 导出后的文件路径
   */
 [[XYEngineWorkspace exportMgr] reverseWithFilePath:filePath exportFilePath:exportFilePath progress:^(NSInteger currentTime, NSInteger totalTime) {
        
    } success:^{
        
    } failure:^(XYProjectExportResultType result, NSInteger errorCode) {
        
    }];

```
## Author

Sunshine, cheng.xia@quvideo.com

## License

QVEditorKit is available under the MIT license. See the LICENSE file for more info.






