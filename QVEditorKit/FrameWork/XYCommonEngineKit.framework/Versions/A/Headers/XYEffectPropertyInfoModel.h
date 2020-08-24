//
//  XYEffectPropertyInfoModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/7/30.
//

#import <Foundation/Foundation.h>

@class XYEffectPropertyItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface XYEffectPropertyInfoModel : NSObject

/// 素材id
@property (nonatomic, assign) UInt64 templateID;

/// 唯一标志
@property (nonatomic, copy) NSString *identifier;

/// subItemType 值范围 5000 - 6000
@property (nonatomic, assign) NSInteger subItemType;

/// 对应的模板插件的属性列表
@property (nonatomic, copy) NSArray <XYEffectPropertyItemModel *> *itemList;

/// 是否关闭此效果
@property (nonatomic, assign) BOOL disable;

@end

NS_ASSUME_NONNULL_END
