//
//  XYClipMirrorTask.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/6/4.
//

#import "XYClipTaskMirror.h"

@implementation XYClipTaskMirror

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeReOpen;
}

- (void)engineOperate {
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CXiaoYingClip *clip = [self.storyboard getClipByIndex:obj.clipIndex];
        MDWord flip = (MDWord)obj.mirrorMode;
        MRESULT ret = [clip setProperty:AMVE_PROP_CLIP_FLIP PropertyData:&flip];
    }];
}

@end
