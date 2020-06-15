//
//  QVPlayerViewController.m
//  QVCloudEngineSDK_Example
//
//  Created by 夏澄 on 2020/3/20.
//  Copyright © 2020 Sunshine. All rights reserved.
//

#import "QVPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "QVBaseNavigationController.h"
#import <Masonry/Masonry.h>
#import "UIImage+QVMediEdit.h"

@interface QVPlayerViewController ()
/**
 *  控制视频播放的控件
 */
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
/**
 *  声明播放视频的控件属性[既可以播放视频也可以播放音频]
 */
@property (nonatomic,strong)AVPlayer *player;
/**
 *  播放的总时长
 */
@property (nonatomic,assign)CGFloat sumPlayOperation;

@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation QVPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *playString = self.fileUrl;
    NSURL *url = [NSURL fileURLWithPath:playString];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    self.player = [[AVPlayer alloc] initWithPlayerItem:item];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
    layer.frame = self.view.frame;
    layer.backgroundColor = [UIColor blackColor].CGColor;
    layer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:layer];
    self.progressSlider.value = 0;
    self.player.volume = 1.0f;
    [self.player play];
    [self.closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeAction {
    [getCurrentViewController().navigationController popToRootViewControllerAnimated:YES];
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton new];
        [_closeButton setImage:[UIImage QVMediEditImageNamed:@"qvmedi_preview_icon_close_white"] forState:UIControlStateNormal];
        [self.view addSubview:_closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.top.offset(70);
            make.width.height.offset(28);
        }];
    }
    return _closeButton;
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
