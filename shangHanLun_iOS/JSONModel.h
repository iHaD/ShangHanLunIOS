//
//  JSONModel.h
//  niuPei
//
//  Created by hh on 15/6/7.
//  Copyright (c) 2015年 hh. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * 注意：实体类的属性必须是NSObject对象，不能是基础类型(BOOL, int等)，否则出错。建议都用NSString。
 * 可以嵌套实体类，或者NSArray等，均能自动解析。
 * 支持序列化、支持copy, mutableCopy
 */

@interface JSONModel : NSObject <NSCopying, NSMutableCopying, NSCoding>

-(instancetype)initWithDictionary:(NSDictionary*)jsonDictionary;

// 如果实体类含有NSArray类型的属性，则须实现此方法。返回值Class为该属性值数组内元素的类
/*
 * 示例：某实体类含有2个NSArray类型的属性分别为property1 、property2
 * - (Class)getSubDataClassInArrayForKey:(NSString *)key
 * {
 *      return @{@"property1":DataClass1.class, @"property2":DataClass2.class}[key] ?
 *          : [super getSubDataClassInArrayForKey:key];
 * }
 */
- (Class)getSubDataClassInArrayForKey:(NSString *)key;

- (NSDictionary *)toDictionary;

@end

@interface NSArray (ToDictionary)
- (NSDictionary *)toDictionary;
- (BOOL)containsName:(NSString *)name isFang:(BOOL)isFang;
@end

@interface NSIndexPath (JSONModel)
- (id)copy;
- (id)mutableCopy;
@end

