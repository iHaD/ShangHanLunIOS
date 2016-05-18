//
//  HH2ArrowView.h
//  shangHanLunTab
//
//  Created by hh on 15/12/17.
//  Copyright © 2015年 hh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, HH2Arrow){
    HH2ArrowUp,
    HH2ArrowDown,
};

@interface HH2ArrowView : UIView

- (instancetype)initWithDirection:(HH2Arrow)direction;
+ (CGSize)getDefaultSize;

@end
