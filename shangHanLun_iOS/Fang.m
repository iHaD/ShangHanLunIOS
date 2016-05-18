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
            return [NSString stringWithFormat:@"$f{%@}$w{(%@%@)}", _name, use.amount, use.extraProcess];
        }
    }
    return @"";
}

@end
