//
//  FangViewController.m
//  shangHanLunTab
//
//  Created by hh on 15/12/3.
//  Copyright © 2015年 hh. All rights reserved.
//

#import "FangViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "HH2SearchCell.h"
#import "YYText.h"

@interface FangViewController ()
{
    UIView *footerView;
}
@end

@implementation FangViewController

- (void)viewDidLoad {
    self.linkClass = LinkClassFang;
    btnTitle = @"查看以上所有方的相关条文";
    [super viewDidLoad];
}

- (void)onLookRelatedItemsForTheFangList:(id)sender
{
    NSMutableArray<NSString *> *fangList = [NSMutableArray new];
    [data enumerateObjectsUsingBlock:^(HH2SectionData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.data enumerateObjectsUsingBlock:^(DataItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [fangList addObject:obj.fangList.firstObject];
        }];
    }];
    NSArray<HH2SectionData *> * d = [super searchItemsForFangList:fangList];
    ViewController *con = [[ViewController alloc] initWithStyle:UITableViewStylePlain data:d];
    con.bookName = @"伤寒论";
    con.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:con animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HH2SearchHeaderView *view = (HH2SearchHeaderView *)[super tableView:tableView viewForHeaderInSection:section];
    NSArray *arr = [linksCellContents[[NSIndexPath indexPathForRow:0 inSection:section]].string componentsSeparatedByString:@"，"];
    NSString *text = [view.text substringToIndex:MIN(view.text.length,[view.text rangeOfString:@" "].location)];
    view.text = [text stringByAppendingFormat:@"    凡%d方", (int)(arr.count - 1)];
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
