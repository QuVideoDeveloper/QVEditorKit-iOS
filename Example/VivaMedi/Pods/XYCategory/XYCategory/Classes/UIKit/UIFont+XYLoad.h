//
//  UIFont+XYLoad.h
//  XYBase
//
//  Created by robbin on 2019/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (XYLoad)

/**
 Load the font from file path. Support format:TTF,OTF.
 If return YES, font can be load use it PostScript Name: [UIFont fontWithName:...]

 @param path font file's full path
 @return font name
 */
+ (NSString *)xy_loadFontFromPath:(NSString *)path;

/**
 Unload font from file path.
 
 @param path    font file's full path
 */
+ (void)xy_unloadFontFromPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
