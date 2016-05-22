//
//  HH2SearchConfig.m
//  shangHanLunTab
//
//  Created by hh on 15/12/3.
//  Copyright © 2015年 hh. All rights reserved.
//

#import "HH2SearchConfig.h"

@implementation HH2SearchConfig
static HH2SearchConfig *config;

- (instancetype)init
{
    NSAssert(NO, @"不能使用init方法，这里是单例");
    return nil;
}

- (instancetype)initDefault
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    _font = [def objectForKey:@"font"] ? [UIFont systemFontOfSize:[[def objectForKey:@"font"] floatValue]] : [UIFont systemFontOfSize:17.0];
    _smallFont = [def objectForKey:@"smallFont"] ? : [_font fontWithSize:_font.pointSize - 4];
    _isContentOpenAtFirst = [([def objectForKey:@"isContentOpenAtFirst"] ? : @NO) boolValue];
    _showShangHan = [[def objectForKey:@"showShangHan"] ? : @(ShowShangHanOnly398) integerValue];
    _showJinKui = [[def objectForKey:@"showJinKui"] ? : @(ShowJinKuiDefault) integerValue];
    
    _showUnderLine = [def objectForKey:@"showUnderLine"] ? [[def objectForKey:@"showUnderLine"] boolValue] : YES;
    
    _headerTextColor = [def objectForKey:@"headerTextColor"] ? : [UIColor blueColor];
    _nColor = [def objectForKey:@"nColor"] ? : [UIColor blueColor];
    _fangColor = [def objectForKey:@"fangColor"] ? : [UIColor blueColor];
    _commentColor = [def objectForKey:@"commentColor"] ? : [UIColor redColor];
    _yaoNumColor = [def objectForKey:@"yaoNumColor"] ? : [UIColor redColor];
    _zhufaNumColor = [def objectForKey:@"zhufaNumColor"] ? : [UIColor colorWithRed:0 green:0.5 blue:1.0 alpha:0.9];
    _yaoColor = [def objectForKey:@"yaoColor"] ? : [UIColor colorWithRed:0.3 green:0 blue:1.0 alpha:1.0];
    _yaoAmountColor = [def objectForKey:@"yaoAmountColor"] ? :[UIColor colorWithRed:0 green:0.5 blue:0 alpha:1.0];
    _fangPrefixColor = [def objectForKey:@"fangPrefixColor"] ? : [UIColor colorWithRed:0.24 green:0.78 blue:0.47 alpha:1.0];
    
    return self;
}

// 存储NSUserDefaults

+ (instancetype)sharedConfig
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc] initDefault];
    });
    return config;
}

- (void)setShowShangHan:(ShowShangHan)showShangHan
{
    _showShangHan = showShangHan;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@(showShangHan) forKey:@"showShangHan"];
    [def setObject:@(_showShangHan == ShowShangHanOnly398) forKey:@"isContentOpenAtFirst"];
    [def synchronize];
}

- (void)setShowJinKui:(ShowJinKui )showJinKui
{
    _showJinKui = showJinKui;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@(showJinKui) forKey:@"showJinKui"];
    [def synchronize];
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    _smallFont = [font fontWithSize:font.pointSize - 4];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@(font.pointSize) forKey:@"font"];
    [def synchronize];
}

- (void)dealloc
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def synchronize];
}

@end
