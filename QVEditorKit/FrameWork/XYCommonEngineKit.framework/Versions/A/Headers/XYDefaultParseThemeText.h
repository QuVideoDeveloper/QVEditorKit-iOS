//
//  XYDefaultParseThemeText.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/30.
//

#import <Foundation/Foundation.h>
#import "QVTextPrepareModel.h"
#import "QVEngineDataSourceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYDefaultParseThemeText : NSObject

+ (NSString *)parseText:(NSString *)formatText;

+ (NSString *)parse:(NSString *)formatText delegate:(id<QVEngineDataSourceProtocol>)delegate;

@end

NS_ASSUME_NONNULL_END
