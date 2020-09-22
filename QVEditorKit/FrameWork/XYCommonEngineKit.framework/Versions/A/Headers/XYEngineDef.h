//
//  XYEngineDef.h
//  XYVivaVideoEngineKit
//
//  Created by 徐新元 on 2018/7/9.
//

#ifndef XYEngineDef_h
#define XYEngineDef_h

//Layers
#define LAYER_ID_DEFAULT 0.0f
#define LAYER_ID_VIDEO_PARAM_ADJUST_EFFECT 1.2f //参数调节
#define LAYER_ID_VIDEO_PARAM_CURVE_COLOR_EFFECT 1.3f //曲线调色

#define LAYER_ID_ANIMATION_FILTER_EFFECT 0.7f                 //动画滤镜
#define LAYER_ID_EFFECT 1.0f                    //调色滤镜
#define LAYER_ID_FX_EFFECT 1.5f                 //特效滤镜

//audio
#define LAYER_ID_PANZOOM -1.5f                    //背景颜色 缩放

#define LAYER_ID_DUB 2.0f                       //音效
#define LAYER_ID_RECORD 3.0f                    //录音
#define LAYER_ID_BGM 4.0f                       //配乐
//vision
#define LAYER_ID_COLLAGE 50.0f                  //画中画
#define LAYER_ID_ANIMATED_FRAME 100.0f          //特效
#define LAYER_ID_STICKER 200.0f                 //贴纸
#define LAYER_ID_MOSAIC  40.0f                  //马赛克
#define LAYER_ID_SUBTITLE 1000.0f               //字幕
#define LAYER_ID_WATERMARK 1500.0f                //水印
#define LAYER_ID_NEW_WATERMARK 9999999.0f            //水印 层级最高 不被所有效果遮挡

//同一时间点添加多个效果时，需要加在不同的层，这个定义就是每一层之间的最小间隔

#define LAYER_ID_VISION_BASE 10000 //可视效果layer id base
#define LAYER_ID_EVERY_CELL_ADDEND 1000// layer id 每个分组累加单元为1000 每个单元最大支持1000 个
#define LAYER_ID_ADDEND 1 //每个layer id 分组下最大支持1000 个 (0 - 1000] 半开区间

#define SUB_TYPE_PIC_IN_PIC_FX_MIN 1000 //画中画特效的起始type
#define SUB_TYPE_PIC_IN_PIC_FX_MAX 2000 //画中画特效的最大type
#define SUB_TYPE_PIC_IN_PIC_ADJUST 100 //画中画参数调节
#define SUB_TYPE_PIC_IN_PIC_COLOR_CURVE 101 //画中画曲线调色

//Groups
#define GROUP_ID_DEFAULT 0
#define GROUP_ID_BGMUSIC 1                      //配乐
#define GROUP_ID_DUBBING 4                      //音效
#define GROUP_ID_RECORD  11                      //录音
#define GROUP_IMAGING_EFFECT 2                 //滤镜
#define GROUP_TEXT_FRAME 3                      //字幕


#define GROUP_ANIMATED_FRAME 6                  //特效
#define GROUP_STICKER 8                         //贴纸
#define GROUP_ID_MOSAIC 40                      //马赛克
#define GROUP_ID_WATERMARK 50                   //水印
#define GROUP_COVER_TITLE 0xFFFFFFFF            //封面文字
#define GROUP_ID_VIDEO_PARAM_ADJUST_EFFECT 105  //滤镜参数调节
#define GROUP_ID_VIDEO_PARAM_CURVE_COLOR_EFFECT 106  //clip 曲线调色

#define GROUP_ID_THEME_TEXT_ANIMATION -8        //主题动画文字
#define GROUP_ID_COLLAGE 20                     //画中画
#define GROUP_ID_VIDEO_PARAM_ADJUST_PANZOOM -10 //比例调节里的Panzoom效果，C D E模版
#define GROUP_ID_VIDEO_PARAM_ANIM_PANZOOM -3    //镜头编辑里的图片动画效果，4B00000000000003模版


//主题的
#define GROUP_THEME_TEXT_FRAME 4                //主题文字
#define GROUP_ID_THEME_FILTER -4                 //主题里的滤镜
#define GROUP_ID_FX_FILTER 15                 //特效滤镜
#define GROUP_ID_ANIMATION_FILTER 200                 //动画滤镜
#define GROUP_ID_LYRICS 100 //歌词字幕
//支持的最小的trim时长
#define VIVAVIDEO_MINIMUM_TRIM_RANGE 500 //ms

//马赛克高斯模糊最大值  (0~200)
#define VIVAVIDEO_MOSAIC_GAUSSIAN_MAX_VALUE  60
//马赛克像素化最大比例    (1~10000)
#define VIVAVIDEO_MOSAIC_PIXEL_MAX_RATIO     0.25
//马赛克像素化最小值
#define VIVAVIDEO_MOSAIC_PIXEL_MIN_VALUE     10

//效果插件的sub type 最小值
#define EFFECT_SUB_TYPE_MIN     5000

//效果插件的sub type 最大值
#define EFFECT_SUB_TYPE_MAX     6000

#define XY_CUSTOM_COVER_BACK_IDENTIFIER    @"xy_custom_cover_back_identifier"


//主题上文字类型
typedef enum : NSUInteger {
	ThemeTextTypeNone,
	ThemeTextTypeFrontCover,
	ThemeTextTypeBackCover,
	ThemeTextTypeStoryboard,
	ThemeTextTypeStoryboardAnim,
} ThemeTextType;



#endif /* XYEngineDef_h */
