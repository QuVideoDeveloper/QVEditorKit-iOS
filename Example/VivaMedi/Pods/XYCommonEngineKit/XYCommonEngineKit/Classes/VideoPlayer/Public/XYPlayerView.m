//
//  XYPlayerView.m
//  XYPlayerView
//
//  Created by 徐新元 on 09/01/2018.
//

#import "XYPlayerView.h"
#import "XYCommonEngineKit.h"
#import <XYReactDataBoard/XYReactBlackBoard.h>
#import <XYReactDataBoard/XYReactWhiteBoard.h>
#import <pthread.h>
#import "XYPlayerViewEngineObserver.h"
#import "XYVideoPlayerInfo.h"
#import "XYPlaybackView.h"
#import "XYPlaybackModule.h"
#import "XYPlayerViewConfiguration.h"
#import "XYAutoEditMgr.h"
#import "XYEngineWorkspace.h"
#import "XYEditUtils.h"

static NSString * const kPlayerStateKey = @"editor_player_state_key";
static NSString * const kPlayerSeekTimeKey = @"editor_player_seek_time_key";


@interface XYDisplayContextConfiguration : NSObject

@property (nonatomic) CGFloat boundsX;
@property (nonatomic) CGFloat boundsY;
@property (nonatomic) CGFloat boundsWidth;
@property (nonatomic) CGFloat boundsHeight;
@property (nonatomic) CGFloat contentScaleFactor;

@end

@implementation XYDisplayContextConfiguration
@end

@interface XYPlayerView () <PlaybackModuleDelegate>

@property (nonatomic, strong) XYReactBlackBoard *playerStateBoard;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTaskId;
@property (nonatomic) BOOL needAutoRebuild;
@property (nonatomic, assign) NSInteger currentSeekPositionFromCallback;
@property (nonatomic) BOOL isAutoSeekMsgSent;
@property (nonatomic, strong) XYPlayerViewEngineObserver *playerObserver;
@property (nonatomic) BOOL isSeekingByUser;
@property (nonatomic, strong) XYPlaybackModule *playbackModule;
@property (nonatomic, strong) XYPlaybackView *playbackView;
@property (nonatomic, strong) NSPointerArray *playerViewDelegateList;
@property (nonatomic, strong) XYDisplayContextConfiguration *displayContextConfig;

@property (nonatomic) BOOL isInitialized;
@end


@implementation XYPlayerView

- (XYPlayerView *)sharedInstance {
    static XYPlayerView *instance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [XYPlayerView new];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        /**
         引擎用于图像渲染的View
         @return 默认返回一个填充满PlayerView的XYPlaybackView
         */
        self.playbackView = [[XYPlaybackView alloc] initWithFrame:self.bounds];
        self.playbackView.backgroundColor = [UIColor blackColor];
        self.playbackView.clipsToBounds = YES;
        [self addSubview:self.playbackView];
        [self initPlayerObserver];
        [XYAutoEditMgr sharedInstance].editorPlayerView = self;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateDisplayContextConfig];
    [self updatePlaybackView];
    if (!self.playbackModule && !self.isInitialized && 0 != self.displayContextConfig.boundsWidth && 0 != self.displayContextConfig.boundsHeight) {//如果playbackModule不存在，才需要重新初始化
        [self initPlay];
        if (self.playbackModule) {
            self.isInitialized = YES;
        }
    }
}

- (void)updateDisplayContextConfig {
    if (0 != self.playerConfig.playStreamSize.width && 0 != self.playerConfig.playStreamSize.height) {
        self.displayContextConfig.boundsX = self.playbackView.bounds.origin.x;
        self.displayContextConfig.boundsY = self.playbackView.bounds.origin.y;
        self.displayContextConfig.boundsWidth = self.playerConfig.playStreamSize.width;
        self.displayContextConfig.boundsHeight = self.playerConfig.playStreamSize.height;
    } else {
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        CGFloat playbackViewWidth;
        CGFloat playbackViewHeight;
        float playbackViewRatio = self.playerConfig.videoRatio;
        if (playbackViewRatio >= 1) {
            playbackViewWidth = width;
            playbackViewHeight = playbackViewWidth / playbackViewRatio;
            if (playbackViewHeight > height) {
                playbackViewHeight = height;
                playbackViewWidth = playbackViewHeight * playbackViewRatio;
            }
        }else{
            playbackViewHeight = height;
            playbackViewWidth = playbackViewHeight * playbackViewRatio;
            if (playbackViewWidth > width) {
                playbackViewWidth = width;
                playbackViewHeight = playbackViewWidth/playbackViewRatio;
            }
        }
        self.displayContextConfig.boundsX = self.playbackView.bounds.origin.x;
        self.displayContextConfig.boundsY = self.playbackView.bounds.origin.y;
        self.displayContextConfig.boundsWidth = playbackViewWidth;
        self.displayContextConfig.boundsHeight = playbackViewHeight;
    }
    
    self.displayContextConfig.contentScaleFactor = self.playbackView.contentScaleFactor;
}
- (void)refreshWithConfig:(XYPlayerViewConfiguration *(^)(XYPlayerViewConfiguration * config))block {
    [self updateWithConfig:block];
}

#pragma mark - 更新播放源
- (void)updateWithConfig:(XYPlayerViewConfiguration *(^)(XYPlayerViewConfiguration *config))block{
    [self addObservers];
    float videoRatioBefore = self.playerConfig.videoRatio;
    if (block) {
        self.playerConfig = [XYPlayerViewConfiguration currentStoryboardSourceConfig];
        XYPlayerViewConfiguration *blockPlayerConfig = block(self.playerConfig);
        if (blockPlayerConfig) {
            self.playerConfig = blockPlayerConfig; //用block丢到外面去修改当前Config参数
        }
    }
    [XYStoryboard sharedXYStoryboard].playView = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self isInBackground]) {//后台状态不初始化player
               self.needAutoRebuild = YES;
               return;
           }
    });
   
    self.isAutoSeekMsgSent = NO;
    
    
    //视频比例有变化的话先更新一下playbackview用于后面获取displaycontext
    if (videoRatioBefore != self.playerConfig.videoRatio) {
        qv_dispatch_sync_on_main_queue(^{
            [self updateDisplayContextConfig];
            [self updatePlaybackView];
        });
    }

    if (self.displayContextConfig.boundsWidth <= 0 && self.displayContextConfig.boundsHeight <= 0) {
        return;
    }
    
    if (!self.playbackModule) {//如果playbackModule不存在，才需要重新初始化
        [self initPlay];
    }else{
        //以前需要uninit init player才能起作用的效果时，改成只做如下操作，速度会有几百毫秒的提升
        if (self.playerConfig.needRebuildStram) {
            [self pause];
            self.playerConfig.needRebuildStram = NO;
            [self.playbackModule setFrameSizeWidth:self.playerConfig.videoInfo.dwFrameWidth height:self.playerConfig.videoInfo.dwFrameHeight];
            [self.playbackModule rebuildStream];
            if (videoRatioBefore != self.playerConfig.videoRatio) {
                QVET_RENDER_CONTEXT_TYPE displayContext = [self createDisplayContext:self.displayContextConfig];
                [self.playbackModule setDisplayContext:&displayContext];
            }
        }
    }
    [self setPlaybackRange:self.playerConfig.playbackRange];
    //刷新UI
    [self updateAllUI];

}

- (void)initPlay {
    if (self.playerConfig.hSession == NULL) {
        return;
    }
    //创建播放stream
    CXiaoYingStream *stream = [XYEditUtils createStream:self.playerConfig.sourceType
                                               hSession:self.playerConfig.hSession
                                             frameWidth:self.playerConfig.videoInfo.dwFrameWidth
                                            frameHeight:self.playerConfig.videoInfo.dwFrameHeight
                                                  dwPos:self.playerConfig.seekPosition
                                                  dwLen:self.playerConfig.totalDuration
                                              dwBGColor:self.playerConfig.bgColor];
    
    //创建displaycontext
    QVET_RENDER_CONTEXT_TYPE displayContext = [self createDisplayContext:self.displayContextConfig];
    
    //创建playbackmodule
    self.playbackModule = [[XYPlaybackModule alloc] init:stream
                                            initPosition:self.playerConfig.seekPosition
                                          displayContext:&displayContext
                                  playbackModuleDelegate:self];
}

- (QVET_RENDER_CONTEXT_TYPE)createDisplayContext:(XYDisplayContextConfiguration *)playbackViewConfig {
    NSLog(@"createDisplayContext<--");
    QVET_RENDER_CONTEXT_TYPE displayContext = {0};
    //Set display context
    displayContext.hDisplayContext = (__bridge MHandle)self.playbackView;
    //displayContext.hOSD = MNull;
    displayContext.colorBackground = 0;
    displayContext.rectScreen.top = displayContext.rectClip.top = playbackViewConfig.boundsY * playbackViewConfig.contentScaleFactor;
    displayContext.rectScreen.bottom = displayContext.rectClip.bottom = (playbackViewConfig.boundsY * playbackViewConfig.contentScaleFactor + playbackViewConfig.boundsHeight * playbackViewConfig.contentScaleFactor);
    displayContext.rectScreen.left = displayContext.rectClip.left = playbackViewConfig.boundsX * playbackViewConfig.contentScaleFactor;
    displayContext.rectScreen.right = displayContext.rectClip.right = (playbackViewConfig.boundsX * playbackViewConfig.contentScaleFactor + playbackViewConfig.boundsWidth * playbackViewConfig.contentScaleFactor);
    displayContext.dwRotation = 0;
    displayContext.dwResampleMode = AMVE_RESAMPLE_MODE_UPSCALE_FITIN;
    displayContext.dwRenderTarget = QVET_RENDER_TARGET_SCREEN;
    NSLog(@"createDisplayContext-->");
    return displayContext;
}


- (void)initPlayerObserver {
    if (!_playerObserver) {
        [self.playerObserver startObserverWithPlayerView:self];
    }
}

#pragma mark - 销毁播放源
- (void)destroySource {
    if ([self isInBackground]) {//后台状态不操作player
        return;
    }
    if(self.playbackModule){
        self.isAutoSeekMsgSent = NO;
        NSLog(@"XYPlayerView uninitSource<--");
        [self.playbackModule unInit];
        self.playbackModule = nil;
        self.playerConfig = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        NSLog(@"XYPlayerView uninitSource-->");
    }
    [self removeObservers];
}

- (void)dealloc {
    NSLog(@"XYPlayerView dealloc");
    [self destroySource];
    [self.playerObserver removeObserver];
}

#pragma mark - resetPlaybackFullrange
- (void)resetPlaybackFullrange {
    XYVeRangeModel *range = [XYVeRangeModel VeRangeModelWithPosition:0 length:self.playerConfig.totalDuration];
    [self setPlaybackRange:range];
}

- (void)setPlaybackRange:(XYVeRangeModel *)range {
    [self setPlaybackRange:range async:YES];
}

- (void)setPlaybackRange:(XYVeRangeModel *)range async:(BOOL)async {
    if ([self isInBackground]) {
        return;
    }

    self.playerConfig.playbackRange = range;
    [self.playbackModule setPlayRange:self.playerConfig.playbackRange.dwPos endPos:self.playerConfig.playbackRange.dwPos + self.playerConfig.playbackRange.dwLen async:async];
}

- (XYVeRangeModel *)getPlaybackRange {
    return self.playerConfig.playbackRange;
}

#pragma mark - Play Pause
- (BOOL)isPlaying {
    return [self.playbackModule isPlaying];
}

- (void)play {
    if ([self isInBackground]) {
        return;
    }
    if (self.isDisablePlayAndSeek) {
        return;
    }
    if (self.playerConfig.seekPosition == self.playerConfig.playbackRange.dwPos + self.playerConfig.playbackRange.dwLen) {
        [self seekTo:self.playerConfig.playbackRange.dwPos force:YES async:NO];
    }
    [self.playbackModule play];
}

- (void)playAsync:(BOOL)async {
    if ([self isInBackground]) {
        return;
    }
    if (self.isDisablePlayAndSeek) {
        return;
    }
    if (self.playerConfig.seekPosition == self.playerConfig.playbackRange.dwPos + self.playerConfig.playbackRange.dwLen) {
        [self seekToPosition:self.playerConfig.seekPosition async:async];
    }
    [self.playbackModule playAsync:async];
}

- (void)playWithOutShowLayer {
    if ([self isInBackground]) {
        return;
    }
    if (self.isDisablePlayAndSeek) {
        return;
    }
    if (self.playerConfig.seekPosition == self.playerConfig.playbackRange.dwPos + self.playerConfig.playbackRange.dwLen) {
        [self seekTo:self.playerConfig.playbackRange.dwPos force:YES async:NO];
    }
    [self.playbackModule playWithOutShowLayer];
}

- (void)pause {
    if ([self isInBackground]) {
        return;
    }
    [self.playbackModule pause];
    self.playerConfig.seekPosition = self.currentSeekPositionFromCallback;//更新当前播放时间
}

#pragma mark - Seek
- (void)seekTo:(NSInteger)iTime force:(BOOL)force {
    if ([self isInBackground]) {
        return;
    }
    if (self.isDisablePlayAndSeek) {
        return;
    }
    if (force) {
        NSLog(@"forced %u",iTime);
    }
    self.playerConfig.seekPosition = iTime;
    [self.playbackModule seekTo:iTime force:force];
}

- (void)seekTo:(NSInteger)iTime force:(BOOL)force async:(BOOL)async {
    if ([self isInBackground]) {
        return;
    }
    if (self.isDisablePlayAndSeek) {
        return;
    }
    if (force) {
        NSLog(@"forced %u",iTime);
    }
    if (iTime > self.playerConfig.totalDuration) {
        return;
    }
    self.playerConfig.seekPosition = iTime;
    [self.playbackModule seekTo:iTime force:force async:async];
}

- (void)seekToPosition:(NSInteger)seekPosition async:(BOOL)async {
    if ([self isInBackground]) {
        return;
    }
    if (self.isDisablePlayAndSeek) {
        return;
    }
    if (seekPosition > self.playerConfig.totalDuration) {
        return;
    }
    self.playerConfig.seekPosition = seekPosition;
    [self.playbackModule seekToPosition:seekPosition async:async];
}

- (void)setVisibaleArea:(CGRect)visibleRect {
    [self.playbackView setVisibaleArea:visibleRect];
}

#pragma mark - 播放状态回调
- (void) playbackStateCallBack : (XYPlayerCallBackData *) playbackData {
    XYPlayerCallBackData *pData = [XYPlayerCallBackData new];
    pData.position = playbackData.position;
    pData.duration = playbackData.duration;
    pData.state = playbackData.state;
    pData.errCode = playbackData.errCode;
//    NSLog(@"XYPlayerView playbackStateCallBack state=%ld currentSeekTime=%ld duration=%ld errCode=0x%x",pData.state,pData.curTime,pData.duration,pData.errCode);
    if(pData.position > pData.duration){//以防万一
        return;
    }
    
    self.currentSeekPositionFromCallback = playbackData.position;
    
    if (pData.state == AMVE_PROCESS_STATUS_RUNNING) {
        self.playerConfig.seekPosition = pData.position;//更新当前播放时间
    }
    
    if(pData.state == AMVE_PROCESS_STATUS_PAUSED
       ||pData.state == AMVE_PROCESS_STATUS_STOPPED){
        if(pData.position == self.playerConfig.playbackEndTime){
            self.playerConfig.seekPosition = pData.position;//更新当前播放时间
            NSLog(@"更新当前播放时间%ld",pData.position);
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //发送信号
        [self.playerStateBoard setValue:@(pData.state) forKey:kPlayerStateKey];
        [self.playerStateBoard setValue:@(pData.position) forKey:kPlayerSeekTimeKey];
        
        if ([self.playbackModule isInBackground]) {
            return;//进入后台的话不回调出去
        }
        //对外回调
        [self playDelegatePlaybackStateCallBack:pData];
    });
}

#pragma mark - 前后台切换事件
- (BOOL)isInBackground {
    return [XYStoryboard sharedXYStoryboard].isInBackground;
}

- (void)addObservers {
    [self removeObservers];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillResignActive:)
     name:UIApplicationWillResignActiveNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillEnterForeground:)
     name:UIApplicationDidBecomeActiveNotification
     object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    if(!self.playbackModule){
        return;
    }
    self.backgroundTaskId = [self beginBackgroundTask:^{
        
    }];
    if([self isPlaying]){
        [self pause];
    }
    [self.playbackModule enterBackground];
    [self endBackgroundTask:self.backgroundTaskId];
    self.backgroundTaskId = UIBackgroundTaskInvalid;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self.playbackModule enterForeground];
    
    //进入前台时如果判断是否需要做rebuild
    if (self.needAutoRebuild) {
        self.needAutoRebuild = NO;
        [self updateWithConfig:^XYPlayerViewConfiguration *(XYPlayerViewConfiguration *config) {
            return config;
        }];
        [self displayRefreshAsync:YES];
    }
    
}

#pragma mark - UI控件更新
- (void)updateAllUI {
    qv_dispatch_sync_on_main_queue(^{
        [self updatePlaybackView];
    });
}

/**
 播放状态监控数据黑板
 */
- (XYReactBlackBoard *)playerStateBoard {
    if (!_playerStateBoard) {
        _playerStateBoard = [XYReactBlackBoard new];
        
        RACSignal *playerStateSignal = [_playerStateBoard signalForKey:kPlayerStateKey];
        @weakify(self)
        [[playerStateSignal distinctUntilChanged] subscribeNext:^(id x) {
            @strongify(self)
            NSLog(@"editor_player_state_key-->%@",x);
        }];
        
        RACSignal *playerSeekTimeSignal = [_playerStateBoard signalForKey:kPlayerSeekTimeKey];
        [[playerSeekTimeSignal distinctUntilChanged] subscribeNext:^(id x) {
            @strongify(self)
//            NSLog(@"editor_player_seek_time_key-->%@",x);
//            [self updateTimeLabel];
            if (!self.isSeekingByUser) {
            }
        }];
    }
    return _playerStateBoard;
}

#pragma mark - Delegate list 初始化

- (XYDisplayContextConfiguration *)displayContextConfig {
    if (!_displayContextConfig) {
        _displayContextConfig = [[XYDisplayContextConfiguration alloc] init];
    }
    return _displayContextConfig;;
}

- (NSPointerArray *)playerViewDelegateList {
    if (!_playerViewDelegateList) {
        _playerViewDelegateList = [NSPointerArray weakObjectsPointerArray];
    }
    return _playerViewDelegateList;
}

#pragma mark - 刷新VisionEffect
- (NSInteger)lockStuffUnderEffect:(CXiaoYingEffect *)effect async:(BOOL)async {
    return [self.playbackModule lockStuffUnderEffect:effect async:async];
}

- (NSInteger)unlockStuffUnderEffect:(CXiaoYingEffect *)effect async:(BOOL)async {
    return [self.playbackModule unlockStuffUnderEffect:effect async:async];
}

- (void)displayRefreshAsync:(BOOL)async {
    [self.playbackModule displayRefreshAsync:async];
}

- (void)refreshEffect:(CXiaoYingClip *)clip
               OpCode:(MDWord)opCode
               effect:(CXiaoYingEffect *)effect
                async:(BOOL)async {
    [self.playbackModule refreshEffect:clip OpCode:opCode Effect:effect async:async];
}

- (void)unInit {
    [self.playbackModule unInit];
}

#pragma mark - 禁用播放和Seek
- (void)setDisablePlayAndSeek:(BOOL)disablePlayAndSeek {
    _disablePlayAndSeek = disablePlayAndSeek;
    self.playbackModule.disablePlayAndSeek = disablePlayAndSeek;
}


- (UIBackgroundTaskIdentifier)beginBackgroundTask:(void(^ __nullable)(void))handler {
    
    UIBackgroundTaskIdentifier backgroundTaskId = UIBackgroundTaskInvalid;
    if ([UIDevice currentDevice].isMultitaskingSupported) {
        backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            if (handler) {
                handler();
            }
        }];
    }
    return backgroundTaskId;
}

-  (void)endBackgroundTask:(UIBackgroundTaskIdentifier)backgroundTaskId {
    
    if (backgroundTaskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskId];
    }
}

static inline void qv_dispatch_sync_on_main_queue(void (^block)(void)) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

- (XYPlayerViewEngineObserver *)playerObserver {
    if (!_playerObserver) {
        _playerObserver = [[XYPlayerViewEngineObserver alloc] init];
    }
    return _playerObserver;
}

//更新播放区域
- (void)updatePlaybackView {
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    if (isnan(self.displayContextConfig.boundsWidth) || isnan(self.displayContextConfig.boundsHeight)) {
        return;
    }
    self.playbackView.frame = CGRectMake(0, 0, self.displayContextConfig.boundsWidth, self.displayContextConfig.boundsHeight);
    self.playbackView.center = CGPointMake(width / 2.0,height / 2.0);
    
    
#if !TARGET_IPHONE_SIMULATOR
    if ([self.playbackView.layer isKindOfClass:[CAMetalLayer class]]) {
        float scaleFactor = [[UIScreen mainScreen] scale];
        ((CAMetalLayer *)self.playbackView.layer).drawableSize = CGSizeMake(self.displayContextConfig.boundsWidth * scaleFactor, self.displayContextConfig.boundsHeight * scaleFactor);
    }
#endif
}

- (void)addPlayDelegate:(id<XYPlayerViewDelegate>)delegate {
    for (id savedDelegate in self.playerViewDelegateList) {
        if (delegate == savedDelegate) {
            return;
        }
    }
    [self.playerViewDelegateList addPointer:(__bridge void*)delegate];
}


- (void)removePlayDelegate:(id<XYPlayerViewDelegate>)delegate {
   [self removeDelegate:delegate delegateList:self.playerViewDelegateList];
}

#pragma mark -- delegate

- (void)removeDelegate:(id)delegate delegateList:(NSPointerArray *)delegateList {
    NSInteger toBeDeleteIndex = -1;
    NSInteger currentIndex = 0;
    
    for (id savedDelegate in delegateList) {
        if (delegate == savedDelegate) {
            toBeDeleteIndex = currentIndex;
            break;
        }
        currentIndex++;
    }
    
    NSInteger count = [delegateList count];
    if (toBeDeleteIndex >= 0 && toBeDeleteIndex < count) {
        [delegateList removePointerAtIndex:toBeDeleteIndex];
    }
}

- (void)playDelegatePlaybackStateCallBack:(XYPlayerCallBackData *)playbackData {
    [self.playerViewDelegateList compact];
    
    for (id delegate in self.playerViewDelegateList) {
        if (delegate && [delegate respondsToSelector:@selector(playbackStateCallBack:)]) {
            [delegate playbackStateCallBack:playbackData];
        }
    }
}

- (void)refreshAudio {
    [self.playbackModule refreshAudio];
}

- (void)setVolume:(MDWord)volume {
    [self.playbackModule setVolumn:volume];
}

- (CGSize)streamSize {
    return CGSizeMake(self.displayContextConfig.boundsWidth, self.displayContextConfig.boundsHeight);
}

@end

