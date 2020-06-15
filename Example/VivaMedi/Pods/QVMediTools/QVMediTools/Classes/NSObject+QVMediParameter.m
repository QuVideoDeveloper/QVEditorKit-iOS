
#import "NSObject+QVMediParameter.h"
#import <objc/runtime.h>

@implementation NSObject (QVMediParameter)


- (void)setQvmedi_parameter:(id)qvmedi_parameter {
    [self willChangeValueForKey:@"qvmedi_parameter"];
    objc_setAssociatedObject(self, _cmd, qvmedi_parameter, OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"qvmedi_parameter"];
}
- (id)qvmedi_parameter {
    return objc_getAssociatedObject(self, @selector(setQvmedi_parameter:));
}

@end
