//
//  XYEngineParam.h
//  Pods
//
//  Created by 徐新元 on 15/06/2017.
//
//

#import <Foundation/Foundation.h>

@interface XYEngineParam : NSObject

@property (nonatomic, copy) NSString *licensePath;
@property (nonatomic) BOOL defaultPlaybackMute;
@property (nonatomic) UInt32 outputVideoFormat;
@property (nonatomic) UInt32 outputAudioFormat;
@property (nonatomic) UInt32 outputFileFormat;
@property (nonatomic) UInt32 resampleMode;
@property (nonatomic) CGSize maxSupportResolution;
@property (nonatomic) UInt32 trimType;
@property (nonatomic) UInt64 defaultBgmId;
@property (nonatomic, copy) NSString *tempFolderPath;
@property (nonatomic, copy) NSString *corruptImagePath;

- (instancetype)initWithDefaultParam;

@end
