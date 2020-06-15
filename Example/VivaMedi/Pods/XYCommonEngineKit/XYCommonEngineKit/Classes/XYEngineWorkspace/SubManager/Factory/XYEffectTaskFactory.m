//
//  XYEffectTaskFactory.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/22.
//

#import "XYEffectTaskFactory.h"
#import "XYBaseEffectTask.h"

//声音效果
#import "XYEffectTaskAddAudio.h"
#import "XYEffectTaskDeleteAudio.h"
#import "XYEffectTaskReplaceAudio.h"
#import "XYEffectTaskAudioUpdateRange.h"
#import "XYEffectTaskUpdateAudioVolume.h"
#import "XYEffectTaskAudioFadeIn.h"
#import "XYEffectTaskAudioFadeOut.h"
#import "XYEffectTaskAudioRepeat.h"
#import "XYEffectTaskAudioTrimUpdate.h"
#import "XYEffectTaskDuplicateAudio.h"
#import "XYEffectTaskReSetThemeAudio.h"
#import "XYEffectTaskAudioUpdateSourceRange.h"
//可视效果
#import "XYEffectTaskVisionDelete.h"
#import "XYEffectTaskVisionAdd.h"
#import "XYEffectTaskVisionUpdate.h"
#import "XYEffectTaskVisionDuplicate.h"
#import "XYEffectTaskVisionTextAdd.h"
#import "XYEffectTaskVisionTextUpdate.h"
#import "XYEffectTaskVisionDeleteKeyFrame.h"
#import "XYEffectTaskAudioVoiceChange.h"

@implementation XYEffectTaskFactory

+ (XYBaseEffectTask *)factoryWithType:(XYCommonEngineTaskID)taskID {
   XYBaseEffectTask *effectTask;
    if (XYCommonEngineTaskIDEffectAudioAdd == taskID) {
        
        effectTask = [[XYEffectTaskAddAudio alloc] init];
    
    } else if (XYCommonEngineTaskIDEffectAudioDelete == taskID) {
        
        effectTask = [[XYEffectTaskDeleteAudio alloc] init];
        
    } else if (XYCommonEngineTaskIDEffectAudioReplace == taskID) {
        
        effectTask = [[XYEffectTaskReplaceAudio alloc] init];
        
    } else if (XYCommonEngineTaskIDEffectAudioUpdateDestRange == taskID) {
        
        effectTask = [[XYEffectTaskAudioUpdateRange alloc] init];
        
    } else if (XYCommonEngineTaskIDEffectUpdateAudioVolume == taskID) {
        
        effectTask = [[XYEffectTaskUpdateAudioVolume alloc] init];
        
    } else if (XYCommonEngineTaskIDEffectAudioFadeIn == taskID) {
        
        effectTask = [[XYEffectTaskAudioFadeIn alloc] init];
        
    } else if (XYCommonEngineTaskIDEffectAudioFadeOut == taskID) {
        
        effectTask = [[XYEffectTaskAudioFadeOut alloc] init];
        
    } else if (XYCommonEngineTaskIDEffectAudioUpdateRepeat == taskID) {

        effectTask = [[XYEffectTaskAudioRepeat alloc] init];
        
    } else if (XYCommonEngineTaskIDEffectAudioUpdateTrimRange == taskID) {

        effectTask = [[XYEffectTaskAudioTrimUpdate alloc] init];
        
    } else if (XYCommonEngineTaskIDEffectAudioDuplicate == taskID) {
        
        effectTask = [[XYEffectTaskDuplicateAudio  alloc] init];
        
    } else if (XYCommonEngineTaskIDEffectAudioVoiceChange == taskID) {
        
        effectTask = [[XYEffectTaskAudioVoiceChange  alloc] init];
        
    } else if (XYCommonEngineTaskIDEffectResetThemeAudio == taskID) {
        
        effectTask = [[XYEffectTaskReSetThemeAudio  alloc] init];
        
    } else if (XYCommonEngineTaskIDEffectAudioUpdateSourceVeRange == taskID) {
        
        effectTask = [[XYEffectTaskAudioUpdateSourceRange alloc] init];
 
    } else if (XYCommonEngineTaskIDEffectVisionDelete == taskID) {//删除可视效果
        
        effectTask = [[XYEffectTaskVisionDelete alloc] init];
        
    } else if (XYCommonEngineTaskIDEffectVisionAdd == taskID) {//添加可视效果
        
        effectTask = [[XYEffectTaskVisionAdd alloc] init];
        
    } else if (XYCommonEngineTaskIDEffectVisionUpdate == taskID) {//更新可视效果
        
        effectTask = [[XYEffectTaskVisionUpdate alloc] init];
        
    } else if (XYCommonEngineTaskIDEffectVisionDuplicate == taskID) {//复制可视效果
        
        effectTask = [[XYEffectTaskVisionDuplicate alloc] init];
        
    } else if (XYCommonEngineTaskIDEffectVisionTextAdd == taskID) {//添加字幕
        
        effectTask = [[XYEffectTaskVisionTextAdd alloc] init];
        
    } else if (XYCommonEngineTaskIDEffectVisionTextUpdate == taskID) {//更新字幕
        
        effectTask = [[XYEffectTaskVisionTextUpdate alloc] init];
        
    } else if (XYCommonEngineTaskIDEffectVisionDelelteKeyFrame == taskID) {//根据groupid 删除关键帧
        
        effectTask = [[XYEffectTaskVisionDeleteKeyFrame alloc] init];
        
    }
    
    return effectTask;
}

@end
