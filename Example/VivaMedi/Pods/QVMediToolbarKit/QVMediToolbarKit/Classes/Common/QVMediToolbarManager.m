//
//  XYToolbarManager.m
//  Pods-XYToolbarKit_Example
//
//  Created by chaojie zheng on 2020/4/14.
//

#import "QVMediToolbarManager.h"

@interface QVMediToolbarManager ()

@end

@implementation QVMediToolbarManager

+ (id)createToolbarWithType:(QVMediToolbarType)toolbarType {
    return nil;
}

+ (QVMediToolbarManager *)manager {
    static QVMediToolbarManager *manager;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
      manager = [[QVMediToolbarManager alloc] init];
    });
    return manager;
}

@end
