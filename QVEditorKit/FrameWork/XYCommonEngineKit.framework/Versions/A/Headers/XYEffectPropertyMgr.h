//
//  XYEffectPropertyItem.h
//  XiaoYingSDK
//
//  Created by xuxinyuan on 12/25/14.
//  Copyright (c) 2014 XiaoYing. All rights reserved.
//

#import "XYBaseCopyModel.h"

typedef NS_ENUM(NSInteger, XYCommonEngineAdjustType) {
    XYCommonEngineAdjustTypeBrightness,//亮度
    XYCommonEngineAdjustTypeContrast,//对比度
    XYCommonEngineAdjustTypeSaturation,//饱和度
    XYCommonEngineAdjustTypeSharpen,//锐度
    XYCommonEngineAdjustTypeTemperature,//色温
    XYCommonEngineAdjustTypeVignette,//暗角
    XYCommonEngineAdjustTypeHue,//色调
    XYCommonEngineAdjustTypeShadow,//阴影
    XYCommonEngineAdjustTypeHighlight,//高光
    XYCommonEngineAdjustTypeFade,//褪色
    XYCommonEngineAdjustTypeNoise,//噪点
};

@interface XYAdjustItem : XYBaseCopyModel
@property (nonatomic, assign) XYCommonEngineAdjustType adjustType;
@property MDWord dwID;
@property MLong dwDefaultValue;
@property MLong dwPreviousValue;
@property MLong dwCurrentValue;//值的范围 [0-100];
@property MLong dwMinValue;
@property MLong dwMaxValue;
@property (nonatomic, strong) NSString *nameEn;
@property (nonatomic, strong) NSString *iconImagePath;
@property (nonatomic, strong) NSString *nameLocale;
@end

/**
 滤镜参数调节设置类
 */
@interface XYEffectPropertyMgr : NSObject

+ (MDWord)getEffectPropertyItemsCount:(MInt64)ltemplateID;

+ (XYAdjustItem *)getEffectPropertyItem:(MInt64)ltemplateID
                                    dwItemIndex:(MDWord)dwItemIndex;

+ (NSArray<XYAdjustItem *> *)getEffectPropertyItemsWithTemplateID:(MInt64)ltemplateID;

+ (NSArray<XYAdjustItem *> *)getEffectPropertyItemsWithEffectPropertyInfo:(CXYEffectpropertyInfo *)effectPropertyInfo;

@end
