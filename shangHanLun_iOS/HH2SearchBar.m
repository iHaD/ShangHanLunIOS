//
//  HH2SearchBar.m
//  shangHanLunTab
//
//  Created by hh on 15/12/3.
//  Copyright © 2015年 hh. All rights reserved.
//

#import "HH2SearchBar.h"
#import "NSString+getAllSubString.h"

@implementation HH2SearchBar
{
    UILabel *numLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.placeholder = @"输入搜索关键字（以空格隔开）";
    numLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 120, 0, 90, 44)];
    numLabel.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    numLabel.textAlignment = NSTextAlignmentRight;
    numLabel.textColor = [UIColor grayColor];
    [self addSubview:numLabel];
    return self;
}

- (void)setHowMany:(int)howMany
{
    _howMany = howMany;
    numLabel.hidden = self.text.length == 0 || [self.text isPureInt];
    numLabel.text = [NSString stringWithFormat:@"%d个结果", howMany];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    numLabel.frame = CGRectMake(self.frame.size.width - 120, 0, 90, 44);
}

@end
