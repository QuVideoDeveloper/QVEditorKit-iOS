//
//  QVMediMacro.h
//  Pods
//
//  Created by robbin on 2020/6/3.
//

#ifndef QVMediMacro_h
#define QVMediMacro_h

#define QVMEDI_SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)
#define QVMEDI_SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)

#define XYEmptyStringReplace(X) (X == nil ? @"" : X)

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

#endif /* QVMediMacro_h */
