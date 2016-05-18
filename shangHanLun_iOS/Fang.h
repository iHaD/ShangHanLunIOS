//
//  Fang.h
//  shangHanLunTab
//
//  Created by hh on 16/5/4.
//  Copyright © 2016年 hh. All rights reserved.
//

#import "DataItem.h"

@interface YaoUse : JSONModel
@property (assign,nonatomic,readonly) NSInteger yaoID;
@property (strong,nonatomic,readonly) NSString *showName;
@property (assign,nonatomic,readonly) float weight;

@property (strong,nonatomic,readonly) NSString *extraProcess;
@property (strong,nonatomic,readonly) NSString *amount;
@end

@interface Fang : DataItem
{
    NSString *curYao; // 当前排序的药名
}

@property (strong,nonatomic,readonly) NSString *name;
@property (assign,nonatomic,readonly) NSInteger yaoCount;       // 几味
@property (assign,nonatomic,readonly) NSInteger drinkNum;       // 几服
@property (strong,nonatomic,readonly) NSString *makeWay;        // 方剂煎煮方法

@property (strong,nonatomic) NSArray<YaoUse *> *standardYaoList; // 标准药物组合
@property (strong,nonatomic) NSArray<YaoUse *> *extraYaoList;    // 药物加减
@property (strong,nonatomic,readonly) NSArray<YaoUse *> *helpYaoList; // 辅助药物／甘烂水等

- (NSString *)getFangNameLinkWithYaoWeight:(NSString *)yao;

- (NSComparisonResult)compare:(Fang *)another;
- (YaoUse *)getYaoUseByName:(NSString *)name;

@end
