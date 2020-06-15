//
//  XYBaseEffectAudioTask.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/26.
//

#import "XYBaseEffectAudioTask.h"
#import "XYEffectAudioModel.h"

@implementation XYBaseEffectAudioTask

- (XYEngineTaskType)engineTaskType {
    return XYEngineTaskTypeAudio;
}

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineByNone;
}

- (CXiaoYingEffect *)pEffect {
    return self.effectModel.pEffect;
}

- (XYCommonEngineTrackType)trackType {
    return XYCommonEngineTrackTypeAudio;
}

- (XYCommonEngineGroupID)groupID {
    return self.effectModel.groupID;
}

- (CGFloat)layerID {
    if (!XYIsFloatZero(self.effectModel.layerID)) {
        return self.effectModel.layerID;
    } else {
        if (XYCommonEngineGroupIDBgmMusic == self.groupID) {
            return LAYER_ID_BGM;
        } else if (XYCommonEngineGroupIDRecord == self.groupID) {
            return LAYER_ID_RECORD;
        } else {
            return LAYER_ID_DUB;
        }
    }
    
}

- (NSInteger)repeatMode {
    XYEffectAudioModel *audioModel = self.effectModel;
    if (audioModel.isRepeatON) {
        return AMVE_AUDIO_FRAME_MODE_REPEAT;
    } else {
        return QVET_TIME_POSITION_ALIGNMENT_MODE_START;
    }
}

@end
