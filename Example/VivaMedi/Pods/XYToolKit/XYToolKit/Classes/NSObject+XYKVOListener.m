//
//  NSObject+XYKVOListener.m
//  AWSCore
//
//  Created by Frenzy Feng on 2019/12/2.
//

#import "NSObject+XYKVOListener.h"

#import <libkern/OSAtomic.h>
#import <objc/message.h>

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Convert your project to ARC or specify the -fobjc-arc flag.
#endif

static void *NSObjectKVOListenerKey = &NSObjectKVOListenerKey;
static void *NSObjectKVOListenerNonRetainingKey = &NSObjectKVOListenerNonRetainingKey;

@implementation NSObject (XYKVOListener)

- (XYKVOListener *)KVOListener
{
  id listener = objc_getAssociatedObject(self, NSObjectKVOListenerKey);
  
  // lazily create the KVOController
  if (nil == listener) {
    listener = [XYKVOListener listenerWithObserver:self];
    self.KVOListener = listener;
  }
  
  return listener;
}

- (void)setKVOListener:(XYKVOListener *)KVOController
{
  objc_setAssociatedObject(self, NSObjectKVOListenerKey, KVOController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XYKVOListener *)KVOListenerNonRetaining
{
  id listener = objc_getAssociatedObject(self, NSObjectKVOListenerNonRetainingKey);
  
  if (nil == listener) {
    listener = [[XYKVOListener alloc] initWithObserver:self retainObserved:NO];
    self.KVOListenerNonRetaining = listener;
  }
  
  return listener;
}

- (void)setKVOListenerNonRetaining:(XYKVOListener *)KVOListenerNonRetaining
{
  objc_setAssociatedObject(self, NSObjectKVOListenerNonRetainingKey, KVOListenerNonRetaining, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)observe:(id)object keyPath:(NSString *)keyPath block:(void(^)(id newValue))block
{
    [self.KVOListener observe:object keyPath:keyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        id newValue = change[NSKeyValueChangeNewKey];
        block(newValue);
    }];
}

@end
