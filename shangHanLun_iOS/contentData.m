//
//  contentData.m
//  shangHanLun
//
//  Created by hh on 14/10/31.
//  Copyright (c) 2014年 hh. All rights reserved.
//
#define CONTENTDATAFILE @"contentData.plist"
#define CONTENTFANGFILE @"contentFang.plist"

#import "contentData.h"

@interface contentData ()
{
    NSString *_dataNoteFile;
    NSString *_fangNoteFile;
}
@end

@implementation contentData

static contentData *sharedData = nil;

-(void)initFilePath
{
    NSArray *filePathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _dataNoteFile = [[filePathArray objectAtIndex:0] stringByAppendingPathComponent:CONTENTDATAFILE];
    _fangNoteFile = [[filePathArray objectAtIndex:0] stringByAppendingPathComponent:CONTENTFANGFILE];
}
-(void)readData
{
    _dataNote = [[NSMutableArray alloc] initWithContentsOfFile:_dataNoteFile];
    _fangNote = [[NSMutableArray alloc] initWithContentsOfFile:_fangNoteFile];
    NSDictionary *dict = @{
                           kDate : [NSDate date],
                           kNote : @""
                           };
    if (_dataNote == nil) {
        _dataNote = [[NSMutableArray alloc] init];
        for (int i = 0; i < 398; i++) {
            [_dataNote insertObject:dict.mutableCopy atIndex:i];
        }
    }
    if (_fangNote == nil) {
        _fangNote = [[NSMutableArray alloc] init];
        for (int i = 0; i < 113; i++) {
            [_fangNote insertObject:dict.mutableCopy atIndex:i];
        }
    }
}

- (NSString *)getNotesString
{
    NSMutableString *str = [NSMutableString new];
    [_dataNote enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [str appendFormat:@"%lu、%@\n",idx + 1,obj[kNote]];
    }];
    return str;
}

-(void)saveData
{
    [_dataNote writeToFile:_dataNoteFile atomically:YES];
    [_fangNote writeToFile:_fangNoteFile atomically:YES];
}

-(void)setNote:(NSString *)text atIndex:(int)index
{
    if (index < 0 || index > 397) {
        NSLog(@"contentData.m: index out of range.");
    }
    NSDictionary *dict = @{
                           kDate : [NSDate date],
                           kNote : text
                           };
    _dataNote[index] = dict;
}

-(void)setFangNote:(NSString *)text atIndex:(int)index
{
    if (index < 0 || index > 112) {
        NSLog(@"contentData.m: index out of range.");
    }
    NSDictionary *dict = @{
                           kDate : [NSDate date],
                           kNote : text
                           };
    _fangNote[index] = dict;
}


-(instancetype)init
{
    self = [super init];
    [self initFilePath];
    [self readData];
    CGRect screen = [[UIScreen mainScreen] bounds];
    _screenWidth = screen.size.width;
    _screenHeight = screen.size.height;
    
    return self;
}

+(instancetype)sharedData
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedData = [[self alloc] init];
    });
    return sharedData;
}


@end
