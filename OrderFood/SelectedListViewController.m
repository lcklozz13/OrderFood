//
//  SelectedListViewController.m
//  OrderFood
//
//  Created by aplle on 8/14/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "SelectedListViewController.h"
#import "FoodListCell.h"

@interface SelectedListViewController ()
@property (nonatomic, retain) IBOutlet  UIImageView     *bgImageView;//背景
@property (nonatomic, retain) IBOutlet  UITableView     *mainView;//列表控件
@property (nonatomic, retain) NSMutableArray            *dataSource;//数据源
@property (nonatomic, retain) FoodObject                *curFoodObject;//当前食物
@property (nonatomic, retain) IBOutlet UITextField      *showTotalLab;//总共金额
@property (nonatomic, retain) IBOutlet UIView           *headView;//列表headview
@property (nonatomic, retain) IBOutlet UIButton         *backBtn;//返回按钮
@property (nonatomic, retain) IBOutlet UIButton         *bookBtn;//下单按钮
@property (nonatomic, retain) IBOutlet UILabel          *headViewTitle;//标题

- (IBAction)bookActon:(id)sender;//返回操作
- (IBAction)backAction:(id)sender;//下单操作
@end

@implementation SelectedListViewController
@synthesize mainView;
@synthesize bgImageView;
@synthesize dataSource;
@synthesize curFoodObject;
@synthesize showTotalLab;
@synthesize headView;
@synthesize backBtn;
@synthesize bookBtn;
@synthesize didBack;
@synthesize didBook;
@synthesize headViewTitle;

//下单操作
- (IBAction)bookActon:(id)sender
{
    if (didBook)
    {
        didBook(self);
    }
}

//返回操作
- (IBAction)backAction:(id)sender
{
    if (didBack)
    {
        didBack(self);
    }
}

- (void)dealloc
{
    self.backBtn = nil;
    self.bookBtn = nil;
    self.mainView = nil;
    self.bgImageView = nil;
    self.dataSource = nil;
    self.curFoodObject = nil;
    self.showTotalLab = nil;
    self.headView = nil;
    self.didBack = nil;
    self.didBook = nil;
    self.headViewTitle = nil;
    
//    [super dealloc];
}

- (id)initWithSelectArray:(NSMutableArray *)selectedArray
{
    self = [super init];
    
    if (self)
    {
        self.dataSource = selectedArray;
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
    [mainView setBackgroundColor:[UIColor clearColor]];
    [mainView setBackgroundView:nil];
    mainView.tableFooterView = /*[*/[[UIView alloc] initWithFrame:CGRectZero] /*autorelease]*/;
    [headViewTitle setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [headViewTitle setTextColor:[UIColor colorWithRed:181.0f/255.0f green:181.0f/255.0f blue:181.0f/255.0f alpha:1]];
    
    [headView setBackgroundColor:[UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1]];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 22)];
    [lab setText:@"共:"];
    [lab setBackgroundColor:[UIColor clearColor]];
    [lab setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
    [lab setFont:[UIFont boldSystemFontOfSize:14.0f]];
    
    UIView *v_l = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [lab.text sizeWithFont:lab.font].width, [@" " sizeWithFont:showTotalLab.font].height)];
    lab.frame = CGRectMake(0, [@" " sizeWithFont:showTotalLab.font].height - [lab.text sizeWithFont:lab.font].height + 2, [lab.text sizeWithFont:lab.font].width, [lab.text sizeWithFont:lab.font].height);
    [v_l addSubview:lab];
    
    [showTotalLab setLeftViewMode:UITextFieldViewModeAlways];
    [showTotalLab setLeftView:v_l];
    [showTotalLab setFont:[UIFont boldSystemFontOfSize:32.0f]];
    [showTotalLab setUserInteractionEnabled:NO];
    [showTotalLab setEnabled:NO];
//    [lab release];
//    [v_l release];
    
    [showTotalLab setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
    showTotalLab.rightViewMode = UITextFieldViewModeAlways;
    showTotalLab.rightView = /*[*/[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spe.png"]] /*autorelease]*/;
    
    CGRect r = bookBtn.frame;
    r.size = CGSizeMake(85, 32);
    bookBtn.frame = r;
    [bookBtn setBackgroundImage:[UIImage imageNamed:@"btn_order2.png"] forState:UIControlStateNormal];
    
    float total = 0.0f;
    
    for (FoodObject *food in dataSource)
    {
        total += [food.price floatValue] * food.bookCount;
    }
    
    [showTotalLab setText:[[NSString alloc] initWithFormat:@"￥%.0f", total]];
    [backBtn setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    
    r = showTotalLab.frame;
    r.size = [showTotalLab.text sizeWithFont:showTotalLab.font];
    r.origin.x = bookBtn.frame.origin.x - r.size.width - 10;
    showTotalLab.frame = r;
    CGPoint cent = showTotalLab.center;
    cent.y = headViewTitle.center.y;
    showTotalLab.center = cent;
    
    cent = bookBtn.center;
    cent.y = bookBtn.center.y;
    bookBtn.center = cent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString     *cellForCategory = [[NSString alloc] initWithFormat:@"cellForSelected%d", indexPath.row];
    
    FoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellForCategory];
    
    if (!cell)
    {
        cell = /*[*/[[FoodListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellForCategory] /*autorelease]*/;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.touchShowAddtion = YES;
    }
    
    if ((indexPath.row + 1) % 2 == 0)
    {
        [cell.selectImageBg setBackgroundColor:[UIColor colorWithRed:238.0f/255.0f green:239.0f/255.0f blue:240.0f/255.0f alpha:1]];
    }
    else
    {
        [cell.selectImageBg setBackgroundColor:[UIColor clearColor]];
    }
    
    __block typeof(self) obj = self;
    cell.showAlertView = YES;
    cell.didDeleteZeroAlert = ^(FoodObject *object) {//提示是否删除该菜品
        __block UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否删除该菜品" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
//        [alertView release];
        obj.curFoodObject = object;
    };
    
    cell.refreshBlock = ^(){//刷新总价
        float total = 0.0f;
        
        for (FoodObject *food in obj.dataSource)
        {
            total += [food.price floatValue] * food.bookCount;
        }
        
        [obj.showTotalLab setText:[[NSString alloc] initWithFormat:@"￥%.0f", total]];
    };
    
    FoodObject *sub = [dataSource objectAtIndex:indexPath.row];
    cell.food = sub;
    __block typeof(cell) cel = cell;
    cell.selectedAddtion = ^(NSString *addtion) {
        cel.food.addtionInfor = addtion;
    };
    
    return cell;    
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return headView.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (editingStyle == UITableViewCellEditingStyleDelete)
     {
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否删除该菜品" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
         [alertView show];
         self.curFoodObject = [dataSource objectAtIndex:indexPath.row];;
     }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)//点击是删除该草品
    {
        [dataSource removeObject:curFoodObject];
        self.curFoodObject.bookCount = 0;
        
        if (curFoodObject.referenceObject)
        {
            curFoodObject.referenceObject.bookCount = 0;
        }
        
        self.curFoodObject = nil;
        float total = 0.0f;
        
        for (FoodObject *food in self.dataSource)
        {
            total += [food.price floatValue] * food.bookCount;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.showTotalLab setText:[[NSString alloc] initWithFormat:@"￥%.0f", total]];
        });
    }
    
    [mainView reloadData];
}
@end
