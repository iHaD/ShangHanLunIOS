//
//  DataItem.h
//  shangHanLunTab
//
//  Created by hh on 16/5/4.
//  Copyright © 2016年 hh. All rights reserved.
//

#import "JSONModel.h"
#import "UIKit/UIKit.h"
@protocol NSString;

// 此类只需要设置self.text和self.indexPath，其他属性可由text自动生成。
@interface DataItem : JSONModel
@property (assign,nonatomic,readonly) NSInteger ID;
@property (strong,nonatomic,readonly) NSString *text;
@property (strong,nonatomic,readonly) NSIndexPath *indexPath;
@property (strong,nonatomic,readonly) NSArray<NSString *> *fangList;
@property (strong,nonatomic,readonly) NSArray<NSString *> *yaoList;

@property (assign,nonatomic) CGFloat height;

@property (strong,nonatomic,readonly) NSMutableAttributedString *attributedText;
//- (NSMutableAttributedString *)attributedText;
- (id)initWithText:(NSString *)text;
- (void)refreshShow;

- (BOOL)containsName:(NSString *)name isFang:(BOOL)isFang;

@end
