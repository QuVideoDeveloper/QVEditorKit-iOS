//
//  XYEngine.h
//  XiaoYing
//
//  Created by xuxinyuan on 13-4-26.
//  Copyright (c) 2013年 XiaoYing Team. All rights reserved.
//

#import "XYEngineParam.h"
#import <UIKit/UIKit.h>
#import <XYCommonEngine/CXiaoYingInc.h>
#import "QVEngineDataSourceProtocol.h"
#import "XYEngineEnum.h"

#define XY_TIMESCALE_DIV_4 0.25
#define XY_TIMESCALE_DIV_2 0.5
#define XY_TIMESCALE_NORMAL 1.0
#define XY_TIMESCALE_MUL_2 2.0
#define XY_TIMESCALE_MUL_4 4.0


@interface XYEngine : NSObject

@property (nonatomic, weak) id<CXiaoYingTemplateAdapter> templateDelegate;
@property (nonatomic, weak) id<QVEngineDataSourceProtocol> engineDataSource;
/// 开启引擎日志写入到本地 默认关闭
@property (nonatomic, assign) BOOL isSaveLog;
/// 输出终端输出日志等级
@property (nonatomic, assign) XYMonLogLevelType logLevel;

+ (XYEngine *)sharedXYEngine;

//templateAdapter和filePathAdapter必须在引擎初始化的时候设置
- (SInt32)initEngineWithParam:(XYEngineParam *)param
              templateAdapter:(id<CXiaoYingTemplateAdapter>)templateAdapter
              filePathAdapter:(id<CXiaoYingFilePathAdapter>)filePathAdapter
                  metalEnable:(BOOL)metalEnable;

- (void)uninit;

- (CXiaoYingEngine *)getCXiaoYingEngine;

- (UInt32)getVersion;

- (void)setTextTransformer:(id<CXiaoyingTextTransformer>)textTransformer;

- (void)setFontAdapter:(id<CXiaoYingFontAdapter>)fontAdapter;

- (BOOL)getMetalEnable;

- (NSString *)getLog;

@end
