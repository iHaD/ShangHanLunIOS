//
//  DataCache.h
//  shangHanLun_iOS
//
//  Created by hh on 16/5/4.
//  Copyright © 2016年 hh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCache : NSObject

@property (strong,nonatomic,readonly) NSArray<HH2SectionData *> *itemData;
@property (strong,nonatomic,readonly) NSArray<HH2SectionData *> *fangData;
@property (strong,nonatomic,readonly) NSArray<HH2SectionData *> *yaoData;

@property (strong,nonatomic,readonly) NSArray<Fang *> *shangHanFang;
@property (strong,nonatomic,readonly) NSArray<Fang *> *jinKuiFang;

@property (strong,nonatomic,readonly) NSArray<Yao *> *yao;

+ (instancetype)sharedData;

+ (NSString *)getStandardYaoName:(NSString *)name;
+ (NSString *)getStandardFangName:(NSString *)name;

+ (NSArray<NSString *> *)getAliasStringArrayByName:(NSString *)name isFang:(BOOL)isFang;

+ (BOOL)hasYao:(NSString *)name;
+ (BOOL)hasFang:(NSString *)name;

+ (BOOL)name:(NSString *)name isEqualToName:(NSString *)text isFang:(BOOL)isFang;

// 根据药名获取药物本经内容
+ (NSMutableAttributedString *)getYaoContentByName:(NSString *)yaoName;

+ (NSArray<HH2SectionData *> *)getFangListByYaoNameInStandardList:(NSString *)name;
+ (NSArray<HH2SectionData *> *)getFangListByYaoNameInAllYaoList:(NSString *)name;

@end
