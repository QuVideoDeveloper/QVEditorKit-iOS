//
//  XYEngineWorkspaceConfigModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYEngineWorkspaceConfiguration : NSObject
@property(nonatomic, assign) CGRect bounds;//播放器的bounds
@property (nonatomic, copy) NSString * _Nullable effectDefaultTransFilePath; //删除clip时需要将默认的转场设置进来 用于删除转场
@property (nonatomic, copy) NSString * _Nullable effectXyt03FilePath; //03模板路径
@property (nonatomic, copy) NSString * _Nullable effectXytCFilePath; //C模板路径
@property (nonatomic, copy) NSString * _Nullable effectXytDFilePath; //D模板路径
@property (nonatomic, copy) NSString * _Nullable effectXytEFilePath; //E模板路径
@property (nonatomic, copy) NSString * _Nullable effectXytFFilePath; //F模板路径

@property (nonatomic, assign) long long adjustEffectId;//
@property (nonatomic, copy) NSString * _Nullable adjustEffectPath; //F模板路径

@property (nonatomic, assign) CGFloat outPutResolutionWidth;

@property (nonatomic) BOOL isMVPrj; //是否是相册工程 默认不是
@property (nonatomic) BOOL addClipNeedAutoAdjustVideoScale; //添加clip是否需要自动调整视频的比例 默认NO
@property (nonatomic) BOOL isUsedCustomWatermark; //是否使用了自定义水印 默认NO

@end

NS_ASSUME_NONNULL_END
