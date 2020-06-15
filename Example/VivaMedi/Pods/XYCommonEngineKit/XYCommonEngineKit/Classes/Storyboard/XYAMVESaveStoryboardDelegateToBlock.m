//
//  XYAMVESaveStoryboardDelegateToBlock.m
//  XYVivaVideoEngineKit
//
//  Created by 徐新元 on 2018/7/13.
//

#import "XYAMVESaveStoryboardDelegateToBlock.h"

@implementation XYAMVESaveStoryboardDelegateToBlock

- (MDWord)AMVESessionStateCallBack:(AMVE_CBDATA_TYPE *)pCBData {
	//    NSLog(@"AMVESessionStateCallBack status=%u errCode=0x%x",pCBData->dwStatus, pCBData->dwErrorCode);
	if (pCBData && pCBData->dwStatus == AMVE_SESSION_STATUS_STOPPED) {
		dispatch_async(dispatch_get_main_queue(), ^{
		  NSString *errorMsg = nil;
		  MDWord errorCode = pCBData->dwErrorCode;
		  if (_storyboardSaveCompleteBlock) {
			  _storyboardSaveCompleteBlock(errorCode);
			  _storyboardSaveCompleteBlock = nil;
			  errorMsg = [NSString stringWithFormat:@"0x%x", errorCode];
		  } else {
			  errorCode = QVET_ERR_APP_FAIL;
			  errorMsg = @"saveCompleteBlock is nil";
		  }

		  //报告工程Save结果
		  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		  [dict setValue:@(errorCode) forKey:@"errorCode"];
		  [dict setValue:errorMsg forKey:@"errorMsg"];
		  [dict setValue:_projectFilePath forKey:@"projectFilePath"];
		  [[NSNotificationCenter defaultCenter] postNotificationName:@"kXYSaveProjectResultLog" object:nil userInfo:dict];
		});
	}
	return 0;
}

@end
