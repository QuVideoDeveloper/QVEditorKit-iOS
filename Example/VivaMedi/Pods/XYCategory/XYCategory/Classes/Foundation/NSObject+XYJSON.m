//
//  NSObject+XYJSON.m
//  XYBase
//
//  Created by robbin on 2019/3/25.
//

#import "NSObject+XYJSON.h"

@implementation NSObject (XYJSON)

- (NSString *)xy_getJSONString {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    
    if (error == nil && jsonData != nil && [jsonData length] > 0){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
}

- (id)xy_getObjectFromJSONString {
    if (![self isKindOfClass:NSString.class]) {
        return nil;
    }
    NSData *dataJSON = [(NSString *)self dataUsingEncoding:NSUTF8StringEncoding];
    if(dataJSON){
        return [NSJSONSerialization JSONObjectWithData:dataJSON options: 0 error:nil];
    }
    return nil;
}

@end
