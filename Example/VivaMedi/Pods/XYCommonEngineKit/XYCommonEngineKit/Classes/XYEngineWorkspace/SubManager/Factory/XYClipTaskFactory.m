//
//  XYClipTaskFactory.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/22.
//

#import "XYClipTaskFactory.h"
#import "XYClipTaskDuplicate.h"
#import "XYClipTaskMute.h"
#import "XYClipTaskUpdateVolume.h"
#import "XYClipTaskFilterAdd.h"
#import "XYClipTaskFilterUpdateAlpha.h"
#import "XYClipTaskVoiceChange.h"
#import "XYClipTaskAdjust.h"
#import "XYClipTaskSpeed.h"
#import "XYClipTaskCut.h"
#import "XYClipTaskTrim.h"
#import "XYClipTaskBackgroundBlur.h"
#import "XYClipTaskBackgroundColor.h"
#import "XYClipTaskFit.h"
#import "XYClipTaskBackgroundImage.h"
#import "XYClipTaskGesturePan.h"
#import "XYClipTaskGesturePinch.h"
#import "XYClipTaskGestureRotation.h"
#import "XYClipTaskTransition.h"
#import "XYClipTaskSplit.h"
#import "XYClipTaskReverse.h"
#import "XYClipTaskDelete.h"
#import "XYClipTaskExchange.h"
#import "XYClipTaskPhotoAnimation.h"
#import "XYClipTaskUpdateGradientAngle.h"
#import "XYClipTaskAdd.h"
#import "XYClipTaskCoverAdd.h"
#import "XYClipTaskCoverUpdate.h"
#import "XYClipTaskBackgroundImageBlur.h"
#import "XYClipTaskRatioBgmReset.h"
#import "XYClipTaskAudioNSX.h"
#import "XYClipTaskReplaceSource.h"
#import "XYClipCropTaskMirror.h"
#import "XYClipTaskMirror.h"
#import "XYClipTaskCrop.h"

@implementation XYClipTaskFactory

+ (XYBaseClipTask *)factoryWithType:(XYCommonEngineTaskID)taskID {
    XYBaseClipTask *clipTask;;
    if (XYCommonEngineTaskIDClipDuplicate == taskID) {
        
        clipTask = [[XYClipTaskDuplicate alloc] init];
        
    } else if (XYCommonEngineTaskIDClipMuteState == taskID) {
        
        clipTask = [[XYClipTaskMute alloc] init];
        
    } else if (XYCommonEngineTaskIDClipUpdateVolume == taskID) {
        
        clipTask = [[XYClipTaskUpdateVolume alloc] init];
        
    } else if (XYCommonEngineTaskIDClipFilterAdd == taskID) {
        
        clipTask = [[XYClipTaskFilterAdd alloc] init];
        
    } else if (XYCommonEngineTaskIDClipFilterUpdateAlpha == taskID) {
        
        clipTask = [[XYClipTaskFilterUpdateAlpha alloc] init];
        
    } else if (XYCommonEngineTaskIDClipVoiceChange == taskID) {
        
        clipTask = [[XYClipTaskVoiceChange alloc] init];
        
    } else if (XYCommonEngineTaskIDClipAdjustUpdate == taskID) {
        
        clipTask = [[XYClipTaskAdjust alloc] init];
        
    } else if (XYCommonEngineTaskIDClipSpeed == taskID) {
        
        clipTask = [[XYClipTaskSpeed alloc] init];
        
    } else if (XYCommonEngineTaskIDClipCut == taskID) {
           
           clipTask = [[XYClipTaskCut alloc] init];

    } else if (XYCommonEngineTaskIDClipTrim == taskID) {
           
           clipTask = [[XYClipTaskTrim alloc] init];

    } else if (XYCommonEngineTaskIDClipBackgroundBlur == taskID) {
        
        clipTask = [[XYClipTaskBackgroundBlur alloc] init];

    }  else if (XYCommonEngineTaskIDClipBackgroundColor == taskID) {
           
           clipTask = [[XYClipTaskBackgroundColor alloc] init];

    } else if (XYCommonEngineTaskIDClipFit == taskID) {
           
           clipTask = [[XYClipTaskFit alloc] init];

    } else if (XYCommonEngineTaskIDClipBackgroundImage == taskID) {
           
           clipTask = [[XYClipTaskBackgroundImage alloc] init];

    } else if (XYCommonEngineTaskIDClipGesturePan == taskID) {
           
           clipTask = [[XYClipTaskGesturePan alloc] init];

    } else if (XYCommonEngineTaskIDClipGesturePinch == taskID) {
           
           clipTask = [[XYClipTaskGesturePinch alloc] init];

    } else if (XYCommonEngineTaskIDClipGestureRotation == taskID) {
           
           clipTask = [[XYClipTaskGestureRotation alloc] init];

    } else if (XYCommonEngineTaskIDClipTransition == taskID) {
              
              clipTask = [[XYClipTaskTransition alloc] init];

    } else if (XYCommonEngineTaskIDClipSplit == taskID) {
                
                clipTask = [[XYClipTaskSplit alloc] init];

    } else if (XYCommonEngineTaskIDClipReverse == taskID) {
                
                clipTask = [[XYClipTaskReverse alloc] init];

    } else if (XYCommonEngineTaskIDClipDelete == taskID) {
                
                clipTask = [[XYClipTaskDelete alloc] init];

    } else if (XYCommonEngineTaskIDClipExchange == taskID) {
                
                clipTask = [[XYClipTaskExchange alloc] init];

    } else if (XYCommonEngineTaskIDClipPhotoAnimation == taskID) {
                
                clipTask = [[XYClipTaskPhotoAnimation alloc] init];

    } else if (XYCommonEngineTaskIDClipUpdateGradientAngle == taskID) {

        clipTask = [[XYClipTaskUpdateGradientAngle alloc] init];
        
    } else if (XYCommonEngineTaskIDClipAddClip == taskID) {
        
        clipTask = [[XYClipTaskAdd alloc] init];
        
    } else if (XYCommonEngineTaskIDClipCoverBackAdd == taskID) {
        
        clipTask = [[XYClipTaskCoverAdd alloc] init];
        
    } else if (XYCommonEngineTaskIDClipCoverBackUpdate == taskID) {
        
        clipTask = [[XYClipTaskCoverUpdate alloc] init];
        
    } else if (XYCommonEngineTaskIDClipBackgroundImageBlur == taskID) {

        clipTask = [[XYClipTaskBackgroundImageBlur alloc] init];
        
    } else if (XYCommonEngineTaskIDClipRatioBgmRset == taskID) {
        
        clipTask = [[XYClipTaskRatioBgmReset alloc] init];
        
    } else if (XYCommonEngineTaskIDClipAudioNSX == taskID) {
        
        clipTask = [[XYClipTaskAudioNSX alloc] init];
        
    } else if (XYCommonEngineTaskIDClipReplaceSource == taskID) {
                
        clipTask = [[XYClipTaskReplaceSource alloc] init];

    } else if (XYCommonEngineTaskIDClipCropMirror == taskID) {
        
        clipTask = [[XYClipCropTaskMirror alloc] init];
        
    } else if (XYCommonEngineTaskIDClipMirror == taskID) {
        
        clipTask = [[XYClipTaskMirror  alloc] init];
        
    } else if (XYCommonEngineTaskIDClipCrop == taskID) {
           
           clipTask = [[XYClipTaskCrop  alloc] init];
           
       }
    
    
    return clipTask;
}

@end
