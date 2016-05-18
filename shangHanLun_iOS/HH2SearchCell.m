//
//  HH2SearchCell.m
//  shangHanLunTab
//
//  Created by hh on 15/12/3.
//  Copyright © 2015年 hh. All rights reserved.
//

#import "HH2SearchCell.h"
#import "HH2SearchConfig.h"
#import "YYText.h"

@implementation HH2SearchCell
{
    YYLabel *label;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    label = [YYLabel new];
    label.numberOfLines = 0;
    [self.contentView addSubview:label];
    self.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0 alpha:0.3];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    label.frame = CGRectInset(self.bounds, 16, 0);
}

- (void)setAttributedText:(NSAttributedString *)text
{
    label.attributedText = text;
    [self setNeedsLayout];
}

- (NSAttributedString *)attributedText
{
    return label.attributedText;
}

@end
