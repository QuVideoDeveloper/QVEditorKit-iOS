//
//  XYScrollToolbarSelectView.h
//  Pods
//
//  Created by chaojie zheng on 2020/4/15.
//

//素材列表

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectBlcok)(id targetResource);

typedef NS_ENUM(NSUInteger, QVMediScrollToolbarType) {
    QVMediScrollToolbarCardPoint,
    QVMediScrollToolbarFilter,
    QVMediScrollToolbarSongs,
    QVMediScrollToolbarSoundEffects,
    QVMediScrollToolbarSpecialEffects,//特效
    QVMediScrollToolbarThemes,
    QVMediScrollToolbarVideoEdit,
    QVMediScrollToolbarVideoEditTransition,
    QVMediScrollToolbarVideoEditAddSticker,
    QVMediScrollToolbarVideoEditSubtitle,
    QVMediScrollToolbarVideoEditAddMosaic,
};

@interface QVMediScrollToolbarSelectView : UIView
@property (nonatomic, strong) UIButton *curSelectButton;
@property (nonatomic, strong) UILabel *bottomTitleLabel;

@property (nonatomic,   copy) NSString *title;

@property (nonatomic, assign) QVMediScrollToolbarType toolbarType;

@property (nonatomic,   copy) void(^toolbarItemClickBlock)(id targetResource);

- (void)createScrollToolbarWithData:(NSArray *)data toolbarType:(QVMediScrollToolbarType)toolbarType action:(NSString *)action;

- (void)createScrollToolbarWithData:(NSArray *)data toolbarType:(QVMediScrollToolbarType)toolbarType changeSelect:(SelectBlcok)changeSelect action:(NSString *)action selectFinish:(SelectBlcok)finish ;

@end

NS_ASSUME_NONNULL_END
