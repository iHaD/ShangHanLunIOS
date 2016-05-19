//
//  LittleWindow.m
//  shangHanLunTab
//
//  Created by hh on 16/3/19.
//  Copyright © 2016年 hh. All rights reserved.
//

#import "LittleWindow.h"
#import "HH2SearchConfig.h"
#import "AppDelegate.h"

@implementation LittleWindow
{
    UIView *mask;
}

- (instancetype)initWithShowFromRect:(CGRect)rect searchText:(NSString *)text inAttributedText:(NSAttributedString *)allText range:(NSRange)range
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    
    mask = [[UIView alloc] initWithFrame:self.frame];
    mask.alpha = 0.5;
    mask.backgroundColor = [UIColor blackColor];
    mask.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [mask addGestureRecognizer:tap];
    [self addSubview:mask];
    
    self.searchText = text;
    self.text = allText;
    self.range = range;
    
    UIWindow *win = [[UIApplication sharedApplication].delegate window];
    [win endEditing:YES];
    
    return self;
}

- (void)show
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:self];
}

- (void)onTap:(id)sender
{
    [self removeFromSuperview];
}

- (CGFloat)getWindowHeight:(CGRect)rect
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CGFloat height = app.window.height;
    CGFloat arrowHeight = [HH2ArrowView getDefaultSize].height;
    if (rect.origin.y + rect.size.height/2 < height/2) {
        return height - rect.origin.y - rect.size.height - arrowHeight - 54;
    }else{
        return rect.origin.y - arrowHeight - 54;
    }
}

- (HH2ArrowView *)getArrowView:(HH2Arrow)direction atY:(CGFloat)arrowY fromRect:(CGRect)rect edge:(CGFloat)edge width:(CGFloat)width
{
    HH2ArrowView *arrow = [[HH2ArrowView alloc] initWithDirection:direction];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CGSize screenSize = app.window.size;
    CGFloat x = rect.origin.x + rect.size.width/2.0;
    CGFloat dx = 0;//app.littleWindowStack.count > 1 ? edge*2 - 1 : edge;
    if (rect.size.width >= screenSize.width - dx*2 - 1) {
        x = direction == HH2ArrowDown ? dx + width - arrow.frame.size.width : dx + arrow.frame.size.width;
    }
    arrow.center = CGPointMake(x, arrowY);
    return arrow;
}

- (void)copyTextViewContentToPastboard:(UIButton *)btn
{
    [UIPasteboard generalPasteboard].string = [btn titleForState:UIControlStateReserved];
    [UIView animateWithDuration:0.3 animations:^{
        btn.frame = CGRectMake(btn.x + btn.width/2, btn.y + btn.height/2, 0, 0);
    } completion:^(BOOL finished) {
        [btn removeFromSuperview];
    }];
}

- (UIViewController *)getCurController
{
    UIWindow *win = [[UIApplication sharedApplication].delegate window];
    UITabBarController *tab = (UITabBarController *)win.rootViewController;
    UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
    return nav.viewControllers.lastObject;
}

- (BOOL)isInContentContext
{
    __block BOOL ret = YES;
    [_text enumerateAttribute:NSUnderlineStyleAttributeName inRange:NSMakeRange(0, _text.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSNumber * _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value.integerValue == NSUnderlineStyleSingle) {
            *stop = YES;
            if (range.location == 0 || [[_text.string substringWithRange:NSMakeRange(range.location - 1, 1)] isEqualToString:@"、"]) {
                ret = NO;
            }
        }
    }];
    return ret;
}

- (BOOL)isInFangContext
{
    __block BOOL ret = YES;
    [_text enumerateAttribute:NSUnderlineStyleAttributeName inRange:NSMakeRange(0, _text.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSNumber *  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value.integerValue == NSUnderlineStyleSingle) {
            *stop = YES;
            if (range.location == 0 || ![[_text.string substringWithRange:NSMakeRange(range.location - 1, 1)] isEqualToString:@"、"] || ![DataCache hasFang:[_text.string substringWithRange:range]] || [_text.string hasPrefix:@"*"]) {
                ret = NO;
            }
        }
    }];
    return ret;
}

- (BOOL)isInYaoContext
{
    __block BOOL ret = YES;
    [_text enumerateAttribute:NSUnderlineStyleAttributeName inRange:NSMakeRange(0, _text.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSNumber *  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value.integerValue == NSUnderlineStyleSingle) {
            *stop = YES;
            if (range.location == 0 || ![[_text.string substringWithRange:NSMakeRange(range.location - 1, 1)] isEqualToString:@"、"] || ![DataCache hasYao:[_text.string substringWithRange:range]]) {
                ret = NO;
            }
        }
    }];
    return ret;
}

@end
