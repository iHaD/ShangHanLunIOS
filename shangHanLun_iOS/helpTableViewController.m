//
//  helpTableViewController.m
//  shangHanLun
//
//  Created by hh on 14/11/2.
//  Copyright (c) 2014年 hh. All rights reserved.
//

#import "helpTableViewController.h"
#import "ViewController.h"
#import "NSString+getAllSubString.h"
#import "AppDelegate.h"
#import "YYText.h"
#import "HelpContentViewController.h"
#import <MessageUI/MessageUI.h>


@interface FileItem : NSObject <UIActivityItemSource>
@property (strong, nonatomic) NSData *data;
@end

@implementation FileItem

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return self.data;
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    return self.data;
}

@end

@interface helpTableViewController () <MFMailComposeViewControllerDelegate>
{
    NSArray *_dataToShow;
    NSArray *_header;
    NSInteger _mailRow;
    UISlider *_slider;
    UILabel *_example;
    UIFont *_font;
    UIActivityIndicatorView *av;
}
@end

@implementation helpTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(copyOut:)];
    
    _dataToShow = @[@[@""],
                    @[@"不显示伤寒论",
                      @"只显示398条",
                      @"显示完整宋板伤寒论",
                      ],
                    @[@"不显示金匮要略",
                      @"显示默认版金匮要略"
                        ],
                    @[@"使用邮件导出原有笔记"],
                    @[@"使用帮助"],
                    @[@"欢迎进QQ群",
                      @"官网",
                      @"留下评论",
                      @"请与我联系"
                        ],
                    ];
    _header = @[
                @"拖动滑块调整查阅界面字体大小",
                @"关于伤寒论内容",
                @"关于金匮要略内容",
                @"关于原有笔记内容",
                @"关于搜索:",
                @"欢迎联系",
                ];
    _mailRow = 3;
    
    [self initExampleLabel];
}

- (void)copyOut:(id)sender
{
    FileItem *item = [FileItem new];
    item.data = [NSData dataWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingString:@"data.plist"]];
    UIActivityViewController *con = [[UIActivityViewController alloc] initWithActivityItems:@[item] applicationActivities:nil];
    [self presentViewController:con animated:YES completion:nil];
}

-(void)initExampleLabel
{
    _example = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 49)];
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat width = 90.0;
    _example = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - width, 0, width, 44)];
    _example.textAlignment = NSTextAlignmentLeft;
    _example.textColor = [UIColor darkGrayColor];
    _example.text = @"文字大小";
    [self.tableView addSubview:_example];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataToShow.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataToShow[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];

    cell.textLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _dataToShow[indexPath.section][indexPath.row];
    
    if (indexPath.section == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        HH2SearchConfig *config = [HH2SearchConfig sharedConfig];
        if (indexPath.row == config.showShangHan) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    if (indexPath.section == 2) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        HH2SearchConfig *config = [HH2SearchConfig sharedConfig];
        if (indexPath.row == config.showJinKui) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    if (indexPath.section == 4 || indexPath.section == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    if (indexPath.section == 5) {
        cell.detailTextLabel.text = @[@"464024993", @"http://www.huanghai.me", @"评论", @"23891995@qq.com"][indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        if (indexPath.row == _mailRow) {
            cell.backgroundColor = [UIColor colorWithRed:0 green:0.9 blue:0 alpha:0.2];
        }
    }
    
    if(indexPath.section == 0){
        CGFloat sWidth = self.view.frame.size.width - 100.0;
        _slider = [[UISlider alloc] initWithFrame:CGRectMake((self.view.frame.size.width - sWidth) / 2.0, 1, sWidth, 44)];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        _slider.value = [def objectForKey:@"sliderValue"] ? [[def objectForKey:@"sliderValue"] floatValue] : 0.5;
        _slider.continuous = NO;
        [_slider addTarget:self action:@selector(fontSizeChanged:) forControlEvents:UIControlEventValueChanged];
        UIView *v[5];
        for (int i = 0; i < 5; i++) {
            v[i] = [[UIView alloc] initWithFrame:CGRectMake(i/4.0 * sWidth, 16.5, 1, 11)];
            v[i].layer.borderWidth = 0.5;
            v[i].layer.borderColor = [UIColor grayColor].CGColor;
            [_slider addSubview:v[i]];
        }
        v[0].center = CGPointMake(2.5, 22.0);
        v[4].center = CGPointMake(sWidth - 2.5, 22.0);
        
        UILabel *a = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 30, 44)];
        a.textAlignment = NSTextAlignmentCenter;
        a.font = [UIFont fontWithName:a.font.fontName size:14.0];
        NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:@"A"];
        [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, 1)];
        a.attributedText = aStr;
        UILabel *A = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 45, 0, 30, 44)];
        A.textAlignment = NSTextAlignmentCenter;
        A.font = [UIFont fontWithName:A.font.fontName size:24.0];
        A.attributedText = aStr;
        [cell.contentView addSubview:a];
        [cell.contentView addSubview:_slider];
        [cell.contentView addSubview:A];
    }

    return cell;
}

-(void)fontSizeChanged:(UISlider *)slider
{
    CGFloat size = 0;
    if (slider.value < 0.125) {
        size = 13.0;
        [slider setValue:0 animated:YES];
    }else if(slider.value < 0.375){
        size = 15.0;
        [slider setValue:0.25 animated:YES];
    }else if(slider.value < 0.625){
        size = 17.0;
        [slider setValue:0.5 animated:YES];
    }else if(slider.value < 0.875){
        size = 19.0;
        [slider setValue:0.80 animated:YES];
    }else{
        size = 21.0;
        [slider setValue:1.0 animated:YES];
    }
    UIFont *font = [HH2SearchConfig sharedConfig].font;
    font = [UIFont fontWithName:font.fontName size:size];
    [HH2SearchConfig sharedConfig].font = font;
    
    DataCache *cache = [DataCache sharedData];
    for (NSArray<HH2SectionData *> *obj in @[cache.itemData, cache.fangData, cache.yaoData]) {
        [obj enumerateObjectsUsingBlock:^(HH2SectionData *obj, NSUInteger idx, BOOL *stop){
            [obj refreshShow];
        }];
    }
    
    for (UINavigationController *nav in self.tabBarController.viewControllers) {
        for (UIViewController *con in nav.viewControllers) {
            if ([con isKindOfClass:[HH2ShowViewController class]]) {
                [((UITableViewController *)con).tableView reloadData];
            }
        }
    }
    
    _example.font = font;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@(slider.value) forKey:@"sliderValue"];
    [def synchronize];
}

- (void)toggleContent
{
    if (!av) {
        av = [UIActivityIndicatorView new];
        av.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        av.center = CGPointMake(self.view.width/2, self.view.window.height/2 - 20);
        [self.view addSubview:av];
    }
    [av startAnimating];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[DataCache sharedData] refreshShowType];
        [av stopAnimating];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)] withRowAnimation:UITableViewRowAnimationAutomatic];
    });
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _header[section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 5) {
        if (indexPath.row == _mailRow) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://23891995@qq.com"]];
            if ([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *con = [[MFMailComposeViewController alloc] init];
                con.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
                con.mailComposeDelegate = self;
                con.navigationBar.tintColor = [UIColor whiteColor];
                [con setSubject:@"伤寒论查阅的问题"];
                [con setToRecipients:@[@"23891995@qq.com"]];
                [self presentViewController:con animated:YES completion:nil];
            }
        }
        if (indexPath.row == 2) {
            NSString *urlString = @"http://itunes.apple.com/us/app/id955298695";
            NSURL *url = [NSURL URLWithString:urlString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }else if (indexPath.section == 4){
        HelpContentViewController *con = [HelpContentViewController new];
        [self.navigationController pushViewController:con animated:YES];
    }else if (indexPath.section == 3){
        NSString *str = @"";//[[contentData sharedData] getNotesString];
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *con = [[MFMailComposeViewController alloc] init];
            con.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
            con.mailComposeDelegate = self;
            con.navigationBar.tintColor = [UIColor whiteColor];
            [con setSubject:@"伤寒论398条笔记"];
            [con setMessageBody:str isHTML:NO];
            [self presentViewController:con animated:YES completion:nil];
        }else{
            SHOW_ALERT(@"您的设备不支持发送邮件，抱歉。已将笔记内容复制到剪贴板，请到备忘录或者其他app中自行粘贴查看。");
            [UIPasteboard generalPasteboard].string = str;
        }
    }else if (indexPath.section == 1 || indexPath.section == 2){
        HH2SearchConfig *config = [HH2SearchConfig sharedConfig];
        if (indexPath.section == 1) {
            config.showShangHan = indexPath.row;
        }else{
            config.showJinKui = indexPath.row;
        }
        [self toggleContent];
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 5 && indexPath.row < 2) {
        return YES;
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)) {
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        if (indexPath.row < 2) {
            pb.string = @[@"464024993", @"http://www.huanghai.me"][indexPath.row];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 6.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 32.0;
    }else if(section == 0){
        return 44.0;
    }
        return -1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.section != 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat edge = screenWidth > 400.0 ? 20.0 : 16.0;
        height = [_dataToShow[indexPath.section][indexPath.row] textHeightWithFontSize:cell.textLabel.font width:screenWidth - edge * 2];
        height += 20.0;
    }else
        height = 46.0;
        
    return height;
}

@end
