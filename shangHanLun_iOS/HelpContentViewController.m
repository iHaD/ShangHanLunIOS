//
//  HelpContentViewController.m
//  shangHanLunTab
//
//  Created by hh on 16/1/23.
//  Copyright © 2016年 hh. All rights reserved.
//

#import "HelpContentViewController.h"
#import "NSString+getAllSubString.h"

@interface HelpContentViewController ()
{
    NSArray<NSString *> *data;
}
@end

@implementation HelpContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"使用帮助";
    self.tableView.allowsSelection = NO;
    self.tableView.tableFooterView = [UIView new];
    
    data = @[@"1.输入1-398之间的数字，可直接滑动定位到该条文",
             @"2.输入多个关键词，以空格隔开即可，比如“甘草 大枣”，即可搜索既包括甘草也包括大枣的条文。",
             @"3.紧挨关键词前或后输入\"-\"，意为不包含该关键字。",
             @"4.支持用 # 或 . (必须是英文符号)代替一个不好打的字",
             @"5、关键词包含y，表示该词为药名。将不会混淆结果，比如 y桂枝 甚至能搜索出只包含“桂”的方。",
             @"6、关键词包含f，表示该词为方名，同上。",
             @"7、支持方药的别名。"
             ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"helpContentReuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    cell.textLabel.text = data[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat edge = screenWidth > 400.0 ? 20.0 : 16.0;
    CGFloat height = [data[indexPath.row] textHeightWithFontSize:[UILabel new].font width:screenWidth - edge * 2];
    height += 20.0;
    return height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
