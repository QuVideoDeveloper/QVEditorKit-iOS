//
//  XYAMVELoadStoryboardDelegateToBlock.m
//  XYVivaVideoEngineKit
//
//  Created by 徐新元 on 2018/7/13.
//

#import "XYAMVELoadStoryboardDelegateToBlock.h"
#import <XYCategory/XYCategory.h>

@implementation XYAMVELoadStoryboardDelegateToBlock

- (MDWord)AMVESessionStateCallBack:(AMVE_CBDATA_TYPE *)pCBData {
	//    NSLog(@"AMVESessionStateCallBack status=%u errCode=0x%x",pCBData->dwStatus, pCBData->dwErrorCode);
	if (pCBData && pCBData->dwStatus == AMVE_SESSION_STATUS_STOPPED) {
		dispatch_async(dispatch_get_main_queue(), ^{
		  NSString *errorMsg = nil;
		  MDWord errorCode = pCBData->dwErrorCode;
		  if (errorCode == MERR_NONE && self.isClipMissing) {
			  errorCode = QVET_ERR_COMMON_PRJLOAD_CLIPFILE_MISSING;
		  } else if (errorCode == QVET_ERR_COMMON_TEMPLATE_MISSING && self.isTemplateMissing) {
			  errorCode = QVET_ERR_COMMON_TEMPLATE_MISSING;
		  }
		  if (_storyboardLoadCompleteBlock) {
			  _storyboardLoadCompleteBlock(errorCode);
			  _storyboardLoadCompleteBlock = nil;
			  //Load success! It's a good project file, let's backup it here.
			  if (errorCode == MERR_NONE || errorCode == QVET_ERR_COMMON_PRJLOAD_CLIPFILE_MISSING || errorCode == QVET_ERR_COMMON_TEMPLATE_MISSING) {
				  NSString *prjDataFilePath = [_projectFilePath stringByReplacingOccurrencesOfString:@".prj" withString:@".dat"];
				  NSString *lastWorkedPrjFilePath = [_projectFilePath stringByReplacingOccurrencesOfString:@".prj" withString:@"_last_worked.prj"];
				  NSString *lastWorkedPrjDataFilePath = [_projectFilePath stringByReplacingOccurrencesOfString:@".prj" withString:@"_last_worked.dat"];
                  [NSFileManager xy_copyFromFile:_projectFilePath toFile:lastWorkedPrjFilePath];
                  [NSFileManager xy_copyFromFile:prjDataFilePath toFile:lastWorkedPrjDataFilePath];
			  }
			  errorMsg = [NSString stringWithFormat:@"0x%x", errorCode];
		  } else {
			  errorCode = QVET_ERR_APP_FAIL;
			  errorMsg = @"loadCompleteBlock is nil";
		  }

		  //报告工程Load结果
		  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		  [dict setValue:@(errorCode) forKey:@"errorCode"];
		  [dict setValue:errorMsg forKey:@"errorMsg"];
		  [dict setValue:_projectFilePath forKey:@"projectFilePath"];
		  [[NSNotificationCenter defaultCenter] postNotificationName:@"kXYLoadProjectResultLog" object:nil userInfo:dict];

		});
	} else {
		self.isClipMissing = (pCBData->dwErrorCode == QVET_ERR_COMMON_PRJLOAD_CLIPFILE_MISSING) || self.isClipMissing;
		self.isTemplateMissing = (pCBData->dwErrorCode == QVET_ERR_COMMON_TEMPLATE_MISSING) || self.isTemplateMissing;
	}
	return 0;
}

@end
