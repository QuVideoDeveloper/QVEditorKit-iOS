//
//  QVVideoEditViewController.m
//  VivaMedi
//
//  Created by chaojie zheng on 2020/4/21.
//  Copyright © 2020 QuVideo. All rights reserved.
//

#import "QVVideoEditViewController.h"
#import "QVVideoEditContentView.h"
#import <Masonry/Masonry.h>
#import <XYCommonEngineKit/XYCommonEngineKit.h>

static CGFloat safeAreaTop() {
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].delegate.window.safeAreaInsets.top > 0 ? [UIApplication sharedApplication].delegate.window.safeAreaInsets.top : 20;
    } else {
        return 0;
    }
}

@interface QVVideoEditViewController ()

@property (nonatomic, strong) QVVideoEditContentView *contentView;

@end

@implementation QVVideoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.blackColor;
    //刷新数据
    [XYEngineWorkspace reloadAllData];
    XYStoryboardModel *sbModel = [XYEngineWorkspace stordboardMgr].currentStbModel;
    sbModel.taskID = XYCommonEngineTaskIDStoryboardRatio;
    sbModel.ratioValue = 16/9.0;
    [[XYEngineWorkspace stordboardMgr] runTask:sbModel];
    [self initUI];
    self.contentView.isCardPoint = self.isCardPoint;
}

- (void)initUI {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(safeAreaTop());
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - lazy
- (QVVideoEditContentView *)contentView {
    if (!_contentView) {
        _contentView = [[QVVideoEditContentView alloc] init];
        _contentView.backgroundColor = UIColor.blackColor;
        [self.view addSubview:_contentView];
    }
    return _contentView;
}

- (void)dealloc {
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
