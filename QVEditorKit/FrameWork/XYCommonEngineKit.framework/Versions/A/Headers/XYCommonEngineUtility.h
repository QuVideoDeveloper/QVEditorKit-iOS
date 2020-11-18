//
//  XYCommonEngineUtility.h
//  XYCommonEngineKit
//
//  Created by lizitao on 2019/9/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define XYObtainCommonEngineClass(cls)  [XYCommonEngineUtility obtainValidCommonEngineClass:cls]

@interface XYCommonEngineUtility : NSObject

+ (Class)obtainValidCommonEngineClass:(NSString *)cls;

+ (BOOL)isTwoFloatEqual:(float)float1 float2:(float)float2;

+ (BOOL)xy_isImageFile:(NSString *)filePath;

+ (BOOL)xy_createFolder:(NSString *)folderPath;
    
+ (BOOL)xy_isFileExist:(NSString *)filePath;

+ (CVPixelBufferRef)pixelBufferFromCGImage:(UIImage *)inputImage;

@end

NS_ASSUME_NONNULL_END
