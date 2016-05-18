//
//  HH2SearchViewController.h
//  shangHanLunTab
//
//  Created by hh on 15/12/3.
//  Copyright © 2015年 hh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HH2SectionData.h"
#import "HH2SearchBar.h"
#import "HH2ShowViewController.h"

static NSString const *SettingsChangedNotification = @"SettingsChangedNotification";

@interface HH2SearchViewController : HH2ShowViewController <UISearchBarDelegate>

@property (strong,nonatomic) HH2SearchBar *searchBar;
@property (assign,nonatomic) BOOL showMode;
@property (assign,nonatomic) CGFloat maxInputTipsHeight;

- (BOOL)hasSearchText;

-(void)clearBar;

// 重构暂时未成功，逻辑还欠缺考虑，该方法暂时勿用。
- (UIAlertAction *)getSeeContext:(NSIndexPath *)indexPath;

@end

