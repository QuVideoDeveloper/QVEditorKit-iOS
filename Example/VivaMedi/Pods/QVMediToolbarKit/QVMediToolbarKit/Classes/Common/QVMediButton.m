//
//  QVMediButton.m
//  Pods
//
//  Created by robbin on 2020/6/4.
//

#import "QVMediButton.h"

#define isRightToLeftLayout [QVMediButton qvmedi_isRightToLeftLayout]


@implementation QVMediButton


+ (instancetype)qvmedi_buttonWithVivaButtonType:(QVMediButtonStyle)buttonType {
    QVMediButton * button = [super buttonWithType:UIButtonTypeCustom];
    if (button) {
        button.qvmedi_ButtonType = buttonType;
    }
    return button;
}

#pragma mark - Private Funs

+ (BOOL)qvmedi_isRightToLeftLayout {
    if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
        return YES;
    }
    return NO;
}

#pragma mark - ButtonType-UpImageBelowTitle

- (void)qvmedi_layoutButtonTypeUpImageBelowTitle {
    [self qvmedi_centerImageAndTitle];
}

- (void)qvmedi_centerImageAndTitle:(float)spacing
{
    const int DEFAULT_SPACING = 3.0f;
    if (spacing <= 0) {
        spacing = DEFAULT_SPACING;
    }
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height),
                                            isRightToLeftLayout ? - titleSize.width : 0.0,
                                            0.0,
                                            isRightToLeftLayout ? 0 : - titleSize.width);
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(spacing,
                                            isRightToLeftLayout ? 0 : - imageSize.width,
                                            - (totalHeight - titleSize.height),
                                            isRightToLeftLayout ? - imageSize.width : 0);
}

- (void)qvmedi_centerImageAndTitle {
    [self qvmedi_centerImageAndTitle:0];
}

#pragma mark - Getter & Setter

- (void)setQvmedi_extInteractEdge:(NSInteger)qvmedi_extInteractEdge {
    _qvmedi_extInteractEdge = qvmedi_extInteractEdge;
    
    self.extInteractInsets = UIEdgeInsetsMake(qvmedi_extInteractEdge, qvmedi_extInteractEdge, qvmedi_extInteractEdge, qvmedi_extInteractEdge);
}

- (void)setQvmedi_ButtonType:(QVMediButtonStyle)qvmedi_ButtonType {
    _qvmedi_ButtonType = qvmedi_ButtonType;
    
    switch (_qvmedi_ButtonType) {
        case QVMediButtonStyleNormal:
            self.imageEdgeInsets = UIEdgeInsetsZero;
            self.titleEdgeInsets = UIEdgeInsetsZero;
            break;
        case QVMediButtonStyleUpImageBelowTitle:
            [self qvmedi_layoutButtonTypeUpImageBelowTitle];
            break;
            
        default:
            break;
    }
}


#pragma mark - UIButton Override

- (void)layoutSubviews{
    if (self.qvmedi_ButtonType == QVMediButtonStyleUpImageBelowTitle) {
        [self qvmedi_layoutButtonTypeUpImageBelowTitle];
    } else if (self.qvmedi_ButtonType == QVMediButtonStyleNormal) {
    }
    
    [super layoutSubviews];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return CGRectContainsPoint(CGRectMake(self.bounds.origin.x - self.extInteractInsets.left, self.bounds.origin.y - self.extInteractInsets.top, self.bounds.size.width + self.extInteractInsets.left+self.extInteractInsets.right, self.bounds.size.height + self.extInteractInsets.top+self.extInteractInsets.bottom) , point);
}
@end
