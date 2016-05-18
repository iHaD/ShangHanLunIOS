//
//  historyTableViewController.m
//  shangHanLunTab
//
//  Created by hh on 14/11/7.
//  Copyright (c) 2014年 hh. All rights reserved.
//

#import "historyTableViewController.h"
#import "AppDelegate.h"
#import "NSString+getAllSubString.h"
#import "noteViewController.h"

@interface historyTableViewController ()<UIActionSheetDelegate>
{
    NSDateFormatter *_dateFormatter;
    CGFloat _screenWidth;
    NSString *_dictArrayFile;
    NSArray<HH2SectionData *> *data;
}

@end

@implementation historyTableViewController

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"YYYY/M/dd - HH:mm:ss"];
    
    _screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    [self initFilePath];
    [self readData];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"疑问条文";
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    data = [DataCache sharedData].itemData;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"排序" style:UIBarButtonItemStylePlain target:self action:@selector(doSort:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(doClose:)];
    self.tableView.separatorColor = [UIColor darkGrayColor];
    [self initFooterView];
}

- (void)doClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self sortDataWithKey:kDate ascending:NO];
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveData];
}

-(void)initFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, 0.5)];
    view.backgroundColor = [UIColor clearColor];
    CGFloat xOffSet = _screenWidth < 400.0 ? 16.0 : 20.0;
    UIView *viewIn = [[UIView alloc] initWithFrame:CGRectMake(xOffSet, 0, _screenWidth - xOffSet, 0.5)];
    viewIn.layer.borderWidth = 0.25;
    viewIn.layer.borderColor = [UIColor grayColor].CGColor;
    [view addSubview:viewIn];
    self.tableView.tableFooterView = view;
}

#pragma mark - read and save with file
-(void)initFilePath
{
    NSArray *filePathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    _dictArrayFile = [[filePathArray objectAtIndex:0] stringByAppendingPathComponent:DICTFILE];
}
-(void)readData
{
    _dictArray = [[NSMutableArray alloc] initWithContentsOfFile:_dictArrayFile];
    if (_dictArray == nil) {
        _dictArray = [[NSMutableArray alloc] init];
    }
}

-(void)saveData
{
    [_dictArray writeToFile:_dictArrayFile atomically:YES];
}

-(void)addNewNote:(int)index
{
    NSMutableDictionary *thisDict = [self hasIndex:index];
    NSDate *now = [NSDate date];
    if(thisDict != nil){
        [thisDict setObject:now forKey:kDate];
    }else{
        NSDictionary *tmp = @{
                              kIndex : [NSNumber numberWithInt:index],
                              kDate : now
                              };
        [_dictArray insertObject:tmp.mutableCopy atIndex:0];
    }
    [self.tableView reloadData];
}

-(NSMutableDictionary *)hasIndex:(int)index
{
    for (NSMutableDictionary *dict in _dictArray) {
        if ([[dict objectForKey:kIndex] integerValue] == index) {
            return dict;
        }
    }
    return nil;
}

#pragma mark - sort
-(void)sortDataWithKey:(NSString *)key ascending:(BOOL)up
{
    NSUInteger count = _dictArray.count;
    NSMutableArray *tmp = [contentData sharedData].dataNote;
    for (int i = 0; i < count; i++) {
        int index = [_dictArray[i][kIndex] intValue];
        _dictArray[i][kDate] = tmp[index][kDate];
    }
    NSSortDescriptor *sortDes = [[NSSortDescriptor alloc] initWithKey:key ascending:up];
    NSArray *sorts = [[NSArray alloc] initWithObjects:&sortDes count:1];
    _dictArray = [_dictArray sortedArrayUsingDescriptors:sorts].mutableCopy;
}

-(void)doSort:(id)sender
{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"按日期降序(推荐)",@"按日期升序",@"按条目降序",@"按条目升序", nil];
    [as showInView:self.view];
}

#pragma mark - ActionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex > 3) {
        return;
    }
    NSArray *keys = @[kDate, kDate, kIndex, kIndex];
    NSArray *up = @[@NO, @YES, @NO, @YES];
    [self sortDataWithKey:keys[buttonIndex] ascending:[up[buttonIndex] boolValue]];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _dictArray.count > 0 ? _dictArray.count : 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"problemCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"problemCell"];
    }
    cell.textLabel.numberOfLines = 0;
    // Configure the cell...
    if(_dictArray.count > 0){
        cell.textLabel.numberOfLines = 0;
        NSInteger indexTmp = [[_dictArray[indexPath.row] objectForKey:kIndex] intValue];
        //NSLog(@"indexTmp:%d",indexTmp);
        //[contentData sharedData].dataNote[indexTmp][kNote] = _dictArray[indexPath.row][kNote];
        __block NSInteger num = indexTmp;
        __block int section = 0;
        [data enumerateObjectsUsingBlock:^(HH2SectionData *obj, NSUInteger idx, BOOL *stop){
            int count = (int)obj.data.count;
            section = (int)idx;
            if (num < count) {
                *stop = YES;
            }else{
                num -= count;
            }
        }];
        NSString *iText = data[section].data[num].attributedText.string;
        NSString *text = [NSString stringWithFormat:@"%@\n%@",[_dateFormatter stringFromDate:[[contentData sharedData].dataNote[indexTmp] objectForKey:kDate]],iText];
        NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:text];
        [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [text rangeOfString:@"\n"].location)];
        cell.textLabel.attributedText = aStr.copy;

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0 alpha:0.3];
    }else
        cell.textLabel.text = @"暂无纪录。";
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dictArray.count == 0) {
        return 44.0;
    }
    CGFloat edge = _screenWidth > 400.0 ? 20.0 : 16.0;
    CGFloat extra = _screenWidth > 400.0 ? 18.0 : 19.0;
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    __block NSInteger num = [[_dictArray[indexPath.row] objectForKey:kIndex] intValue];
    __block int section = 0;
    [data enumerateObjectsUsingBlock:^(HH2SectionData *obj, NSUInteger idx, BOOL *stop){
        int count = (int)obj.data.count;
        section = (int)idx;
        if (num < count) {
            *stop = YES;
        }else{
            num -= count;
        }
    }];
    NSString *iText = data[section].data[num].attributedText.string;
    NSString *text = [NSString stringWithFormat:@"%@\n%@",[_dateFormatter stringFromDate:[[contentData sharedData].dataNote[[iText getInt]] objectForKey:kDate]],iText];
    CGFloat height = [text textHeightWithFontSize:cell.textLabel.font width:_screenWidth - edge * 2 - extra];
    return height + 20.0;
}

#pragma mark - tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    noteViewController *noteView = [[noteViewController alloc] initWithDataSource:[contentData sharedData].dataNote];
    noteView.navigationItem.title = @"疑问笔记与心得";
    noteView.index = [_dictArray[indexPath.row][kIndex] integerValue];
    [self.navigationController pushViewController:noteView animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (_dictArray.count <= 1) {
        return NO;
    }
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dictArray.count == 0) {
        return;
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [_dictArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UIMenu and copy
/*
-(void)copyCellContent:(long)index
{
    [UIPasteboard generalPasteboard].string = [contentData sharedData].data[[[_dictArray[index] objectForKey:kIndex] intValue]];
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)) {
        return YES;
    }
    return  NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)) {
        [self copyCellContent:indexPath.row];
    }
}
*/

@end
