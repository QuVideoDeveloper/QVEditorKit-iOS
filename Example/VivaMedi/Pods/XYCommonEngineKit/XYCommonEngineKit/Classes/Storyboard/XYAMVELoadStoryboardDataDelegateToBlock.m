//
//  XYAMVELoadStoryboardDataDelegateToBlock.m
//  Pods
//
//  Created by darren on 2020/3/5.
//

#import "XYAMVELoadStoryboardDataDelegateToBlock.h"

@implementation XYAMVELoadStoryboardDataDelegateToBlock

- (MDWord)AMVESessionStateCallBack:(AMVE_CBDATA_TYPE *)pCBData
{
    if (pCBData && pCBData->dwStatus == AMVE_SESSION_STATUS_STOPPED) {
        MDWord errorCode = pCBData->dwErrorCode;
        if (self.storyboardLoadCompleteBlock) {
            self.storyboardLoadCompleteBlock(errorCode);
            self.storyboardLoadCompleteBlock = nil;
        } else {
            
        }
    } else {
        
    }
    
    return 0;
}

@end
