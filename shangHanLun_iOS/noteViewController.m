//
//  noteViewController.m
//  shangHanLunTab
//
//  Created by hh on 14/11/24.
//  Copyright (c) 2014年 hh. All rights reserved.
//

#import "noteViewController.h"
#import "contentData.h"
#import "NSString+getAllSubString.h"

@interface noteViewController ()<UITextViewDelegate>
{
    UITextView *textView;
    UIButton *_accessoryView;
    UILabel *_titleLabel;
    UIBarButtonItem *_rightItem;
    BOOL _isChanged;
}
@end

@implementation noteViewController

-(instancetype)initWithDataSource:(NSMutableArray *)array
{
    self = [super init];
    self.curArray = array;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isChanged = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onFinish:)];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64.0, [[UIScreen mainScreen] bounds].size.width - 20.0, 44.0)];
    _titleLabel.textColor = [UIColor grayColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    [dateF setDateFormat:@"YYYY年M月dd日 HH:mm:ss"];
    //[_histVc.dictArray[_index] setObject:[NSDate date] forKey:kDate];
    _titleLabel.text = [dateF stringFromDate:_curArray[_index][kDate]];

//    self.automaticallyAdjustsScrollViewInsets = NO;
    textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64 + 34, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    textView.delegate = self;
//    textView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    textView.scrollEnabled = YES;
    textView.bounces = YES;
    textView.text = _curArray[_index][kNote];
    textView.font = [UIFont fontWithName:textView.font.fontName size:18.0];
    
    [self.view addSubview:_titleLabel];
    [self.view addSubview:textView];
    
    _accessoryView = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 50, [[UIScreen mainScreen] bounds].size.height, 50, 30)];
    [_accessoryView setImage:[UIImage imageNamed:@"IMG_1388.PNG"] forState:UIControlStateNormal];
    _accessoryView.backgroundColor = [UIColor whiteColor];
    [_accessoryView addTarget:self action:@selector(inputComplete:) forControlEvents:UIControlEventTouchUpInside];
    _accessoryView.layer.borderColor = [UIColor grayColor].CGColor;
    _accessoryView.layer.borderWidth = 0.5;
    _accessoryView.layer.cornerRadius = 5;
    
    UIWindow *window = [[UIApplication sharedApplication] windows][0];
    [window addSubview:_accessoryView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view.window bringSubviewToFront:_accessoryView];
//    [textView becomeFirstResponder];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_isChanged) {
        [self refreshTimeAndSaveNote];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView_
{
    [[contentData sharedData] saveData];
}

-(void)textViewDidChange:(UITextView *)textView_
{
    _isChanged = YES;
    self.navigationItem.rightBarButtonItem = _rightItem;
}

-(void)onFinish:(id)sender
{
    [self refreshTimeAndSaveNote];
    [textView resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)refreshTimeAndSaveNote
{
    NSDate *now = [NSDate date];
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"YYYY年M月dd日 HH:mm:ss"];
    _titleLabel.text = [form stringFromDate:now];
    _curArray[_index][kNote] = textView.text;
    _curArray[_index][kDate] = now;
}

-(void)inputComplete:(id)sender
{
    [textView resignFirstResponder];
}

- (void) changeContentViewPoint:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];        // 添加移动动画，使视图跟随键盘移动
    CGFloat targetY;
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        targetY = keyBoardEndY - _accessoryView.bounds.size.height/2.0;
    }else
        targetY = [[UIScreen mainScreen] bounds].size.height + _accessoryView.bounds.size.height/2.0;
    
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        _accessoryView.center = CGPointMake(_accessoryView.center.x, targetY);   // keyBoardEndY的坐标包括了状态栏的高度，要减去
        CGRect rect = textView.frame;
        rect.size.height = keyBoardEndY - 64 - 34;
        textView.frame = rect;
    }];
}

@end
