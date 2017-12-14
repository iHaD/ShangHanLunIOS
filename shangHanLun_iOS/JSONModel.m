//
//  JSONModel.m
//  niuPei
//
//  Created by hh on 15/6/7.
//  Copyright (c) 2015年 hh. All rights reserved.
//

#import "JSONModel.h"
#import <objc/runtime.h>

@implementation JSONModel 

-(instancetype)initWithDictionary:(NSMutableDictionary *)jsonDictionary
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:jsonDictionary];
    }
    return self;
}

- (NSDictionary *)toDictionary
{
    NSArray<NSString *> *propertyList = [self getPropertyListForEncode];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for (NSString *str in propertyList) {
        id value = [self valueForKey:str];
        if ([value isKindOfClass:[NSArray class]] && [value count] > 0 && [(id)[value firstObject] respondsToSelector:@selector(toDictionary)]) {
            NSMutableArray *arr = [NSMutableArray new];
            for (id item in value) {
                [arr addObject:[item toDictionary]];
            }
            dict[str] = arr;
        }else{
            dict[str] = [value respondsToSelector:@selector(toDictionary)] ? [value toDictionary] : value;
        }
    }
    
    return dict;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
//    NSLog(@"key:%@",key);
    if ([value isKindOfClass:[NSArray class]]) {
        objc_property_t pt = class_getProperty(self.class, [key cStringUsingEncoding:NSUTF8StringEncoding]);
        NSString *clsString = [NSString stringWithCString:property_getAttributes(pt) encoding:NSUTF8StringEncoding];
        NSLog(@"clsString:%@",clsString);
        Class dataClass = [self getSubDataClassInArrayForKey:key];
        NSMutableArray *arr = [NSMutableArray new];
        for (NSDictionary *json in value) {
            if ([json isKindOfClass:[NSDictionary class]]) {
                [arr addObject:[[dataClass alloc] initWithDictionary:json]];
            }else{
                [arr addObject:json];
            }
        }
        [super setValue:arr forKey:key];
    }else if ([value isKindOfClass:[NSDictionary class]]){
        objc_property_t pt = class_getProperty(self.class, [key cStringUsingEncoding:NSUTF8StringEncoding]);
        NSString *clsString = [NSString stringWithCString:property_getAttributes(pt) encoding:NSUTF8StringEncoding];
        NSRange endR = [clsString rangeOfString:@","];
        NSUInteger end = endR.location - 1;
        clsString = [clsString substringWithRange:NSMakeRange(3, end - 3)];
//         NSLog(@"class:%@",clsString);
        Class dataClass = NSClassFromString(clsString);
        if (dataClass == NSDictionary.class || dataClass == [NSString class]) {
            [super setValue:value forKey:key];
        }else{
            [super setValue:[[dataClass alloc] initWithDictionary:value] forKey:key];
        }
    }else{
        [super setValue:value forKey:key];
    }
}

- (NSString *)description
{
    NSArray *propertyList = [self getPropertyListForEncode];
    NSMutableString *str = [NSMutableString new];
    [str appendString:@"\n{"];
    for (NSString *propertyKey in propertyList) {
        id value = [self valueForKey:propertyKey];
        [str appendFormat:@"\t%@:%@\n",propertyKey,value];
//        NSLog(@"%@:%@",propertyKey,value);
    }
    [str appendString:@"}"];
    return str;
}

- (NSDictionary *)getSubDataClassInArrayForKey:(NSString *)key
{
    return nil;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"ID"];
    }
    NSLog(@"Undefined Key: %@:%@",key,value);
}

- (NSArray<NSString *> *)getPropertyListForEncode
{
    // test:
//    NSLog(@"<%@ properties>:",self.class);
    Class cls = self.class;
    NSMutableArray *arr = [NSMutableArray new];
    while (![cls isEqual:JSONModel.class]) {
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList(cls, &count);
        if (properties == NULL) {
            cls = cls.superclass;
            continue;
        }
        for (int i = 0; i < count; i++) {
            NSString *key = @(property_getName(properties[i]));
//            NSLog(@"%@",key);
            [arr addObject:key];
        }
        
        free(properties);
        
        cls = cls.superclass;
    }
    return arr;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSArray *propertyList = [self getPropertyListForEncode];
    for (NSString *propertyKey in propertyList) {
        // may have bugs: property maybe BOOL、int etc
        id value = [self valueForKey:propertyKey];
//        NSLog(@"%@:%@",propertyKey,value);
        [aCoder encodeObject:value forKey:propertyKey];
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    NSArray *propertyList = [self getPropertyListForEncode];
    for (NSString *propertyKey in propertyList) {
        // may have bugs: property maybe BOOL、int etc
        id value = [aDecoder decodeObjectForKey:propertyKey];
        [self setValue:value forKey:propertyKey];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [self.class allocWithZone:zone];
    NSArray *arr = [self getPropertyListForEncode];
    for (NSString *key in arr) {
        NSLog(@"%@",key);
        id value = [self valueForKey:key];
        id vCopy = value;
        if ([value respondsToSelector:@selector(copy)]) {
            vCopy = [value copy];
        }
        [copy setValue:vCopy forKey:key];
    }
    return copy;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    id mutableCopy = [self.class allocWithZone:zone];
    NSArray *arr = [self getPropertyListForEncode];
    for (NSString *key in arr) {
        id value = [self valueForKey:key];
        id vCopy = value;
        if (![value isKindOfClass:[NSNumber class]] && [value respondsToSelector:@selector(mutableCopy)]) {
            vCopy = [value mutableCopy];
        }
        [mutableCopy setValue:vCopy forKey:key];
    }
    return mutableCopy;
}

@end

@implementation NSArray (ToDictionary)

- (NSDictionary *)toDictionary
{
    NSMutableArray *arr = [NSMutableArray new];
    for (id item in self) {
        if ([item respondsToSelector:@selector(toDictionary)]) {
            [arr addObject:[item toDictionary]];
        }else{
            [arr addObject:item];
        }
    }
    return arr.copy;
}

- (BOOL)containsName:(NSString *)name isFang:(BOOL)isFang
{
    for (id item in self) {
        if ([item respondsToSelector:@selector(containsName:isFang:)]) {
            if ([item containsName:name isFang:isFang]) {
                return YES;
            }else{
                continue;
            }
        }else if ([item isKindOfClass:[NSString class]]){
            if ([DataCache name:item isEqualToName:name isFang:isFang]) {
                return YES;
            }else{
                continue;
            }
        }
    }
    return NO;
}

@end

@implementation NSIndexPath (JSONModel)

- (id)copy
{
    return [NSIndexPath indexPathForRow:self.row inSection:self.section];
}

- (id)mutableCopy
{
    return [self copy];
}

@end

