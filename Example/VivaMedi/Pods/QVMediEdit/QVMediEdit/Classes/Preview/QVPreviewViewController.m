//
//  QVPreviewViewController.m
//  QVEditor_Example
//
//  Created by chaojie zheng on 2020/4/10.
//  Copyright © 2020 Sunshine. All rights reserved.
//

#import "QVPreviewViewController.h"
#import <XYCommonEngineKit/XYCommonEngineKit.h>
#import "QVMediVideoEditManager.h"
#import <Masonry/Masonry.h>
#import "UIImage+QVMediEdit.h"

@interface QVPreviewViewController ()

@property (nonatomic, strong) XYPlayerView *playView;

@end

@implementation QVPreviewViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"预览";
    self.view.backgroundColor = UIColor.whiteColor;
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(200);
        make.center.equalTo(self.view);
    }];
    [self.playView refreshWithConfig:^XYPlayerViewConfiguration *(XYPlayerViewConfiguration *config) {
        return [XYPlayerViewConfiguration currentStoryboardSourceConfig];
    }];
}

- (void)creatBarItem {
    UIButton *leftCustomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    [leftCustomButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [leftCustomButton setImage:[UIImage QVMediEditImageNamed:@"qvmedi_preview_icon_close"] forState:UIControlStateNormal];
    UIBarButtonItem * leftButtonItem =[[UIBarButtonItem alloc] initWithCustomView:leftCustomButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    UIButton *rightCustomButton = [self creatExportButton];
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightCustomButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

#pragma mark- action

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)exportAction {
    NSLog(@"最终导出");
}


#pragma mark-

- (XYPlayerView *)playView {
    if (!_playView) {
        _playView = [[XYPlayerView alloc] init];
        [self.view addSubview:_playView];
    }
    return _playView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
