//
//  HH2FangYaoBaseViewController.h
//  shangHanLunTab
//
//  Created by hh on 16/2/2.
//  Copyright © 2016年 hh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HH2SearchViewController.h"


@interface HH2FangYaoBaseViewController : HH2SearchViewController
{
    @protected
    NSMutableDictionary<NSIndexPath *, NSMutableAttributedString *> *linksCellContents;
    NSMutableDictionary<NSIndexPath *, NSNumber *> *linksCellHeights;
    NSString *btnTitle;
}
@property (assign,nonatomic) LinkClass linkClass;
@end
