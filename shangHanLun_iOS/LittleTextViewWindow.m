//
//  LittleTextViewWindow.m
//  shangHanLunTab
//
//  Created by hh on 16/3/19.
//  Copyright © 2016年 hh. All rights reserved.
//

#import "LittleTextViewWindow.h"
#import "AppDelegate.h"
#import "YYText.h"
#import "HH2ArrowView.h"
#import "YaoViewController.h"
#import "ViewController.h"

@implementation LittleTextViewWindow
{
    YYTextView *yyTextView;
    UIButton *btnCopy;
    UIButton *btnGoto;
    HH2ArrowView *arrow;
}

- (instancetype)initWithShowFromRect:(CGRect)rect searchText:(NSString *)text inAttributedText:(NSAttributedString *)allText range:(NSRange)range
{
    self = [super initWithShowFromRect:rect searchText:text inAttributedText:allText range:range];
    
    NSString *yao = text;
    AppDelegate *app = APP;
//    if (app.littleWindowStack.count > 0) {
//        LittleWindow *lw = app.littleWindowStack.lastObject;
//        NSString *left = app.yaoAliasDict[lw.searchText]?:lw.searchText;
//        NSString *right = app.yaoAliasDict[text]?:text;
//        if ([left isEqualToString:right] && [self isInYaoContext]) {
//            _onlyShowRelatedFang = YES;
//        }
//    }else{
//        UIViewController *con = [self getCurController];
//        if ([con isKindOfClass:[YaoViewController class]] && [(YaoViewController *)con isContentShow]) {
//            _onlyShowRelatedFang = YES;
//        }
//    }
//    [app.littleWindowStack addObject:self];
//    
//    NSDictionary *dict = app.yaoAliasDict;
//    NSString *right = dict[yao] ? : yao;
//    
//    NSMutableString *strOut = [NSMutableString new];
//    [app.curFang enumerateObjectsUsingBlock:^(HH2SectionData *obj, NSUInteger idx, BOOL *stop){
//        NSMutableString *strIn = [NSMutableString new];
//        __block int i = 0;
//        [obj.data enumerateObjectsUsingBlock:^(DataItem *obj2, NSUInteger idx2, BOOL *stop2){
//            [obj2.yaoList enumerateObjectsUsingBlock:^(NSString *obj3, NSUInteger idx3, BOOL *stop3){
//                NSString *left = dict[obj3] ? : obj3;
//                if ([left isEqualToString:right]) {
//                    i++;
//                    *stop3 = YES;
//                    [strIn appendFormat:@"$f{%@}，", obj2.fangList.firstObject];
//                }
//            }];
//        }];
//        if (idx > 0) {
//            [strOut appendString:@"\r\r"];
//        }
//        if (strIn.length > 0) {
//            [strOut appendFormat:@"$m{%@}-$a{含“$v{%@}”凡%d方：}\r%@",obj.header, right, i, strIn];
//        }else{
//            [strOut appendFormat:@"$m{%@}-$a{含“$v{%@}”凡%d方。}",obj.header, right, i];
//        }
//    }];
    NSMutableAttributedString *text_ = [NSMutableAttributedString new];
    if (!_onlyShowRelatedFang) {
        [text_ appendAttributedString:[self getYaoContent:text]];
        [text_ appendAttributedString:[[NSAttributedString alloc] initWithString:@"\r\r"]];
    }
//    [text_ appendAttributedString:[strOut parseText:YES]];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat edge = 16;
    CGFloat width = screenSize.width - 2 * edge;
    CGFloat height = [self getWindowHeight:rect];
    CGSize size = CGSizeMake(width - edge*2, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:text_];
    height = MIN((layout.textBoundingSize.height + 30),height);
    CGFloat y, arrowY;
    HH2Arrow direction;
    
    CGFloat arrowHeight = [HH2ArrowView getDefaultSize].height;
    BOOL isUp = NO;
    if (rect.origin.y + rect.size.height/2 > screenSize.height/2.0) {
        y = rect.origin.y - height - arrowHeight;
        direction = HH2ArrowDown;
        arrowY = y + height;
        isUp = YES;
    }else{
        y = rect.origin.y + rect.size.height + arrowHeight;
        direction = HH2ArrowUp;
        arrowY = y;
    }
    
    yyTextView = [[YYTextView alloc] initWithFrame:CGRectMake(edge, y, width, height)];
    yyTextView.editable = NO;
    
    CGFloat dy = [HH2ArrowView getDefaultSize].height/2;
    dy = direction == HH2ArrowDown ? dy - 1 : -dy + 1;
    arrowY += dy;
    arrow = [self getArrowView:direction atY:arrowY fromRect:rect edge:edge width:width];
    
    yyTextView.backgroundColor = [UIColor whiteColor];
    yyTextView.layer.borderWidth = 0.5;
    yyTextView.layer.cornerRadius = 8;
    CGFloat inset = 15;
    yyTextView.textContainerInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    
    NSMutableAttributedString *str = text_;
    str.yy_lineSpacing = 4;
    str.yy_font = [UIFont systemFontOfSize:17];
    yyTextView.attributedText = str;
    
    btnCopy = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat bWidth = 100;
    CGFloat bHeight = 34;
    btnCopy.frame = CGRectMake(yyTextView.x + yyTextView.width - 8 - bWidth - 4 - bWidth, isUp ? yyTextView.y - bHeight : yyTextView.y + yyTextView.height, bWidth, bHeight);
    [btnCopy setTitle:@"拷贝内容" forState:UIControlStateNormal];
    [btnCopy setTitle:str.string forState:UIControlStateReserved];
    btnCopy.titleLabel.font = [UIFont systemFontOfSize:14];
    btnCopy.layer.cornerRadius = 4;
    btnCopy.backgroundColor = [UIColor blackColor];
    [btnCopy addTarget:self action:@selector(copyTextViewContentToPastboard:) forControlEvents:UIControlEventTouchUpInside];
    
    btnGoto = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGoto.frame = CGRectMake(yyTextView.x + yyTextView.width - 8 - bWidth, isUp ? yyTextView.y - bHeight : yyTextView.y + yyTextView.height, bWidth, bHeight);
    [btnGoto setTitle:@"查看药证条文" forState:UIControlStateNormal];
    [btnGoto setTitle:yao forState:UIControlStateReserved];
    btnGoto.titleLabel.font = [UIFont systemFontOfSize:14];
    btnGoto.layer.cornerRadius = 4;
    btnGoto.backgroundColor = [UIColor blackColor];
    [btnGoto addTarget:self action:@selector(gotoYaoZheng:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btnCopy];
    [self addSubview:btnGoto];
    [self addSubview:yyTextView];
    [self addSubview:arrow];
    
    return self;
}

- (NSMutableAttributedString *)getYaoContent:(NSString *)yaoText
{
//    __block NSMutableAttributedString *target = nil;
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    NSDictionary *dict = app.yaoAliasDict;
//    NSString *right = dict[yaoText] ? : yaoText;
//    [app.yaoData.firstObject.data enumerateObjectsUsingBlock:^(DataItem *obj, NSUInteger idx, BOOL *stop){
//        NSString *left = dict[obj.yaoList.firstObject] ? : obj.yaoList.firstObject;
//        if ([left isEqualToString:right]) {
//            target = obj.attributedText;
//            *stop = YES;
//        }
//    }];
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString: @"未查到！"];
//    [str yy_setColor:[UIColor redColor] range:NSMakeRange(0, str.length)];
//    [str yy_setStrokeWidth:@(-4) range:NSMakeRange(0, str.length)];
//    return target ? : str;
    return nil;
}

- (void)gotoYaoZheng:(UIButton *)btn
{
    NSString *yaoStr = [btn titleForState:UIControlStateReserved];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    HH2SearchViewController *fang = [[ViewController alloc] initWithStyle:UITableViewStylePlain data:[DataCache sharedData].itemData];
    fang.hidesBottomBarWhenPushed = YES;
    fang.showMode = YES;
    fang.searchYaoZheng = yaoStr;
    fang.bookName = @"伤寒论";
    UITabBarController *tab = (UITabBarController *)app.window.rootViewController;
    UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
    [nav pushViewController:fang animated:YES];
    [self onTap:nil];
}

- (void)onTap:(id)sender
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [app.littleWindowStack removeObjectAtIndex:app.littleWindowStack.count - 1];
    [self removeFromSuperview];
}

@end
