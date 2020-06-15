//
//  XYQProjectCreate.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/24.
//

#import "XYQProjectTaskCreate.h"
#import "XYEngineWorkspace.h"

@implementation XYQProjectTaskCreate

- (void)engineOperate {
    [XYEngineWorkspace clean];
    [self.storyboard initXYStoryBoard];
}

@end
