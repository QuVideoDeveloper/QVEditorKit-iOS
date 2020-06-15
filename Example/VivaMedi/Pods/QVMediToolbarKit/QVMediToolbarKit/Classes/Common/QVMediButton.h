//
//  QVMediButton.h
//  Pods
//
//  Created by robbin on 2020/6/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, QVMediButtonStyle) {
    QVMediButtonStyleNormal,
    QVMediButtonStyleUpImageBelowTitle,
};

@interface QVMediButton : UIButton

@property (nonatomic, assign) NSInteger qvmedi_customSpacing;

@property (nonatomic, assign) NSInteger qvmedi_extInteractEdge;
@property (nonatomic, assign) UIEdgeInsets extInteractInsets;

@property (nonatomic, assign) QVMediButtonStyle qvmedi_ButtonType;

+ (instancetype)qvmedi_buttonWithVivaButtonType:(QVMediButtonStyle)buttonType;

@end

NS_ASSUME_NONNULL_END
