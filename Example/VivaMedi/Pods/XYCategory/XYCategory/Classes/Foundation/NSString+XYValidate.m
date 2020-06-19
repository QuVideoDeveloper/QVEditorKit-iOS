//
//  NSString+XYValidate.m
//  XYBase
//
//  Created by robbin on 2019/3/26.
//

#import "NSString+XYValidate.h"

@implementation NSString (XYValidate)

- (BOOL)xy_isEmailFormat {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)xy_isMobileFormat {
    NSString *phoneRegex = @"^1+[3578]+\\d{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

- (BOOL)xy_isQQFormat {
    NSString *qqRegex = @"[1-9][0-9]{4,}";
    NSPredicate *qqTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",qqRegex];
    return [qqTest evaluateWithObject:self];
}

@end
