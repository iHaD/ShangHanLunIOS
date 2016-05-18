//
//  HH2SearchConfig.h
//  shangHanLunTab
//
//  Created by hh on 15/12/3.
//  Copyright © 2015年 hh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "AppDelegate.h"

/*
 $n{...} 条文序号
 $f{...} 方名
 $a{...} 内嵌注释
 $m{...} 药味总数
 $s{...} 药煮法开头的“上...味"
 * $u{...} 药名
 * $w{...} 药量
 * $q{...} 方名前缀（千金，外台） 不允许嵌套使用
 * $h{...} 隐藏的方名（暂时只用于标记方名)
 */

typedef NS_ENUM(NSInteger, ShowShangHan){
    ShowShangHanNone = 0,
    ShowShangHanOnly398 = 1,
    ShowShangHanAllSongBanShangHan = 2,
};

typedef NS_ENUM(NSInteger, ShowJinKui){
    ShowJinKuiNone = 0,
    ShowJinKuiDefault = 1,
};

@interface HH2SearchConfig : NSObject

@property (strong,nonatomic) NSString *magicText; // "#"，用以代替一个不好打的字
@property (strong,nonatomic) UIFont *font;
@property (strong,nonatomic) UIFont *smallFont;

@property (assign,nonatomic) BOOL showUnderLine;

@property (strong,nonatomic) UIColor *headerTextColor;

// 染色
/*
 $n{...} 条文序号
 $f{...} 方名
 $a{...} 内嵌注释
 $m{...} 药味总数
 $s{...} 药煮法开头的“上...味"
 * $u{...} 药名
 * $w{...} 药量
 * $q{...} 方名前缀（千金，外台） 不允许嵌套使用
 * $h{...} 隐藏的方名（暂时只用于标记方名)
 */
@property (strong,nonatomic) UIColor *nColor;
@property (strong,nonatomic) UIColor *fangColor;
@property (strong,nonatomic) UIColor *commentColor;
@property (strong,nonatomic) UIColor *yaoNumColor;
@property (strong,nonatomic) UIColor *zhufaNumColor;
@property (strong,nonatomic) UIColor *yaoColor;
@property (strong,nonatomic) UIColor *yaoAmountColor;
@property (strong,nonatomic) UIColor *fangPrefixColor;

@property (assign,nonatomic) BOOL isContentOpenAtFirst; //
@property (assign,nonatomic) ShowShangHan showShangHan;
@property (assign,nonatomic) ShowJinKui showJinKui;

+ (instancetype)sharedConfig;

@end
