//
//  XYeffectTaskMusicUpdateRange.m
//  Pods
//
//  Created by 夏澄 on 2019/10/26.
//

#import "XYEffectTaskAudioUpdateRange.h"

@implementation XYEffectTaskAudioUpdateRange

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeUpdateEffect;
}

- (void)engineOperate {
    CXiaoYingEffect *effect = [self.storyboard getStoryboardEffectByIndex:self.indexInStoryboard dwTrackType:self.trackType groupId:self.groupID];
//    if(XYCommonEngineGroupIDDubbing == self.groupID) {
//        MDWord dwRepeatMode = AMVE_AUDIO_FRAME_MODE_REPEAT;
//        //set repeat mode
//        MRESULT res = [effect setProperty: AMVE_PROP_EFFECT_AUDIO_FRAME_REPEAT_MODE
//                             PropertyData: (MVoid*)&dwRepeatMode];
//        if(res){
//            NSLog(@"[ENGINE] set AMVE_PROP_EFFECT_AUDIO_FRAME_REPEAT_MODE err=0x%x",res);
//        }
//    }else if (XYCommonEngineGroupIDBgmMusic == self.groupID) {
//        MDWord align = QVET_TIME_POSITION_ALIGNMENT_MODE_START;
//        MRESULT res = [effect setProperty: AMVE_PROP_EFFECT_POSITION_ALIGNMENT
//                             PropertyData: &align];
//        if(res){
//            NSLog(@"[ENGINE] set QVET_TIME_POSITION_ALIGNMENT_MODE_START err=0x%x",res);
//        }
//    }
    
    [self.storyboard setEffectRange:effect startPos:self.destPos duration:self.destLen];
    [self.effectModel updateRelativeClipInfo];
}

@end
