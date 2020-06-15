//
//  XYAddImageView.h
//  DZNEmptyDataSet
//
//  Created by chaojie zheng on 2020/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QVMEDIADDBUTTONDIRECTION) {
    QVMEDIADDBUTTONDIRECTION_LEFT,
    QVMEDIADDBUTTONDIRECTION_REIGHT
};

@interface QVMediAddImageView : UIView

- (void)creatWithAddButtonDirection:(QVMEDIADDBUTTONDIRECTION)direction addClick:(void(^)(NSInteger curSelectIndex))addClick select:(void(^)(NSInteger curSelectIndex, UIImage *image, BOOL autoRefresh))selectFinish;

- (void)setDataSource:(id)data;

- (void)reloadData:(id)data;

@end

NS_ASSUME_NONNULL_END
