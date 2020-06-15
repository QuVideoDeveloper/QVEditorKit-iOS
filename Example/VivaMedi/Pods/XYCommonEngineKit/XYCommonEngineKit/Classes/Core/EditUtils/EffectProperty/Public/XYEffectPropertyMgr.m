//
//  XYEffectPropertyMgr.m
//  XiaoYingSDK
//
//  Created by xuxinyuan on 12/25/14.
//  Copyright (c) 2014 XiaoYing. All rights reserved.
//

#import "XYEffectPropertyMgr.h"
#import "XYEngine.h"

@implementation XYAdjustItem

@end

@implementation XYEffectPropertyMgr

+ (NSInteger)getEffectPropertyItemsCount:(long long)ltemplateID {
	CXYEffectpropertyInfo *effectPropertyInfo = [CXiaoYingStyle GetEffectPropertyInfo:[[XYEngine sharedXYEngine] getCXiaoYingEngine] TemplateID:ltemplateID];
	if (!effectPropertyInfo) {
		return 0;
	}
	NSInteger dwItemCount = effectPropertyInfo->dwItemCount;
    [CXiaoYingStyle ReleasePropertyInfo:effectPropertyInfo];
	return dwItemCount;
}

+ (XYAdjustItem *)getEffectPropertyItem:(long long)ltemplateID
                                    dwItemIndex:(NSInteger)dwItemIndex {
	CXYEffectpropertyInfo *effectPropertyInfo = [CXiaoYingStyle GetEffectPropertyInfo:[[XYEngine sharedXYEngine] getCXiaoYingEngine] TemplateID:ltemplateID];
	if (!effectPropertyInfo) {
		return nil;
	}
	NSInteger dwItemCount = effectPropertyInfo->dwItemCount;
	if (dwItemIndex >= dwItemCount) {
		return nil;
	}

	CXYEffectPropertyItem *pItem = effectPropertyInfo->pItems + dwItemIndex * sizeof(CXYEffectPropertyItem);
	XYAdjustItem *effectPropertyItem = [[XYAdjustItem alloc] init];
	effectPropertyItem.dwID = pItem->dwID;
	effectPropertyItem.dwMinValue = pItem->dwMinValue;
	effectPropertyItem.dwMaxValue = pItem->dwMaxValue;
	effectPropertyItem.dwDefaultValue = pItem->dwCurValue;
	effectPropertyItem.dwCurrentValue = effectPropertyItem.dwDefaultValue;
	effectPropertyItem.nameEn = [NSString stringWithUTF8String:pItem->pszName];
	effectPropertyItem.nameLocale = [NSString stringWithUTF8String:pItem->pszWildCards];
	[XYEffectPropertyMgr parseAndUpdateEffectPropertyLocaleName:effectPropertyItem];
	[CXiaoYingStyle ReleasePropertyInfo:effectPropertyInfo];
	return effectPropertyItem;
}

+ (NSArray<XYAdjustItem *> *)getEffectPropertyItemsWithTemplateID:(long long)ltemplateID {
	CXYEffectpropertyInfo *effectPropertyInfo = [CXiaoYingStyle GetEffectPropertyInfo:[[XYEngine sharedXYEngine] getCXiaoYingEngine] TemplateID:ltemplateID];
	return [self getEffectPropertyItemsWithEffectPropertyInfo:effectPropertyInfo];
}

+ (NSArray<XYAdjustItem *> *)getEffectPropertyItemsWithEffectPropertyInfo:(CXYEffectpropertyInfo *)effectPropertyInfo {
	if (!effectPropertyInfo) {
		return nil;
	}
	NSInteger dwItemCount = effectPropertyInfo->dwItemCount;
	if (dwItemCount == 0) {
		return nil;
	}

	NSMutableArray *effectPropertyItems = [NSMutableArray new];
	for (int i = 0; i < dwItemCount; i++) {
		CXYEffectPropertyItem *pItem = effectPropertyInfo->pItems + i;
		XYAdjustItem *effectPropertyItem = [[XYAdjustItem alloc] init];
		effectPropertyItem.dwID = pItem->dwID;
		effectPropertyItem.dwMinValue = pItem->dwMinValue;
		effectPropertyItem.dwMaxValue = pItem->dwMaxValue;
		effectPropertyItem.dwDefaultValue = pItem->dwCurValue;
		effectPropertyItem.dwCurrentValue = effectPropertyItem.dwDefaultValue;
		effectPropertyItem.nameEn = [NSString stringWithUTF8String:pItem->pszName];
		effectPropertyItem.nameLocale = [NSString stringWithUTF8String:pItem->pszWildCards];
		[XYEffectPropertyMgr parseAndUpdateEffectPropertyLocaleName:effectPropertyItem];
		[effectPropertyItems addObject:effectPropertyItem];
	}

	[CXiaoYingStyle ReleasePropertyInfo:effectPropertyInfo];
	return effectPropertyItems;
}

+ (void)parseAndUpdateEffectPropertyLocaleName:(XYAdjustItem *)effectPropertyItem {
	if ([effectPropertyItem.nameLocale isEqualToString:@"%brightness%"]) {
        effectPropertyItem.adjustType = XYCommonEngineAdjustTypeBrightness;
	} else if ([effectPropertyItem.nameLocale isEqualToString:@"%contrast%"]) {
        effectPropertyItem.adjustType = XYCommonEngineAdjustTypeContrast;
	} else if ([effectPropertyItem.nameLocale isEqualToString:@"%sharpen%"]) {
        effectPropertyItem.adjustType = XYCommonEngineAdjustTypeSharpen;
	} else if ([effectPropertyItem.nameLocale isEqualToString:@"%saturation%"]) {
        effectPropertyItem.adjustType = XYCommonEngineAdjustTypeSaturation;
	} else if ([effectPropertyItem.nameLocale isEqualToString:@"%temperature%"]) {
        effectPropertyItem.adjustType = XYCommonEngineAdjustTypeTemperature;
	} else if ([effectPropertyItem.nameLocale isEqualToString:@"%vignette%"]) {
        effectPropertyItem.adjustType = XYCommonEngineAdjustTypeVignette;
	} else if ([effectPropertyItem.nameLocale isEqualToString:@"%hue%"]) {
        effectPropertyItem.adjustType = XYCommonEngineAdjustTypeHue;
	} else if ([effectPropertyItem.nameLocale isEqualToString:@"%fade%"]) {
        effectPropertyItem.adjustType = XYCommonEngineAdjustTypeFade;
	} else if ([effectPropertyItem.nameLocale isEqualToString:@"%shadow%"]) {
        effectPropertyItem.adjustType = XYCommonEngineAdjustTypeShadow;
	} else if ([effectPropertyItem.nameLocale isEqualToString:@"%highlight%"]) {
        effectPropertyItem.adjustType = XYCommonEngineAdjustTypeHighlight;
	} else if ([effectPropertyItem.nameLocale isEqualToString:@"%noise%"]) {
        effectPropertyItem.adjustType = XYCommonEngineAdjustTypeNoise;
    }
}

@end
