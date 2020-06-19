//
//  XYReactBlackMapBoard.m
//  XYReactDataBoard
//
//  Created by 夏澄 on 2019/10/25.
//

#import "XYReactBlackMapBoard.h"

typedef NS_ENUM(NSInteger, XYReactMapFlagValue) {
    XYReactMapSignalOn = 0,
    XYReactMapSignalOff,
};
@interface XYReactBlackMapBoard ()
@property (nonatomic, strong) NSMutableDictionary <NSString *, RACSubject*> *observers;
@property (nonatomic, strong) NSMutableDictionary *values;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSNumber*> *flags;
@end

@implementation XYReactBlackMapBoard

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self.values) {
        [self.values setValue:value forKey:key];
    }
    if (XYReactMapSignalOn == [[self.flags valueForKey:key] integerValue]) {
        NSArray *arr = [self subjectsForKey:key];
        [arr enumerateObjectsUsingBlock:^(RACSubject *subject, NSUInteger idx, BOOL * _Nonnull stop) {
            [subject sendNext:value];
        }];
    }
}

- (id)valueForKey:(NSString *)key
{
    if (key.length <= 0) return nil;
    return [self.values objectForKey:key];
}

- (RACSignal *)addObserver:(id)obj forKey:(NSString *)key
{
    if (key.length <= 0) return [RACSignal empty];
    @synchronized (self) {
       [self.flags setValue:@(XYReactMapSignalOn) forKey:key];
       NSString *insideKey = [NSString stringWithFormat:@"%@_%@_%p",key,NSStringFromClass([obj class]),obj];
       RACSubject *subject = [RACSubject subject];
       [self.observers setValue:subject forKey:insideKey];
       return subject;
    }
}

- (BOOL)isSubscribeForKey:(NSString *)key {
    NSArray *subjects = [self subjectsForKey:key];
    if (subjects.count > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (NSArray *)subjectsForKey:(NSString *)key
{
     __block NSMutableArray *allSubjects = [NSMutableArray array];
     @synchronized (allSubjects) {
        [self.observers.allKeys enumerateObjectsUsingBlock:^(NSString *insideKey, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([insideKey hasPrefix:key]) {
                [allSubjects addObject:[self.observers objectForKey:insideKey]];
            }
        }];
        return allSubjects;
    }
}

- (void)pauseSignalForKey:(NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self.flags) {
        [self.flags setValue:@(XYReactMapSignalOff) forKey:key];
    }
}

- (void)restartSignalForKey:(NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self.flags) {
        [self.flags setValue:@(XYReactMapSignalOn) forKey:key];
    }
}

- (void)removeObserver:(id)obj forKey:(NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self.observers) {
        NSString *insideKey = [NSString stringWithFormat:@"%@_%@_%p",key,NSStringFromClass([obj class]),obj];
         RACSubject *subject = [self.observers objectForKey:insideKey];
        if (subject) {
           [self.observers removeObjectForKey:insideKey];
        }
    }
}

- (void)removeAllObjObservers:(id)obj
{
    if (!obj) return;
    NSString *obj_str = [NSString stringWithFormat:@"%@_%p",NSStringFromClass([obj class]),obj];
    if (obj_str.length <= 0) return;
    @synchronized (self.observers) {
        [self.observers.allKeys enumerateObjectsUsingBlock:^(NSString *insideKey, NSUInteger idx, BOOL * _Nonnull stop) {
           if ([insideKey containsString:obj_str]) {
              [self.observers removeObjectForKey:insideKey];
           }
        }];
    }
}

- (void)removeAllKeyObservers:(NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self.observers) {
        [self.observers.allKeys enumerateObjectsUsingBlock:^(NSString *insideKey, NSUInteger idx, BOOL * _Nonnull stop) {
           if ([insideKey hasPrefix:key]) {
              [self.observers removeObjectForKey:insideKey];
           }
        }];
    }
}

- (NSMutableDictionary *)observers
{
    if (!_observers) {
        _observers = [NSMutableDictionary dictionary];
    }
    return _observers;
}

- (NSMutableDictionary *)values
{
    if (!_values) {
        _values = [NSMutableDictionary dictionary];
    }
    return _values;
}

- (NSMutableDictionary *)flags
{
    if (!_flags) {
        _flags = [NSMutableDictionary dictionary];
    }
    return _flags;
}

@end
