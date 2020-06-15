//
//  XYSlideShowMedia.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/30.
//


#import "XYSlideShowMedia.h"
#import "CXiaoYingSourceInfoNode.h"
#import "XYSourceInfoNodeHelper.h"
#import "XYVeRangeModel.h"
#import <Photos/Photos.h>

@interface XYSlideShowMedia ()

{
    CXiaoYingSourceInfoNode *_sourceInfoNode;
}

//for image
@property(nonatomic) SInt32 faceCenterX;// 默认 5000
@property(nonatomic) SInt32 faceCenterY;// 默认 5000
@property(nonatomic) BOOL faceDetected;//true

@end

@implementation XYSlideShowMedia

- (instancetype)initWithNode:(CXiaoYingSourceInfoNode *)node
{
    self = [super init];
    if (self) {
        _sourceInfoNode = node;
       [self addObserver];
    }
    return self;
}

- (instancetype)initWithMediaPath:(NSString *)mediaPath mediaTyp:(XYSlideShowMediaType)mediaType
{
    self = [super init];
    if (self) {
        _sourceInfoNode = [[CXiaoYingSourceInfoNode alloc] init];
        _sourceInfoNode.pstrSourceFile = mediaPath;
        _sourceInfoNode.uiRotation = 0;
        _sourceInfoNode.uiSourceType = [XYSourceInfoNodeHelper getInnerSouceTypeByXYSourceInfoType:mediaType];
        [self addObserver];
        switch (mediaType) {
            case XYSlideShowMediaTypeImage:
                _sourceInfoNode.pSourceInfo = [[CXiaoYingImageSourceInfo alloc] init];
                break;
            case XYSlideShowMediaTypeVideo:
                _sourceInfoNode.pSourceInfo = [[CXiaoYingVideoSourceInfo alloc] init];
            default:
                break;
        }
    }
    return self;
}

- (void)addObserver {
//    [self.videoRange addObserver:self forKeyPath:@"dwPos" options:NSKeyValueObservingOptionNew context:nil];
//    [self.videoRange addObserver:self forKeyPath:@"dwLen" options:NSKeyValueObservingOptionNew context:nil];
}

- (CXiaoYingSourceInfoNode *)sourceInfoNode
{
    return _sourceInfoNode;
}

- (NSString *)mediaPath
{
    return _sourceInfoNode.pstrSourceFile;
}

- (NSUInteger)rotation
{
    return (NSUInteger)_sourceInfoNode.uiRotation;
}

- (void)setRotation:(NSUInteger)rotation
{
    _sourceInfoNode.uiRotation = (UInt32)rotation;
}

- (XYSlideShowMediaType)mediaType
{
    return [XYSourceInfoNodeHelper getXYSourceInfoTypeByInnerSourceType:_sourceInfoNode.uiSourceType];
}

- (void)setMediaType:(XYSlideShowMediaType)mediaType
{
    _sourceInfoNode.uiSourceType = [XYSourceInfoNodeHelper getInnerSouceTypeByXYSourceInfoType:mediaType];
}

- (CXiaoYingImageSourceInfo *)getImageInfo
{
    if ([_sourceInfoNode.pSourceInfo isKindOfClass:[CXiaoYingImageSourceInfo class]]) {
        return (CXiaoYingImageSourceInfo *)_sourceInfoNode.pSourceInfo;
    }
    return nil;
}

- (CXiaoYingVideoSourceInfo *)getVideoInfo
{
    if ([_sourceInfoNode.pSourceInfo isKindOfClass:[CXiaoYingVideoSourceInfo class]]) {
        return (CXiaoYingVideoSourceInfo *)_sourceInfoNode.pSourceInfo;
    }
    return nil;
}

- (XYVeRangeModel *)videoRange
{
    CXiaoYingVideoSourceInfo *videoInfo = [self getVideoInfo];
    if (!_videoRange) {
        _videoRange = [[XYVeRangeModel alloc] init];
    }
    if (!videoInfo) {
        CXIAOYING_POSITION_RANGE_TYPE range = {0};
    }
    _videoRange.dwPos = videoInfo.srcRange.uiPosition;
    _videoRange.dwLen = videoInfo.srcRange.uiLen;
    return _videoRange;
}

- (SInt32)faceCenterX
{
    CXiaoYingImageSourceInfo *imageInfo = [self getImageInfo];
    if (!imageInfo) {
        return 0;
    }
    return imageInfo.siFaceCenterX;
}

- (void)setFaceCenterX:(SInt32)faceCenterX
{
    CXiaoYingImageSourceInfo *imageInfo = [self getImageInfo];
    if (!imageInfo) {
        return;
    }
    imageInfo.siFaceCenterX = faceCenterX;
}

- (SInt32)faceCenterY
{
    CXiaoYingImageSourceInfo *imageInfo = [self getImageInfo];
    if (!imageInfo) {
        return 0;
    }
    return imageInfo.siFaceCenterY;
}

- (void)setFaceCenterY:(SInt32)faceCenterY
{
    CXiaoYingImageSourceInfo *imageInfo = [self getImageInfo];
    if (!imageInfo) {
        return;
    }
    imageInfo.siFaceCenterY = faceCenterY;
}

- (BOOL)faceDetected
{
    CXiaoYingImageSourceInfo *imageInfo = [self getImageInfo];
    if (!imageInfo) {
        return NO;
    }
    return imageInfo.bFaceDetected;
}

- (void)setFaceDetected:(BOOL)faceDetected
{
    CXiaoYingImageSourceInfo *imageInfo = [self getImageInfo];
    if (!imageInfo) {
        return;
    }
    imageInfo.bFaceDetected = faceDetected;
}

+ (NSString *)getMediaPathForEngine:(PHAsset *)phAsset {
    NSString *string = [phAsset valueForKey:@"filename"];
    NSArray *NameArray = [string componentsSeparatedByString:@"."];
    NSString *videoLocalIdentifier = [NSString stringWithFormat:@"PHASSET://%@.%@",phAsset.localIdentifier,NameArray[1]];
    return videoLocalIdentifier;
}

///** 添加观察者必须要实现的方法 */
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    CXiaoYingVideoSourceInfo *videoInfo = [self getVideoInfo];
//    if (!videoInfo) {
//        return;
//    }
//    if ([@"dwPos" isEqualToString:keyPath]) {
//        NSNumber *new = change[NSKeyValueChangeNewKey];
//        CXIAOYING_POSITION_RANGE_TYPE range = {(UInt32)[new integerValue], (UInt32)self.videoRange.dwLen};
//        videoInfo.srcRange = range;
//    } else if ([@"dwLen" isEqualToString:keyPath]) {
//        NSNumber *new = change[NSKeyValueChangeNewKey];
//        CXIAOYING_POSITION_RANGE_TYPE range = {(UInt32)self.videoRange.dwPos, (UInt32)[new integerValue]};
//        videoInfo.srcRange = range;
//    }
//}

//-(void)dealloc {
//    [self.videoRange removeObserver:self forKeyPath:@"dwPos" context:nil];
//    [self.videoRange removeObserver:self forKeyPath:@"dwLen" context:nil];
//}

@end
