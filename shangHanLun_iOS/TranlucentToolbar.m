//
//  TranlucentToolbar.m
//  shangHanLunTab
//
//  Created by hh on 16/2/7.
//  Copyright © 2016年 hh. All rights reserved.
//

#import "TranlucentToolbar.h"

@implementation TranlucentToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.clearsContextBeforeDrawing = YES;
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // do nothing;
}


@end
