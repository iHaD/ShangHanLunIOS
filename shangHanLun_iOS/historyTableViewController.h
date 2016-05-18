//
//  historyTableViewController.h
//  shangHanLunTab
//
//  Created by hh on 14/11/7.
//  Copyright (c) 2014年 hh. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "contentData.h"

@interface historyTableViewController : UITableViewController

@property (strong,nonatomic) NSMutableArray *dictArray;

-(instancetype)initWithStyle:(UITableViewStyle)style;
-(void)saveData;
-(void)addNewNote:(int)index;

@end
