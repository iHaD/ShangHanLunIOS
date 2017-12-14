//
//  AppDelegate.m
//  shangHanLun_iOS
//
//  Created by hh on 16/5/4.
//  Copyright © 2016年 hh. All rights reserved.
//

#import "AppDelegate.h"
#import "helpTableViewController.h"
#import "unitTableViewController.h"
#import "YaoViewController.h"
#import "FangViewController.h"
#import "ViewController.h"
#import "HH2SearchCell.h"

@interface AppDelegate () <UINavigationControllerDelegate>
{
    UITabBarController *_tc;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    HH2SearchConfig *config = [HH2SearchConfig sharedConfig];
    config = config;
    DataCache *cache = [DataCache sharedData];
    
    _littleWindowStack = [NSMutableArray new];
    
    _list = [NSMutableArray new];
    _listHeader = [NSMutableArray new];
    _heightList = [NSMutableArray new];
    
    ViewController *vc = [[ViewController alloc] initWithStyle:UITableViewStylePlain data:cache.itemData];
    vc.bookName = @"伤寒论";
    vc.tabBarItem.title = @"伤寒论条文";
    UINavigationController *vcNav = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.tabBarItem.image = [UIImage imageNamed:@"IMG_1370.PNG"];
    
    FangViewController *vcFang = [[FangViewController alloc] initWithStyle:UITableViewStylePlain data:cache.fangData];
    vcFang.bookName = @"伤寒论113方";
    vcFang.tabBarItem.title = @"方剂表";
    UINavigationController *vcFangNav = [[UINavigationController alloc] initWithRootViewController:vcFang];
    vcFang.tabBarItem.image = [UIImage imageNamed:@"IMG_1378.PNG"];
    
    unitTableViewController *vcUnit = [[unitTableViewController alloc] initWithStyle:UITableViewStylePlain];
    //vcUnit.title = @"汉制单位换算";
    //    vcUnit.bgColor = vc.bgColor;
    vcUnit.tabBarItem.title = @"汉制单位";
    UINavigationController *vcUnitNav = [[UINavigationController alloc] initWithRootViewController:vcUnit];
    vcUnit.tabBarItem.image = [UIImage imageNamed:@"ruler.png"];
    vcUnit.bgColor = [UIColor colorWithRed:0.8 green:0.8 blue:0 alpha:0.3];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.font = [UIFont fontWithName:label.font.fontName size:19.0];
    label.text = @"汉制单位换算表";
    label.textColor = [UIColor whiteColor];
    vcUnit.navigationItem.titleView = label;
    
    YaoViewController *vcYao = [[YaoViewController alloc] initWithStyle:UITableViewStylePlain data:cache.yaoData];
    vcYao.bookName = @"伤寒药物";
    vcYao.tabBarItem.title = @"伤寒药物";
    UINavigationController *vcYaoNav = [[UINavigationController alloc] initWithRootViewController:vcYao];
    vcYao.tabBarItem.image = [UIImage imageNamed:@"IMG_1376.PNG"];
    
    helpTableViewController *help = [[helpTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    help.tabBarItem.title = @"设置与帮助";
    UINavigationController *helpNav = [[UINavigationController alloc] initWithRootViewController:help];
    help.tabBarItem.image = [UIImage imageNamed:@"IMG_1368.PNG"];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    label2.font = [UIFont fontWithName:label.font.fontName size:19.0];
    label2.text = @"设置与帮助";
    label2.textColor = [UIColor whiteColor];
    help.navigationItem.titleView = label2;
    
    _tc = [[UITabBarController alloc] init];
    _tc.viewControllers = @[vcNav,vcFangNav,vcYaoNav,vcUnitNav,helpNav];
    
    [_tc.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UINavigationController *nav = (UINavigationController *)obj;
        nav.delegate = self;
        nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        nav.navigationBar.tintColor = [UIColor whiteColor];
    }];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = _tc;
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.6 green:0.7 blue:1.0 alpha:1]];
    //    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.7]];

    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - UINavigationController 代理
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    viewController.navigationItem.backBarButtonItem = backItem;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Little Window TableView Datasource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _list.lastObject.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list.lastObject[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuse = [self.description stringByAppendingString:@"listReuse"];
    HH2SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[HH2SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.attributedText = _list.lastObject[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _heightList.lastObject[indexPath.section][indexPath.row].floatValue;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _listHeader.lastObject[section];
}

@end
