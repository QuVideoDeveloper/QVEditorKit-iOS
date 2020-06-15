//
//  QVMediCameraClipModel.h
//  QVMediCameraEngine
//
//  Created by 徐新元 on 2020/4/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QVMediCameraClipModel : NSObject

//普通镜头相关
@property (nonatomic, copy) NSString *clipFilePath;
@property (nonatomic, assign) NSInteger startPos;
@property (nonatomic, assign) NSInteger endPos;
@property (nonatomic, assign) BOOL isToBeDeleted;
@property (nonatomic, assign) BOOL isClipFinishedRecording;
@property (nonatomic, assign) float timeScale;
@property (nonatomic, assign) CGRect cropRect;
@property (nonatomic, assign) NSInteger rotation;

//滤镜相关
@property (nonatomic, copy) NSString *filterFilePath;
@property (nonatomic, assign) NSInteger filterConfigIndex;

//音乐镜头相关
@property (nonatomic, copy) NSString *musicFilePath;
@property (nonatomic, assign) NSInteger dwMusicTrimStartPos;
@property (nonatomic, assign) NSInteger dwMusicTrimLen;
@property (nonatomic, assign) BOOL isMusicClipFinished;

@end

NS_ASSUME_NONNULL_END
