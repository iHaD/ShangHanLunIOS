//
//  LittleWindow.h
//  shangHanLunTab
//
//  Created by hh on 16/3/19.
//  Copyright © 2016年 hh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HH2ArrowView.h"

@interface LittleWindow : UIView

@property (strong,nonatomic) NSAttributedString *text;
@property (assign,nonatomic) NSRange range;
@property (strong,nonatomic) NSString *searchText;

- (instancetype)initWithShowFromRect:(CGRect)rect searchText:(NSString *)text inAttributedText:(NSAttributedString *)allText range:(NSRange)range;

- (CGFloat)getWindowHeight:(CGRect)rect;
- (HH2ArrowView *)getArrowView:(HH2Arrow)direction atY:(CGFloat)arrowY fromRect:(CGRect)rect edge:(CGFloat)edge width:(CGFloat)width;
- (void)copyTextViewContentToPastboard:(UIButton *)btn;
- (UIViewController *)getCurController;

- (void)show;

- (BOOL)isInContentContext;
- (BOOL)isInFangContext;
- (BOOL)isInYaoContext;

@end
