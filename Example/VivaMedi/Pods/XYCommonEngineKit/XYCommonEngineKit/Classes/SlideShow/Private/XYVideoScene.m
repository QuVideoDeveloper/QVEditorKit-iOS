//
//  XYVideoScene.m
//  XiaoYingCoreSDK
//
//  Created by 吕孟霖 on 16/5/23.
//  Copyright © 2016年 QuVideo. All rights reserved.
//

#import "XYVideoScene.h"
#import "XYSlideShowSourceNode.h"

@interface XYVideoScene ()
{
    NSMutableArray * _sourceInfoNodeArray;
}
@end

@implementation XYVideoScene
@dynamic sourceInfoNodeArray;


- (instancetype)init
{
    self = [super init];
    if (self) {
        _sourceInfoNodeArray = [NSMutableArray array];
    }
    return self;
}

- (NSArray<XYSlideShowSourceNode *> *)sourceInfoNodeArray
{
    return _sourceInfoNodeArray;
}

- (UInt32)previewPos
{
    if (self.sourceInfoNodeArray.count == 0) {
        return 0;
    }
    XYSlideShowSourceNode * node = self.sourceInfoNodeArray[0];
    return node.previewPos;
}

- (void)addSourceInfoNode:(XYSlideShowSourceNode *)node
{
    [_sourceInfoNodeArray addObject:node];
}

@end
