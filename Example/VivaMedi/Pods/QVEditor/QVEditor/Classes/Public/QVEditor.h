//
//  QVEditor.h
//  QVEditor
//
//  Created by 夏澄 on 2020/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface QVEditorConfiguration : NSObject

/// 证书路径
@property (nonatomic, copy) NSString *licensePath;

@end

@interface QVEditor : NSObject

+ (void)initializeWithConfig:(QVEditorConfiguration *)config;

@end

NS_ASSUME_NONNULL_END
