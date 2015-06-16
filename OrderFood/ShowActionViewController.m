//
//  ShowActionViewController.m
//  OrderFood
//
//  Created by aplle on 9/26/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "ShowActionViewController.h"

@interface ShowActionViewController ()
{
    IBOutlet        UIButton *orderBtn;//预定按钮
    IBOutlet        UIButton *memberBtn;//会员定食按钮
    IBOutlet        UIButton *bookBtn;//开房按钮
    IBOutlet        UILabel  *notifilab;
}
- (IBAction)backAction:(id)sender;//返回操作
- (IBAction)orderfood:(id)sender;//订餐操作
- (IBAction)memberorderfood:(id)sender;//会员订餐操作
- (IBAction)bookroom:(id)sender;//开房操作


@end

@implementation ShowActionViewController
@synthesize backAction;
@synthesize curBoxInforView;
@synthesize orderFood;
@synthesize memberOrderFood;
@synthesize bookRoom;

- (id)initWithBoxInforView:(BoxInforView *)view
{
    self = [super init];
    
    if (self)
    {
        self.curBoxInforView = view;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
    // Do any additional setup after loading the view from its nib.
    
    switch (curBoxInforView.stat)
    {
        case 1://U使用
        {
            if (curBoxInforView.isMember)//判断是否会员
            {
                //会员
                [memberBtn setHidden:NO];
                [orderBtn setHidden:YES];
            }
            else
            {
                [memberBtn setHidden:YES];
                [orderBtn setHidden:NO];
            }
            
            
            [bookBtn setHidden:YES];
            [notifilab setHidden:YES];
        }
            break;
            
//        case 2://Z整理
//        {
//            if (curBoxInforView.isMember)//判断是否会员
//            {
//                [memberBtn setHidden:NO];
//                [orderBtn setHidden:YES];
//            }
//            else
//            {
//                [memberBtn setHidden:YES];
//                [orderBtn setHidden:NO];
//            }
//            
//            
//            [bookBtn setHidden:YES];
//        }
//            break;
//            
//        case 3://K空闲
//        {
//            [bookBtn setHidden:NO];
//            [orderBtn setHidden:YES];
//            [memberBtn setHidden:YES];
//        }
//            break;
//            
//        case 4://W维修中
//        {
//            [bookBtn setHidden:YES];
//            [orderBtn setHidden:YES];
//            [memberBtn setHidden:YES];
//        }
//            break;
//            
//        case 5://S试机中
//        {
//            [bookBtn setHidden:NO];
//            [orderBtn setHidden:YES];
//            [memberBtn setHidden:YES];
//        }
//            break;
        case 6://Y已结
        {
            if (curBoxInforView.isMember)//判断是否会员
            {
                //会员
                [memberBtn setHidden:NO];
                [orderBtn setHidden:YES];
            }
            else
            {
                [memberBtn setHidden:YES];
                [orderBtn setHidden:NO];
            }
            
            [bookBtn setHidden:YES];
            [memberBtn setHidden:YES];
            [notifilab setHidden:YES];
        }
            break;
            
        default:
        {
            [bookBtn setHidden:YES];
            [orderBtn setHidden:YES];
            [memberBtn setHidden:YES];
            [notifilab setHidden:NO];
        }
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.backAction = nil;
    self.curBoxInforView = nil;
    self.bookRoom = nil;
    self.orderFood = nil;
    self.memberOrderFood = nil;
    
//    [super dealloc];
}
//返回操作
- (IBAction)backAction:(id)sender
{
    if (backAction)
    {
        backAction(self);
    }
}
//订餐操作
- (IBAction)orderfood:(id)sender
{
    if (orderFood)
    {
        orderFood(self);
    }
    
    [self backAction:nil];
}
//会员订餐操作
- (IBAction)memberorderfood:(id)sender
{
    if (memberOrderFood)
    {
        memberOrderFood(self);
    }
    
    [self backAction:nil];
}
//开房操作
- (IBAction)bookroom:(id)sender
{
    if (bookRoom)
    {
        bookRoom(self);
    }
    
    [self backAction:nil];
}

@end
