//
//  Fang.m
//  shangHanLunTab
//
//  Created by hh on 16/5/4.
//  Copyright © 2016年 hh. All rights reserved.
//

#import "Fang.h"

@implementation YaoUse

@end

@implementation Fang

- (Class)getSubDataClassInArrayForKey:(NSString *)key
{
    return [YaoUse class];
}

- (NSString *)getFangNameLinkWithYaoWeight:(NSString *)yao
{
    for (YaoUse *use in _standardYaoList) {
        if ([DataCache name:use.showName isEqualToName:yao isFang:NO]) {
            return [NSString stringWithFormat:@"$f{%@}$w{(%@%.0f%@服)}", _name, use.amount, floorf(_drinkNum), use.suffix?:@""];
        }
    }
    return @"";
}

- (NSComparisonResult)compare:(Fang *)another
{
    if (!curYao) {
        return [_name compare:another.name];
    }
    
    YaoUse *use = [self getYaoUseByName:curYao];
    if (!use) {
        return [_name compare:another.name];
    }
    
    YaoUse *ano = [another getYaoUseByName:curYao];
    if (!ano) {
        return [_name compare:another.name];
    }
    
    int res = NSOrderedSame;
    float left = MAX(use.weight,use.maxWeight)/_drinkNum;
    float right = MAX(ano.weight,ano.maxWeight)/another.drinkNum;
    if (left > right) {
        res = NSOrderedAscending;
    }else if (left < right){
        res = NSOrderedDescending;
    }
    return res;
}

- (YaoUse *)getYaoUseByName:(NSString *)name
{
    for (YaoUse *use in _standardYaoList) {
        if ([DataCache name:name isEqualToName:use.showName isFang:NO]) {
            return use;
        }
    }
    return nil;
}

@end
