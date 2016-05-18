//
//  DataItem.m
//  shangHanLunTab
//
//  Created by hh on 16/5/4.
//  Copyright © 2016年 hh. All rights reserved.
//

#import "DataItem.h"
#import "YYText.h"
#import "NSString+getAllSubString.h"

@implementation DataItem
{
    NSMutableAttributedString *_attributedText;
}

- (NSString *)description
{
    return _text;
}

- (NSMutableAttributedString *)attributedText
{
    return _attributedText;
}

- (Class)getSubDataClassInArrayForKey:(NSString *)key
{
    return [NSString class];
}

- (instancetype)init
{
    NSAssert(NO, @"不能直接用init方法，必须用initWithText:方法初始化");
    return nil;
}

- (id)initWithText:(NSString *)text
{
    self = [super init];
    _text = text;
    _fangList = [text getFangNameList];
    _yaoList = [text getYaoList];
    [self refreshShow];
    return self;
}

- (void)refreshShow
{
    CGFloat _screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat edge = 16;
    CGSize size = CGSizeMake(_screenWidth - edge*2, CGFLOAT_MAX);
    _attributedText = [_text parseText:YES];
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:_attributedText];
    self.height = layout.textBoundingSize.height + 20;
}

- (BOOL)containsName:(NSString *)name isFang:(BOOL)isFang
{
    return [(isFang?_fangList:_yaoList) containsName:name isFang:isFang];
}

@end
