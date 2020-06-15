//
//  XYXMLDictionary.h
//
//  Version 1.4
//
//  Created by Nick Lockwood on 15/11/2010.
//  Copyright 2010 Charcoal Design. All rights reserved.
//
//  Get the latest version of XYXMLDictionary from here:
//
//  https://github.com/nicklockwood/XYXMLDictionary
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import <Foundation/Foundation.h>
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wobjc-missing-property-synthesis"


typedef NS_ENUM(NSInteger, XYXMLDictionaryAttributesMode)
{
    XYXMLDictionaryAttributesModePrefixed = 0, //default
    XYXMLDictionaryAttributesModeDictionary,
    XYXMLDictionaryAttributesModeUnprefixed,
    XYXMLDictionaryAttributesModeDiscard
};


typedef NS_ENUM(NSInteger, XYXMLDictionaryNodeNameMode)
{
    XYXMLDictionaryNodeNameModeRootOnly = 0, //default
    XYXMLDictionaryNodeNameModeAlways,
    XYXMLDictionaryNodeNameModeNever
};


static NSString *const XYXMLDictionaryAttributesKey   = @"__attributes";
static NSString *const XYXMLDictionaryCommentsKey     = @"__comments";
static NSString *const XYXMLDictionaryTextKey         = @"__text";
static NSString *const XYXMLDictionaryNodeNameKey     = @"__name";
static NSString *const XYXMLDictionaryAttributePrefix = @"_";


@interface XYXMLDictionaryParser : NSObject <NSCopying>

+ (XYXMLDictionaryParser *)sharedInstance;

@property (nonatomic, assign) BOOL collapseTextNodes; // defaults to YES
@property (nonatomic, assign) BOOL stripEmptyNodes;   // defaults to YES
@property (nonatomic, assign) BOOL trimWhiteSpace;    // defaults to YES
@property (nonatomic, assign) BOOL alwaysUseArrays;   // defaults to NO
@property (nonatomic, assign) BOOL preserveComments;  // defaults to NO
@property (nonatomic, assign) BOOL wrapRootNode;      // defaults to NO

@property (nonatomic, assign) XYXMLDictionaryAttributesMode attributesMode;
@property (nonatomic, assign) XYXMLDictionaryNodeNameMode nodeNameMode;

- (NSDictionary *)dictionaryWithParser:(NSXMLParser *)parser;
- (NSDictionary *)dictionaryWithData:(NSData *)data;
- (NSDictionary *)dictionaryWithString:(NSString *)string;
- (NSDictionary *)dictionaryWithFile:(NSString *)path;

@end


@interface NSDictionary (XYXMLDictionary)

+ (NSDictionary *)xyxml_dictionaryWithXMLParser:(NSXMLParser *)parser;
+ (NSDictionary *)xyxml_dictionaryWithXMLData:(NSData *)data;
+ (NSDictionary *)xyxml_dictionaryWithXMLString:(NSString *)string;
+ (NSDictionary *)xyxml_dictionaryWithXMLFile:(NSString *)path;

- (NSDictionary *)xyxml_attributes;
- (NSDictionary *)xyxml_childNodes;
- (NSArray *)xyxml_comments;
- (NSString *)xyxml_nodeName;
- (NSString *)xyxml_innerText;
- (NSString *)xyxml_innerXML;
- (NSString *)xyxml_XMLString;

- (NSArray *)xyxml_arrayValueForKeyPath:(NSString *)keyPath;
- (NSString *)xyxml_stringValueForKeyPath:(NSString *)keyPath;
- (NSDictionary *)xyxml_dictionaryValueForKeyPath:(NSString *)keyPath;

@end


@interface NSString (XYXMLDictionary)

- (NSString *)xyxml_XMLEncodedString;

@end


#pragma GCC diagnostic pop
