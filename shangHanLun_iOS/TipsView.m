//
//  TipsView.m
//  shangHanLunTab
//
//  Created by hh on 16/2/5.
//  Copyright © 2016年 hh. All rights reserved.
//

#import "TipsView.h"
#import "AppDelegate.h"

@implementation TipsView
{
    UIButton *closeBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.editable = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 8;
    CGFloat inset = 15;
    self.textContainerInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    
//    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    closeBtn.frame = CGRectMake(self.width - 60, self.height, 50, 34);
//    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
//    closeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    closeBtn.backgroundColor = [UIColor blackColor];
//    closeBtn.layer.cornerRadius = 6;
    
    return self;
}

- (void)setCurSearchText:(NSString *)curSearchText
{
    _curSearchText = curSearchText;
    //不作检查是否含有f／y
    NSString *cls = _linkClass == LinkClassYao ? @"y" : @"f";
    NSString *sText = [curSearchText componentsSeparatedByString:cls].lastObject;
    sText = [sText stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *pre = _linkClass == LinkClassYao ? @"$u{" : @"$f{";
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DataCache *cache = [DataCache sharedData];
    NSArray<HH2SectionData *> *list = _linkClass == LinkClassYao ? cache.yaoData : cache.fangData;
    NSMutableString *strOut = [NSMutableString new];
    [list enumerateObjectsUsingBlock:^(HH2SectionData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableString *strIn = [NSMutableString new];
        [obj.dataBac enumerateObjectsUsingBlock:^(DataItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop2) {
            NSString *unit = _linkClass == LinkClassYao ? obj.yaoList.firstObject : obj.fangList.firstObject;
            if ([sText isEqualToString:unit]) {
                _isFinished = YES;
                [self removeFromSuperview];
                *stop2 = YES;
                *stop = YES;
                return;
            }
            if (sText.length == 0 || [unit containsString:sText]) {
                [strIn appendFormat:@"%@%@}，",pre, unit];
            }
        }];
        if (strIn.length > 0) {
            [strOut appendFormat:@"$m{%@}\r%@\r\r",obj.header?:@"所有药物", strIn];
        }
    }];
    
    if (strOut.length == 0) {
        [self removeFromSuperview];
        return;
    }
    
    NSString *strOut_ = strOut.length > 2 ? [strOut substringToIndex:strOut.length - 2] : strOut;
    NSMutableAttributedString *astr = [strOut_ parseTextWithBlock:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        NSString *which = [text.string substringWithRange:range];
        NSString *orig = [NSString stringWithFormat:@"%@%@",cls,sText];
        NSUInteger start = curSearchText.length - sText.length - 1;
        NSString *newText = [curSearchText stringByReplacingOccurrencesOfString:orig withString:[NSString stringWithFormat:@"%@%@ ",cls, which] options:NSCaseInsensitiveSearch range:NSMakeRange(start, curSearchText.length - start)];
        [_con searchBar:_con.searchBar textDidChange:newText];
        _con.searchBar.text = newText;
        [self removeFromSuperview];
        [_con.searchBar becomeFirstResponder];
    }];
    
    NSMutableAttributedString *str = astr;
    str.yy_lineSpacing = 4;
    str.yy_font = [UIFont systemFontOfSize:17];
    self.attributedText = str;
    self.contentOffset = CGPointZero;
    
    if (!self.superview) {
        [_con.view addSubview:self];
    }
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(self.width - 2*15, MAXFLOAT) text:str];
    CGFloat height = layout.textBoundingSize.height + 30;
    _curContentHeight = height;
    [UIView animateWithDuration:0.3 animations:^{
        self.height = MIN(height, _con.maxInputTipsHeight);
    }];
}

@end
