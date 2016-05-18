//
//  NSString+getAllSubString.m
//  shangHanLun
//
//  Created by hh on 14/11/4.
//  Copyright (c) 2014年 hh. All rights reserved.
//

#import "NSString+getAllSubString.h"
#import "HH2SearchConfig.h"
#import "AppDelegate.h"
#import "YYText.h"
#import "HH2ArrowView.h"
#import "UIView+HH2Rect.h"
#import "ViewController.h"
#import "LittleTextViewWindow.h"
#import "LittleTableViewWindow.h"

@implementation NSString (getAllSubString)

-(NSArray *)getAllSubString:(NSString *)text
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSRange searchRange = NSMakeRange(0, self.length);
    NSRange range;
    while ((range = [self rangeOfString:text options:0 range:searchRange]).location != NSNotFound) {
        [result addObject:@(range.location)];
        NSUInteger loc = NSMaxRange(range);
        searchRange = NSMakeRange(loc, self.length - loc);
    }
    return result;
}

-(NSArray *)getAllSubStringRange:(NSString *)text
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSRange searchRange = NSMakeRange(0, self.length);
    NSRange range;
    while ((range = [self rangeOfString:text options:0 range:searchRange]).location != NSNotFound) {
        [result addObject:[NSValue valueWithRange:range]];
        NSUInteger loc = NSMaxRange(range);
        searchRange = NSMakeRange(loc, self.length - loc);
    }
    return result;
}

-(NSArray *)getAllSubStringRangeByReg:(NSString *)regular
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSRange searchRange = NSMakeRange(0, self.length);
    NSRange range;
    while ((range = [self rangeOfString:regular options:NSRegularExpressionSearch range:searchRange]).location != NSNotFound) {
        [result addObject:[NSValue valueWithRange:range]];
        NSUInteger loc = NSMaxRange(range);
        searchRange = NSMakeRange(loc, self.length - loc);
    }
    return result;
}

-(NSArray *)splitFor:(NSString *)text
{
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    NSUInteger curLoc = 0;
    NSUInteger index = 0;
    NSUInteger end = self.length - text.length;
    for (; index <= end; index++) {
        NSRange range = NSMakeRange(index, 1);
        if ([[self substringWithRange:range] isEqualToString:text]) {
            if (curLoc == index) {
                [tmp addObject:text];
                curLoc++;
            }else{
                NSRange r = NSMakeRange(curLoc, index - curLoc);
                [tmp addObject:[self substringWithRange:r]];
                [tmp addObject:text];
                curLoc = index + 1;
            }
        }else if(index == end){
            NSRange r = NSMakeRange(curLoc, index - curLoc + 1);
            [tmp addObject:[self substringWithRange:r]];
        }
    }
    return tmp.copy;
}

-(NSRange)matchesMagic:(NSString *)text magic:(NSString *)magic
{
    NSRange nilRange = NSMakeRange(0, 0);
    NSArray *words = [text splitFor:magic];
    NSArray *firstTimes;
    NSUInteger times;
    if ([words[0] isEqualToString:magic]) {
        times = self.length - text.length;
        NSMutableArray *tmp = [[NSMutableArray alloc] init];
        for (int i = 0; i < times; i++) {
            [tmp addObject:[NSNumber numberWithUnsignedInteger:i]];
        }
        firstTimes = tmp.copy;
    }else{
        firstTimes = [self getAllSubString:words[0]];
        times = firstTimes.count;
    }
    if (times == 0) {
        return nilRange;
    }
    NSUInteger maxLoc = self.length - 1;
    for (int i = 0; i < times; i++) {
        NSUInteger curLoc = [firstTimes[i] unsignedIntegerValue];
        NSUInteger saveLoc = curLoc;
        int j = 0;
        for (NSString *word in words) {
            if (curLoc > maxLoc) {
                break;
            }
            NSString *curStr = [self substringFromIndex:curLoc];
            //不匹配的情况：
            if (![word isEqualToString:magic] && [curStr rangeOfString:word].location > 0) {
                break;
            }
            curLoc += word.length;
            j++;
        }
        if (j == words.count) {
            return NSMakeRange(saveLoc, text.length);
        }
    }
    return nilRange;
}

-(CGFloat)textHeightWithFontSize:(UIFont *)font width:(CGFloat)width
{
    CGSize constraint = CGSizeMake(width, MAXFLOAT);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size = [self boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading  attributes:dic context:nil].size;
    
    return ceil(size.height);
}

- (CGFloat)getTextHeight
{
    CGFloat _screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat edge = _screenWidth > 400.0 ? 20.0 : 16.0;
    
    return [self textHeightWithFontSize:[HH2SearchConfig sharedConfig].font width:_screenWidth - edge*2] + 20;
}

-(int)getInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    [scan scanInt:&val];
    return val;
}

-(BOOL)isPureInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

-(NSMutableAttributedString *)parseText:(BOOL)enableLinks
{
    if (!self) {
        return nil;
    }
    NSMutableAttributedString *res = [[NSMutableAttributedString alloc] initWithString:self];
    UIFont *font = [HH2SearchConfig sharedConfig].font;
    res.yy_font = font;
    res.yy_lineSpacing = 4;
    /*
     $n{...} 条文序号
     $f{...} 方名
     $a{...} 内嵌注释
     $m{...} 药味总数
     $s{...} 药煮法开头的“上...味"
     * $u{...} 药名
     * $v{...} 药名，但是不显示本经内容
     * $w{...} 药量
     * $q{...} 方名前缀（千金，外台） 不允许嵌套使用
     * $h{...} 隐藏的方名（暂时只用于标记方名)
     已支持嵌套使用
     */
    HH2SearchConfig *config = [HH2SearchConfig sharedConfig];
    NSDictionary<NSString *, UIColor *> *dict = @{
                          @"n" : config.nColor,
                          @"f" : config.fangColor,
                          @"a" : config.commentColor,
                          @"m" : config.yaoNumColor,
                          @"s" : config.zhufaNumColor,
                          @"u" : config.yaoColor,
                          @"v" : config.yaoColor,
                          @"w" : config.yaoAmountColor,
                          @"q" : config.fangPrefixColor,
                          @"h" : [UIColor blackColor],
                          };
    NSRange sRange;

    while ((sRange = [res.string rangeOfString:@"$"]).location != NSNotFound) {
        NSUInteger pn = sRange.location;
        NSRange range = [res.string rangeOfString:@"}" options:NSCaseInsensitiveSearch range:NSMakeRange(pn, res.string.length - pn)];
        
        // 检查有没有嵌套的$
        NSString *rest = [res.string substringWithRange:NSMakeRange(pn, range.location - pn)];
        NSInteger n = [rest getAllSubString:@"$"].count;
        NSUInteger m = 1; // 1个}
        
        while (n > m) {
            NSInteger endPos = pn;
            for (int i = 0; i < n; i++) {
                endPos = [res.string rangeOfString:@"}" options:NSCaseInsensitiveSearch range:NSMakeRange(endPos, res.string.length - endPos)].location + 1;
            }
            m = n;
            range = NSMakeRange(endPos - 1, 1);
            
            rest = [res.string substringWithRange:NSMakeRange(pn, range.location - pn)];
            n = [rest getAllSubString:@"$"].count;
        }
        // 检查完毕

        NSString *cls = [res.string substringWithRange:NSMakeRange(pn + 1, 1)];
        NSRange innerRange = NSMakeRange(pn + 3, range.location - pn - 3);
        
//        if (![@"ufw" containsString:cls]) {
            [res yy_setColor:[dict valueForKey:cls] range:innerRange];
//        }
        // 药量与注释与隐藏皆小字显示
        if ([@"wah" containsString:cls]) {
            [res yy_setFont:config.smallFont range:innerRange];
        }
        // 药名加下划线，并且能够点击
        if ([@"uf" containsString:cls]) {
            if (config.showUnderLine && enableLinks) {
                [res yy_setUnderlineColor:[UIColor blackColor] range:innerRange];
                [res yy_setUnderlineStyle:NSUnderlineStyleSingle range:innerRange];
            }
            //                NSLog(@"%@",[res.string substringWithRange:innerRange]);
            YYTextBorder *border = [YYTextBorder borderWithFillColor:[UIColor grayColor] cornerRadius:3];
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setColor:[UIColor whiteColor]];
            [highlight setBackgroundBorder:border];
            if ([cls isEqualToString:@"u"]) {
                highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                    //                    NSLog(@"tap text:%@",[text.string substringWithRange:range]);
                    // 你也可以把事件回调放到 YYLabel 和 YYTextView 来处理。
                    //                        NSLog(@"%@",text.description);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                            [self showYao:[text.string substringWithRange:range] fromRect:rect containerView:containerView];
                        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        CGRect rect_ = [containerView convertRect:rect toView:app.window];
                        LittleTextViewWindow *little = [[LittleTextViewWindow alloc] initWithShowFromRect:rect_ searchText:[text.string substringWithRange:range] inAttributedText:text range:range];
                        [little show];
                    }) ;
                };
            }else{
                [res yy_setStrokeWidth:@(-2) range:innerRange];
                //                    [res yy_setUnderlineStyle:NSUnderlineStyleNone range:innerRange];
                
                highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        CGRect rect_ = [containerView convertRect:rect toView:app.window];
                        LittleTableViewWindow *little = [[LittleTableViewWindow alloc] initWithShowFromRect:rect_ searchText:[text.string substringWithRange:range] inAttributedText:text range:range];
                        [little show];
                    }) ;
                };
            }
            if (enableLinks) {
                [res yy_setTextHighlight:highlight range:innerRange];
            }
        }
        [res deleteCharactersInRange:NSMakeRange(range.location, 1)];
        [res deleteCharactersInRange:NSMakeRange(pn, 3)];
    }
    
    return [self renderItemNum:res];
}

// 此方法仅用于搜索框提示链接用。
-(NSMutableAttributedString *)parseTextWithBlock:(void (^)(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect))block
{
    if (!self) {
        return nil;
    }
    NSMutableAttributedString *res = [[NSMutableAttributedString alloc] initWithString:self];
    UIFont *font = [HH2SearchConfig sharedConfig].font;
    res.yy_font = font;
    res.yy_lineSpacing = 4;
    /*
     $n{...} 条文序号
     $f{...} 方名
     $a{...} 内嵌注释
     $m{...} 药味总数
     $s{...} 药煮法开头的“上...味"
     * $u{...} 药名
     * $v{...} 药名，但是不显示本经内容
     * $w{...} 药量
     * $q{...} 方名前缀（千金，外台） 不允许嵌套使用
     * $h{...} 隐藏的方名（暂时只用于标记方名)
     已支持嵌套使用
     */
    HH2SearchConfig *config = [HH2SearchConfig sharedConfig];
    NSDictionary<NSString *, UIColor *> *dict = @{
                                                  @"n" : config.nColor,
                                                  @"f" : config.fangColor,
                                                  @"a" : config.commentColor,
                                                  @"m" : config.yaoNumColor,
                                                  @"s" : config.zhufaNumColor,
                                                  @"u" : config.yaoColor,
                                                  @"v" : config.yaoColor,
                                                  @"w" : config.yaoAmountColor,
                                                  @"q" : config.fangPrefixColor,
                                                  @"h" : [UIColor blackColor],
                                                  };
    NSRange sRange;
    
    while ((sRange = [res.string rangeOfString:@"$"]).location != NSNotFound) {
        NSUInteger pn = sRange.location;
        NSRange range = [res.string rangeOfString:@"}" options:NSCaseInsensitiveSearch range:NSMakeRange(pn, res.string.length - pn)];
        
        // 检查有没有嵌套的$
        NSString *rest = [res.string substringWithRange:NSMakeRange(pn, range.location - pn)];
        NSInteger n = [rest getAllSubString:@"$"].count;
        NSUInteger m = 1; // 1个}
        
        while (n > m) {
            NSInteger endPos = pn;
            for (int i = 0; i < n; i++) {
                endPos = [res.string rangeOfString:@"}" options:NSCaseInsensitiveSearch range:NSMakeRange(endPos, res.string.length - endPos)].location + 1;
            }
            m = n;
            range = NSMakeRange(endPos - 1, 1);
            
            rest = [res.string substringWithRange:NSMakeRange(pn, range.location - pn)];
            n = [rest getAllSubString:@"$"].count;
        }
        // 检查完毕
        
        NSString *cls = [res.string substringWithRange:NSMakeRange(pn + 1, 1)];
        NSRange innerRange = NSMakeRange(pn + 3, range.location - pn - 3);
        
        [res yy_setColor:[dict valueForKey:cls] range:innerRange];
        // 药量与注释和隐藏皆小字显示
        if ([@"wah" containsString:cls]) {
            [res yy_setFont:config.smallFont range:innerRange];
        }
        // 药名加下划线，并且能够点击
        if ([@"uf" containsString:cls]) {
            if (config.showUnderLine) {
                [res yy_setUnderlineColor:[UIColor blackColor] range:innerRange];
                [res yy_setUnderlineStyle:NSUnderlineStyleSingle range:innerRange];
            }
            //                NSLog(@"%@",[res.string substringWithRange:innerRange]);
            YYTextBorder *border = [YYTextBorder borderWithFillColor:[UIColor grayColor] cornerRadius:3];
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setColor:[UIColor whiteColor]];
            [highlight setBackgroundBorder:border];
            highlight.tapAction = block;
            if ([cls isEqualToString:@"f"]) {
                [res yy_setStrokeWidth:@(-2) range:innerRange];
            }
            [res yy_setTextHighlight:highlight range:innerRange];
        }
        [res deleteCharactersInRange:NSMakeRange(range.location, 1)];
        [res deleteCharactersInRange:NSMakeRange(pn, 3)];
    }
    
    return [self renderItemNum:res];
}

-(NSMutableAttributedString *)renderItemNum:(NSMutableAttributedString *)text
{
    HH2SearchConfig *config = [HH2SearchConfig sharedConfig];
    NSRange end = [text.string rangeOfString:@"、"];
    if (end.location != NSNotFound && [[text.string substringToIndex:end.location] isPureInt]) {
        [text yy_setColor:config.nColor range:NSMakeRange(0, end.location)];
    }
    return text;
}

-(NSArray *)getFangNameList
{
    return [self getPropertyList:@"fh"];
}

- (NSArray *)getYaoList
{
    return [self getPropertyList:@"u"];
}

- (NSArray *)getPropertyList:(NSString *)property
{
    NSRange range;
    NSRange searchRange = NSMakeRange(0, self.length);
    NSMutableArray<NSString *> *res = [NSMutableArray new];
    while ((range = [self rangeOfString:@"$" options:0 range:searchRange]).location != NSNotFound) {
        NSUInteger loc = NSMaxRange(range);
        searchRange = NSMakeRange(loc, self.length - loc);
        NSString *cls = [self substringWithRange:NSMakeRange(range.location + 1, 1)];
        if ([property containsString:cls]) {
            NSRange end = [self rangeOfString:@"}" options:0 range:searchRange];
            CGFloat startPos = range.location + 3;
            NSString *cut = [self substringWithRange:NSMakeRange(startPos, end.location - startPos)];
            if (![res containsObject:cut]) {
                [res addObject:cut];
            }
        }
        
    }
    return res.count > 0 ? res : nil;
}

- (UIViewController *)getCurController
{
    UIWindow *win = [[UIApplication sharedApplication].delegate window];
    UITabBarController *tab = (UITabBarController *)win.rootViewController;
    UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
    return nav.viewControllers.lastObject;
}

@end
