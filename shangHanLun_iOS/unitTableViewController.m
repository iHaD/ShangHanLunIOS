//
//  unitTableViewController.m
//  shangHanLunTab
//
//  Created by hh on 14/11/9.
//  Copyright (c) 2014年 hh. All rights reserved.
//

#import "unitTableViewController.h"
#import "historyTableViewController.h"

@interface unitTableViewController ()
{
    NSArray *_data;
    NSArray *_header;
}
@end

@implementation unitTableViewController

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    _bgColor = [UIColor colorWithRed:0.8 green:0.8 blue:0 alpha:0.3];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.separatorColor = [UIColor darkGrayColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"疑问条文" style:UIBarButtonItemStylePlain target:self action:@selector(gotoQuetion:)];
    
    _data = @[
             @[@"汉制一两约为 15.625克",
             @"汉制一两为 24铢",
             @"汉制一铢为 0.65克",
             @"汉制一升约为 200毫升",
             @"汉制一合为 20毫升",
             @"杏仁一枚约为 0.4克"],
             @[@"1石=四钧＝29760克",
             @"1钧=三十斤＝7440克",
             @"1斤=248克",
             @"1斤=16两",
             @"1斤=液体250毫升",
             @"1两=15.625克",
             @"1两=24铢",
             @"1升=液体200毫升",
             @"1合=20毫升",
             @"1圭=0.5克",
             @"1龠=10毫升",
             @"1撮=2克",
             @"1方寸匕=金石类2.74克",
             @"1方寸匕=药末约2克",
             @"1方寸匕=草木类药末约1克",
             @"半方寸匕=一刀圭=一钱匕=1.5克",
             @"一钱匕=1.5-1.8克",
             @"一铢=100个黍米的重量",
             @"一分=3.9-4.2克"],
             @[@"梧桐子大约为 黄豆大",
             @"蜀椒一升=50克",
             @"葶力子一升=60克",
             @"吴茱萸一升=50克",
             @"五味子一升=50克",
             @"半夏一升=130克",
             @"虻虫一升=16克",
             @"附子大者1枚=20-30克",
             @"附子中者1枚=15克",
             @"强乌头1枚小者=3克",
             @"强乌头1枚大者=5-6克",
             @"杏仁大者10枚=4克",
             @"栀子10枚平均15克",
             @"瓜蒌大小平均1枚=46克",
             @"枳实1枚约14.4克",
             @"石膏鸡蛋大1枚约40克",
             @"厚朴1尺约30克",
             @"竹叶一握约12克"],
             @[@"1斛=10斗＝20000毫升",
             @"1斗=10升＝2000毫升",
             @"1升=10合＝200毫升",
             @"1合=2龠＝20毫升",
             @"1龠=5撮＝10毫升",
             @"1撮=4圭＝2毫升",
             @"1圭=0.5毫升",
             @"1引=10丈＝2310厘米",
             @"1丈=10尺＝231厘米",
             @"1尺=10寸＝23.1厘米",
             @"1寸=10分＝2.31厘米",
             @"1分=0.231厘米"]
             ];
    _header = @[
               @"汉制单位概略",
               @"汉制重量",
               @"伤寒条文估算",
               @"汉制体积"
               ];
}

- (void)gotoQuetion:(id)sender
{
    historyTableViewController *vcHist = [[historyTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *vcHistNav = [[UINavigationController alloc] initWithRootViewController:vcHist];
    vcHistNav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    vcHistNav.navigationBar.tintColor = [UIColor whiteColor];
    [self presentViewController:vcHistNav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_data[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"huansuan"];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"huansuan"];
 
    // Configure the cell...
    cell.textLabel.text = _data[indexPath.section][indexPath.row];
    cell.backgroundColor = _bgColor;
    //cell.textLabel.font = [UIFont fontWithName:cell.textLabel.font.fontName size:19.0];
 
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _header[section];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49)];
    label.font = [UIFont fontWithName:label.font.fontName size:19.0];
    NSMutableAttributedString *aStr= [[NSMutableAttributedString alloc] initWithString:_header[section]];
    NSRange range = NSMakeRange(0, aStr.length);
    [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:1.0 alpha:1.0] range:range];
    [aStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:label.font.pointSize]
                   range:range];
    label.attributedText = aStr;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.7];
    label.layer.borderWidth = 0.5;
    return label;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 38.0;
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
        [UIPasteboard generalPasteboard].string = _data[indexPath.section][indexPath.row];
    }
}
@end
