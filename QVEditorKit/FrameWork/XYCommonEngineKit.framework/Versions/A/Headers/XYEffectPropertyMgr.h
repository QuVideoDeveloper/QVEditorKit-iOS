//
//  XYEffectPropertyItem.h
//  XiaoYingSDK
//
//  Created by xuxinyuan on 12/25/14.
//  Copyright (c) 2014 XiaoYing. All rights reserved.
//

#import "XYBaseCopyModel.h"

typedef NS_ENUM(NSInteger, XYCommonEngineAdjustType) {
       XYCommonEngineAdjustTypeBrightness = 1,//亮度
       XYCommonEngineAdjustTypeContrast,//对比度
       XYCommonEngineAdjustTypeSharpen,//锐度
       XYCommonEngineAdjustTypeSaturation,//饱和度
       XYCommonEngineAdjustTypeTemperature,//色温
       XYCommonEngineAdjustTypeVignette,//暗角
       XYCommonEngineAdjustTypeHue,//色调
       XYCommonEngineAdjustTypeFade,//褪色
       XYCommonEngineAdjustTypeShadow,//阴影
       XYCommonEngineAdjustTypeHighlight,//高光
       XYCommonEngineAdjustTypeNoise,//噪点
};

@interface XYAdjustItem : XYBaseCopyModel
@property (nonatomic, assign) XYCommonEngineAdjustType adjustType;
@property NSInteger dwID;//唯一id
@property NSInteger dwDefaultValue;//默认值
@property NSInteger dwPreviousValue;
@property NSInteger dwCurrentValue;//值的范围 [0-100];
@property NSInteger dwMinValue;//最大值
@property NSInteger dwMaxValue;//最小值
@property (nonatomic, copy) NSString *nameEn;
@property (nonatomic, copy) NSString *iconImagePath;
@property (nonatomic, copy) NSString *nameLocale;
@end


@interface XYEffectPropertyMgr : NSObject

+ (NSInteger)getEffectPropertyItemsCount:(long long)ltemplateID;

+ (XYAdjustItem *)getEffectPropertyItem:(long long)ltemplateID
                                    dwItemIndex:(NSInteger)dwItemIndex;

+ (NSArray<XYAdjustItem *> *)getEffectPropertyItemsWithTemplateID:(long long)ltemplateID;

+ (NSArray<XYAdjustItem *> *)getEffectPropertyItemsWithEffectPropertyInfo:(CXYEffectpropertyInfo *)effectPropertyInfo;

@end
