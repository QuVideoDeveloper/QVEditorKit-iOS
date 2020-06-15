//
//  XYBaseEngineTask.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/21.
//

#import "XYBaseEngineTask.h"
#import "XYEngine.h"
#import "XYTaskErrorModel.h"

@implementation XYBaseEngineTask

- (instancetype)init {
    self = [super init];
    if (self) {
        self.preRunTaskPlayerNeedPause = YES;
        self.isInstantRefresh = NO;
        self.adjustEffect = YES;
        self.skipRefreshPlayer = NO;
        self.succeed = YES;
    }
    return self;
}

- (void)run {
    [self engineOperate];
    if ([self.delegate respondsToSelector:@selector(onEngineFinish:)]) {
        [self.delegate onEngineFinish:self];
    }
}


- (void)engineOperate {
    
}

- (XYEngine *)engine {
    return [[XYEngine sharedXYEngine] getCXiaoYingEngine];
}

- (XYTaskErrorModel *)errorModel {
    if (!_errorModel) {
        _errorModel = [[XYTaskErrorModel alloc] init];
    }
    return _errorModel;
}

@end
