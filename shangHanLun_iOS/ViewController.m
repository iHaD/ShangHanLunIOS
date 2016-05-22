//
//  ViewController.m
//  shangHanLun
//
//  Created by hh on 14/10/31.
//  Copyright (c) 2014年 hh. All rights reserved.
//

#import "ViewController.h"
#import "helpTableViewController.h"
#import "historyTableViewController.h"
#import "NSString+getAllSubString.h"
#import "noteViewController.h"
#import "HH2SectionData.h"
#import "FangViewController.h"
#import "AppDelegate.h"

// TODO: 芒硝作芒消

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![dataBac isEqual:[DataCache sharedData].itemData]) {
        self.searchBar.placeholder = @"输入关键词（研究对比药证）";
        self.searchBar.backgroundColor = [UIColor clearColor];
        self.searchBar.backgroundImage = [UIImage new];
        self.searchBar.translucent = YES;
        self.searchBar.frame = CGRectMake(0, 0, self.view.width - 120 + 5, 44);
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
        [v addSubview:self.searchBar];
        self.navigationItem.titleView = v;
    }
}

- (void)onClickBack:(id)sender
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITabBarController *tab = (UITabBarController *)app.window.rootViewController;
    UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
    [nav popViewControllerAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [super searchBar:searchBar textDidChange:searchText];
    if ([searchText isPureInt]) {
        __block int num = searchText.intValue;
        num = MIN(num, 398);
        num = MAX(num, 1);
        __block int section = 0;
//        int startSection = config.showContent != ShowAllSongBanShangHan ? 0 : 8;
        __block NSIndexPath *ip;
        [data enumerateObjectsUsingBlock:^(HH2SectionData *obj, NSUInteger idx, BOOL *stop){
//            if (idx < startSection) {
//                return;
//            }
//            int count = (int)obj.data.count;
//            section = (int)idx;
//            if (num < count) {
//                *stop = YES;
//            }else{
//                num -= count;
//            }
            [obj.data enumerateObjectsUsingBlock:^(DataItem * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                if (obj2.ID == num) {
                    *stop = YES;
                    *stop2 = YES;
                    ip = [NSIndexPath indexPathForRow:idx2 inSection:idx];
                }
            }];
        }];
        if (!ip) {
            return;
        }
        NSLog(@"%@",ip);
        if (![self isContentShow]) {
            [self showContent];
        }
        [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (int)getItemNum:(DataItem *)item
{
    NSRange end = [item.text rangeOfString:@"、"];
    if (end.location == NSNotFound) {
        return -1;
    }
    return [item.text substringToIndex:end.location].intValue;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIAlertController *con = [[UIAlertController alloc] init];
    [con addAction:[UIAlertAction actionWithTitle:@"拷贝本条" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UIPasteboard generalPasteboard].string = data[indexPath.section].data[indexPath.row].attributedText.string;
    }]];
    HH2SectionData *secData = data[indexPath.section];
    DataItem *item = secData.data[indexPath.row];
    if (item.ID < 1000) {
        HH2SectionData *secData = data[indexPath.section];
        DataItem *item = secData.data[indexPath.row];
        int index = [self getItemNum:item];
        [con addAction:[UIAlertAction actionWithTitle:@"查看笔记" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            noteViewController *noteVc = [[noteViewController alloc] initWithDataSource:[contentData sharedData].dataNote];
            noteVc.hidesBottomBarWhenPushed = YES;
            noteVc.index = index - 1;
            noteVc.title = [NSString stringWithFormat:@"第%ld条",(long)index];
            [self.navigationController pushViewController:noteVc animated:YES];
        }]];
    }
    if ([self hasSearchText] && ![self.searchBar.text isPureInt]) {
        [con addAction:[self getSeeContext:indexPath]];
    }
    [con addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:con animated:YES completion:nil];
}

@end
