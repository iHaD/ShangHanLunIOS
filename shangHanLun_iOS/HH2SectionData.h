//
//  HH2SectionData.h
//  shangHanLunTab
//
//  Created by hh on 15/12/3.
//  Copyright © 2015年 hh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HH2SearchHeaderView.h"
#import "HH2SearchConfig.h"
#import "NSString+getAllSubString.h"
#import "DataItem.h"

typedef NS_ENUM(NSInteger, DataType){
    DataTypeItem = 0,
    DataTypeFang = 1,
    DataTypeYao = 2,
};

@interface HH2SectionData : JSONModel
{
    DataType type;
}

@property (assign,nonatomic,readonly) NSUInteger section;
@property (strong,nonatomic) NSString *header;
@property (strong,nonatomic) NSArray<DataItem *> *data;

- (NSArray<DataItem *> *)dataBac;

- (HH2SearchHeaderView *)headerView;
- (void)setHeaderView:(HH2SearchHeaderView *)headerView;

- (instancetype)initWithDictionary:(NSDictionary *)dict section:(NSUInteger)section type:(DataType)type_;
- (instancetype)initWithData:(NSArray<DataItem *> *)data section:(NSUInteger)section;
- (void)refreshShow;
- (void)resetData;

@end
