//
//  QVBaseViewController.m
//  QVEditor_Example
//
//  Created by chaojie zheng on 2020/4/10.
//  Copyright © 2020 Sunshine. All rights reserved.
//

#import "QVBaseViewController.h"
#import <QVMediTools/UIColor+QVMediInit.h>

@interface QVBaseViewController ()

@end

@implementation QVBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (UIButton *)creatExportButton {
    UIButton *rightCustomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 26)];
    [rightCustomButton addTarget:self action:@selector(exportAction) forControlEvents:UIControlEventTouchUpInside];
    [rightCustomButton setTitle:@"导出" forState:UIControlStateNormal];
    rightCustomButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    rightCustomButton.backgroundColor = [UIColor qvmedi_colorWithHEX:0xF94141];
    rightCustomButton.layer.cornerRadius = 4;
    return rightCustomButton;
}

- (void)exportAction {
    NSLog(@"导出");
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
