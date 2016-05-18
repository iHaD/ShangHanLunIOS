//
//  LittleTableViewWindow.m
//  shangHanLunTab
//
//  Created by hh on 16/3/19.
//  Copyright © 2016年 hh. All rights reserved.
//

#import "LittleTableViewWindow.h"
#import "AppDelegate.h"
#import "YYText.h"
#import "ViewController.h"
#import "FangViewController.h"

@implementation LittleTableViewWindow

- (instancetype)initWithShowFromRect:(CGRect)rect searchText:(NSString *)text inAttributedText:(NSAttributedString *)allText range:(NSRange)range
{
    self = [super initWithShowFromRect:rect searchText:text inAttributedText:allText range:range];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat edge = 16;
    CGFloat width = screenSize.width - 2 * edge;
    CGFloat height = [self getWindowHeight:rect];
    CGFloat y, arrowY;
    HH2Arrow direction;
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DataCache *cache = [DataCache sharedData];
    if (app.littleWindowStack.count > 0) {
        LittleWindow *lw = app.littleWindowStack.lastObject;
        if ([DataCache name:lw.searchText isEqualToName:text isFang:YES] && [self isInFangContext]) {
            _onlyShowRelatedContent = YES;
        }
    }else{
        UIViewController *con = [self getCurController];
        if ([con isKindOfClass:[FangViewController class]] && [(FangViewController *)con isContentShow]) {
            _onlyShowRelatedContent = YES;
        }
    }
    [app.littleWindowStack addObject:self];
    NSMutableArray *arr = [NSMutableArray new];
    NSMutableArray *arrHeight = [NSMutableArray new];
    NSMutableArray *arrHeader = [NSMutableArray new];
    
    __block CGFloat totalHeight = 0;
    NSString *fang = text;
    if (!_onlyShowRelatedContent) {
        [cache.fangData enumerateObjectsUsingBlock:^(HH2SectionData *obj, NSUInteger idx, BOOL *stop){
            __block NSMutableArray *sec = [NSMutableArray new];
            __block NSMutableArray *heights = [NSMutableArray new];
            [obj.data enumerateObjectsUsingBlock:^(DataItem *obj2, NSUInteger idx2, BOOL *stop2){
                if ([DataCache name:fang isEqualToName:obj2.fangList.firstObject isFang:YES]) {
                    [sec addObject:obj2.attributedText];
                    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(width - 2*16, MAXFLOAT) text:sec.lastObject];
                    CGFloat h = layout.textBoundingSize.height + 20;
                    totalHeight += h;
                    [heights addObject:@(h)];
                    
                    totalHeight += 28;
                    [arr addObject:sec];
                    [arrHeight addObject:heights];
                    [arrHeader addObject:obj.header];
                    *stop2 = YES;
                }
            }];
        }];
        
        if (arr.count == 0) {
            totalHeight += 28 + 44;
            [arrHeader addObject:@"伤寒金匮方"];
            [arrHeight addObject:@[@(44)]];
            NSMutableAttributedString *astr = [[NSMutableAttributedString alloc] initWithString:@"未见方。"];
            astr.yy_color = [UIColor redColor];
            astr.yy_font = [UIFont systemFontOfSize:17];
            [astr yy_setStrokeWidth:@(-4) range:NSMakeRange(0, 4)];
            [arr addObject:@[astr]];
        }
    }
    
    [cache.itemData enumerateObjectsUsingBlock:^(HH2SectionData *obj, NSUInteger idx, BOOL *stop){
        if (obj.data.firstObject.ID > 1000) {
            return;
        }
        __block NSMutableArray *sec = nil;// [NSMutableArray new];
        __block NSMutableArray *heights = nil;// [NSMutableArray new];
        [obj.data enumerateObjectsUsingBlock:^(DataItem *obj2, NSUInteger idx2, BOOL *stop2){
            [obj2.fangList enumerateObjectsUsingBlock:^(NSString *obj3, NSUInteger idx3, BOOL *stop3){
                if ([DataCache name:fang isEqualToName:obj3 isFang:YES]) {
                    *stop3 = YES;
                    if (!sec) {
                        sec = [NSMutableArray new];
                        heights = [NSMutableArray new];
                    }
                    //                    [sec addObject:[obj2.text parseText:NO]];
                    [sec addObject:obj2.attributedText];
                    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(width - 2*16, MAXFLOAT) text:sec.lastObject];
                    CGFloat h = layout.textBoundingSize.height + 20;
                    totalHeight += h;
                    [heights addObject:@(h)];
                }
            }];
        }];
        if (sec.count > 0) {
            totalHeight += 28;
            [arr addObject:sec];
            [arrHeight addObject:heights];
            [arrHeader addObject:obj.header];
        }
    }];
    height = MIN(totalHeight, height);
    
    BOOL isUp = NO;
    CGFloat arrowHeight = [HH2ArrowView getDefaultSize].height;
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
    
    UITableView *yyTextView = [[UITableView alloc] initWithFrame:CGRectMake(edge, y, width, height) style:UITableViewStylePlain];
    
    [app.list addObject:arr];
    [app.listHeader addObject:arrHeader];
    [app.heightList addObject:arrHeight];
    yyTextView.dataSource = app;
    yyTextView.delegate = app;
    yyTextView.allowsSelection = NO;
    
    CGFloat dy = [HH2ArrowView getDefaultSize].height/2;
    dy = direction == HH2ArrowDown ? dy - 1 : -dy + 1;
    arrowY += dy;
    HH2ArrowView *arrow = [self getArrowView:direction atY:arrowY fromRect:rect edge:edge width:width];
    
    yyTextView.backgroundColor = [UIColor whiteColor];
    yyTextView.layer.borderWidth = 0.5;
    yyTextView.layer.cornerRadius = 8;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat bWidth = 100;
    CGFloat bHeight = 34;
    btn.frame = CGRectMake(yyTextView.x + yyTextView.width - 8 - bWidth, isUp ? yyTextView.y - bHeight : yyTextView.y + yyTextView.height, bWidth, bHeight);
    [btn setTitle:@"跳转查看条文" forState:UIControlStateNormal];
    [btn setTitle:fang forState:UIControlStateReserved];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.layer.cornerRadius = 4;
    btn.backgroundColor = [UIColor blackColor];
    [btn addTarget:self action:@selector(gotoContent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(yyTextView.x + yyTextView.width - 8 - bWidth - 4 - bWidth, isUp ? yyTextView.y - bHeight : yyTextView.y + yyTextView.height, bWidth, bHeight);
    [btn2 setTitle:@"拷贝内容" forState:UIControlStateNormal];
    [btn2 setTitle:fang forState:UIControlStateReserved];
    btn2.titleLabel.font = [UIFont systemFontOfSize:14];
    btn2.layer.cornerRadius = 4;
    btn2.backgroundColor = [UIColor blackColor];
    [btn2 addTarget:self action:@selector(copyToPastboard:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    [self addSubview:btn2];
    
    [self addSubview:yyTextView];
    [self addSubview:arrow];
    
    return self;
}

- (void)clearData
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.list removeLastObject];
    [app.listHeader removeLastObject];
    [app.heightList removeLastObject];
    [app.littleWindowStack removeObjectAtIndex:app.littleWindowStack.count - 1];
    [self removeFromSuperview];
}

- (void)gotoContent:(UIButton *)btn
{
    NSString *fangStr = [btn titleForState:UIControlStateReserved];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    HH2SearchViewController *fang = [[ViewController alloc] initWithStyle:UITableViewStylePlain data:[DataCache sharedData].itemData];
    fang.hidesBottomBarWhenPushed = YES;
    fang.showMode = YES;
    fang.searchFang = fangStr;
    fang.bookName = @"伤寒论";
    UITabBarController *tab = (UITabBarController *)app.window.rootViewController;
    UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
    [nav pushViewController:fang animated:YES];
    [self clearData];
}

- (void)onTap:(id)sender
{
    [self clearData];
}

- (void)copyToPastboard:(UIButton *)btn
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableString *str = [NSMutableString new];
    [app.list.lastObject enumerateObjectsUsingBlock:^(NSArray<NSAttributedString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [str appendFormat:@"%@\n",app.listHeader.lastObject[idx]];
        [obj enumerateObjectsUsingBlock:^(NSAttributedString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [str appendFormat:@"%@\n",obj.string];
        }];
        [str appendString:@"\n"];
    }];
    [UIPasteboard generalPasteboard].string = str;
    [UIView animateWithDuration:0.3 animations:^{
        btn.frame = CGRectMake(btn.x + btn.width/2, btn.y + btn.height/2, 0, 0);
    } completion:^(BOOL finished) {
        [btn removeFromSuperview];
    }];
}

@end
