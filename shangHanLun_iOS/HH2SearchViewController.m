//
//  HH2SearchViewController.m
//  shangHanLunTab
//
//  Created by hh on 15/12/3.
//  Copyright © 2015年 hh. All rights reserved.
//

#import "HH2SearchViewController.h"
#import "HH2SearchCell.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "TipsView.h"
#import "TranlucentToolbar.h"

#define HEADER_HEIGHT 49

@interface HH2SearchViewController () 
{
    NSString *lastSearchWords;
    CGPoint lastContentOffset;
    
    TipsView *tipsView;
    UIButton *btnBack;
}
@end

@implementation HH2SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_showMode) {
        self.searchBar = [[HH2SearchBar alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 44)];
        self.searchBar.delegate = self;
        self.searchBar.tintColor = [UIColor blackColor];
        self.navigationItem.titleView = _searchBar;
        TranlucentToolbar *tb = [[TranlucentToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
        tb.tintColor = [UIColor redColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 50, 30);
        [btn setImage:[UIImage imageNamed:@"IMG_1388@2x.PNG"] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        btn.layer.cornerRadius = 6;
        btn.layer.borderWidth = 0.5;
        [btn addTarget:self action:@selector(inputComplete:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *finish = [[UIBarButtonItem alloc] initWithCustomView:btn];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        tb.items = @[space, finish];
        _searchBar.inputAccessoryView = tb;
    }
    
    tipsView = [[TipsView alloc] initWithFrame:CGRectMake(16, 64, self.view.frame.size.width - 32, 240)];
    tipsView.con = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    if (btnBack.superview) {
        [self onBack:btnBack];
    }
}

-(void)inputComplete:(id)sender
{
    [_searchBar resignFirstResponder];
}

-(void)clearBar
{
    _searchBar.text = @"";
    [self searchBar:_searchBar textDidChange:@""];
}

- (void) changeContentViewPoint:(NSNotification *)notification
{
    // 如果已经获得提示框最大高度，就返回。
//    if (_maxInputTipsHeight > 10) {
//        return;
//    }
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
//    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];        // 添加移动动画，使视图跟随键盘移动
    
    _maxInputTipsHeight = keyBoardEndY - 64 - 8;
    _maxInputTipsHeight = MIN((self.view.height - 64 - 49 - 8), _maxInputTipsHeight);
    
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat height = tipsView.curContentHeight;
        tipsView.height = MIN(height, _maxInputTipsHeight);
    }];
}

#pragma mark - UISearchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchText = searchText;
    _searchBar.howMany = self->totalNum;
    
    NSString *last = searchText;
    if ([last containsString:@" "]) {
        last = [last componentsSeparatedByString:@" "].lastObject;
    }
    
    BOOL hasLinks = [last containsString:@"y"] || [last containsString:@"f"];
    
    if (searchText.length == 0 || !hasLinks) {
        [tipsView removeFromSuperview];
        return;
    }
    
    if (hasLinks) {
        tipsView.linkClass = [last containsString:@"y"] ? LinkClassYao : LinkClassFang;
        tipsView.curSearchText = searchText;
    }
}

- (BOOL)hasSearchText
{
    return self.searchText && self.searchText.length > 0;
}

- (void)clickHH2SearchHeaderView:(HH2SearchHeaderView *)view
{
    [super clickHH2SearchHeaderView:view];
    [self.searchBar resignFirstResponder];
}

// 以下部分暂不成熟，待以后成熟再用。
- (UIAlertAction *)getSeeContext:(NSIndexPath *)indexPath
{
    UITableView *tableView = self.tableView;
    return [UIAlertAction actionWithTitle:@"查看此条上下文" style:UIAlertActionStyleDefault handler:^(UIAlertAction *act){
        CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
        //            rect = [self.view convertRect:rect toView:self.view.window];
        CGFloat top = rect.origin.y - tableView.contentOffset.y;
        CGFloat height = HEADER_HEIGHT;
        NSIndexPath *ip = data[indexPath.section].data[indexPath.row].indexPath;
        NSInteger section = ip.section;
        NSInteger row = ip.row;
        
        lastSearchWords = self.searchBar.text ? : self.searchText;
        lastContentOffset = tableView.contentOffset;

        [self clearBar];
        [self showContent];
        self.navigationItem.title = @"全文";
        
        for (int i = 0; i < section; i++) {
            height += [self.tableView rectForSection:i].size.height;
        }
        for (int i = 0; i < row; i++) {
            height += [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section]].size.height;
        }
        self.tableView.contentOffset = CGPointMake(0, height - top);
        
        CGFloat bHeight = 34;
        UIView *wrapper = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100, 64 + (HEADER_HEIGHT - bHeight)/2, 100, bHeight)];
        wrapper.layer.cornerRadius = 8;
        wrapper.clipsToBounds = YES;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 1, bHeight)];
        line.backgroundColor = [UIColor whiteColor];
        
        btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnBack setTitle:@"后退" forState:UIControlStateNormal];
        [btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnBack setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        btnBack.backgroundColor = [UIColor blackColor];
        btnBack.frame = CGRectMake(0, 0, 50, bHeight);
        btnBack.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnBack addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnCancel setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        btnCancel.backgroundColor = [UIColor blackColor];
        btnCancel.frame = CGRectMake(50, 0, 50, bHeight);
        btnCancel.titleLabel.font = btnBack.titleLabel.font;
        [btnCancel addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
        
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [wrapper addSubview:btnBack];
        [wrapper addSubview:btnCancel];
        [wrapper addSubview:line];
        [app.window addSubview:wrapper];
    }];
}

- (void)onCancel:(UIButton *)btn
{
    [self clearBtns:btn];
}

- (void)onBack:(UIButton *)btn
{
    self.searchBar.text = lastSearchWords;
    self.searchText = lastSearchWords;
    if (_showMode) {
        self.navigationItem.title = lastSearchWords;
    }
    self.tableView.contentOffset = lastContentOffset;
    [self clearBtns:btn];
}

- (void)clearBtns:(UIButton *)btn
{
    for (UIView *view in btn.superview.subviews) {
        [view removeFromSuperview];
    }
    [btn.superview removeFromSuperview];
}

- (void)resetDataSource:(NSArray<HH2SectionData *> *)d
{
    [super resetDataSource:d];
    _searchBar.text = @"";
    [self searchBar:_searchBar textDidChange:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    // TODO: 持久化一些参数
}

@end
