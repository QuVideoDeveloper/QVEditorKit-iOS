//
//  XYBaseCopyModel.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/12/4.
//

#import "XYBaseCopyModel.h"
#import<objc/runtime.h>
#import <YYModel/YYModel.h>

#import "XYClipModel.h"
#import "XYEffectModel.h"
#import "XYEffectAudioModel.h"
#import "XYEffectVisionModel.h"
#import "XYEffectVisionTextModel.h"
#import "XYStoryboardModel.h"
#import "XYAdjustEffectValueModel.h"

#import "CXiaoYingClip.h"
#import "CXiaoYingEffect.h"
#import "XYStoryboard.h"

#import "XYEffectRelativeClipInfo.h"
#import "TextInfo.h"
#import "XYEngineUndoMgr.h"

#define xy_force_inline __inline__ __attribute__((always_inline))

typedef NS_ENUM (NSUInteger, XYEncodingNSType) {
    XYEncodingTypeNSUnknown = 0,
    XYEncodingTypeNSString,
    XYEncodingTypeNSMutableString,
    XYEncodingTypeNSValue,
    XYEncodingTypeNSNumber,
    XYEncodingTypeNSDecimalNumber,
    XYEncodingTypeNSData,
    XYEncodingTypeNSMutableData,
    XYEncodingTypeNSDate,
    XYEncodingTypeNSURL,
    XYEncodingTypeNSArray,
    XYEncodingTypeNSMutableArray,
    XYEncodingTypeNSDictionary,
    XYEncodingTypeNSMutableDictionary,
    XYEncodingTypeNSSet,
    XYEncodingTypeNSMutableSet,
};

typedef NS_OPTIONS(NSUInteger, XYEncodingType) {
    XYEncodingTypeMask       = 0xFF, ///< mask of type value
    XYEncodingTypeUnknown    = 0, ///< unknown
    XYEncodingTypeVoid       = 1, ///< void
    XYEncodingTypeBool       = 2, ///< bool
    XYEncodingTypeInt8       = 3, ///< char / BOOL
    XYEncodingTypeUInt8      = 4, ///< unsigned char
    XYEncodingTypeInt16      = 5, ///< short
    XYEncodingTypeUInt16     = 6, ///< unsigned short
    XYEncodingTypeInt32      = 7, ///< int
    XYEncodingTypeUInt32     = 8, ///< unsigned int
    XYEncodingTypeInt64      = 9, ///< long long
    XYEncodingTypeUInt64     = 10, ///< unsigned long long
    XYEncodingTypeFloat      = 11, ///< float
    XYEncodingTypeDouble     = 12, ///< double
    XYEncodingTypeLongDouble = 13, ///< long double
    XYEncodingTypeObject     = 14, ///< id
    XYEncodingTypeClass      = 15, ///< Class
    XYEncodingTypeSEL        = 16, ///< SEL
    XYEncodingTypeBlock      = 17, ///< block
    XYEncodingTypePointer    = 18, ///< void*
    XYEncodingTypeStruct     = 19, ///< struct
    XYEncodingTypeUnion      = 20, ///< union
    XYEncodingTypeCString    = 21, ///< char*
    XYEncodingTypeCArray     = 22, ///< char[10] (for example)
    
    XYEncodingTypeQualifierMask   = 0xFF00,   ///< mask of qualifier
    XYEncodingTypeQualifierConst  = 1 << 8,  ///< const
    XYEncodingTypeQualifierIn     = 1 << 9,  ///< in
    XYEncodingTypeQualifierInout  = 1 << 10, ///< inout
    XYEncodingTypeQualifierOut    = 1 << 11, ///< out
    XYEncodingTypeQualifierBycopy = 1 << 12, ///< bycopy
    XYEncodingTypeQualifierByref  = 1 << 13, ///< byref
    XYEncodingTypeQualifierOneway = 1 << 14, ///< oneway
    
    XYEncodingTypePropertyMask         = 0xFF0000, ///< mask of property
    XYEncodingTypePropertyReadonly     = 1 << 16, ///< readonly
    XYEncodingTypePropertyCopy         = 1 << 17, ///< copy
    XYEncodingTypePropertyRetain       = 1 << 18, ///< retain
    XYEncodingTypePropertyNonatomic    = 1 << 19, ///< nonatomic
    XYEncodingTypePropertyWeak         = 1 << 20, ///< weak
    XYEncodingTypePropertyCustomGetter = 1 << 21, ///< getter=
    XYEncodingTypePropertyCustomSetter = 1 << 22, ///< setter=
    XYEncodingTypePropertyDynamic      = 1 << 23, ///< @dynamic
};

/// Get the Foundation class type from property info.
static xy_force_inline XYEncodingNSType XYClassGetNSType(Class cls) {
    if (!cls) return XYEncodingTypeNSUnknown;
    if ([cls isSubclassOfClass:[NSMutableString class]]) return XYEncodingTypeNSMutableString;
    if ([cls isSubclassOfClass:[NSString class]]) return XYEncodingTypeNSString;
    if ([cls isSubclassOfClass:[NSDecimalNumber class]]) return XYEncodingTypeNSDecimalNumber;
    if ([cls isSubclassOfClass:[NSNumber class]]) return XYEncodingTypeNSNumber;
    if ([cls isSubclassOfClass:[NSValue class]]) return XYEncodingTypeNSValue;
    if ([cls isSubclassOfClass:[NSMutableData class]]) return XYEncodingTypeNSMutableData;
    if ([cls isSubclassOfClass:[NSData class]]) return XYEncodingTypeNSData;
    if ([cls isSubclassOfClass:[NSDate class]]) return XYEncodingTypeNSDate;
    if ([cls isSubclassOfClass:[NSURL class]]) return XYEncodingTypeNSURL;
    if ([cls isSubclassOfClass:[NSMutableArray class]]) return XYEncodingTypeNSMutableArray;
    if ([cls isSubclassOfClass:[NSArray class]]) return XYEncodingTypeNSArray;
    if ([cls isSubclassOfClass:[NSMutableDictionary class]]) return XYEncodingTypeNSMutableDictionary;
    if ([cls isSubclassOfClass:[NSDictionary class]]) return XYEncodingTypeNSDictionary;
    if ([cls isSubclassOfClass:[NSMutableSet class]]) return XYEncodingTypeNSMutableSet;
    if ([cls isSubclassOfClass:[NSSet class]]) return XYEncodingTypeNSSet;
    return XYEncodingTypeNSUnknown;
}


/// Whether the type is c number.
static xy_force_inline BOOL XYEncodingTypeIsCNumber(XYEncodingType type) {
    switch (type & XYEncodingTypeMask) {
        case XYEncodingTypeBool:
        case XYEncodingTypeInt8:
        case XYEncodingTypeUInt8:
        case XYEncodingTypeInt16:
        case XYEncodingTypeUInt16:
        case XYEncodingTypeInt32:
        case XYEncodingTypeUInt32:
        case XYEncodingTypeInt64:
        case XYEncodingTypeUInt64:
        case XYEncodingTypeFloat:
        case XYEncodingTypeDouble:
        case XYEncodingTypeLongDouble: return YES;
        default: return NO;
    }
}


/// A property info in object model.
@interface _XYModelPropertyMeta : NSObject {
    @package
    NSString *_name;             ///< property's name
    XYEncodingType _type;        ///< property's type
    XYEncodingNSType _nsType;    ///< property's Foundation type
    BOOL _isCNumber;             ///< is c number type
    Class _cls;                  ///< property's class, or nil
    Class _genericCls;           ///< container's generic class, or nil if threr's no generic class
    SEL _getter;                 ///< getter, or nil if the instances cannot respond
    SEL _setter;                 ///< setter, or nil if the instances cannot respond
    BOOL _isKVCCompatible;       ///< YES if it can access with key-value coding
    BOOL _isStructAvailableForKeyedArchiver; ///< YES if the struct can encoded with keyed archiver/unarchiver
    BOOL _hasCustomClassFromDictionary; ///< class/generic class implements +modelCustomClassForDictionary:
    
    /*
     property->key:       _mappedToKey:key     _mappedToKeyPath:nil            _mappedToKeyArray:nil
     property->keyPath:   _mappedToKey:keyPath _mappedToKeyPath:keyPath(array) _mappedToKeyArray:nil
     property->keys:      _mappedToKey:keys[0] _mappedToKeyPath:nil/keyPath    _mappedToKeyArray:keys(array)
     */
    NSString *_mappedToKey;      ///< the key mapped to
    NSArray *_mappedToKeyPath;   ///< the key path mapped to (nil if the name is not key path)
    NSArray *_mappedToKeyArray;  ///< the key(NSString) or keyPath(NSArray) array (nil if not mapped to multiple keys)
    YYClassPropertyInfo *_info;  ///< property's info
    _XYModelPropertyMeta *_next; ///< next meta if there are multiple properties mapped to the same key.
}
@end

@implementation _XYModelPropertyMeta
+ (instancetype)metaWithClassInfo:(YYClassInfo *)classInfo propertyInfo:(YYClassPropertyInfo *)propertyInfo generic:(Class)generic {
    
    // support pseudo generic class with protocol name
    if (!generic && propertyInfo.protocols) {
        for (NSString *protocol in propertyInfo.protocols) {
            Class cls = objc_getClass(protocol.UTF8String);
            if (cls) {
                generic = cls;
                break;
            }
        }
    }
    
    _XYModelPropertyMeta *meta = [self new];
    meta->_name = propertyInfo.name;
    meta->_type = propertyInfo.type;
    meta->_info = propertyInfo;
    meta->_genericCls = generic;
    
    if ((meta->_type & XYEncodingTypeMask) == XYEncodingTypeObject) {
        meta->_nsType = XYClassGetNSType(propertyInfo.cls);
    } else {
        meta->_isCNumber = XYEncodingTypeIsCNumber(meta->_type);
    }
    if ((meta->_type & XYEncodingTypeMask) == XYEncodingTypeStruct) {
        /*
         It seems that NSKeyedUnarchiver cannot decode NSValue except these structs:
         */
        static NSSet *types = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSMutableSet *set = [NSMutableSet new];
            // 32 bit
            [set addObject:@"{CGSize=ff}"];
            [set addObject:@"{CGPoint=ff}"];
            [set addObject:@"{CGRect={CGPoint=ff}{CGSize=ff}}"];
            [set addObject:@"{CGAffineTransform=ffffff}"];
            [set addObject:@"{UIEdgeInsets=ffff}"];
            [set addObject:@"{UIOffset=ff}"];
            // 64 bit
            [set addObject:@"{CGSize=dd}"];
            [set addObject:@"{CGPoint=dd}"];
            [set addObject:@"{CGRect={CGPoint=dd}{CGSize=dd}}"];
            [set addObject:@"{CGAffineTransform=dddddd}"];
            [set addObject:@"{UIEdgeInsets=dddd}"];
            [set addObject:@"{UIOffset=dd}"];
            types = set;
        });
        if ([types containsObject:propertyInfo.typeEncoding]) {
            meta->_isStructAvailableForKeyedArchiver = YES;
        }
    }
    meta->_cls = propertyInfo.cls;
    
    if (generic) {
        meta->_hasCustomClassFromDictionary = [generic respondsToSelector:@selector(modelCustomClassForDictionary:)];
    } else if (meta->_cls && meta->_nsType == XYEncodingTypeNSUnknown) {
        meta->_hasCustomClassFromDictionary = [meta->_cls respondsToSelector:@selector(modelCustomClassForDictionary:)];
    }
    
    if (propertyInfo.getter) {
        if ([classInfo.cls instancesRespondToSelector:propertyInfo.getter]) {
            meta->_getter = propertyInfo.getter;
        }
    }
    if (propertyInfo.setter) {
        if ([classInfo.cls instancesRespondToSelector:propertyInfo.setter]) {
            meta->_setter = propertyInfo.setter;
        }
    }
    
    if (meta->_getter && meta->_setter) {
        /*
         KVC invalid type:
         long double
         pointer (such as SEL/CoreFoundation object)
         */
        switch (meta->_type & XYEncodingTypeMask) {
            case XYEncodingTypeBool:
            case XYEncodingTypeInt8:
            case XYEncodingTypeUInt8:
            case XYEncodingTypeInt16:
            case XYEncodingTypeUInt16:
            case XYEncodingTypeInt32:
            case XYEncodingTypeUInt32:
            case XYEncodingTypeInt64:
            case XYEncodingTypeUInt64:
            case XYEncodingTypeFloat:
            case XYEncodingTypeDouble:
            case XYEncodingTypeObject:
            case XYEncodingTypeClass:
            case XYEncodingTypeBlock:
            case XYEncodingTypeStruct:
            case XYEncodingTypeUnion: {
                meta->_isKVCCompatible = YES;
            } break;
            default: break;
        }
    }
    
    return meta;
}
@end


/// A class info in object model.
@interface _XYModelMeta : NSObject {
    @package
    YYClassInfo *_classInfo;
    /// Key:mapped key and key path, Value:_XYModelPropertyMeta.
    NSDictionary *_mapper;
    /// Array<_XYModelPropertyMeta>, all property meta of this model.
    NSArray *_allPropertyMetas;
    /// Array<_XYModelPropertyMeta>, property meta which is mapped to a key path.
    NSArray *_keyPathPropertyMetas;
    /// Array<_XYModelPropertyMeta>, property meta which is mapped to multi keys.
    NSArray *_multiKeysPropertyMetas;
    /// The number of mapped key (and key path), same to _mapper.count.
    NSUInteger _keyMappedCount;
    /// Model class type.
    XYEncodingNSType _nsType;
    
    BOOL _hasCustomWillTransformFromDictionary;
    BOOL _hasCustomTransformFromDictionary;
    BOOL _hasCustomTransformToDictionary;
    BOOL _hasCustomClassFromDictionary;
}
@end

@implementation _XYModelMeta

- (instancetype)initWithClass:(Class)cls {
    YYClassInfo *classInfo = [YYClassInfo classInfoWithClass:cls];
    if (!classInfo) return nil;
    self = [super init];
    
    // Get black list
    NSSet *blacklist = nil;
    if ([cls respondsToSelector:@selector(modelPropertyBlacklist)]) {
        NSArray *properties = [(id<YYModel>)cls modelPropertyBlacklist];
        if (properties) {
            blacklist = [NSSet setWithArray:properties];
        }
    }
    
    // Get white list
    NSSet *whitelist = nil;
    if ([cls respondsToSelector:@selector(modelPropertyWhitelist)]) {
        NSArray *properties = [(id<YYModel>)cls modelPropertyWhitelist];
        if (properties) {
            whitelist = [NSSet setWithArray:properties];
        }
    }
    
    // Get container property's generic class
    NSDictionary *genericMapper = nil;
    if ([cls respondsToSelector:@selector(modelContainerPropertyGenericClass)]) {
        genericMapper = [(id<YYModel>)cls modelContainerPropertyGenericClass];
        if (genericMapper) {
            NSMutableDictionary *tmp = [NSMutableDictionary new];
            [genericMapper enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if (![key isKindOfClass:[NSString class]]) return;
                Class meta = object_getClass(obj);
                if (!meta) return;
                if (class_isMetaClass(meta)) {
                    tmp[key] = obj;
                } else if ([obj isKindOfClass:[NSString class]]) {
                    Class cls = NSClassFromString(obj);
                    if (cls) {
                        tmp[key] = cls;
                    }
                }
            }];
            genericMapper = tmp;
        }
    }
    
    // Create all property metas.
    NSMutableDictionary *allPropertyMetas = [NSMutableDictionary new];
    YYClassInfo *curClassInfo = classInfo;
    while (curClassInfo && curClassInfo.superCls != nil) { // recursive parse super class, but ignore root class (NSObject/NSProxy)
        for (YYClassPropertyInfo *propertyInfo in curClassInfo.propertyInfos.allValues) {
            if (!propertyInfo.name) continue;
            if (blacklist && [blacklist containsObject:propertyInfo.name]) continue;
            if (whitelist && ![whitelist containsObject:propertyInfo.name]) continue;
            _XYModelPropertyMeta *meta = [_XYModelPropertyMeta metaWithClassInfo:classInfo
                                                                    propertyInfo:propertyInfo
                                                                         generic:genericMapper[propertyInfo.name]];
            if (!meta || !meta->_name) continue;
            if (!meta->_getter || !meta->_setter) continue;
            if (allPropertyMetas[meta->_name]) continue;
            allPropertyMetas[meta->_name] = meta;
        }
        curClassInfo = curClassInfo.superClassInfo;
    }
    if (allPropertyMetas.count) _allPropertyMetas = allPropertyMetas.allValues.copy;
    
    // create mapper
    NSMutableDictionary *mapper = [NSMutableDictionary new];
    NSMutableArray *keyPathPropertyMetas = [NSMutableArray new];
    NSMutableArray *multiKeysPropertyMetas = [NSMutableArray new];
    
    if ([cls respondsToSelector:@selector(modelCustomPropertyMapper)]) {
        NSDictionary *customMapper = [(id <YYModel>)cls modelCustomPropertyMapper];
        [customMapper enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, NSString *mappedToKey, BOOL *stop) {
            _XYModelPropertyMeta *propertyMeta = allPropertyMetas[propertyName];
            if (!propertyMeta) return;
            [allPropertyMetas removeObjectForKey:propertyName];
            
            if ([mappedToKey isKindOfClass:[NSString class]]) {
                if (mappedToKey.length == 0) return;
                
                propertyMeta->_mappedToKey = mappedToKey;
                NSArray *keyPath = [mappedToKey componentsSeparatedByString:@"."];
                for (NSString *onePath in keyPath) {
                    if (onePath.length == 0) {
                        NSMutableArray *tmp = keyPath.mutableCopy;
                        [tmp removeObject:@""];
                        keyPath = tmp;
                        break;
                    }
                }
                if (keyPath.count > 1) {
                    propertyMeta->_mappedToKeyPath = keyPath;
                    [keyPathPropertyMetas addObject:propertyMeta];
                }
                propertyMeta->_next = mapper[mappedToKey] ?: nil;
                mapper[mappedToKey] = propertyMeta;
                
            } else if ([mappedToKey isKindOfClass:[NSArray class]]) {
                
                NSMutableArray *mappedToKeyArray = [NSMutableArray new];
                for (NSString *oneKey in ((NSArray *)mappedToKey)) {
                    if (![oneKey isKindOfClass:[NSString class]]) continue;
                    if (oneKey.length == 0) continue;
                    
                    NSArray *keyPath = [oneKey componentsSeparatedByString:@"."];
                    if (keyPath.count > 1) {
                        [mappedToKeyArray addObject:keyPath];
                    } else {
                        [mappedToKeyArray addObject:oneKey];
                    }
                    
                    if (!propertyMeta->_mappedToKey) {
                        propertyMeta->_mappedToKey = oneKey;
                        propertyMeta->_mappedToKeyPath = keyPath.count > 1 ? keyPath : nil;
                    }
                }
                if (!propertyMeta->_mappedToKey) return;
                
                propertyMeta->_mappedToKeyArray = mappedToKeyArray;
                [multiKeysPropertyMetas addObject:propertyMeta];
                
                propertyMeta->_next = mapper[mappedToKey] ?: nil;
                mapper[mappedToKey] = propertyMeta;
            }
        }];
    }
    
    [allPropertyMetas enumerateKeysAndObjectsUsingBlock:^(NSString *name, _XYModelPropertyMeta *propertyMeta, BOOL *stop) {
        propertyMeta->_mappedToKey = name;
        propertyMeta->_next = mapper[name] ?: nil;
        mapper[name] = propertyMeta;
    }];
    
    if (mapper.count) _mapper = mapper;
    if (keyPathPropertyMetas) _keyPathPropertyMetas = keyPathPropertyMetas;
    if (multiKeysPropertyMetas) _multiKeysPropertyMetas = multiKeysPropertyMetas;
    
    _classInfo = classInfo;
    _keyMappedCount = _allPropertyMetas.count;
    _nsType = XYClassGetNSType(cls);
    _hasCustomWillTransformFromDictionary = ([cls instancesRespondToSelector:@selector(modelCustomWillTransformFromDictionary:)]);
    _hasCustomTransformFromDictionary = ([cls instancesRespondToSelector:@selector(modelCustomTransformFromDictionary:)]);
    _hasCustomTransformToDictionary = ([cls instancesRespondToSelector:@selector(modelCustomTransformToDictionary:)]);
    _hasCustomClassFromDictionary = ([cls respondsToSelector:@selector(modelCustomClassForDictionary:)]);
    
    return self;
}

/// Returns the cached model class meta
+ (instancetype)metaWithClass:(Class)cls {
    if (!cls) return nil;
    static CFMutableDictionaryRef cache;
    static dispatch_once_t onceToken;
    static dispatch_semaphore_t lock;
    dispatch_once(&onceToken, ^{
        cache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        lock = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    _XYModelMeta *meta = CFDictionaryGetValue(cache, (__bridge const void *)(cls));
    dispatch_semaphore_signal(lock);
    if (!meta || meta->_classInfo.needUpdate) {
        meta = [[_XYModelMeta alloc] initWithClass:cls];
        if (meta) {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            CFDictionarySetValue(cache, (__bridge const void *)(cls), (__bridge const void *)(meta));
            dispatch_semaphore_signal(lock);
        }
    }
    return meta;
}

@end

@interface XYBaseCopyModel () <YYModel>

@end

@implementation XYBaseCopyModel

- (id)xyModelCopy {
    return [self yy_modelCopy];
}

- (id)copy {
    return [self xyModelCopy];
}

- (BOOL)xyModelIsEqual:(id)model {
    if (self == model) return YES;
    if (![model isMemberOfClass:self.class]) {
        return NO;
    }
    _XYModelMeta *modelMeta = [_XYModelMeta metaWithClass:self.class];
    if (modelMeta->_nsType) {
        return [self isEqual:model];
    }
    //     if ([self hash] != [model hash]) return NO;
    
    for (_XYModelPropertyMeta *propertyMeta in modelMeta->_allPropertyMetas) {
        if ([NSStringFromSelector(propertyMeta->_getter) isEqualToString:@"outPutResolutionWidth"]
            || [NSStringFromSelector(propertyMeta->_getter) isEqualToString:@"outPutResolutionHeight"]
            || [NSStringFromSelector(propertyMeta->_getter) isEqualToString:@"isStaticPicture"]) {
            continue;
        }
        if (!propertyMeta->_isKVCCompatible) continue;
        id this = [self valueForKey:NSStringFromSelector(propertyMeta->_getter)];
        id that = [model valueForKey:NSStringFromSelector(propertyMeta->_getter)];
        if ([NSStringFromSelector(propertyMeta->_getter) isEqualToString:@"centerPoint"]) {
            CGPoint thisPoint = [(NSValue *)this CGPointValue];
            CGPoint thatPoint = [(NSValue *)that CGPointValue];
            if (fabsf(thisPoint.x - thatPoint.x < 1) && fabsf(thisPoint.y - thatPoint.y < 1)) {
                continue;
            }
        } else if ([NSStringFromSelector(propertyMeta->_getter) isEqualToString:@"height"] || [NSStringFromSelector(propertyMeta->_getter) isEqualToString:@"width"]) {
            CGFloat thisValue = [this floatValue];
            CGFloat thatValue  = [that floatValue];
            if (fabsf(thisValue - thatValue) < 1) {
                continue;
            }
        } else if ([self propertyMetaIsRecursiveDisable:this]) {
            continue;
        }
        if (this == that) continue;
        if (this == nil || that == nil) {
            return NO;
        }
        if ([this isKindOfClass:[NSArray class]]) {
            NSArray *thisArr = this;
            NSArray *thatArr = that;
            for (int i = 0 ; i < thisArr.count; i ++) {
                id rThis = thisArr[i];
                if (i < thatArr.count) {
                    id rThat = thatArr[i];
                    if (![self recursiveModelIsEqual:rThis that:rThat]) {
                        return NO;
                    }
                }
            }
        } else {
            if (![self recursiveModelIsEqual:this that:that]) {
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)recursiveModelIsEqual:(id)this that:(id)that {
    if ([this respondsToSelector:@selector(xyModelIsEqual:)]) {
        XYBaseCopyModel *thisModel = this;
        XYBaseCopyModel *thatModel = that;
        if (![thisModel xyModelIsEqual:thatModel]) {//递归
            return NO;
        }
    } else if (![this isEqual:that]) {
        return NO;
    }
    return YES;
}

- (BOOL)propertyMetaIsRecursiveDisable:(id)this {
    NSString *propertyMetaStr = NSStringFromClass([this class]);
    if ([propertyMetaStr isEqualToString:NSStringFromClass([self class])]
        || [propertyMetaStr isEqualToString:NSStringFromClass([XYStoryboardModel class])]
        || [propertyMetaStr isEqualToString:NSStringFromClass([XYClipModel class])]
        || [propertyMetaStr isEqualToString:NSStringFromClass([XYEffectModel class])]
        || [propertyMetaStr isEqualToString:NSStringFromClass([XYEffectAudioModel class])]
        || [propertyMetaStr isEqualToString:NSStringFromClass([XYEffectVisionModel class])]
        || [propertyMetaStr isEqualToString:NSStringFromClass([XYEffectVisionTextModel class])]
        || [propertyMetaStr isEqualToString:NSStringFromClass([XYStoryboard class])]
        || [propertyMetaStr isEqualToString:NSStringFromClass([CXiaoYingStoryBoardSession class])]
        || [propertyMetaStr isEqualToString:NSStringFromClass([CXiaoYingClip class])]
        || [propertyMetaStr isEqualToString:NSStringFromClass([XYAdjustEffectValueModel class])]
        || [propertyMetaStr isEqualToString:NSStringFromClass([CXiaoYingEffect class])]
        || [propertyMetaStr isEqualToString:NSStringFromClass([XYEffectRelativeClipInfo class])]
        || [propertyMetaStr isEqualToString:NSStringFromClass([XYEffectUserDataModel class])]
        || [propertyMetaStr isEqualToString:NSStringFromClass([TextInfo class])]
        || [propertyMetaStr isEqualToString:NSStringFromClass([XYEngineUndoManagerConfig class])]
        || [propertyMetaStr isEqualToString:NSStringFromClass([XYEngineUndoManagerModule class])]) {
        return YES;
    }
    return NO;
}

@end
