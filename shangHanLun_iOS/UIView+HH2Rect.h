//
//  UIView+HH2Rect.h
//  JiPei
//
//  Created by hh on 16/1/30.
//  Copyright © 2016年 hh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HH2Rect)

- (CGFloat)x;
- (void)setX:(CGFloat)x;
- (CGFloat)y;
- (void)setY:(CGFloat)y;
- (CGFloat)width;
- (void)setWidth:(CGFloat)width;
- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGPoint)origin;
- (void)setOrigin:(CGPoint)origin;
- (CGSize)size;
- (void)setSize:(CGSize)size;

@end
