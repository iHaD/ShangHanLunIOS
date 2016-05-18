//
//  YaoViewController.m
//  shangHanLunTab
//
//  Created by hh on 16/1/16.
//  Copyright © 2016年 hh. All rights reserved.
//

#import "YaoViewController.h"
#import "HH2SearchCell.h"
#import "YYText.h"
#import "AppDelegate.h"

@interface YaoViewController ()

@end

@implementation YaoViewController

- (void)viewDidLoad {
    self.linkClass = LinkClassYao;
    btnTitle = @"查看包含以上药物方剂的相关条文";
    [super viewDidLoad];
}

- (void)onLookRelatedItemsForTheFangList:(id)sender
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableArray<NSString *> *yaoList = [NSMutableArray new];
    [data enumerateObjectsUsingBlock:^(HH2SectionData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.data enumerateObjectsUsingBlock:^(DataItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [yaoList addObject:obj.yaoList.firstObject];
        }];
    }];
    
//    NSMutableArray<NSString *> *fangList = [NSMutableArray new];
//    [app.curFang enumerateObjectsUsingBlock:^(HH2SectionData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj.dataBac enumerateObjectsUsingBlock:^(DataItem * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
//            [yaoList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj3, NSUInteger idx3, BOOL * _Nonnull stop3) {
//                if ([obj2.yaoList containsObject:obj3]) {
//                    [fangList addObject:obj2.fangList.firstObject];
//                    *stop3 = YES;
//                }
//            }];
//        }];
//    }];
//    
//    NSArray<HH2SectionData *> * d = [super searchItemsForFangList:fangList];
//    ViewController *con = [[ViewController alloc] initWithStyle:UITableViewStylePlain data:d];
//    con.bookName = @"伤寒论";
//    con.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:con animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HH2SearchHeaderView *header = [HH2SearchHeaderView new];
    header.section = 0;
    header.delegate = self;
    NSArray<NSString *> *arr = [linksCellContents[[NSIndexPath indexPathForRow:0 inSection:section]].string componentsSeparatedByString:@"，"];
    header.text = [@"" stringByAppendingFormat:@"所有药物列表   凡%d药", (int)(arr.count - 1)];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

@end
