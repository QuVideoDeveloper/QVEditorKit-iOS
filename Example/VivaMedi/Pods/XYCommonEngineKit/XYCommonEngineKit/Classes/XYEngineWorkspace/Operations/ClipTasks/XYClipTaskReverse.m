//
//  XYClipTaskReverse.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/16.
//

#import "XYClipTaskReverse.h"

@interface XYClipTaskReverse()

@property (nonatomic, assign) BOOL isSaveToCameraRoll;


@end

@implementation XYClipTaskReverse

- (BOOL)dataClipReinitThumbnailManager {
    return YES;
}


- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineAll;
}

- (BOOL)isReload {
    return YES;
}

- (BOOL)needRebuildThumbnailManager {
    return YES;
}

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeReOpen;
}

- (void)engineOperate {
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CXiaoYingClip *selectedClip = [self.storyboard getClipByIndex:obj.clipIndex];
        MBool hasReversed = MFalse;
        MRESULT res = [selectedClip getProperty:AMVE_PROP_CLIP_INVERSE_PLAY_VIDEO_FLAG PropertyData:&hasReversed];
        if (res) {
            NSLog(@"ENGINE]XYClipEditVC getProperty AMVE_PROP_CLIP_INVERSE_PLAY_VIDEO_FLAG res=0x%x",res);
        } else {
            hasReversed = hasReversed == MTrue ? MFalse : MTrue;
            res = [selectedClip setProperty:AMVE_PROP_CLIP_INVERSE_PLAY_VIDEO_FLAG PropertyData:&hasReversed];
            
            if (res) {
                NSLog(@"ENGINE]XYClipEditVC getProperty AMVE_PROP_CLIP_INVERSE_PLAY_VIDEO_FLAG res=0x%x", res);
            } else {
                obj.isReversed = (hasReversed == MTrue);
                AMVE_POSITION_RANGE_TYPE trimRange = [self.storyboard getClipTrimRangeByClip:selectedClip];
                obj.trimVeRange = [XYVeRangeModel VeRangeModelWithPosition:trimRange.dwPos length:trimRange.dwLen];
            }
        }
    }];
}


@end
