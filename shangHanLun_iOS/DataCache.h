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

+ (BOOL)name:(NSString *)name isEqualToName:(NSString *)text isFang:(BOOL)isFang;

+ (NSMutableAttributedString *)getYaoContentByName:(NSString *)yaoName;

@end
