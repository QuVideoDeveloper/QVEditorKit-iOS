//
//  QVMediAlbumMediaItem.h
//  Pods
//
//  Created by robbin on 2020/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, QVMediAssetMediaType) {
    QVMediAssetMediaTypeImage   = 0,
    QVMediAssetMediaTypeVideo   = 1,
};

typedef NS_ENUM(NSInteger, QVMediMediaSourceType) {
    QVMediMediaSourceTypePHPhoto    = 0,
};

@interface QVMediAlbumMediaItem : NSObject

@property (nonatomic, strong) id originData;

@property (nonatomic, assign) QVMediAssetMediaType mediaType;

@property (nonatomic, assign) QVMediMediaSourceType sourceType;

@property (nonatomic, copy) NSString *filePath; // PHAsset类型为：PHASSET://

@property (nonatomic, assign) NSUInteger pixelWidth;

@property (nonatomic, assign) NSUInteger pixelHeight;

// 视频
@property (nonatomic, assign) CGFloat duration; // 毫秒计时

@property (nonatomic, assign) CGFloat startPoint; // 毫秒计时

@property (nonatomic, assign) CGFloat endPoint; // 毫秒计时

// 图片
@property (nonatomic, assign) UIImageOrientation orientation;

@end

NS_ASSUME_NONNULL_END
