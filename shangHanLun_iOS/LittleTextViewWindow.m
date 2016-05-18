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
    if (app.littleWindowStack.count > 0) {
        LittleWindow *lw = app.littleWindowStack.lastObject;
        if ([DataCache name:lw.searchText isEqualToName:text isFang:NO] && [self isInYaoContext]) {
            _onlyShowRelatedFang = YES;
        }
    }else{
        UIViewController *con = [self getCurController];
        if ([con isKindOfClass:[YaoViewController class]] && [(YaoViewController *)con isContentShow]) {
            _onlyShowRelatedFang = YES;
        }
    }
    [app.littleWindowStack addObject:self];
    
    NSString *right = [DataCache getStandardYaoName:yao];
    
    NSMutableString *strOut = [NSMutableString new];
    NSArray<HH2SectionData *> *fangList = [DataCache getFangListByYaoNameInStandardList:yao];
    for (HH2SectionData *sec in fangList) {
        NSArray<Fang *> *old = (NSArray<Fang *> *)sec.data;
        NSArray<Fang *> *fl_ = [old sortedArrayUsingSelector:@selector(compare:)];
        [strOut appendFormat:@"$m{%@}-$a{含“$v{%@}”凡%ld方：}\r%@",sec.header, right, fl_.count, [self getFangStringList:fl_]];
        [strOut appendString:@"\r\r"];
    }
    [strOut deleteCharactersInRange:NSMakeRange(strOut.length - 2, 2)];
    

    NSMutableAttributedString *text_ = [NSMutableAttributedString new];
    if (!_onlyShowRelatedFang) {
        [text_ appendAttributedString:[self getYaoContent:text]];
        [text_ appendAttributedString:[[NSAttributedString alloc] initWithString:@"\r\r"]];
    }
    [text_ appendAttributedString:[strOut parseText:YES]];
    
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

- (NSString *)getFangStringList:(NSArray<Fang *> *)arr
{
    NSMutableString *strIn = [NSMutableString new];
    [arr enumerateObjectsUsingBlock:^(Fang *obj2, NSUInteger idx2, BOOL *stop2){
        [strIn appendString:[(Fang *)obj2 getFangNameLinkWithYaoWeight:[obj2 valueForKey:@"curYao"]]];
        [strIn appendString:@"，"];
    }];
    return strIn;
}

- (NSMutableAttributedString *)getYaoContent:(NSString *)yaoText
{
    NSMutableAttributedString *target = [DataCache getYaoContentByName:yaoText];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString: @"未查到！"];
    [str yy_setColor:[UIColor redColor] range:NSMakeRange(0, str.length)];
    [str yy_setStrokeWidth:@(-4) range:NSMakeRange(0, str.length)];
    return target ? : str;
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
    [app.littleWindowStack removeObjectAtIndex:app.littleWindowStack.count - 1];
    [self removeFromSuperview];
}

@end
