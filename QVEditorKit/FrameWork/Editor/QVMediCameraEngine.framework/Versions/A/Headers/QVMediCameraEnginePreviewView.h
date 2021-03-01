//
//  QVMediCameraEnginePreviewView.h
//  QVMediCameraEngine
//
//  Created by 徐新元 on 2020/4/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface QVMediCameraEnginePreviewView : UIView

+ (void)enableMetal:(BOOL)enable;

- (void)setVisibaleArea:(CGRect)visibleRect;

@end

NS_ASSUME_NONNULL_END
