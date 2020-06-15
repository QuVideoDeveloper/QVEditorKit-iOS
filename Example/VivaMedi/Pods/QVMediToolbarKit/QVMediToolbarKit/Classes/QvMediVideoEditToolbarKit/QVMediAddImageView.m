//
//  XYAddImageView.m
//  DZNEmptyDataSet
//
//  Created by chaojie zheng on 2020/4/21.
//

#import "QVMediAddImageView.h"
#import <Masonry/Masonry.h>
#import <XYCategory/XYCategory.h>
#import <QVMediTools/UIImage+QVMedi.h>

@interface QVMediAddImageView ()

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, assign) NSInteger curSelectIndex;

@property (nonatomic,   copy) void(^addBlock)(NSInteger curSelectIndex);

@property (nonatomic,   copy) void(^selectBlock)(NSInteger curSelectIndex, UIImage *image, BOOL autoRefresh);

@property (nonatomic, assign) QVMEDIADDBUTTONDIRECTION direction;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, strong) UIScrollView *imageBgScrollView;

@property (nonatomic, strong) UIButton *curSelectButton;

@end

@implementation QVMediAddImageView

- (instancetype)init {
    if (self = [super init]) {
        self.imageArray = [NSMutableArray new];
        self.buttonArray = [NSMutableArray new];
    }
    return self;
}

- (void)creatWithAddButtonDirection:(QVMEDIADDBUTTONDIRECTION)direction addClick:(void(^)(NSInteger curSelectIndex))addClick select:(void(^)(NSInteger curSelectIndex, UIImage *image, BOOL autoRefresh))selectFinish {
    self.addBlock = addClick;
    self.direction = direction;
    self.selectBlock = selectFinish;
    [self initUI];
}

- (void)initUI {
    if (self.direction == QVMEDIADDBUTTONDIRECTION_LEFT) {
        [self.addButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.centerY.equalTo(self);
            make.width.height.offset(60);
        }];
        [self.imageBgScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.addButton.mas_right);
            make.top.bottom.right.offset(0);
            make.centerY.equalTo(self);
         }];
    }else {
        [self.addButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-20);
            make.centerY.equalTo(self);
            make.width.height.offset(60);
        }];
        [self.imageBgScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.addButton.mas_left).offset(-10);
            make.left.offset(20);
            make.top.bottom.offset(0);
            make.centerY.equalTo(self);
         }];
    }
}

#pragma mark- action
- (void)setDataSource:(id)data {
    self.imageArray = data;
    [self reloadData:@""];
}

- (void)reloadData:(id)data {
    if ([data isKindOfClass:[UIImage class]]) {
        [self.imageArray addObject:data];
    }else if ([data isKindOfClass:[NSArray class]]) {
        [self.imageArray addObjectsFromArray:data];
    }
    if (!self.imageArray) {
        return;
    }
    if (self.imageArray.count == 0) {
        [self.imageBgScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self initUI];
        return;
    }
    [self.imageBgScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *imageBtnAry = [NSMutableArray arrayWithCapacity:self.imageArray.count];
    for (NSInteger index = 0; index < self.imageArray.count; index++) {
        UIImage *image = self.imageArray[index];
        UIButton *imageItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [imageItem setImage:image forState:UIControlStateNormal];
        imageItem.layer.cornerRadius = 6;
        imageItem.tag = 1000 + index;
        imageItem.clipsToBounds = YES;
        if (self.curSelectIndex < self.imageArray.count) {
            if (index == self.curSelectIndex) {
                [self autoSelectItem:imageItem];
            }
        }else {
            if (index == 0) {
                [self autoSelectItem:imageItem];
            }
        }
       
        [imageItem addTarget:self action:@selector(selectImageAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.imageBgScrollView addSubview:imageItem];
        [imageBtnAry addObject:imageItem];
    }
    self.buttonArray = imageBtnAry;
    [imageBtnAry mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:8 leadSpacing:8 tailSpacing:8];
    [imageBtnAry mas_makeConstraints:^(MASConstraintMaker *make) {
        if (imageBtnAry.count == 1) {
            make.left.offset(8);
        }
        make.width.offset(60);
        make.height.offset(60);
        make.centerY.equalTo(self.imageBgScrollView);
    }];
}

- (void)selectImageAction:(UIButton *)target {
    self.curSelectIndex = target.tag - 1000;
    if (self.selectBlock) {
        self.selectBlock(self.curSelectIndex, target.imageView.image, YES);
    }
    [self addBorder:target];
}

- (void)autoSelectItem:(UIButton *)target {
    self.curSelectIndex = target.tag - 1000;
    if (self.selectBlock) {
        self.selectBlock(self.curSelectIndex, target.imageView.image, NO);
    }
    [self addBorder:target];
}

- (void)addBorder:(UIButton *)target {
    if (target == self.curSelectButton) {
        return;
    }
    if (self.curSelectButton) {
        self.curSelectButton.selected = NO;
        self.curSelectButton.layer.borderWidth = 0;
        self.curSelectButton.layer.borderColor = UIColor.clearColor.CGColor;
        [UIView animateWithDuration:.1f animations:^{
            self.curSelectButton.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
        }];
    }
    if (self.curSelectButton == target) {
        self.curSelectButton = nil;
        return;
    }
    [UIView animateWithDuration:.1f animations:^{
        target.transform = CGAffineTransformMake(1.05, 0, 0, 1.05, 0, 0);
    }];
    target.layer.borderWidth = 2;
    target.layer.borderColor = UIColor.redColor.CGColor;
    self.curSelectButton = target;
}


- (void)addClickAction {
    if (self.addBlock) {
        self.addBlock(self.curSelectIndex);
    }
}

#pragma mark- lazy get set
- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton new];
        [_addButton setBackgroundImage:[UIImage qvmedi_imageWithName:@"qv_video_edit_add_icon" bundleName:@"QVMediToolbarKit"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addClickAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addButton];
    }
    return _addButton;
}

- (UIScrollView *)imageBgScrollView {
    if (!_imageBgScrollView) {
        _imageBgScrollView = [UIScrollView new];
        _imageBgScrollView.showsVerticalScrollIndicator = NO;
        _imageBgScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_imageBgScrollView];
    }
    return _imageBgScrollView;
}

@end
