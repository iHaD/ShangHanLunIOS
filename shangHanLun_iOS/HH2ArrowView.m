//
//  HH2ArrowView.m
//  shangHanLunTab
//
//  Created by hh on 15/12/17.
//  Copyright © 2015年 hh. All rights reserved.
//

#import "HH2ArrowView.h"

@implementation HH2ArrowView
{
    HH2Arrow direction;
    CGFloat border;
}

- (instancetype)initWithDirection:(HH2Arrow)direction_
{
    border = 20;
    self = [super initWithFrame:CGRectMake(0, 0, border, border)];
    direction = direction_;
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

+ (CGSize)getDefaultSize
{
    return CGSizeMake(20, 20);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:1.0];
    [[UIColor blackColor] setStroke];
    if (direction == HH2ArrowDown) {
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(border, 0)];
        [path addLineToPoint:CGPointMake(border/2.0, border)];
        [path closePath];
    }else{
        [path moveToPoint:CGPointMake(0, border)];
        [path addLineToPoint:CGPointMake(border, border)];
        [path addLineToPoint:CGPointMake(border/2.0, 0)];
        [path closePath];

    }
    [path stroke];
    [[UIColor whiteColor] setFill];
    [path fill];
    
    UIGraphicsPopContext();
}

@end
