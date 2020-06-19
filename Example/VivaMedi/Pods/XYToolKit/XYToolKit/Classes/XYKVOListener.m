//
//  XYKVOListener.m
//  AWSCore
//
//  Created by Frenzy Feng on 2019/12/2.
//

#import "XYKVOListener.h"
#import <libkern/OSAtomic.h>
#import <objc/message.h>

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Convert your project to ARC or specify the -fobjc-arc flag.
#endif

#pragma mark Utilities -

static NSString *describe_option(NSKeyValueObservingOptions option)
{
  switch (option) {
    case NSKeyValueObservingOptionNew:
      return @"NSKeyValueObservingOptionNew";
      break;
    case NSKeyValueObservingOptionOld:
      return @"NSKeyValueObservingOptionOld";
      break;
    case NSKeyValueObservingOptionInitial:
      return @"NSKeyValueObservingOptionInitial";
      break;
    case NSKeyValueObservingOptionPrior:
      return @"NSKeyValueObservingOptionPrior";
      break;
    default:
      NSCAssert(NO, @"unexpected option %tu", option);
      break;
  }
  return nil;
}

static void append_option_description(NSMutableString *s, NSUInteger option)
{
  if (0 == s.length) {
    [s appendString:describe_option(option)];
  } else {
    [s appendString:@"|"];
    [s appendString:describe_option(option)];
  }
}

static NSUInteger enumerate_flags(NSUInteger *ptrFlags)
{
  NSCAssert(ptrFlags, @"expected ptrFlags");
  if (!ptrFlags) {
    return 0;
  }
  
  NSUInteger flags = *ptrFlags;
  if (!flags) {
    return 0;
  }
  
  NSUInteger flag = 1 << __builtin_ctzl(flags);
  flags &= ~flag;
  *ptrFlags = flags;
  return flag;
}

static NSString *describe_options(NSKeyValueObservingOptions options)
{
  NSMutableString *s = [NSMutableString string];
  NSUInteger option;
  while (0 != (option = enumerate_flags(&options))) {
    append_option_description(s, option);
  }
  return s;
}

#pragma mark - _XYKVOInfo

/**
 @abstract The key-value observation info.
 @discussion Object equality is only used within the scope of a controller instance. Safely omit controller from equality definition.
 */
@interface _XYKVOInfo : NSObject
@end

@implementation _XYKVOInfo
{
@public
  __weak XYKVOListener *_listener;
  NSString *_keyPath;
  NSKeyValueObservingOptions _options;
  SEL _action;
  void *_context;
  XYKVONotificationBlock _block;
}

- (instancetype)initWithController:(XYKVOListener *)listener keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(XYKVONotificationBlock)block action:(SEL)action context:(void *)context
{
  self = [super init];
  if (nil != self) {
    _listener = listener;
    _block = [block copy];
    _keyPath = [keyPath copy];
    _options = options;
    _action = action;
    _context = context;
  }
  return self;
}

- (instancetype)initWithController:(XYKVOListener *)listener keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(XYKVONotificationBlock)block
{
  return [self initWithController:listener keyPath:keyPath options:options block:block action:NULL context:NULL];
}

- (instancetype)initWithController:(XYKVOListener *)listener keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options action:(SEL)action
{
  return [self initWithController:listener keyPath:keyPath options:options block:NULL action:action context:NULL];
}

- (instancetype)initWithController:(XYKVOListener *)listener keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
  return [self initWithController:listener keyPath:keyPath options:options block:NULL action:NULL context:context];
}

- (instancetype)initWithController:(XYKVOListener *)listener keyPath:(NSString *)keyPath
{
  return [self initWithController:listener keyPath:keyPath options:0 block:NULL action:NULL context:NULL];
}

- (NSUInteger)hash
{
  return [_keyPath hash];
}

- (BOOL)isEqual:(id)object
{
  if (nil == object) {
    return NO;
  }
  if (self == object) {
    return YES;
  }
  if (![object isKindOfClass:[self class]]) {
    return NO;
  }
  return [_keyPath isEqualToString:((_XYKVOInfo *)object)->_keyPath];
}

- (NSString *)debugDescription
{
  NSMutableString *s = [NSMutableString stringWithFormat:@"<%@:%p keyPath:%@", NSStringFromClass([self class]), self, _keyPath];
  if (0 != _options) {
    [s appendFormat:@" options:%@", describe_options(_options)];
  }
  if (NULL != _action) {
    [s appendFormat:@" action:%@", NSStringFromSelector(_action)];
  }
  if (NULL != _context) {
    [s appendFormat:@" context:%p", _context];
  }
  if (NULL != _block) {
    [s appendFormat:@" block:%p", _block];
  }
  [s appendString:@">"];
  return s;
}

@end

#pragma mark - _XYKVOSharedController

/**
 @abstract The shared KVO controller instance.
 @discussion Acts as a receptionist, receiving and forwarding KVO notifications.
 */
@interface _XYKVOSharedController : NSObject

/** A shared instance that never deallocates. */
+ (instancetype)sharedController;

/** observe an object, info pair */
- (void)observe:(id)object info:(_XYKVOInfo *)info;

/** unobserve an object, info pair */
- (void)unobserve:(id)object info:(_XYKVOInfo *)info;

/** unobserve an object with a set of infos */
- (void)unobserve:(id)object infos:(NSSet *)infos;

@end

@implementation _XYKVOSharedController
{
  NSHashTable *_infos;
  OSSpinLock _lock;
}

+ (instancetype)sharedController
{
  static _XYKVOSharedController *_controller = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _controller = [[_XYKVOSharedController alloc] init];
  });
  return _controller;
}

- (instancetype)init
{
  self = [super init];
  if (nil != self) {
    NSHashTable *infos = [NSHashTable alloc];
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
    _infos = [infos initWithOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    if ([NSHashTable respondsToSelector:@selector(weakObjectsHashTable)]) {
      _infos = [infos initWithOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
    } else {
      // silence deprecated warnings
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
      _infos = [infos initWithOptions:NSPointerFunctionsZeroingWeakMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
#pragma clang diagnostic pop
    }
    
#endif
    _lock = OS_SPINLOCK_INIT;
  }
  return self;
}

- (NSString *)debugDescription
{
  NSMutableString *s = [NSMutableString stringWithFormat:@"<%@:%p", NSStringFromClass([self class]), self];
  
  // lock
  OSSpinLockLock(&_lock);
  
  NSMutableArray *infoDescriptions = [NSMutableArray arrayWithCapacity:_infos.count];
  for (_XYKVOInfo *info in _infos) {
    [infoDescriptions addObject:info.debugDescription];
  }
  
  [s appendFormat:@" contexts:%@", infoDescriptions];
  
  // unlock
  OSSpinLockUnlock(&_lock);
  
  [s appendString:@">"];
  return s;
}

- (void)observe:(id)object info:(_XYKVOInfo *)info
{
  if (nil == info) {
    return;
  }
  
  // register info
  OSSpinLockLock(&_lock);
  [_infos addObject:info];
  OSSpinLockUnlock(&_lock);
  
  // add observer
  [object addObserver:self forKeyPath:info->_keyPath options:info->_options context:(void *)info];
}

- (void)unobserve:(id)object info:(_XYKVOInfo *)info
{
  if (nil == info) {
    return;
  }
  
  // unregister info
  OSSpinLockLock(&_lock);
  [_infos removeObject:info];
  OSSpinLockUnlock(&_lock);
  
  // remove observer
  [object removeObserver:self forKeyPath:info->_keyPath context:(void *)info];
}

- (void)unobserve:(id)object infos:(NSSet *)infos
{
  if (0 == infos.count) {
    return;
  }
  
  // unregister info
  OSSpinLockLock(&_lock);
  for (_XYKVOInfo *info in infos) {
    [_infos removeObject:info];
  }
  OSSpinLockUnlock(&_lock);
  
  // remove observer
  for (_XYKVOInfo *info in infos) {
    [object removeObserver:self forKeyPath:info->_keyPath context:(void *)info];
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  NSAssert(context, @"missing context keyPath:%@ object:%@ change:%@", keyPath, object, change);
  
  _XYKVOInfo *info;
  
  {
    // lookup context in registered infos, taking out a strong reference only if it exists
    OSSpinLockLock(&_lock);
    info = [_infos member:(__bridge id)context];
    OSSpinLockUnlock(&_lock);
  }
  
  if (nil != info) {
    
    // take strong reference to controller
    XYKVOListener *listener = info->_listener;
    if (nil != listener) {
      
      // take strong reference to observer
      id observer = listener.observer;
      if (nil != observer) {
        
        // dispatch custom block or action, fall back to default action
        if (info->_block) {
          info->_block(observer, object, change);
        } else if (info->_action) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
          [observer performSelector:info->_action withObject:change withObject:object];
#pragma clang diagnostic pop
        } else {
          [observer observeValueForKeyPath:keyPath ofObject:object change:change context:info->_context];
        }
      }
    }
  }
}

@end


#pragma mark - XYKVOListener

@implementation XYKVOListener
{
  NSMapTable *_objectInfosMap;
  OSSpinLock _lock;
}

#pragma mark Lifecycle -

+ (instancetype)listenerWithObserver:(id)observer
{
  return [[self alloc] initWithObserver:observer];
}

- (instancetype)initWithObserver:(id)observer retainObserved:(BOOL)retainObserved
{
  self = [super init];
  if (nil != self) {
    _observer = observer;
    NSPointerFunctionsOptions keyOptions = retainObserved ? NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPointerPersonality : NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality;
    _objectInfosMap = [[NSMapTable alloc] initWithKeyOptions:keyOptions valueOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPersonality capacity:0];
    _lock = OS_SPINLOCK_INIT;
  }
  return self;
}

- (instancetype)initWithObserver:(id)observer
{
  return [self initWithObserver:observer retainObserved:YES];
}

- (void)dealloc
{
  [self unobserveAll];
}

#pragma mark - Properties

- (NSString *)debugDescription
{
  NSMutableString *s = [NSMutableString stringWithFormat:@"<%@:%p", NSStringFromClass([self class]), self];
  [s appendFormat:@" observer:<%@:%p>", NSStringFromClass([_observer class]), _observer];
  
  // lock
  OSSpinLockLock(&_lock);
  
  if (0 != _objectInfosMap.count) {
    [s appendString:@"\n  "];
  }
  
  for (id object in _objectInfosMap) {
    NSMutableSet *infos = [_objectInfosMap objectForKey:object];
    NSMutableArray *infoDescriptions = [NSMutableArray arrayWithCapacity:infos.count];
    [infos enumerateObjectsUsingBlock:^(_XYKVOInfo *info, BOOL *stop) {
      [infoDescriptions addObject:info.debugDescription];
    }];
    [s appendFormat:@"%@ -> %@", object, infoDescriptions];
  }
  
  // unlock
  OSSpinLockUnlock(&_lock);
  
  [s appendString:@">"];
  return s;
}

#pragma mark - Utilities

- (void)_observe:(id)object info:(_XYKVOInfo *)info
{
  // lock
  OSSpinLockLock(&_lock);
  
  NSMutableSet *infos = [_objectInfosMap objectForKey:object];
  
  // check for info existence
  _XYKVOInfo *existingInfo = [infos member:info];
  if (nil != existingInfo) {
    NSLog(@"observation info already exists %@", existingInfo);
    
    // unlock and return
    OSSpinLockUnlock(&_lock);
    return;
  }
  
  // lazilly create set of infos
  if (nil == infos) {
    infos = [NSMutableSet set];
    [_objectInfosMap setObject:infos forKey:object];
  }
  
  // add info and oberve
  [infos addObject:info];
  
  // unlock prior to callout
  OSSpinLockUnlock(&_lock);
  
  [[_XYKVOSharedController sharedController] observe:object info:info];
}

- (void)_unobserve:(id)object info:(_XYKVOInfo *)info
{
  // lock
  OSSpinLockLock(&_lock);
  
  // get observation infos
  NSMutableSet *infos = [_objectInfosMap objectForKey:object];
  
  // lookup registered info instance
  _XYKVOInfo *registeredInfo = [infos member:info];
  
  if (nil != registeredInfo) {
    [infos removeObject:registeredInfo];
    
    // remove no longer used infos
    if (0 == infos.count) {
      [_objectInfosMap removeObjectForKey:object];
    }
  }
  
  // unlock
  OSSpinLockUnlock(&_lock);
  
  // unobserve
  [[_XYKVOSharedController sharedController] unobserve:object info:registeredInfo];
}

- (void)_unobserve:(id)object
{
  // lock
  OSSpinLockLock(&_lock);
  
  NSMutableSet *infos = [_objectInfosMap objectForKey:object];
  
  // remove infos
  [_objectInfosMap removeObjectForKey:object];
  
  // unlock
  OSSpinLockUnlock(&_lock);
  
  // unobserve
  [[_XYKVOSharedController sharedController] unobserve:object infos:infos];
}

- (void)_unobserveAll
{
  // lock
  OSSpinLockLock(&_lock);
  
  NSMapTable *objectInfoMaps = [_objectInfosMap copy];
  
  // clear table and map
  [_objectInfosMap removeAllObjects];
  
  // unlock
  OSSpinLockUnlock(&_lock);
  
  _XYKVOSharedController *shareController = [_XYKVOSharedController sharedController];
  
  for (id object in objectInfoMaps) {
    // unobserve each registered object and infos
    NSSet *infos = [objectInfoMaps objectForKey:object];
    [shareController unobserve:object infos:infos];
  }
}

#pragma mark - API

- (void)observe:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(XYKVONotificationBlock)block
{
  NSAssert(0 != keyPath.length && NULL != block, @"missing required parameters observe:%@ keyPath:%@ block:%p", object, keyPath, block);
  if (nil == object || 0 == keyPath.length || NULL == block) {
    return;
  }
  
  // create info
  _XYKVOInfo *info = [[_XYKVOInfo alloc] initWithController:self keyPath:keyPath options:options block:block];
  
  // observe object with info
  [self _observe:object info:info];
}


- (void)observe:(id)object keyPaths:(NSArray *)keyPaths options:(NSKeyValueObservingOptions)options block:(XYKVONotificationBlock)block
{
  NSAssert(0 != keyPaths.count && NULL != block, @"missing required parameters observe:%@ keyPath:%@ block:%p", object, keyPaths, block);
  if (nil == object || 0 == keyPaths.count || NULL == block) {
    return;
  }
  
  for (NSString *keyPath in keyPaths)
  {
    [self observe:object keyPath:keyPath options:options block:block];
  }
}

- (void)observe:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options action:(SEL)action
{
  NSAssert(0 != keyPath.length && NULL != action, @"missing required parameters observe:%@ keyPath:%@ action:%@", object, keyPath, NSStringFromSelector(action));
  NSAssert([_observer respondsToSelector:action], @"%@ does not respond to %@", _observer, NSStringFromSelector(action));
  if (nil == object || 0 == keyPath.length || NULL == action) {
    return;
  }
  
  // create info
  _XYKVOInfo *info = [[_XYKVOInfo alloc] initWithController:self keyPath:keyPath options:options action:action];
  
  // observe object with info
  [self _observe:object info:info];
}

- (void)observe:(id)object keyPaths:(NSArray *)keyPaths options:(NSKeyValueObservingOptions)options action:(SEL)action
{
  NSAssert(0 != keyPaths.count && NULL != action, @"missing required parameters observe:%@ keyPath:%@ action:%@", object, keyPaths, NSStringFromSelector(action));
  NSAssert([_observer respondsToSelector:action], @"%@ does not respond to %@", _observer, NSStringFromSelector(action));
  if (nil == object || 0 == keyPaths.count || NULL == action) {
    return;
  }
  
  for (NSString *keyPath in keyPaths)
  {
    [self observe:object keyPath:keyPath options:options action:action];
  }
}

- (void)observe:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
  NSAssert(0 != keyPath.length, @"missing required parameters observe:%@ keyPath:%@", object, keyPath);
  if (nil == object || 0 == keyPath.length) {
    return;
  }
  
  // create info
  _XYKVOInfo *info = [[_XYKVOInfo alloc] initWithController:self keyPath:keyPath options:options context:context];
  
  // observe object with info
  [self _observe:object info:info];
}

- (void)observe:(id)object keyPaths:(NSArray *)keyPaths options:(NSKeyValueObservingOptions)options context:(void *)context
{
  NSAssert(0 != keyPaths.count, @"missing required parameters observe:%@ keyPath:%@", object, keyPaths);
  if (nil == object || 0 == keyPaths.count) {
    return;
  }
  
  for (NSString *keyPath in keyPaths)
  {
    [self observe:object keyPath:keyPath options:options context:context];
  }
}

- (void)unobserve:(id)object keyPath:(NSString *)keyPath
{
  // create representative info
  _XYKVOInfo *info = [[_XYKVOInfo alloc] initWithController:self keyPath:keyPath];
  
  // unobserve object property
  [self _unobserve:object info:info];
}

- (void)unobserve:(id)object
{
  if (nil == object) {
    return;
  }
  
  [self _unobserve:object];
}

- (void)unobserveAll
{
  [self _unobserveAll];
}

@end
