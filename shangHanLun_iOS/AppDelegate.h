//
//  AppDelegate.h
//  shangHanLun_iOS
//
//  Created by hh on 16/5/4.
//  Copyright © 2016年 hh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LittleWindow;
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) NSMutableArray<LittleWindow *> *littleWindowStack;

// 小窗口tableView的数据
@property (strong,nonatomic) NSMutableArray<NSArray<NSArray<NSAttributedString *> *> *> *list; // 用以保存弹出框中的条文列表
@property (strong,nonatomic) NSMutableArray<NSArray<NSString *> *> *listHeader;
@property (strong,nonatomic) NSMutableArray<NSArray<NSArray<NSNumber *> *> *> *heightList;

@end

