//
//  ShowDetailViewController.m
//  OrderFood
//
//  Created by aplle on 8/14/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "ShowDetailViewController.h"

@interface ShowDetailViewController ()
@property (nonatomic, retain) IBOutlet      UIImageView *bgImageView;//背景图
@property (nonatomic, retain) IBOutlet      UIImageView *detailImageView;//图片详细图
@property (nonatomic, retain) IBOutlet      UIButton    *backBtn;//返回按钮
@property (nonatomic, retain) IBOutlet      UITextField *priceShow;//价格
@property (nonatomic, retain) IBOutlet      UILabel     *foodName;//食物名称
@property (nonatomic, retain) IBOutlet      UITextView  *descrption;//食物描述
@property (nonatomic, retain) FoodObject                *curFoodObject;//当前食物

- (IBAction)backAction:(id)sender;//返回操作
@end

@implementation ShowDetailViewController
@synthesize bgImageView;
@synthesize detailImageView;
@synthesize backBtn;
@synthesize priceShow;
@synthesize foodName;
@synthesize didBackAction;
@synthesize curFoodObject;
@synthesize descrption;

- (id)initWithFoodObject:(FoodObject *)object
{
    self = [super init];
    
    if (self)
    {
        self.curFoodObject = object;
    }
    
    return self;
}

- (void)dealloc
{
    self.bgImageView = nil;
    self.detailImageView = nil;
    self.backBtn = nil;
    self.priceShow = nil;
    self.foodName = nil;
    self.didBackAction = nil;
    self.curFoodObject = nil;
    self.descrption = nil;
    
//    [super dealloc];
}

- (IBAction)backAction:(id)sender
{
    //返回操作
    if (didBackAction)
    {
        didBackAction(self);
    }
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
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
    [self.detailImageView setImage:curFoodObject.foodPrewview];
    [foodName setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [foodName setText:curFoodObject.foodName];//显示食物名称
    [foodName setTextColor:[UIColor colorWithRed:181.0f/255.0f green:181.0f/255.0f blue:181.0f/255.0f alpha:1]];
    [priceShow setUserInteractionEnabled:NO];
    [priceShow setEnabled:NO];
    priceShow.rightViewMode = UITextFieldViewModeAlways;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 22)];
    [lab setText:[NSString stringWithFormat:@"/%@", curFoodObject.danwei]];//显示单位
    [lab setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [lab setBackgroundColor:[UIColor clearColor]];
    [lab setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
    UIView  *v_r = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [lab.text sizeWithFont:lab.font].width, priceShow.frame.size.height)];
    lab.frame = CGRectMake(0, priceShow.frame.size.height-[lab.text sizeWithFont:lab.font].height, [lab.text sizeWithFont:lab.font].width, [lab.text sizeWithFont:lab.font].height);
    [v_r addSubview:lab];
    
    priceShow.rightView = v_r;
    [priceShow setFont:[UIFont boldSystemFontOfSize:32.0f]];
    [priceShow setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
//    [lab release];
//    [v_r release];
    
    [priceShow setText:[NSString stringWithFormat:@"￥%@", curFoodObject.price]];//显示价格
    [backBtn setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];//设置返回按钮背景图
    [descrption setText:curFoodObject.description];//显示简介
    [descrption setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
    [descrption setUserInteractionEnabled:NO];
    [descrption setEditable:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
