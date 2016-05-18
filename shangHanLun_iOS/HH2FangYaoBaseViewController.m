//
//  HH2FangYaoBaseViewController.m
//  shangHanLunTab
//
//  Created by hh on 16/2/2.
//  Copyright © 2016年 hh. All rights reserved.
//

#import "HH2FangYaoBaseViewController.h"
#import "YYText.h"
#import "HH2SearchCell.h"

@implementation HH2FangYaoBaseViewController
{
    UIView *footerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    linksCellContents = [NSMutableDictionary new];
    linksCellHeights = [NSMutableDictionary new];
    [self refreshLinksCollects];
    
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, self.view.width - 60, 44);
    btn.center = CGPointMake(self.view.width/2, footerView.height/2);
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    btn.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:1 alpha:1];
    btn.layer.cornerRadius = 6;
    [btn addTarget:self action:@selector(onLookRelatedItemsForTheFangList:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn];
    if (data.count > 0) {
        self.tableView.tableFooterView = footerView;
    }
}

- (void)onLookRelatedItemsForTheFangList:(id)sender
{
    // in subClass implement
}

- (void)setData:(NSArray<HH2SectionData *> *)d
{
    [super setData:d];
    if (d.count > 0 && ![self.tableView.tableFooterView isEqual:footerView]) {
        self.tableView.tableFooterView = footerView;
    }
    
    if (!d || d.count == 0) {
        self.tableView.tableFooterView = [UIView new];
    }
}

- (void)setSearchText:(NSString *)searchText
{
    [super setSearchText:searchText];
    [self refreshLinksCollects];
}

- (void)refreshLinksCollects
{
    [data enumerateObjectsUsingBlock:^(HH2SectionData *section, NSUInteger idx, BOOL *stop){
        NSMutableString *str = [NSMutableString new];
        [section.data enumerateObjectsUsingBlock:^(DataItem *obj, NSUInteger idx2, BOOL *stop2){
            [str appendFormat:@"$%@{%@}，",_linkClass == LinkClassYao ? @"u" : @"f", _linkClass == LinkClassYao ? obj.yaoList.firstObject : obj.fangList.firstObject];
        }];
        NSMutableAttributedString *astr = [str parseText:YES];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:idx];
        linksCellContents[indexPath] = astr;
        
        CGFloat _screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat edge = 16;
        CGSize size = CGSizeMake(_screenWidth - edge*2, CGFLOAT_MAX);
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:astr];
        linksCellHeights[indexPath] = @(layout.textBoundingSize.height + 20);
    }];
}

- (void)copyItemsToPastboard:(NSArray<NSIndexPath *> *)arr
{
    if (!isContentOpen) {
        NSMutableString *str = [NSMutableString new];
        [arr enumerateObjectsUsingBlock:^(NSIndexPath *obj, NSUInteger idx, BOOL *stop){
            if (_linkClass == LinkClassFang) {
                [str appendString:obj.section == 0 ? @"伤寒论方\n" : @"金匮要略方\n"];
            }else{
                [str appendString:@"药物列表\n"];
            }
            [str appendString:linksCellContents[obj].string];
            [str appendString:@"\n"];
        }];
        [UIPasteboard generalPasteboard].string = str;
        [self.tableView setEditing:!self.tableView.editing animated:YES];
        [self onCancelThis];
    }else{
        [super copyItemsToPastboard:arr];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isContentOpen) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isContentOpen) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    HH2SearchCell *cell = [[HH2SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.attributedText = linksCellContents[indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (!self.tableView.editing) {
        UIAlertController *con = [[UIAlertController alloc] init];
        [con addAction:[UIAlertAction actionWithTitle:@"拷贝本条" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [UIPasteboard generalPasteboard].string = isContentOpen ? data[indexPath.section].data[indexPath.row].attributedText.string : linksCellContents[indexPath].string;
        }]];
        [con addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:con animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isContentOpen) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return linksCellHeights[indexPath].floatValue;
}

- (void)clickHH2SearchHeaderView:(HH2SearchHeaderView *)view
{
    [super clickHH2SearchHeaderView:view];
    if (!isContentOpen) {
        CGFloat y = self.tableView.contentOffset.y;
        for (int i = 0; i < view.section; i++) {
            y += linksCellHeights[[NSIndexPath indexPathForRow:0 inSection:i]].floatValue;
        }
        self.tableView.contentOffset = CGPointMake(0, y);
    }
}

@end
