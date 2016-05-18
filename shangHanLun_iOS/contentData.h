//
//  contentData.h
//  shangHanLun
//
//  Created by hh on 14/10/31.
//  Copyright (c) 2014年 hh. All rights reserved.
//
#define kIndex @"keyText"
#define kDate @"keyDate"
#define kNote @"keyNote"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface contentData : NSObject
{
    NSArray *_data;
    NSArray *_fang;
}

@property (nonatomic,strong) NSMutableArray<NSDictionary *> *dataNote;
@property (nonatomic,strong) NSMutableArray *fangNote;

@property CGFloat screenWidth;
@property CGFloat screenHeight;

+(instancetype)sharedData;
-(void)saveData;
-(void)setNote:(NSString *)text atIndex:(int)index;
-(void)setFangNote:(NSString *)text atIndex:(int)index;

- (NSString *)getNotesString;

@end

