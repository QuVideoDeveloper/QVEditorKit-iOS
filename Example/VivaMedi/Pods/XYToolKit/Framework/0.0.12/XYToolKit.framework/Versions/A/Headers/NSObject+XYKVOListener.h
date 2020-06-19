//
//  NSObject+XYKVOListener.h
//  AWSCore
//
//  Created by Frenzy Feng on 2019/12/2.
//

#import <Foundation/Foundation.h>
#import "XYKVOListener.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (XYKVOListener)

/**
 @abstract Lazy-loaded XYKVOListener for use with any object
 @return FBKVOController associated with this object, creating one if necessary
 @discussion This makes it convenient to simply create and forget a FBKVOController, and when this object gets dealloc'd, so will the associated controller and the observation info.
 */
@property (nonatomic, strong) XYKVOListener *KVOListener;
@property (nonatomic, strong) XYKVOListener *KVOListenerNonRetaining;

- (void)observe:(id)object keyPath:(NSString *)keyPath block:(void(^)(id newValue))block;

@end

NS_ASSUME_NONNULL_END
