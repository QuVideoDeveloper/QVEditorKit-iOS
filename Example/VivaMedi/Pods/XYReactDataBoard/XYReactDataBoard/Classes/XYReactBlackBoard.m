//
//  XYReactBlackBoard.m
//  XYReactDataBoard
//
//  Created by lizitao on 2018/1/19.
//

#import "XYReactBlackBoard.h"
@interface XYReactBlackBoard ()
@property (nonatomic, strong) NSMutableDictionary *subjects;
@property (nonatomic, strong) NSMutableDictionary *values;
@property (nonatomic, strong) NSMutableDictionary <NSString*, NSNumber*>*flags;
@end

@implementation XYReactBlackBoard

- (instancetype)init
{
    self = [super init];
    if (self) {
        _subjects = [NSMutableDictionary dictionary];
        _values = [NSMutableDictionary dictionary];
        _flags = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self) {
        
        [self.values setValue:value forKey:key];
        if (![self.flags valueForKey:key]) {
            [self.flags setValue:@(1) forKey:key];
        }
    }
    if ([[self.flags valueForKey:key] integerValue]) {
         [[self subjectForKey:key] sendNext:value];
    }
}

- (void)pauseSignalForKey:(NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self) {
        [self.flags setValue:@(0) forKey:key];
    }
}

- (void)restartSignalForKey:(NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self) {
        [self.flags setValue:@(1) forKey:key];
    }
}

- (id)valueForKey:(NSString *)key
{
    return [self.values objectForKey:key];
}

- (RACSignal *)signalForKey:(NSString *)key
{
    if (key.length <= 0) return [RACSignal empty];
    RACSubject *subject = [self subjectForKey:key];
    if (!subject) {
        subject = [RACSubject subject];
        @synchronized (self) {
            [self.subjects setValue:subject forKey:key];
            [self.rac_deallocDisposable addDisposable:[RACDisposable disposableWithBlock:^{
                [subject sendCompleted];
            }]];
        }
    }
    return subject;
}

- (RACSubject *)subjectForKey:(NSString *)key
{
    return [self.subjects objectForKey:key];
}

- (void)removeValueForKey:(NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self) {
        [self.subjects removeObjectForKey:key];
        [self.values removeObjectForKey:key];
        [self.flags removeObjectForKey:key];
    }
}

@end
