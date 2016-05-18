//
//  HH2ShowViewController.h
//  shangHanLunTab
//
//  Created by hh on 15/12/29.
//  Copyright © 2015年 hh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HH2SectionData.h"
#import "HH2SearchConfig.h"

#define HEADER_HEIGHT 49
typedef NS_ENUM(NSUInteger, LinkClass) {
    LinkClassFang = 0,
    LinkClassYao = 1,
};

@interface HH2ShowViewController : UIViewController <HH2SearchHeaderViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
@protected
    HH2SearchConfig *config;
    NSArray<HH2SectionData *> *dataBac;
    NSArray<HH2SectionData *> *data;
    NSMutableSet<NSIndexPath *> *copyList;
    
    int totalNum;
    
    BOOL isContentOpen;
    CGSize screenSize;
}

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic,readonly) NSArray<HH2SectionData *> *dataBac;
@property (strong,nonatomic) NSString *searchText;
@property (strong,nonatomic) NSString *searchFang;
@property (strong,nonatomic) NSString *searchYaoZheng;
@property (strong,nonatomic) NSString *bookName;

- (instancetype)initWithStyle:(UITableViewStyle)style data:(NSArray<HH2SectionData *> *)data;
- (void)resetDataSource:(NSArray<HH2SectionData *> *)d;
// 此2方法用于搜索时自动展开内容
- (BOOL)isContentShow;
- (void)showContent;
- (void)closeContent;

- (NSArray<HH2SectionData *> *)searchItemsForFangList:(NSArray<NSString *> *)fangList;

// 子类覆盖点，必须先[super ...];
- (void)clickHH2SearchHeaderView:(HH2SearchHeaderView *)view;
- (void)setData:(NSArray<HH2SectionData *> *)d;

- (void)copyAllDataToPastboard;
- (void)copyCurrentSectionDataToPastboard:(NSInteger)section;
- (void)copyCurrentRowDataToPastboard:(NSIndexPath *)indexPath;

// 子类覆盖点
- (void)selectAndCopy:(UIBarButtonItem *)item;
- (void)onCancelThis;
- (void)copyItemsToPastboard:(NSArray<NSIndexPath *> *)arr;

- (BOOL)findFang:(NSString *)fang inDataItem:(DataItem *)item;
- (BOOL)findYao:(NSString *)yao inDataItem:(DataItem *)item;

@end
