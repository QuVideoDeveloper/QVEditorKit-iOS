//
//  XYBaseMacro.h
//  XYToolKit
//
//  Created by robbin on 2019/3/21.
//

#import <pthread.h>
#import <UIKit/UIKit.h>

#ifndef XYBaseMacro_h
#define XYBaseMacro_h

#ifdef __cplusplus
#define XY_EXTERN_C_BEGIN  extern "C" {
#define XY_EXTERN_C_END  }
#else
#define XY_EXTERN_C_BEGIN
#define XY_EXTERN_C_END
#endif

XY_EXTERN_C_BEGIN

#define XYNSNullReplace(X) (X == nil ? [NSNull null] : X)
#define XYEmptyStringReplace(X) (X == nil ? @"" : X)

// ================================ todo ============================
#define STRINGIFY(S) #S
#define DEFER_STRINGIFY(S) STRINGIFY(S)
#define PRAGMA_MESSAGE(MSG) _Pragma(STRINGIFY(message(MSG)))
#define FORMATTED_MESSAGE(MSG) "[TODO-" DEFER_STRINGIFY(__COUNTER__) "] " MSG " \n" \
DEFER_STRINGIFY(__FILE__) " line " DEFER_STRINGIFY(__LINE__)
#define KEYWORDIFY try {} @catch (...) {}
// 最终使用下面的宏
#define TODO(MSG) KEYWORDIFY PRAGMA_MESSAGE(FORMATTED_MESSAGE(MSG))

// ================================ float compare ============================

#define XYFloatIsEqual(A, B) (fabs(A - B) < 1.0e-7)
#define XYFloatIsEqualWithAccuracy(A, B, Accuracy) (fabs(A - B) < Accuracy)
#define XYRectHasNAN(rect) (isnan(rect.origin.x)||isnan(rect.origin.y)||isnan(rect.size.width)||isnan(rect.size.height))

// ================================ swap value ============================

#ifndef XY_SWAP // swap two value
#define XY_SWAP(_a_, _b_)  do { __typeof__(_a_) _tmp_ = (_a_); (_a_) = (_b_); (_b_) = _tmp_; } while (0)
#endif

// ================================ assert ============================

#define XYAssertNil(condition, description, ...) NSAssert(!(condition), (description), ##__VA_ARGS__)

#define XYAssertNotNil(condition, description, ...) NSAssert((condition), (description), ##__VA_ARGS__)

#define XYAssertMainThread() NSAssert([NSThread isMainThread], @"This method must be called on the main thread")

// ================================ synth dynamic property ================================
/**
 Synthsize a dynamic object property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @param association  ASSIGN / RETAIN / COPY / RETAIN_NONATOMIC / COPY_NONATOMIC
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Example:
 @interface NSObject (MyAdd)
 @property (nonatomic, retain) UIColor *myColor;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
 XYSYNTH_DYNAMIC_PROPERTY_OBJECT(myColor, setMyColor, RETAIN, UIColor *)
 @end
 */
#ifndef XYSYNTH_DYNAMIC_PROPERTY_OBJECT
#define XYSYNTH_DYNAMIC_PROPERTY_OBJECT(_getter_, _setter_, _association_, _type_) \
- (void)_setter_ : (_type_)object { \
[self willChangeValueForKey:@#_getter_]; \
objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _association_); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
return objc_getAssociatedObject(self, @selector(_setter_:)); \
}
#endif

// ================================ @weakfy @strongify ============================

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

// ================================ system version compare ============================

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// ================================ main queue compare and dispatch ============================

/**
 Whether in main queue/thread.
 */
static inline bool dispatch_is_main_queue() {
    return pthread_main_np() != 0;
}

/**
 Submits a block for asynchronous execution on a main queue and returns immediately.
 */
static inline void dispatch_async_on_main_queue(void (^block)(void)) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

/**
 Submits a block for execution on a main queue and waits until the block completes.
 */
static inline void dispatch_sync_on_main_queue(void (^block)(void)) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

XY_EXTERN_C_END

#endif /* Header_h */
