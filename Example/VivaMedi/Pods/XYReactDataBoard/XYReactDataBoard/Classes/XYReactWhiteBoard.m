//
//  XYReactWhiteBoard.m
//  XYReactDataBoard
//
//  Created by lizitao on 2018/1/10.
//

#import "XYReactWhiteBoard.h"
#import "XYReactDataBoardSubject.h"

@interface XYReactWhiteBoard ()
@property (nonatomic, strong) NSMutableDictionary *subjects;
@property (nonatomic, strong) NSMutableDictionary <NSString*, RACSubject*>*values;
@end

@implementation XYReactWhiteBoard

static XYReactWhiteBoard *whiteBoard;
static dispatch_once_t onceToken;

+ (instancetype)shareBoard
{
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    dispatch_once(&onceToken, ^{
        whiteBoard = [super allocWithZone:zone];
    });
    return whiteBoard;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return whiteBoard;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone
{
    return whiteBoard;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if (![self checkValidStringValue:key]) return;
    @synchronized (self.values) {
        if (value) {
            [self.values setValue:value forKey:key];
        } else {
            [self.values removeObjectForKey:key];
        }
    }
    [[self subjectForKey:key] sendNext:value];
}

- (id)valueForKey:(NSString *)key
{
    if (![self checkValidStringValue:key]) return nil;
    @synchronized (self.values) {
        return [self.values objectForKey:key];
    }
}

- (RACSignal *)signalForKey:(NSString *)key
{
    if (![self checkValidStringValue:key]) return [RACSignal empty];
    RACSubject *subject = [self subjectForKey:key];
    if (!subject) {
        subject = [RACSubject subject];
        @synchronized (self.subjects) {
            [self.subjects setValue:subject forKey:key];
        }
    }
    return subject;
}

- (nonnull RACSignal *)singleSignalForKey:(nonnull NSString *)key
{
    if (![self checkValidStringValue:key]) return [RACSignal empty];
    RACSubject *subject = [self subjectForKey:key];
    if (!subject || ![subject isKindOfClass:[XYReactDataBoardSubject class]]) {
        subject = [XYReactDataBoardSubject subject];
        @synchronized (self.subjects) {
            [self.subjects setValue:subject forKey:key];
        }
    }
    return subject;
}

- (RACSubject *)subjectForKey:(NSString *)key
{
    if (![self checkValidStringValue:key]) return nil;
    @synchronized (self.subjects) {
       return [self.subjects objectForKey:key];
    }
}

- (BOOL)checkValidStringValue:(NSString *)value
{
    if (![value isKindOfClass:[NSString class]]) {
       return NO;
    }
    if (value.length <= 0) {
        return NO;
    }
    return YES;
}

#pragma mark - accessor

- (NSMutableDictionary *)subjects
{
    if (!_subjects) {
        _subjects = [NSMutableDictionary dictionary];
    }
    return _subjects;
}

- (NSMutableDictionary *)values
{
    if (!_values) {
        _values = [NSMutableDictionary dictionary];
    }
    return _values;
}

#pragma mark - remove and destroy

- (void)removeValueForKey:(nonnull NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self.subjects) {
        [self.subjects removeObjectForKey:key];
    }
    @synchronized (self.values) {
        [self.values removeObjectForKey:key];
    }
}

@end
