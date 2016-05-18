//
//  TipsView.h
//  shangHanLunTab
//
//  Created by hh on 16/2/5.
//  Copyright © 2016年 hh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HH2SearchViewController.h"
#import "YYText.h"

@interface TipsView : YYTextView

@property (weak,nonatomic) HH2SearchViewController *con;
@property (assign,nonatomic) LinkClass linkClass;
@property (strong,nonatomic) NSString *curSearchText;
@property (assign,nonatomic) CGFloat curContentHeight;

@property (assign,nonatomic) BOOL isFinished;

@end
