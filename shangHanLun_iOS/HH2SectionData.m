//
//  HH2SectionData.m
//  shangHanLunTab
//
//  Created by hh on 15/12/3.
//  Copyright © 2015年 hh. All rights reserved.
//

#import "HH2SectionData.h"
#import "YYText.h"


@implementation HH2SectionData
{
    HH2SearchHeaderView *_headerView;
    NSArray<DataItem *> *_dataBac;
}

- (instancetype)init
{
    NSAssert(NO, @"不能直接用init方法，必须用initWithDictionary:方法初始化");
    return nil;
}

- (NSArray<DataItem *> *)dataBac
{
    return _dataBac;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"data"]) {
        [super setValue:value forKey:key];
        _dataBac = _data;
        [_data enumerateObjectsUsingBlock:^(DataItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj refreshShow];
            NSIndexPath *ip = [NSIndexPath indexPathForRow:idx inSection:_section];
            [obj setValue:ip forKey:@"indexPath"];
        }];
    }else{
        [super setValue:value forKey:key];
    }
}

- (HH2SearchHeaderView *)headerView
{
    return _headerView;
}

- (void)refreshShow
{
    [_headerView setTextColor:[HH2SearchConfig sharedConfig].headerTextColor];
    [_data enumerateObjectsUsingBlock:^(DataItem *obj, NSUInteger idx, BOOL *stop){
        [obj refreshShow];
    }];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict section:(NSUInteger)section type:(DataType)type_
{
    self = [super init];
    _section = section;
    type = type_;
    [self setValuesForKeysWithDictionary:dict];
    
    return self;
}

- (instancetype)initWithData:(NSArray<DataItem *> *)data section:(NSUInteger)section
{
    self = [super init];
    _section = section;
    _dataBac = data;
    _data = data;
    return self;
}

- (void)resetData
{
    _data = _dataBac;
}

- (BOOL)isPureInt:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (void)setHeaderView:(HH2SearchHeaderView *)headerView
{
    _headerView = headerView;
    _headerView.text = _header;
    _headerView.section = _section;
}

- (NSString *)description
{
    return _data.description;
}

- (Class)getSubDataClassInArrayForKey:(NSString *)key
{
    return @[[Item class], [Fang class], [Yao class]][type];
}

@end
