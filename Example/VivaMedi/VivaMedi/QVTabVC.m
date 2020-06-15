//
//  QVTabVC.m
//  VivaMedi
//
//  Created by 夏澄 on 2020/4/15.
//  Copyright © 2020 QuVideo. All rights reserved.
//

#import "QVTabVC.h"

@interface QVTabVC ()<UITabBarControllerDelegate, UINavigationControllerDelegate>

@end

@implementation QVTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBar.hidden = YES;
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
