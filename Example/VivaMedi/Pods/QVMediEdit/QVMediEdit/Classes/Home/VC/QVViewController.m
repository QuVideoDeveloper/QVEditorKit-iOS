//
//  QVViewController.m
//  QVEditor
//
//  Created by Sunshine on 03/31/2020.
//  Copyright (c) 2020 Sunshine. All rights reserved.
//

#import "QVViewController.h"
#import "QVHomeContentView.h"
#import "QVPreviewViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <XYCommonEngineKit/XYCommonEngineKit.h>
#import <Masonry/Masonry.h>
#import <Photos/PHPhotoLibrary.h>

@interface QVViewController ()

@property (nonatomic, strong) QVHomeContentView *contentView;

@end

@implementation QVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [XYEngineWorkspace addObserver:self taskID:XYCommonEngineTaskIDObserverEveryTaskFinishDispatchMain block:^(XYBaseEngineTask *task) {
        
        [SVProgressHUD dismiss];
    }];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = UIColor.whiteColor;
    [self initUI];
    
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
        }];
    } else if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        NSLog(@"无权限");
    }
}

- (void)initUI {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (QVHomeContentView *)contentView {
    if (!_contentView) {
        _contentView = [[QVHomeContentView alloc] init];
        [self.view addSubview:_contentView];
    }
    return _contentView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
