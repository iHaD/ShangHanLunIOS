//
//  DataCache.m
//  shangHanLun_iOS
//
//  Created by hh on 16/5/4.
//  Copyright © 2016年 hh. All rights reserved.
//

#import "DataCache.h"
#import "HH2SearchConfig.h"

@implementation DataCache
static DataCache *data;
HH2SearchConfig *config;
NSDictionary *_yaoAliasDict;
NSDictionary *_fangAliasDict;

- (instancetype)init
{
    self = [super init];
    config = [HH2SearchConfig sharedConfig];
    [self initAlias];
    [self initYaoData];
    [self initFangData];
    [self initContentData];
    return self;
}

+ (instancetype)sharedData
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        data = [[self alloc] init];
    });
    return data;
}

- (void)initContentData
{
    NSArray *arr;
    NSURL *url;
    NSData *data;
    if (config.showShangHan != ShowShangHanNone) {
        url = [[NSBundle mainBundle] URLForResource:@"shangHan_data" withExtension:@"json"];
        data = [[NSData alloc] initWithContentsOfURL:url];
        arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (config.showShangHan == ShowShangHanOnly398){
            arr = [arr subarrayWithRange:NSMakeRange(8, 10)];
        }
    }else{
        arr = [NSArray new];
    }
    
    if (config.showJinKui != ShowJinKuiNone) {
        url = [[NSBundle mainBundle] URLForResource:@"jinKui_data" withExtension:@"json"];
        data = [[NSData alloc] initWithContentsOfURL:url];
        NSArray *arr2 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        arr = [arr arrayByAddingObjectsFromArray:arr2];
        arr2 = nil;
    }
    NSMutableArray  *d = [NSMutableArray new];
    [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop){
        HH2SectionData *s = [[HH2SectionData alloc] initWithDictionary:dict section:idx type:DataTypeItem];
        s.headerView = [HH2SearchHeaderView new];
        [d addObject:s];
    }];
    _itemData = d;
}

- (void)initFangData
{
    NSArray<HH2SectionData *> *target;
    int section = 0;
    if (config.showShangHan != ShowShangHanNone) {
        [self initFang:@"shangHanFang" to:&target withHeader:@"伤寒论方" section:section];
        section++;
        _shangHanFang = (NSArray<Fang *> *)target.firstObject.data;
        _fangData = target;
    }
    
    if (config.showJinKui != ShowJinKuiNone) {
        [self initFang:@"jinKuiFang" to:&target withHeader:@"金匮要略方" section:section];
        _jinKuiFang = (NSArray<Fang *> *)target.firstObject.data;
        if (!_fangData) {
            _fangData = [NSArray new];
        }
        _fangData = [_fangData arrayByAddingObjectsFromArray:target];
    }
}

- (void)initFang:(NSString *)fileName to:(NSArray<HH2SectionData *> **)target withHeader:(NSString *)header section:(NSInteger)section
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSMutableArray  *d = [NSMutableArray new];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"data"] = arr;
    dict[@"header"] = header;
    HH2SectionData *s = [[HH2SectionData alloc] initWithDictionary:dict section:section type:DataTypeFang];
    s.headerView = [HH2SearchHeaderView new];
    [d addObject:s];
    *target = d;
}

- (void)initYaoData
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"yao" withExtension:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSMutableArray  *d = [NSMutableArray new];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"data"] = arr;
    dict[@"header"] = @"所有药物列表";
    HH2SectionData *s = [[HH2SectionData alloc] initWithDictionary:dict section:0 type:DataTypeYao];
    s.headerView = [HH2SearchHeaderView new];
    [d addObject:s];
    _yaoData = d;
    _yao = (NSArray<Yao *> *)s.data;
}

- (void)initAlias
{
    _yaoAliasDict = @{
                      @"术":@"白术",
                      @"朮":@"白术",
                      @"白朮":@"白术",
                      @"桂":@"桂枝",
                      @"桂心":@"桂枝",
                      @"肉桂":@"桂枝",
                      @"白芍药":@"芍药",
                      @"枣":@"大枣",
                      @"枣膏":@"大枣",
                      @"生姜汁":@"生姜",
                      @"姜":@"生姜",
                      @"生葛":@"葛根",
                      
                      @"生地黄":@"地黄",
                      @"干地黄":@"地黄",
                      @"生地":@"地黄",
                      @"熟地":@"地黄",
                      @"生地黄汁":@"地黄",
                      @"地黄汁":@"地黄",
                      
                      @"甘遂末":@"甘遂",
                      @"茵陈蒿末":@"茵陈蒿",
                      @"大附子":@"附子",
                      @"川乌":@"乌头",
                      @"粉":@"白粉",
                      @"白蜜":@"蜜",
                      @"食蜜":@"蜜",
                      @"杏子":@"杏仁",
                      @"葶苈":@"葶苈子",
                      @"香豉":@"豉",
                      @"肥栀子":@"栀子",
                      @"生狼牙":@"狼牙",
                      @"干苏叶":@"苏叶",
                      @"清酒":@"酒",
                      @"白酒":@"酒",
                      
                      @"艾叶":@"艾",
                      @"乌扇":@"射干",
                      @"代赭石":@"赭石",
                      @"代赭":@"赭石",
                      @"煅灶下灰":@"煅灶灰",
                      
                      @"蛇床子仁":@"蛇床子",
                      @"牡丹皮":@"牡丹",
                      @"小麦汁":@"小麦",
                      @"小麦粥":@"小麦",
                      @"麦粥":@"小麦",
                      @"大麦粥":@"大麦",
                      @"大麦粥汁":@"大麦",
                      
                      @"葱白":@"葱",
                      
                      @"赤硝":@"赤消",
                      @"硝石":@"赤消",
                      @"消石":@"赤消",
                      @"芒消":@"芒硝",
                      
                      @"法醋":@"苦酒",
                      @"大猪胆":@"猪胆汁",
                      @"大猪胆汁":@"猪胆汁",
                      @"鸡子白":@"鸡子",
                      
                      @"太一禹余粮":@"禹余粮",
                      @"妇人中裈近隐处取烧作灰":@"中裈灰",
                      @"石苇":@"石韦",
                      @"灶心黄土":@"灶中黄土",
                      @"瓜子":@"瓜瓣",
                      
                      @"括蒌根":@"栝楼根",
                      @"瓜蒌根":@"栝楼根",
                      @"括蒌实":@"栝楼实",
                      @"瓜蒌实":@"栝楼实",
                      @"栝楼":@"栝楼实",
                      };
    
    _fangAliasDict = @{
                       @"人参汤":@"理中汤",
                       @"芪芍桂酒汤":@"黄芪芍药桂枝苦酒汤",
                       @"膏发煎":@"猪膏发煎",
                       @"小柴胡":@"小柴胡汤"
                       };
}

+ (NSString *)getStandardYaoName:(NSString *)name
{
    return _yaoAliasDict[name]?:name;
}

+ (NSString *)getStandardFangName:(NSString *)name
{
    return _fangAliasDict[name]?:name;
}

+ (BOOL)hasYao:(NSString *)name
{
    for (Yao *y in data.yao) {
        if ([self name:y.name isEqualToName:name isFang:NO]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)hasFang:(NSString *)name
{
    for (HH2SectionData *sec in data.fangData) {
        for (Fang *f in sec.data) {
            if ([self name:f.name isEqualToName:name isFang:YES]) {
                return YES;
            }
        }
    }
    return NO;
}

// 第二个参数可以是正则表达式
+ (BOOL)fang:(NSString *)left isEqualToFang:(NSString *)right
{
    left = _fangAliasDict[left] ? : left;
    NSRange range = [left rangeOfString:right options:NSRegularExpressionSearch];
    if (range.length > 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)yao:(NSString *)left isEqualToYao:(NSString *)right
{
    left = _yaoAliasDict[left] ? : left;
    NSRange range = [left rangeOfString:right options:NSRegularExpressionSearch];
    if (range.length == left.length) {
        return YES;
    }
    return NO;
}

+ (BOOL)name:(NSString *)name isEqualToName:(NSString *)text isFang:(BOOL)isFang
{
    NSDictionary *dict = isFang ? _fangAliasDict : _yaoAliasDict;
    NSString *left = dict[name] ? : name;
    NSString *right = dict[text] ? : text;
    NSRange range = [left rangeOfString:right options:NSRegularExpressionSearch];
//    if ((isFang && range.length > 0) || (!isFang && range.length == left.length)) {
//        return YES;
//    }
    if (range.length == left.length) {
        return YES;
    }
    return NO;
}

+ (NSMutableAttributedString *)getYaoContentByName:(NSString *)yaoName
{
    for (Yao *y in data.yao) {
        if ([self name:yaoName isEqualToName:y.name isFang:NO]) {
            return y.attributedText;
        }
    }
    return nil;
}

+ (NSArray<HH2SectionData *> *)getFangListByYaoNameInStandardList:(NSString *)name
{
    NSMutableArray *arr = [NSMutableArray new];
    for (HH2SectionData *sec in data.fangData) {
        NSMutableArray *arrIn = [NSMutableArray new];
        for (Fang *f in sec.data) {
            BOOL has = NO;
            for (YaoUse *use in f.standardYaoList) {
                if ([self name:name isEqualToName:use.showName isFang:NO]) {
                    has = YES;
                    break;
                }
            }
            if (has) {
                [f setValue:name forKey:@"curYao"];
                [arrIn addObject:f];
            }
        }
        HH2SectionData *d = [[HH2SectionData alloc] initWithData:arrIn section:sec.section];
        if (sec.header) {
            d.header = sec.header;
        }
        [arr addObject:d];
    }
    return arr;
}

@end
