//
//  XYKeyAnchorOffsetInfo.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/7/23.
//

#import "XYBaseKeyFrame.h"
#import "XYVe3DDataF.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYKeyAnchorOffsetInfo : XYBaseKeyFrame

///中心点，实际为锚点坐标，默认在效果的中心点,是相对中心的偏移量，(0,0,0)是在中心点 (100,100,100)为相对中心的向右下方及z轴的里面偏移了100；(-100,-100,-100)为相对中心的向左上方及z轴的外面偏移了100
@property (nonatomic, strong) XYVe3DDataF *anchorOffset;

@end

NS_ASSUME_NONNULL_END
