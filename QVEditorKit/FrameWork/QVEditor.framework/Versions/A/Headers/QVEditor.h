//
//  QVEditor.h
//  QVEditor
//
//  Created by 夏澄 on 2020/4/23.
//

#import <Foundation/Foundation.h>
#import <XYCommonEngineKit/XYCommonEngineKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface QVEditorConfiguration : NSObject

/// 证书路径
@property (nonatomic, copy) NSString *licensePath;

/// clip错误时显示图片的地址。如相册的图片被删除或者上传到iCloud等
@property (nonatomic, copy) NSString *corruptImgPath;

/// 默认素材的版本 如果有升级素材 需要修改版好 加1往上升即可
@property (nonatomic, assign) NSInteger defaultTemplateVersion;

@end

@interface QVEditor : NSObject

+ (void)initializeWithConfig:(QVEditorConfiguration *)config delegate:(id <QVEngineDataSourceProtocol>)delegate;

@end

NS_ASSUME_NONNULL_END
