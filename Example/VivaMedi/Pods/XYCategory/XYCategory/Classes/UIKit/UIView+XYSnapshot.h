//
//  UIView+XYSnapshot.h
//  XYBase
//
//  Created by robbin on 2019/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XYSnapshot)

/**
 Create a snapshot image of the complete view hierarchy.
 */
- (nullable UIImage *)xy_snapshotImage;

/**
 Create a snapshot image of the complete view hierarchy.
 @discussion It's faster than "snapshotImage", but may cause screen updates.
 See -[UIView drawViewHierarchyInRect:afterScreenUpdates:] for more information.
 */
- (nullable UIImage *)xy_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

@end

NS_ASSUME_NONNULL_END
