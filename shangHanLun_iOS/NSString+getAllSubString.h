//
//  NSString+getAllSubString.h
//  shangHanLun
//
//  Created by hh on 14/11/4.
//  Copyright (c) 2014年 hh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (getAllSubString)

-(NSArray *)getAllSubString:(NSString *)text;
-(NSArray *)getAllSubStringRange:(NSString *)text;
-(NSArray *)getAllSubStringRangeByReg:(NSString *)regular;
-(NSArray *)splitFor:(NSString *)text;
-(NSRange)matchesMagic:(NSString *)text  magic:(NSString *)magic;
-(CGFloat)textHeightWithFontSize:(UIFont *)font width:(CGFloat)width;
- (CGFloat)getTextHeight;
-(int)getInt;
-(BOOL)isPureInt;
- (BOOL)isPureFloat;
//-(NSAttributedString *)renderItemNum:(NSMutableAttributedString *)text;
-(NSMutableAttributedString *)parseText:(BOOL)enableLinks;
-(NSMutableAttributedString *)parseTextWithBlock:(void (^)(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect))block;
-(NSArray *)getFangNameList;
- (NSArray *)getYaoList;

@end
