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
@property (nonatomic, copy) NSString *thumbnailFilePath;//封面缩略图保存的路径
@property (nonatomic) UInt64 thumbPos;;//根据时间点来获取封面缩略图

@end

NS_ASSUME_NONNULL_END
