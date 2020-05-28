//
//  XYEngineEnum.h
//  Pods
//
//  Created by 夏澄 on 2019/10/23.
//

#ifndef XYEngineEnum_h
#define XYEngineEnum_h
#import "XYEngineDef.h"

typedef NS_ENUM(NSInteger, XYCommonEngineClipModuleType) {
    XYCommonEngineClipModuleImage = AMVE_IMAGE_CLIP,
    XYCommonEngineClipModuleVideo = AMVE_VIDEO_CLIP,
    XYCommonEngineClipModuleGif = AMVE_GIF_CLIP,
    XYCommonEngineClipModuleThemeCoverFront = 111110,//主题片头
    XYCommonEngineClipModuleThemeCoverBack = 111111,//主题片尾
    XYCommonEngineClipModuleCustomCoverBack = 111112,//自定义片尾
};

typedef NS_ENUM(NSInteger, XYCommonEngineTaskID) {
    XYCommonEngineTaskNone,
    //获取引擎数据 不在内存中能拿到的数据 需引擎取
    XYCommonEngineTaskIDAchieveEngineTaskHandle = 0,
    XYCommonEngineTaskIDObserverEveryTaskStart,//每个引擎操作开始前回调 ⚠️注意回调是在子线程
    XYCommonEngineTaskIDObserverEveryTaskFinish,//每个引擎操作完成后回调 ⚠️注意回调是在子线程
    XYCommonEngineTaskIDFinanceObserverEveryTaskFinish,//每个引擎操作完成后回调 ⚠️注意回调是在子线程 ⚠️ 给变现用
    XYCommonEngineTaskIDObserverTempWorkspaceEveryTaskFinish,
    XYCommonEngineTaskIDObserverTempWorkspaceEveryTaskFinishDispatchMain,//每个引擎操作完成后回调 ⚠️注意回调是在主线程 且引擎线程任务都执行完了
    XYCommonEngineTaskIDObserverEveryTaskFinishDispatchMain,//每个引擎操作完成后回调 ⚠️注意回调是在主线程 且引擎线程任务都执行完了
    XYCommonEngineTaskIDFinanceObserverEveryTaskForPlayerFinish,//每个引擎操作完成后回调 ⚠️注意回调是在子线程 ⚠️专门给播放器用
    
    //storyboard 相关taskID========================================================================storyboard 相关taskID
    XYCommonEngineTaskIDStoryboardWillSwitch,//将要切换工作站的 storyboard 销毁播放器
    XYCommonEngineTaskIDStoryboardSwitch,//切换工作站的 storyboard
    XYCommonEngineTaskIDStoryboardAddTheme,//对应 需要的参数,themePath 2.themeSize;//从主题素材中得到需要改变storyboard的尺寸
    XYCommonEngineTaskIDStoryboardUpdateThemeText,// 对应 需要的参数,TextInfo model
    XYCommonEngineTaskIDStoryboardRatio,//比例 对应 需要的参数 1.ratioValue  2.isPropRatioSelected;//是否设置了比例 如原比例为NO 非原比例 YES
    XYCommonEngineTaskIDStoryboardUndo,//undo
    XYCommonEngineTaskIDStoryboardRedo,//redo
    XYCommonEngineTaskIDStoryboardBackUp,//back up 备份
    XYCommonEngineTaskIDStoryboardReset,//Reset 重置掉备份后的所有的改动
    
    //clip 相关taskID========================================================================clip 相关taskID
    
    XYCommonEngineTaskIDClipAddClip,
    XYCommonEngineTaskIDClipMuteState,//设置声音是否开启  需要的参数 isMute
    XYCommonEngineTaskIDClipUpdateVolume,//修改原clip的声音大小 需要的参数 volumeValue
    XYCommonEngineTaskIDClipFilterAdd,//添加滤镜 需要的参数 clipEffectModel对象设置值 1. 对应的FilterFilePath 2. 对应的FilterAlpha 0～1.0  3. effectConfigIndex 对应素材的TemplateItemData 的 nConfigureCount 4.groupID <XYCommonEngineGroupIDColorFilter 调色滤镜 XYCommonEngineGroupIDThemeFilter 特色滤镜 XYCommonEngineGroupIDThemeFilter 主题滤镜>
    XYCommonEngineTaskIDClipFilterUpdateAlpha,//修改滤镜程度 需要的参数 1. 对应的FilterAlpha 0～1.0 2.<XYCommonEngineGroupIDColorFilter 调色滤镜 XYCommonEngineGroupIDThemeFilter 特色滤镜 XYCommonEngineGroupIDThemeFilter 主题滤镜>
    XYCommonEngineTaskIDClipVoiceChange,//变声 需要的参数 voiceChangeValue
    XYCommonEngineTaskIDClipAdjustUpdate,//参数调节   1.adjustItem dwCurrentValue
    XYCommonEngineTaskIDClipSpeed,//变速 1. speedValue 2.iskeepTone//是否保持原声调 调用变速前需要判断设置后clip时长是否>=VIVAVIDEO_MINIMUM_TRIM_RANGE。 设置后需要重新计算效果
    //比例背景相关
    XYCommonEngineTaskIDClipMirror,//镜像 参数设置 clipPropertyData.isMirror //yes 镜像 in no 非镜像
    XYCommonEngineTaskIDClipFit,//比例fit In fit Out 参数 1.0 clipPropertyData.isFitIn //yes fit in no fit out
    XYCommonEngineTaskIDClipBackgroundBlur, //背景模糊 参数 1.0 clipPropertyData.backgroundBlurValue 引擎的默认值是 50  值范围 0~100
    XYCommonEngineTaskIDClipBackgroundColor, //背景颜色 参数  1. clipPropertyData.backgroundColorStartValue;//背景颜色 渐变起始颜色 格式（0Xffffff） 2.clipPropertyData.backgroundColorEndValue;//背景颜色 渐变结束颜色 格式（0Xffffff）3clipPropertyData.linearGradientAngle; //线性渐变的角度 默认为水平方向，取值范围：0~90，对应的角度：0~90，单位为°
    XYCommonEngineTaskIDClipUpdateGradientAngle,//修改背景颜色的线性渐变的角度 对应的参数 1.clipPropertyData.linearGradientAngle 取值范围：0~360，对应的角度：0~360，单位为°
    XYCommonEngineTaskIDClipBackgroundImage, //设置背景图片。参数 1. clipPropertyData.backImagePath 设置默认背景图片 传nil
    XYCommonEngineTaskIDClipBackgroundImageBlur,  //背景图片模糊 参数 1.0 clipPropertyData.backgroundBlurValue 值范围 0~100

    XYCommonEngineTaskIDClipGesturePan, //移动 属性都在clipPropertyData这个对象里  需要的参数 1.shiftX 2.shiftY（没做移动默认值都是1,shiftX 是移动的X除以播放器的的宽(playbackView.width),shiftY同理）
    XYCommonEngineTaskIDClipGesturePinch, //缩放  属性都在clipPropertyData这个对象里 需要的参数 scale (没做缩放默认值是1)
    XYCommonEngineTaskIDClipGestureRotation, //旋转 属性都在clipPropertyData这个对象里  需要的参数 angleZ 0~360，没做旋转默认是0
    
    XYCommonEngineTaskIDClipCut,//剪多短  参数 1. NSArray <XYClipModel*> * trimModels 设置trimVeRange值;  用XYClipModel这里有对应的 identifier 为了更好赋值给对应timeline的identifier  设置后需要重新计算效果，
    XYCommonEngineTaskIDClipTrim,//trim 参数 1. trimVeRange  设置后需要重新计算效果
    XYCommonEngineTaskIDClipTransition,//转场 需要的参数 往clipEffectModel对象设置值 1. transFilePath
    XYCommonEngineTaskIDClipSplit,//分割 需要的参数 1.新建一个 XYClipModel 再将model赋值给 duplicateClipModel 2.给新的model 赋值 splitClipPostion
    XYCommonEngineTaskIDClipReverse,//镜头倒放
    XYCommonEngineTaskIDClipDuplicate,//镜头复制   需要的参数 1.新建一个 XYClipModel model 里面有identifier 赋给timeline 再将model赋值给 duplicateClipModel
    XYCommonEngineTaskIDClipDelete,//镜头删除
    XYCommonEngineTaskIDClipExchange,//镜头交换顺序 1.sourceIndex 2.destinationIndex
    XYCommonEngineTaskIDClipPhotoAnimation,//镜头 图片动画 clipPropertyData.isAnimationON YES 开启动画  ，NO 关闭动画
    XYCommonEngineTaskIDClipCoverBackAdd,//backCovers
    XYCommonEngineTaskIDClipCoverBackUpdate,//backCovers
    XYCommonEngineTaskIDClipRatioBgmRset,//需要的参数 angleZ 0~360 2.scale 3.shiftX 4.shiftY
    XYCommonEngineTaskIDClipAudioNSX,//音频降噪功能是否开启，默认关
    
    XYCommonEngineTaskIDClipReplaceSource,//clip 路径替换
    
    
    
    //Project 相关taskID========================================================================Project 相关taskID
    XYCommonEngineTaskIDQProjectCreate,//创建新工程
    XYCommonEngineTaskIDQProjectSaveProject,//prjFilePath
    XYCommonEngineTaskIDQProjectLoadProject,//prjFilePath
    XYCommonEngineTaskIDProjectMemoryDataLoadFinish,

    
    
    //effect 相关taskID========================================================================effect 相关taskID
    
    
    //背景音乐相关的
    
    XYCommonEngineTaskIDEffectAddBgmMusic,// 对应 需要的参数,1. filePath 音乐的路径 2. mTrimVeRange 3.mDestVeRange 开始的时间和结束时间。5. title 音乐名称 5.groupID = XYCommonEngineGroupIDBgmMisic 6.isRepeatON
    XYCommonEngineTaskIDEffectDeleteBgmMusic,//对应 需要的参数,
    XYCommonEngineTaskIDEffectReplaceBgmMusic,// 对应 需要的参数,1.filePath 音乐的路径  2. title 音乐名称
    XYCommonEngineTaskIDEffectBgmMusicUpdateRange,//加添加音乐id 对应 需要的参数 1.mDestVeRange 开始的时间和结束时间
    XYCommonEngineTaskIDEffectBgmUpdateAudioVolume,// 对应 需要的参数 1.volumeValue
    XYCommonEngineTaskIDEffectBgmFadeIn,//音乐淡入 对应 需要的参数 1.isFadeON 2.0 2.0 fadeDuration 默认2000 默认2000
    XYCommonEngineTaskIDEffectBgmFadeOut,//音乐淡出 对应 需要的参数 1.isFadeOutON 2.0 fadeDuration 默认2000
    XYCommonEngineTaskIDEffectBgmSetRepeat,// 对应 需要的参数 1.isRepeatON
    XYCommonEngineTaskIDEffectBgmMusicTrimUpdate,//修改背景音乐的trimRange 对应 需要的参数 1.mTrimVeRange
    XYCommonEngineTaskIDEffectBgmVoiceChange,//背景音乐变声

    //音效相关的
    XYCommonEngineTaskIDEffectAddDubbing,// 对应 需要的参数,1. filePath 音乐的路径 2. mTrimVeRange 3.mDestVeRange 开始的时间和结束时间。 4. title 音乐名称 5.groupID = XYCommonEngineGroupIDDubbing
    XYCommonEngineTaskIDEffectDeleteDubbing,//
    XYCommonEngineTaskIDEffectReplaceDubbing,// 对应 需要的参数,1.filePath 音乐的路径 2. title 音乐名称
    XYCommonEngineTaskIDEffectDubbingUpdateRange,// 对应 需要的参数 1.mDestVeRange 开始的时间和结束时间
    XYCommonEngineTaskIDEffectDuplicateDubbing,// 对应 需要的参数  new 新的model 1.mDestVeRange 开始的时间和结束时间 新的赋值给duplicateClipModel
    XYCommonEngineTaskIDEffectDubbingUpdateAudioVolume,// 对应 需要的参数 1.volumeValue
    //音乐淡入
    XYCommonEngineTaskIDEffectDubbingFadeIn,// 对应 需要的参数 1.isFadeON 2.0 fadeDuration 默认2000
    //音乐淡出
    XYCommonEngineTaskIDEffectDubbingFadeOut,// 对应 需要的参数 1.isFadeOutON 2.0 fadeDuration 默认2000
    XYCommonEngineTaskIDEffectDubbingVoiceChange,//音效变声
    //录音相关的
    XYCommonEngineTaskIDEffectAddRecord,// 对应 需要的参数,1. filePath 音乐的路径 2. mTrimVeRange 3. mDestVeRange 开始的时间和结束时间。4. title 音乐名称 5.groupID = XYCommonEngineGroupIDRecord
    XYCommonEngineTaskIDEffectDeleteRecord,//删除录音
    XYCommonEngineTaskIDEffectRecordUpdateRange,//对应 需要的参数 1.mDestVeRange 开始的时间和结束时间
    XYCommonEngineTaskIDEffectDuplicateRecord,// 对应 需要的参数  new 新的model 1.mDestVeRange 开始的时间和结束时间 新的赋值给duplicateClipModel
    XYCommonEngineTaskIDEffectRecordUpdateAudioVolume,// 对应 需要的参数 1.volumeValue
    XYCommonEngineTaskIDEffectRecordFadeIn,//录音淡入 对应 需要的参数 1.isFadeON 2.0 2.0 fadeDuration 默认2000 默认2000
    XYCommonEngineTaskIDEffectRecordFadeOut,//录音淡出 对应 需要的参数 1.isFadeOutON 2.0 fadeDuration 默认2000
    XYCommonEngineTaskIDEffectRecordTrimUpdate,//修改录音的trimRange 对应 需要的参数 1.mTrimVeRange
    XYCommonEngineTaskIDEffectRecordVoiceChange,//录音变声

    XYCommonEngineTaskIDEffectBgmRetThemeAudio,//恢复主题带的音乐 参数 1. groupid = XYCommonEngineGroupIDBgmMusic

    
     //可视效果 相关taskID========================================================================可视效果 相关taskID
    //可视效果-贴纸,特效，画中画,自定义水印
    XYCommonEngineTaskIDEffectVisionAdd,  //添加可视效果 用这个model：XYEffectVisionModel 需要的参数 1.groupID 2.filePath 3.mDestVeRange.dwPos 起始点 默认有长度
    XYCommonEngineTaskIDEffectVisionUpdate,  //更新可视效果 用这个model：XYEffectVisionModel 里面的参数都可以修改
    XYCommonEngineTaskIDEffectVisionDuplicate, //复制一个可视效果
    XYCommonEngineTaskIDEffectVisionDelete,  //删除可视效果 用这个model：XYEffectVisionModel 需要确保pEffect有值
    //可视效果-字幕
    XYCommonEngineTaskIDEffectVisionTextAdd,  //添加字幕效果 用这个model：XYEffectVisionTextModel
    XYCommonEngineTaskIDEffectVisionTextUpdate,  //更新字幕效果 用这个model：XYEffectVisionTextModel 里面的参数都可以修改
    XYCommonEngineTaskIDEffectVisionDelelteKeyFrame,  //根据visionModels 删除关键帧
};

typedef NS_ENUM(MDWord, XYCommonEngineTrackType) {
    XYCommonEngineTrackTypePrimalVideo = AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO,
    XYCommonEngineTrackTypeVideo = AMVE_EFFECT_TRACK_TYPE_VIDEO,
    XYCommonEngineTrackTypeAudio = AMVE_EFFECT_TRACK_TYPE_AUDIO,
    XYCommonEngineTrackTypeFreezeFrame = AMVE_EFFECT_TRACK_TYPE_FREEZE_FRAME,
    XYCommonEngineTrackTypeLyric = AMVE_EFFECT_TRACK_TYPE_LYRIC,
};

typedef NS_ENUM(MDWord, XYCommonEngineGroupID) {
    XYCommonEngineGroupIDBgmMusic = GROUP_ID_BGMUSIC,//背景音乐分类 1
    XYCommonEngineGroupIDDubbing = GROUP_ID_DUBBING,//音效分类 4
    XYCommonEngineGroupIDRecord = GROUP_ID_RECORD,//录音分类 11
    XYCommonEngineGroupIDSticker = GROUP_STICKER,//贴纸 8
    XYCommonEngineGroupIDMosaic = GROUP_ID_MOSAIC,//马赛克 40
    XYCommonEngineGroupIDWatermark = GROUP_ID_WATERMARK,//水印 50
    XYCommonEngineGroupIDText = GROUP_TEXT_FRAME,//字幕 3
    XYCommonEngineGroupIDCollage = GROUP_ID_COLLAGE,//画中画 20
    XYCommonEngineGroupIDAnimatedFrame = GROUP_ANIMATED_FRAME,//特效 全屏的特效。
    XYCommonEngineGroupIDColorFilter = GROUP_IMAGING_EFFECT,//调色滤镜
    XYCommonEngineGroupIDThemeFilter = GROUP_ID_THEME_FILTER,//主题滤镜group
    XYCommonEngineGroupIDFXFilter = 15,//特效滤镜。

    XYCommonEngineGroupIDClip = 10000,//clip 分类
    XYCommonEngineGroupIDTheme = 10001,//主题 分类
    XYCommonEngineGroupIDTransition = 10002,//转场 分类
};

typedef NS_ENUM(NSInteger, XYCommonEngineRequestID) {
    XYCommonEngineRequestIDThemeTextList = 0,//RequestID 对应 需要的参数 playbackViewFrame 返回的值 NSArray <TextInfo *>
    XYCommonEngineRequestIDClipAdjustList,//RequestID 对应 需要的参数 clipIndex 返回的值是 NSArray <XYEffectPropertyItem *>
    XYCommonEngineRequestIDClipFilter,//RequestID 对应 需要的参数 1.clipIndex 2.groupID <XYCommonEngineGroupIDColorFilter 调色滤镜 XYCommonEngineGroupIDFXFilter 特色滤镜 XYCommonEngineGroupIDThemeFilter 主题滤镜>  返回的值是 XYClipEffectModel 对象
};

typedef NS_ENUM(NSInteger, XYCommonEngineOperationCode) {
    XYCommonEngineOperationCodeNone = 1230,
    XYCommonEngineOperationCodeAddEffect = QVET_REFRESH_STREAM_OPCODE_ADD_EFFECT,
    XYCommonEngineOperationCodeUpdateEffect = QVET_REFRESH_STREAM_OPCODE_UPDATE_EFFECT,
    XYCommonEngineOperationCodeRemoveEffect = QVET_REFRESH_STREAM_OPCODE_REMOVE_EFFECT,
    XYCommonEngineOperationCodeUpdatePanzoom = QVET_REFRESH_STREAM_OPCODE_UPDATE_PANZOOM,
    XYCommonEngineOperationCodeUpdateAllClipAllEffect = QVET_REFRESH_STREAM_OPCODE_UPDATE_ALL_CLIP_ALL_EFFECT,
    XYCommonEngineOperationCodeUpdateAllEffect = QVET_REFRESH_STREAM_OPCODE_UPDATE_ALL_EFFECT,
    XYCommonEngineOperationCodeUpdateAllMusic = QVET_REFRESH_STREAM_OPCODE_UPDATE_ALL_MUSIC,
    XYCommonEngineOperationCodeUpdateTransitons = QVET_REFRESH_STREAM_OPCODE_UPDATE_TRANSITION,
    XYCommonEngineOperationCodeAllTransitons = QVET_REFRESH_STREAM_OPCODE_UPDATE_ALL_TRANSITION,
    XYCommonEngineOperationCodeUpdateTimeScale = QVET_REFRESH_STREAM_OPCODE_UPDATE_TIME_SCALE,
    XYCommonEngineOperationCodeReOpen = QVET_REFRESH_STREAM_OPCODE_REOPEN,
    XYCommonEngineOperationCodeDisplayRefresh = 1234,
    XYCommonEngineOperationCodeRefreshAudio = 1235,
    XYCommonEngineOperationCodeReplaceEffect = 1236,
    XYCommonEngineOperationCodeReBuildPlayer = 1237,
    XYCommonEngineOperationCodeStartInstantUpdateVisionEffect = 1238,
    XYCommonEngineOperationCodeRefreshAudioEffect = 1239,
};

typedef NS_ENUM(NSInteger, XYEngineReloadTimeLineType) {
    XYEngineReloadTimeLineAll = 0,//默认会重新加载timeline
    XYEngineReloadTimeLineBySelf,
    XYEngineReloadTimeLineByNone,//无需更新timeline
};

typedef NS_ENUM(NSInteger, XYEngineUndoActionState) {
    XYEngineUndoActionStateNone = 0,//无需undo
    XYEngineUndoActionStateForcePreAdd,//暴力预置一个 前面一个会被覆盖
    XYEngineUndoActionStatePreAdd,//将目前的状态拷贝 只会预置第一个 后面不会覆盖
    XYEngineUndoActionStateSetPreAdd,//将目前的状态拷贝加入undo 堆栈 不执行引擎相关操作
    XYEngineUndoActionStateAdded,//直接将现在将要改变的状态加入到undo 堆栈
    XYEngineUndoActionStateReplaceLastOne,//undoStact替换掉最后一个
    XYEngineUndoActionStateBySelf,//不会拷贝引擎的内存数据 业务自己通过自己的参数 做undo redo

};

#endif /* XYEngineEnum_h */
