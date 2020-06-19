//
//  XYVideoScene.h
//  XiaoYingCoreSDK
//
//  Created by 吕孟霖 on 16/5/23.
//  Copyright © 2016年 QuVideo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XYSlideShowSourceNode;

@interface XYVideoScene : NSObject

@property (nonatomic)NSInteger sceneIndex;
@property (nonatomic)UInt32 previewPos;
@property (nonatomic, strong, readonly)NSArray<XYSlideShowSourceNode *> *sourceInfoNodeArray;

- (void)addSourceInfoNode:(XYSlideShowSourceNode *)node;

@end
