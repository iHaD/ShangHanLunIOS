//
//  HH2SearchHeaderView.m
//  shangHanLunTab
//
//  Created by hh on 15/12/3.
//  Copyright © 2015年 hh. All rights reserved.
//

#import "HH2SearchHeaderView.h"
#import "HH2SearchConfig.h"
#import "YYText.h"
#import "NSString+getAllSubString.h"

@implementation HH2SearchHeaderView
{
    YYLabel *_textLabel;
    UIView *lineTop;
    UIView *lineBottom;
    NSRange colorRange;
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    [self addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(selectOneChapter:)];
    [self addGestureRecognizer:longPress];
    
    _textLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
    _textLabel.font = [UIFont fontWithName:_textLabel.font.fontName size:19.0];
    _textLabel.numberOfLines = 2;
    _textLabel.userInteractionEnabled = NO;

    self.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.7];
    [self addSubview:_textLabel];
    
    lineTop = [[UIView alloc] initWithFrame:CGRectZero];
    lineTop.backgroundColor = [UIColor grayColor];
    lineTop.layer.borderWidth = 0.25;
    lineBottom = [[UIView alloc] initWithFrame:CGRectZero];
    lineBottom.backgroundColor = lineTop.backgroundColor;
    lineBottom.layer.borderWidth = lineTop.layer.borderWidth;
    [self addSubview:lineTop];
    [self addSubview:lineBottom];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _textLabel.frame = CGRectInset(self.bounds, 16, 0);
    lineTop.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
    lineBottom.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.5);
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    NSMutableAttributedString *astr = _textLabel.attributedText.mutableCopy;
    [astr yy_setColor:textColor range:colorRange];
    _textLabel.attributedText = astr;
}

- (void)setText:(NSString *)text
{
    NSInteger loc = text.length;
    BOOL hasComment = NO;
    if ([text rangeOfString:@"$"].location != NSNotFound) {
        hasComment = YES;
        loc = [text rangeOfString:@"$"].location;
        text = [text stringByReplacingOccurrencesOfString:@"$" withString:@""];
    }
    _text = text;
    
    NSMutableAttributedString *aStr= [[NSMutableAttributedString alloc] initWithString:text];

    colorRange = NSMakeRange(0, loc);
    [aStr yy_setFont:[UIFont boldSystemFontOfSize:[HH2SearchConfig sharedConfig].font.pointSize] range:colorRange];
    aStr.yy_color = [HH2SearchConfig sharedConfig].headerTextColor;
    if (hasComment) {
        [aStr yy_setColor:[UIColor redColor] range:NSMakeRange(loc, text.length - loc)];
    }
//    [aStr yy_setAlignment:NSTextAlignmentCenter range:NSMakeRange(0, text.length)];
    [aStr yy_setParagraphSpacing:0 range:NSMakeRange(loc, text.length - loc)];
    
    _textLabel.attributedText = aStr;
}

- (void)onClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(clickHH2SearchHeaderView:)]) {
        [self.delegate clickHH2SearchHeaderView:self];
        [self setNeedsLayout];
    }
}

- (void)selectOneChapter:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state != UIGestureRecognizerStateBegan) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(longPressSearchHeaderView:)]) {
        [self.delegate longPressSearchHeaderView:self];
    }
}

@end
