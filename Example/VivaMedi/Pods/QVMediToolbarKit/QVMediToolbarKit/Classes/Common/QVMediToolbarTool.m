//
//  XYToolbarTool.m
//  XYToolbarKit
//
//  Created by 夏澄 on 2020/5/21.
//

#import "QVMediToolbarTool.h"

@implementation QVMediToolbarTool

+ (unsigned long long)qvmedi_getLongLongFromString:(NSString *)strLongLong {
    NSScanner *scanner = [NSScanner scannerWithString:strLongLong];
    unsigned long long longlongTtid = 0;
    [scanner scanHexLongLong:&longlongTtid];
    return longlongTtid;
}

+ (NSString*)qvmedi_getHexStringFromLongLong:(unsigned long long) longValue
{
    NSString* strTtid = [NSString stringWithFormat:@"0x%016llX",longValue];
    return strTtid;
}
+ (NSDictionary *)getTemplateDic {
   return @{
        @"xy_videoEditToolbarTypeThemeAction:":@[@"0x010000000000005E", @"0x0100030000000073"],
        @"xy_videoEditToolbarTypeSubtitleAction:":@[@"0x090000000000028A", @"0x090000000000028B", @"0x090000000000028C", @"0x090000000000028D", @"0x090000000000028E",@"0x090000000000028F", @"0x0900000000000280", @"0x0900000000000281", @"0x0900000000000282", @"0x0900000000000283",@"0x0900000000000284", @"0x0900000000000285", @"0x0900000000000286", @"0x0900000000000287", @"0x0900000000000288",@"0x0900000000000289", @"0x0900000000000290", @"0x0900000000000291", @"0x0900500000000001"],
        @"xy_videoEditToolbarTypeStickerAction:":@[@"0x05000000000005F3", @"0x05000000000005F7", @"0x050000000000047D", @"0x050000000000047E", @"0x050000000000047F",@"0x0500000000000480", @"0x0500000000000481", @"0x0500000000000483"],
        @"xy_videoEditToolbarTypeSpecialEffectsAction:": @[@"0x06000000000000D9", @"0x06000000000000DA", @"0x0600000000000141", @"0x0600000000000145"],
        @"xy_videoEditToolbarTypeEdit_toobarTypeTransitionAction:":@[@"0x0300000000000001", @"0x0300000000000006", @"0x0300000000000007"],
        @"xy_videoEditToolbarTypeEdit_toobarTypeFilterAction:":@[@"0x04000000000000E7", @"0x04000000000000E8", @"0x04000000000000E9", @"0x04000000000000EA", @"0x04000000000000EB", @"0x04000000000000EC"],
    };
}

@end
