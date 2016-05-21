//
//  HH2ShowViewController.m
//  shangHanLunTab
//
//  Created by hh on 15/12/29.
//  Copyright © 2015年 hh. All rights reserved.
//

#import "HH2ShowViewController.h"
#import "HH2SearchCell.h"
#import "YYText.h"
#import "AppDelegate.h"



@interface HH2ShowViewController ()
{
    UIView *copyBtns;
    UIView *lastTitleView;
    AppDelegate *app;
}
@end

@implementation HH2ShowViewController
@synthesize dataBac;

- (instancetype)initWithStyle:(UITableViewStyle)style data:(NSArray<HH2SectionData *> *)data_
{
    self = [super init]; //WithStyle:style];
    data = data_;
    dataBac = data_;
    [data enumerateObjectsUsingBlock:^(HH2SectionData *obj, NSUInteger idx, BOOL *stop){
        obj.headerView.section = idx;
    }];
    copyList = [NSMutableSet new];
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    screenSize = [UIScreen mainScreen].bounds.size;
    config = [HH2SearchConfig sharedConfig];
    isContentOpen = config.isContentOpenAtFirst || data.count <= 2 || _searchText.length > 0;
    totalNum = 0;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(selectAndCopy:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    self.tableView.separatorColor = [UIColor darkGrayColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
}

- (void)selectAndCopy:(UIBarButtonItem *)item
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    item.title = self.tableView.editing ? @"取消" : @"选择";
    if (!self.tableView.editing) {
        [self onCancelThis];
    }else{
        if (!copyBtns) {
            CGFloat bHeight = 34;
            CGFloat bWidth = 80;
            copyBtns = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2*bWidth + 8, bHeight)];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, bWidth, bHeight);
            [btn setTitle:@"选择全部" forState:UIControlStateNormal];
            btn.layer.cornerRadius = 6;
            btn.layer.borderWidth = 0.5;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.layer.borderColor = [UIColor whiteColor].CGColor;
            [btn addTarget:self action:@selector(selectAllIndexPath:) forControlEvents:UIControlEventTouchUpInside];
            [copyBtns addSubview:btn];
            
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(bWidth + 8, 0, bWidth, bHeight);
            [btn setTitle:@"拷贝" forState:UIControlStateNormal];
            btn.layer.cornerRadius = 6;
            btn.layer.borderWidth = 0.5;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.layer.borderColor = [UIColor whiteColor].CGColor;
            [btn addTarget:self action:@selector(copySelectedItemToPasteboard) forControlEvents:UIControlEventTouchUpInside];
            [copyBtns addSubview:btn];
        }
        
        lastTitleView = self.navigationItem.titleView;
        self.navigationItem.titleView = copyBtns;
    }
}

- (void)selectAllIndexPath:(UIButton *)btn
{
    BOOL select = [btn.titleLabel.text isEqualToString:@"选择全部"];
    NSString *title = select ? @"反选全部" : @"选择全部";
    [btn setTitle:title forState:UIControlStateNormal];
    for (int i = 0; i < data.count; i++) {
        HH2SectionData *sec = data[i];
        for (int j = 0; j < sec.data.count; j++) {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:j inSection:i];
            select ? [copyList addObject:ip] : [copyList removeObject:ip];
        }
    }
    
    [self.tableView reloadData];
}

- (NSMutableArray<NSIndexPath *> *)getOrderedArrayFromCopyList
{
    NSMutableArray<NSIndexPath *> *arr = [NSMutableArray new];
    [copyList enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        [arr addObject:obj];
    }];
    [arr sortUsingComparator:^NSComparisonResult(NSIndexPath *obj1, NSIndexPath *obj2) {
        if (obj1.section == obj2.section) {
            return obj1.row > obj2.row ? NSOrderedDescending : NSOrderedAscending;
        }else{
            return obj1.section > obj2.section ? NSOrderedDescending : NSOrderedAscending;
        }
        return NSOrderedAscending;
    }];
//    NSLog(@"%@",arr);
    return arr;
}

- (void)copyItemsToPastboard:(NSArray<NSIndexPath *> *)arr
{
    NSMutableString *str = [NSMutableString new];
    [str appendString:self.bookName];
    NSInteger lastSection = -1;
    for (int i = 0; i < arr.count; i++) {
        NSInteger curSection = arr[i].section;
        if (curSection != lastSection) {
            lastSection = curSection;
            if (data[curSection].header) {
                [str appendFormat:@"\n%@", data[curSection].header];
            }
            [str appendString:@"\n"];
        }
        
        [str appendString:data[curSection].data[arr[i].row].attributedText.string];
        [str appendString:@"\n"];
    }
    [UIPasteboard generalPasteboard].string = str;
    [self onCancelThis];
}

- (void)copySelectedItemToPasteboard
{
    NSMutableArray<NSIndexPath *> *arr = [self getOrderedArrayFromCopyList];
    [self copyItemsToPastboard:arr];
}

- (void)onCancelThis
{
    [copyList removeAllObjects];
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem.title = @"选择";
    self.navigationItem.titleView = lastTitleView;
}

- (void)setSearchText:(NSString *)searchText
{
    [copyList removeAllObjects];
    _searchText = searchText;
    self.navigationItem.title = searchText;
    // 没有搜索词，或者搜索词为纯数字时，清除筛选数据
    if (!searchText || searchText.length == 0 || [searchText isPureInt]) {
        [self setData:dataBac];
        [self.tableView reloadData];
        return;
    }
    
    // 有搜索词，进行筛选
    // 先收集多关键字
    NSArray *textArray_ = [searchText componentsSeparatedByString:@" "];
    NSMutableArray *textArray = [NSMutableArray array];
    [textArray_ enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop){
        if (obj.length > 0) {
            [textArray addObject:obj];
        }
    }];
    
    // 从dataBac中进行筛选
    totalNum = 0;
    NSMutableArray *array = [NSMutableArray new];
    [dataBac enumerateObjectsUsingBlock:^(HH2SectionData *obj_, NSUInteger idx_, BOOL *stop_){
        [obj_ resetData];
        __block NSMutableArray<DataItem *> *arr = nil;
        [obj_.data enumerateObjectsUsingBlock:^(DataItem *obj, NSUInteger idx, BOOL *stop){
            BOOL found = YES;
            BOOL exclude = NO;
            DataItem *item = obj;
            for (NSString *sText_ in textArray) {
                // 先判断是否有 - 前缀或后缀
                exclude = NO;
                NSString *sText = sText_.copy;
                if ([sText containsString:@"-"]) {
                    sText = [sText stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    exclude = YES;
                }
                
                // 判断是否含有通配符
                if ([sText containsString:@"#"]) {
                    sText = [sText stringByReplacingOccurrencesOfString:@"#" withString:@"."];
                }
                
                
                BOOL isLink = NO;
                BOOL isFang = NO;
                if ([sText containsString:@"y"]) {
                    isLink = YES;
                    sText = [sText stringByReplacingOccurrencesOfString:@"y" withString:@""];
                    found = [self findYao:sText inDataItem:obj];
                }else if ([sText containsString:@"f"]) {
                    isLink = YES;
                    isFang = YES;
                    sText = [sText stringByReplacingOccurrencesOfString:@"f" withString:@""];
                    found = [self findFang:sText inDataItem:obj];
                }else{
                    found = [obj.attributedText.string rangeOfString:sText options:NSRegularExpressionSearch].location != NSNotFound;
                }
                
                // 如果不匹配发生了一次，即表示不匹配
                // 如此赋值是表示没有找到，继续找～（因为两者相等表示没找到）
                if (found == exclude) {
                    found = exclude;
                    break;
                }
                if(found && !exclude){
                    // 找到则染色
                    if (item == obj) {
                        item = obj.mutableCopy;
                    }
                    
                    if (!isLink) { // 普通的染色
                        // 因为匹配上的所有子串都要染色，需要防止通配符导致全部染色的情况
                        NSRange once = [sText rangeOfString:@"\\.*" options:NSRegularExpressionSearch range:NSMakeRange(0, sText.length)];
                        BOOL onlyOnce = NO;
                        if (once.length == sText.length) {
                            onlyOnce = YES;
                        }
                        
                        NSInteger length = obj.attributedText.string.length;
                        NSRange searchRange = NSMakeRange(0, length);
                        NSRange range;
                        // 对所有匹配的子串进行染色
                        while ((range = [obj.attributedText.string rangeOfString:sText options:NSRegularExpressionSearch range:searchRange]).location != NSNotFound) {
                            if (range.length == 0) {
                                NSUInteger loc = range.location + 1;
                                if (loc >= length) {
                                    break;
                                }
                                searchRange = NSMakeRange(loc, length - loc);
                                continue;
                            }
                            [item.attributedText yy_setColor:[UIColor redColor] range:range];
                            [item.attributedText yy_setStrokeWidth:@(-4) range:range];
                            NSUInteger loc = NSMaxRange(range);
                            searchRange = NSMakeRange(loc, length - loc);
                            
                            if (onlyOnce) {
                                break;
                            }
                        }
                    }else{ // 方药染色专用
                        // 先找出所有链接的range
                        NSMutableArray<NSValue *> *arr = [NSMutableArray new];
                        [obj.attributedText enumerateAttribute:NSUnderlineStyleAttributeName inRange:NSMakeRange(0, obj.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSNumber *value, NSRange range, BOOL * _Nonnull stop) {
                            if (value.integerValue == NSUnderlineStyleSingle) {
                                [arr addObject:[NSValue valueWithRange:range]];
                            }
                        }];
                        
                        NSArray *sNames = [DataCache getAliasStringArrayByName:sText isFang:isFang];
                        
                        // 遍历所有链接以染色。
                        for (NSValue *value in arr) {
                            NSRange range = [value rangeValue];
                            NSString *curStr = [obj.attributedText.string substringWithRange:range];
                            if ([sNames containsObject:curStr]) {
                                [item.attributedText yy_setColor:[UIColor redColor] range:range];
                                [item.attributedText yy_setStrokeWidth:@(-4) range:range];
                            }
                        }
                    }
                }
            }
            // 找到YES必须exclude为NO,反之亦然
            if (found != exclude) {
                if (!arr) {
                    arr = [NSMutableArray new];
                }
                [arr addObject:item];
                totalNum++;
            }
        }];
        if (arr.count > 0) {
            HH2SectionData *d = [[HH2SectionData alloc] initWithData:arr section:obj_.section];
            if (obj_.header) {
                d.header = obj_.header;
                d.headerView = [HH2SearchHeaderView new];
            }
            [array addObject:d];
        }
    }];
    
    [self setData:array];
    [self.tableView reloadData];
}

- (BOOL)findFang:(NSString *)fang inDataItem:(DataItem *)item
{
    return [self findName:fang inDataItem:item isFang:YES];
}

- (BOOL)findYao:(NSString *)yao inDataItem:(DataItem *)item
{
    return [self findName:yao inDataItem:item isFang:NO];
}

- (BOOL)findName:(NSString *)name inDataItem:(DataItem *)item isFang:(BOOL)isFang
{
    NSArray *arr = isFang ? item.fangList : item.yaoList;
    for (NSString *f in arr) {
        if ([DataCache name:f isEqualToName:name isFang:isFang]) {
            return YES;
        }
    }
    return NO;
}

//- (BOOL)findFangOrYao:(NSString *)sText inDataItem:(DataItem *)item cls:(NSString *)cls
//{
//    sText = [sText stringByReplacingOccurrencesOfString:cls withString:@""];
//    return [item containsName:sText isFang:[cls isEqualToString:@"f"]];
//}

// 搜索方药，精确化。无需染色。（本已蓝色）
- (void)setSearchFang:(NSString *)searchFang
{
    _searchText = searchFang;
    self.navigationItem.title = searchFang;
    totalNum = 0;
    NSArray *array = [self searchFangOrYao:LinkClassFang thatContains:searchFang];
    [self setData:array];
    [self.tableView reloadData];
}

// text必须有前缀或后缀f/y
- (NSArray *)searchFangOrYao:(LinkClass)linkCls thatContains:(NSString *)text
{
    BOOL isFang = linkCls == LinkClassFang;
    NSMutableArray *array = [NSMutableArray new];
    [dataBac enumerateObjectsUsingBlock:^(HH2SectionData *obj_, NSUInteger idx_, BOOL *stop_){
        [obj_ resetData];
        __block NSMutableArray<DataItem *> *arr = nil;
        [obj_.data enumerateObjectsUsingBlock:^(DataItem *obj, NSUInteger idx, BOOL *stop){
            NSArray<NSString *> *list = isFang ? obj.fangList : obj.yaoList;
            [list enumerateObjectsUsingBlock:^(NSString *obj2, NSUInteger idx2, BOOL *stop2){
                if ([DataCache name:obj2 isEqualToName:text isFang:isFang]) {
                    if (!arr) {
                        arr = [NSMutableArray new];
                    }
                    [arr addObject:obj];
                    *stop2 = YES;
                }
            }];
        }];
        if (arr) {
            HH2SectionData *d = [[HH2SectionData alloc] initWithData:arr section:obj_.section];
            if (obj_.header) {
                d.header = obj_.header;
                d.headerView = [HH2SearchHeaderView new];
            }
            [array addObject:d];
        }
    }];
    return array;
}

- (NSString *)searchFang
{
    return _searchText;
}

- (NSString *)searchYaoZheng
{
    return _searchText;
}

- (NSArray<HH2SectionData *> *)searchItemsForFangList:(NSArray<NSString *> *)fangList
{
    NSMutableArray *array = [NSMutableArray new];
    [[DataCache sharedData].itemData enumerateObjectsUsingBlock:^(HH2SectionData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block NSMutableArray<DataItem *> *arr = nil;
        [obj.data enumerateObjectsUsingBlock:^(DataItem * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
            [obj2.fangList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj3, NSUInteger idx3, BOOL * _Nonnull stop3) {
                [fangList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj4, NSUInteger idx4, BOOL * _Nonnull stop4) {
                    if ([DataCache name:obj3 isEqualToName:obj4 isFang:YES]) {
                        if (!arr) {
                            arr = [NSMutableArray new];
                        }
                        [arr addObject:obj2];
                        *stop3 = YES;
                        *stop4 = YES;
                    }
                }];
            }];
        }];
        if (arr) {
            HH2SectionData *d = [[HH2SectionData alloc] initWithData:arr section:obj.section];
            if (obj.header) {
                d.header = obj.header;
                d.headerView = [HH2SearchHeaderView new];
            }
            [array addObject:d];
        }
    }];
    
    return array;
}

- (void)setSearchYaoZheng:(NSString *)searchYaoZheng
{
    _searchText = searchYaoZheng;
    self.navigationItem.title = [NSString stringWithFormat:@"%@药证",searchYaoZheng];
    
    NSMutableArray<NSString *> *fangList = [NSMutableArray new];
    [[DataCache sharedData].fangData enumerateObjectsUsingBlock:^(HH2SectionData *obj, NSUInteger idx, BOOL *stop){
        [obj.data enumerateObjectsUsingBlock:^(DataItem *obj2, NSUInteger idx2, BOOL *stop2){
            [obj2.yaoList enumerateObjectsUsingBlock:^(NSString *obj3, NSUInteger idx3, BOOL *stop3){
                if ([DataCache name:obj3 isEqualToName:searchYaoZheng isFang:NO]) {
                    [fangList addObject:obj2.fangList.firstObject];
                    *stop3 = YES;
                }
            }];
        }];
    }];
    
    [self setData:[self searchItemsForFangList:fangList]];
    [self.tableView reloadData];
}

- (void)setData:(NSArray<HH2SectionData *> *)d
{
    data = d;
    [data enumerateObjectsUsingBlock:^(HH2SectionData *obj, NSUInteger idx, BOOL *stop){
        obj.headerView.section = idx;
    }];
}

- (void)resetDataSource:(NSArray<HH2SectionData *> *)d
{
    if ([data isEqual:d]) {
        return;
    }
    data = d;
    dataBac = d;
    [data enumerateObjectsUsingBlock:^(HH2SectionData *obj, NSUInteger idx, BOOL *stop){
        obj.headerView.section = idx;
    }];
    if (data.count <= 10) {
        [self showContent];
    }else{
        [self closeContent];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HH2SectionData *sd = data[section];
    return dataBac.count == 1 ? sd.data.count : (isContentOpen ? sd.data.count : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuse = [self.description stringByAppendingString:@"cellReuse"];
    HH2SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[HH2SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    HH2SectionData *sectionData = data[indexPath.section];
    NSMutableAttributedString *astr = sectionData.data[indexPath.row].attributedText;
    cell.attributedText = astr;
    
    BOOL selected = [copyList containsObject:indexPath];
    if (selected) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return data[indexPath.section].data[indexPath.row].height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HH2SectionData *sectionData = data[section];
    HH2SearchHeaderView *header = sectionData.headerView;
    header.delegate = self;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

#pragma mark - HH2SearchHeaderViewDelegate
- (void)clickHH2SearchHeaderView:(HH2SearchHeaderView *)view
{
    isContentOpen = !isContentOpen;
    CGRect rect = view.frame;
    CGFloat offsetY = rect.origin.y - self.tableView.contentOffset.y;
    
    [self.tableView reloadData];
    CGFloat height = 0;
    if (isContentOpen) {
        for (int i = 0; i < view.section; i++) {
            height += [self.tableView rectForSection:i].size.height;
        }
        self.tableView.contentOffset = CGPointMake(0, height - offsetY);
    }else{
        height = view.section * HEADER_HEIGHT;
        self.tableView.contentOffset = CGPointMake(0, height - offsetY);
    }
}

- (void)longPressSearchHeaderView:(HH2SearchHeaderView *)view
{
    if (!self.tableView.editing) {
        return;
    }
    NSInteger section = view.section;
    __block BOOL hasSelect = NO;
    [copyList enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.section == section) {
            hasSelect = YES;
            *stop = YES;
        }
    }];
    
    NSInteger count = data[section].data.count;
    for (int i = 0; i < count; i++) {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:section];
        if (hasSelect) {
            [copyList removeObject:ip];
        }else{
            [copyList addObject:ip];
        }
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selected = YES;
        [copyList addObject:indexPath];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selected = NO;
        [copyList removeObject:indexPath];
    }
}

- (BOOL)isContentShow
{
    return isContentOpen;
}

- (void)showContent
{
    isContentOpen = YES;
    [self.tableView reloadData];
}

- (void)closeContent
{
    isContentOpen = NO;
    [self.tableView reloadData];
}

#pragma mark - UIPasteboard
- (NSMutableString *)getHeaderStringForPaste
{
    NSMutableString *str = [NSMutableString new];
    [str appendString:self.bookName];
    if (self.searchText && self.searchText.length > 0) {
        [str appendFormat:@" 搜索“%@“结果：", self.searchText];
    }
    [str appendString:@"\n"];
    return str;
}

- (void)processPrintString:(NSMutableString *)str ofSection:(HH2SectionData *)sec
{
    [sec.data enumerateObjectsUsingBlock:^(DataItem *item, NSUInteger idx2, BOOL *stop2){
        [str appendString:item.attributedText.string];
        [str appendString:@"\n"];
    }];
}

- (void)copyAllDataToPastboard
{
    NSMutableString *str = [self getHeaderStringForPaste];
    [data enumerateObjectsUsingBlock:^(HH2SectionData *obj, NSUInteger idx, BOOL *stop){
        if (dataBac.count > 1) {
            [str appendFormat:@"\n%@\n", obj.header];
        }
        [self processPrintString:str ofSection:obj];
    }];
    [UIPasteboard generalPasteboard].string = str;
}

- (void)copyCurrentSectionDataToPastboard:(NSInteger)section
{
    NSMutableString *str = [self getHeaderStringForPaste];
    HH2SectionData *sec = data[section];
    if (dataBac.count > 1) {
        [str appendFormat:@"\n%@\n", sec.header];
    }
    [self processPrintString:str ofSection:sec];
    [UIPasteboard generalPasteboard].string = str;
}

- (void)copyCurrentRowDataToPastboard:(NSIndexPath *)indexPath
{
    DataItem *item = data[indexPath.section].data[indexPath.row];
    [UIPasteboard generalPasteboard].string = item.attributedText.string;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
