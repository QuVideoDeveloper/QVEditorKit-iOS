//
//  XYKVOListener.h
//  AWSCore
//
//  Created by Frenzy Feng on 2019/12/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 @abstract Block called on key-value change notification.
 @param observer The observer of the change.
 @param object The object changed.
 @param change The change dictionary.
 */
typedef void (^XYKVONotificationBlock)(id observer, id object, NSDictionary *change);

@interface XYKVOListener : NSObject

/**
 @abstract Creates and returns an initialized KVO controller instance.
 @param observer The object notified on key-value change.
 @return The initialized KVO controller instance.
 */
+ (instancetype)listenerWithObserver:(id)observer;

/**
 @abstract The designated initializer.
 @param observer The object notified on key-value change. The specified observer must support weak references.
 @param retainObserved Flag indicating whether observed objects should be retained.
 @return The initialized KVO controller instance.
 @discussion Use retainObserved = NO when a strong reference between controller and observee would create a retain loop. When not retaining observees, special care must be taken to remove observation info prior to observee dealloc.
 */
- (instancetype)initWithObserver:(id)observer retainObserved:(BOOL)retainObserved;

/**
 @abstract Convenience initializer.
 @param observer The object notified on key-value change. The specified observer must support weak references.
 @return The initialized KVO controller instance.
 @discussion By default, KVO controller retains objects observed.
 */
- (instancetype)initWithObserver:(id)observer;

/// The observer notified on key-value change. Specified on initialization.
@property (atomic, weak, readonly) id observer;

/**
 @abstract Registers observer for key-value change notification.
 @param object The object to observe.
 @param keyPath The key path to observe.
 @param options The NSKeyValueObservingOptions to use for observation.
 @param block The block to execute on notification.
 @discussion On key-value change, the specified block is called. In order to avoid retain loops, the block must avoid referencing the KVO controller or an owner thereof. Observing an already observed object key path or nil results in no operation.
 */
- (void)observe:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(XYKVONotificationBlock)block;

/**
 @abstract Registers observer for key-value change notification.
 @param object The object to observe.
 @param keyPath The key path to observe.
 @param options The NSKeyValueObservingOptions to use for observation.
 @param action The observer selector called on key-value change.
 @discussion On key-value change, the observer's action selector is called. The selector provided should take the form of -propertyDidChange, -propertyDidChange: or -propertyDidChange:object:, where optional parameters delivered will be KVO change dictionary and object observed. Observing nil or observing an already observed object's key path results in no operation.
 */
- (void)observe:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options action:(SEL)action;

/**
 @abstract Registers observer for key-value change notification.
 @param object The object to observe.
 @param keyPath The key path to observe.
 @param options The NSKeyValueObservingOptions to use for observation.
 @param context The context specified.
 @discussion On key-value change, the observer's -observeValueForKeyPath:ofObject:change:context: method is called. Observing an already observed object key path or nil results in no operation.
 */
- (void)observe:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;


/**
 @abstract Registers observer for key-value change notification.
 @param object The object to observe.
 @param keyPaths The key paths to observe.
 @param options The NSKeyValueObservingOptions to use for observation.
 @param block The block to execute on notification.
 @discussion On key-value change, the specified block is called. Inorder to avoid retain loops, the block must avoid referencing the KVO controller or an owner thereof. Observing an already observed object key path or nil results in no operation.
 */
- (void)observe:(id)object keyPaths:(NSArray *)keyPaths options:(NSKeyValueObservingOptions)options block:(XYKVONotificationBlock)block;

/**
 @abstract Registers observer for key-value change notification.
 @param object The object to observe.
 @param keyPaths The key paths to observe.
 @param options The NSKeyValueObservingOptions to use for observation.
 @param action The observer selector called on key-value change.
 @discussion On key-value change, the observer's action selector is called. The selector provided should take the form of -propertyDidChange, -propertyDidChange: or -propertyDidChange:object:, where optional parameters delivered will be KVO change dictionary and object observed. Observing nil or observing an already observed object's key path results in no operation.
 */
- (void)observe:(id)object keyPaths:(NSArray *)keyPaths options:(NSKeyValueObservingOptions)options action:(SEL)action;

/**
 @abstract Registers observer for key-value change notification.
 @param object The object to observe.
 @param keyPaths The key paths to observe.
 @param options The NSKeyValueObservingOptions to use for observation.
 @param context The context specified.
 @discussion On key-value change, the observer's -observeValueForKeyPath:ofObject:change:context: method is called. Observing an already observed object key path or nil results in no operation.
 */
- (void)observe:(id)object keyPaths:(NSArray *)keyPaths options:(NSKeyValueObservingOptions)options context:(void *)context;


/**
 @abstract Unobserve object key path.
 @param object The object to unobserve.
 @param keyPath The key path to observe.
 @discussion If not observing object key path, or unobserving nil, this method results in no operation.
 */
- (void)unobserve:(id)object keyPath:(NSString *)keyPath;

/**
 @abstract Unobserve all object key paths.
 @param object The object to unobserve.
 @discussion If not observing object, or unobserving nil, this method results in no operation.
 */
- (void)unobserve:(id)object;

/**
 @abstract Unobserve all objects.
 @discussion If not observing any objects, this method results in no operation.
 */
- (void)unobserveAll;

@end

NS_ASSUME_NONNULL_END
