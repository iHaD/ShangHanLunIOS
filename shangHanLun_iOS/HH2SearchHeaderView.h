//
//  HH2SearchHeaderView.h
//  shangHanLunTab
//
//  Created by hh on 15/12/3.
//  Copyright © 2015年 hh. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HH2SearchHeaderView, HH2SectionData;
@protocol HH2SearchHeaderViewDelegate <NSObject>

@required
- (void)clickHH2SearchHeaderView:(HH2SearchHeaderView *)view;
- (void)longPressSearchHeaderView:(HH2SearchHeaderView *)view;
@end

@interface HH2SearchHeaderView : UIControl

@property (strong,nonatomic) NSString *text;
@property (strong,nonatomic) UIColor *textColor;
@property (assign,nonatomic) id<HH2SearchHeaderViewDelegate> delegate;
@property (assign,nonatomic) NSUInteger section;

@end
