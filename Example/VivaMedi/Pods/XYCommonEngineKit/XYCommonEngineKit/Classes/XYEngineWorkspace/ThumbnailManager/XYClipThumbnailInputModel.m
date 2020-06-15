//
//  XYThumbnailInputModel.m
//  XYVivaEditor
//
//  Created by 徐新元 on 2019/12/20.
//

#import "XYClipThumbnailInputModel.h"
#import <objc/runtime.h>

@implementation XYClipThumbnailInputModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.thumbnailWidth = 128;
        self.thumbnailHeight = 128;
        self.skipBlackFrame = NO;
        self.maxOperationCount = 20;
    }
    return self;
}

#pragma mark - 对象深度拷贝
- (id)copyWithZone:(NSZone *)zone {
    id objCopy = [[[self class] allocWithZone:zone] init];
    
    Class cls = [self class];
    while (cls != NSObject.class) {
        [self copy:objCopy cls:cls];
        cls = [cls superclass];
    }
    
    return objCopy;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    id objCopy = [[[self class]allocWithZone:zone] init];
    
    Class cls = [self class];
    while (cls != NSObject.class) {
        [self mutableCopy:objCopy cls:cls];
        cls = [cls superclass];
    }
    
    return objCopy;
}

- (void)copy:(id)objCopy cls:(Class)cls {
    unsigned int propertyCount = 0;
    objc_property_t * propertyArray = class_copyPropertyList(cls, &propertyCount);
    
    for (int i=0; i<propertyCount; i++) {
        objc_property_t  property = propertyArray[i];
        
        const char * propertyName = property_getName(property);
        NSString * key = [NSString stringWithUTF8String:propertyName];
        
        id value=[self valueForKey:key];
        NSLog(@"name:%s,value:%@",propertyName,value);
        
        if ([value respondsToSelector:@selector(copyWithZone:)] && [value isAccessibilityElement]) {
            [objCopy setValue:[value copy] forKey:key];
        }else{
            [objCopy setValue:value forKey:key];
        }
    }
    free(propertyArray);
}

- (void)mutableCopy:(id)objCopy cls:(Class)cls {
    unsigned int propertyCount = 0;
    objc_property_t * propertyArray = class_copyPropertyList(cls, &propertyCount);
    
    for (int i=0; i<propertyCount; i++) {
        objc_property_t  property = propertyArray[i];
        
        const char * propertyName = property_getName(property);
        NSString * key = [NSString stringWithUTF8String:propertyName];
        
        id value=[self valueForKey:key];
        NSLog(@"name:%s,value:%@",propertyName,value);
        
        if ([value respondsToSelector:@selector(mutableCopyWithZone:)]) {
            [objCopy setValue:[value mutableCopy] forKey:key];
        }else{
            [objCopy setValue:value forKey:key];
        }
    }
    free(propertyArray);
}

@end
