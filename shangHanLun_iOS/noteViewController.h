//
//  noteViewController.h
//  shangHanLunTab
//
//  Created by hh on 14/11/24.
//  Copyright (c) 2014年 hh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "historyTableViewController.h"

@interface noteViewController : UIViewController

@property NSInteger index;
@property (strong,nonatomic) NSMutableArray *curArray;

-(instancetype)initWithDataSource:(NSMutableArray *)array;

@end
