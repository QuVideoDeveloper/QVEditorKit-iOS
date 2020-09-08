//
//  XYProjectModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/23.
//

#import "XYBaseEngineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYQprojectModel : XYBaseEngineModel

@property (nonatomic, copy) NSString *prjFilePath;//保存工程的路径
@property (nonatomic, assign) BOOL isAsynchronouTaskQueune;//是否在引擎队列 如果中途自动保存 建议使用YES


@end

NS_ASSUME_NONNULL_END
