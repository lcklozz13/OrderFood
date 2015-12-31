//
//  ShowBookFoodListViewController.m
//  OrderFood
//
//  Created by aplle on 10/6/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "ShowBookFoodListViewController.h"
#import "OrderedFoodCell.h"
#import "OrderedFood.h"

@interface ShowBookFoodListViewController ()<AsyncUdpSocketDelegate>
{
    float               weijie;//未结金额
    float               yijie;//已结金额
    AsyncUdpSocket      *tuidanRequest;//退单请求
}
@property (nonatomic, retain) IBOutlet  UITableView     *mainView;//显示列表
@property (nonatomic, retain) NSMutableArray            *dataSource1;//未结列表数据源
@property (nonatomic, retain) NSMutableArray            *dataSource2;//已结列表数据源
@property (nonatomic, retain) IBOutlet UITextField      *showTotalLab;//显示金额
@property (nonatomic, retain) IBOutlet UIView           *headView;//列表的headview
@property (nonatomic, retain) IBOutlet UIButton         *backBtn;//返回按钮
@property (nonatomic, retain) IBOutlet UISegmentedControl   *segmentedControl;//选择未结已结的分段控件
@property (nonatomic, retain) UILabel                   *danwei1;
@property (nonatomic, retain) UILabel                   *danwei2;
@property (nonatomic, retain) OrderedFood               *curFood;//当前已定食物列表
//add 20140505
@property (nonatomic, retain) IBOutlet UILabel          *headViewTitle;
@property (nonatomic, retain) NSMutableArray            *dataSource;
- (IBAction)backAction:(id)sender;//返回
- (IBAction)changeAction:(id)sender;//选择显示已结未结
@end

@implementation ShowBookFoodListViewController

@synthesize mainView;
@synthesize dataSource1;
@synthesize dataSource2;
@synthesize showTotalLab;
@synthesize headView;
@synthesize backBtn;
@synthesize segmentedControl;
@synthesize didBack;
@synthesize danwei1;
@synthesize danwei2;
@synthesize roomId;
@synthesize curFood;

@synthesize dataSource;
@synthesize headViewTitle;

- (id)initWithDict:(NSMutableDictionary *)dict
{
    self = [super init];
    
    if (self)
    {
        //初始化数据源
        self.dataSource1 = [dict objectForKey:Ordered_No_Checkout];
        self.dataSource2 = [dict objectForKey:Ordered_Had_Checkout];
        
        for (OrderedFood *str in dataSource1)
        {
            weijie += [str.totalCount floatValue];
        }
        
        for (OrderedFood *str in dataSource2)
        {
            yijie += [str.totalCount floatValue];
        }
        
        tuidanRequest = [[AsyncUdpSocket alloc] initWithDelegate:self];
        
        dataSource = [[NSMutableArray alloc] initWithArray:dataSource1];
        [dataSource addObjectsFromArray:dataSource2];
    }
    
    return self;
}

#pragma mark AsyncUdpSocketDelegate

- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    [[Public getInstance].juhua hide:YES];
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"链接超时" message:@"链接超时，请重试。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [view show];
//    [view release];
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    [[Public getInstance].juhua hide:YES];
    NSString *str = [[NSString alloc] initWithData:data encoding:[Public getInstance].gbkEncoding];
    NSLog(@"tag:%ld recv:%@", tag, str);
    //退订成功
    if (tag == [INS_BOOK intValue])
    {
        //设置已结未结金额，并刷新界面
        weijie -= [curFood.totalCount floatValue];
        NSString *showStr = [[NSString alloc] initWithFormat:@"未结:￥%.0f|已结:￥%.0f", weijie, yijie];
        [danwei1 setText:showStr];
        CGSize labSzie = [showStr sizeWithFont:danwei1.font];
        danwei1.frame = CGRectMake(0, (32.0f-labSzie.height)/2, labSzie.width, labSzie.height);
        CGRect r = showTotalLab.frame;
        [showTotalLab setText:[[NSString alloc] initWithFormat:@"￥%.0f", weijie + yijie]];
        r.size = [showTotalLab.text sizeWithFont:showTotalLab.font];
        r.size.width += danwei2.frame.size.width;
        r.size.width += danwei1.frame.size.width;
        r.origin.x = showTotalLab.superview.frame.size.width - 12.0f - r.size.width;
        showTotalLab.frame = r;
        
        [dataSource1 removeObject:curFood];
        [mainView reloadData];
        self.curFood = nil;
        //提示退单成功
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"退单成功";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:NO afterDelay:1];
    }
    
//    [str release];
    
    return YES;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"%@", error.userInfo);
    NSLog(@"%@", error.domain);
    [[Public getInstance].juhua hide:YES];
}

- (void)dealloc
{
    tuidanRequest.delegate = nil;
//    [tuidanRequest release],
    tuidanRequest = nil;
    self.dataSource = nil;
    self.headViewTitle = nil;
    self.mainView = nil;
    self.dataSource1 = nil;
    self.dataSource2 = nil;
    self.showTotalLab = nil;
    self.headView = nil;
    self.backBtn = nil;
    self.segmentedControl = nil;
    self.didBack = nil;
    self.danwei1 = nil;
    self.danwei2 = nil;
    self.roomId = nil;
    self.curFood = nil;
    
//    [super dealloc];
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
    // Do any additional setup after loading the view from its nib.
    [mainView setBackgroundColor:[UIColor clearColor]];
    [mainView setBackgroundView:nil];
    mainView.tableFooterView = /*[*/[[UIView alloc] initWithFrame:CGRectZero] /*autorelease]*/;
    
    [headView setBackgroundColor:[UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1]];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 22)];
    [lab setText:@"共:"];
    [lab setBackgroundColor:[UIColor clearColor]];
    [lab setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
    [lab setFont:[UIFont boldSystemFontOfSize:14.0f]];
    
    UIView *v_l = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [lab.text sizeWithFont:lab.font].width, [@" " sizeWithFont:showTotalLab.font].height)];
    lab.frame = CGRectMake(0, [@" " sizeWithFont:showTotalLab.font].height - [lab.text sizeWithFont:lab.font].height + 2, [lab.text sizeWithFont:lab.font].width, [lab.text sizeWithFont:lab.font].height);
    [v_l addSubview:lab];
    self.danwei2 = lab;
    [showTotalLab setLeftViewMode:UITextFieldViewModeAlways];
    [showTotalLab setLeftView:v_l];
    [showTotalLab setFont:[UIFont boldSystemFontOfSize:32.0f]];
    [showTotalLab setUserInteractionEnabled:NO];
    [showTotalLab setEnabled:NO];
//    [lab release];
//    [v_l release];
    
    [showTotalLab setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
    showTotalLab.rightViewMode = UITextFieldViewModeAlways;
    lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 30, 22)];
    [lab setBackgroundColor:[UIColor clearColor]];
    [lab setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
    [lab setFont:[UIFont boldSystemFontOfSize:18.0f]];
    self.danwei1 = lab;
    
    NSString *showStr = [[NSString alloc] initWithFormat:@"未结:￥%.0f|已结:￥%.0f", weijie, yijie];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [showStr sizeWithFont:lab.font].width, 32.0f)];
    CGSize labSzie = [showStr sizeWithFont:lab.font];
    lab.frame = CGRectMake(0, (32.0f-labSzie.height)/2, labSzie.width, labSzie.height);
    [lab setText:showStr];
    [view addSubview:lab];
//    showTotalLab.rightView = view;//modofiy by lincong 20140506
//    [lab release];
//    [view release];
    
    CGRect r = showTotalLab.frame;
        
    [showTotalLab setText:[[NSString alloc] initWithFormat:@"￥%.0f", weijie + yijie]];
    [backBtn setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    
    r.size = [showTotalLab.text sizeWithFont:showTotalLab.font];
//    r.size.width += danwei2.frame.size.width;//modofiy by lincong 20140506
//    r.size.width += danwei1.frame.size.width;//modofiy by lincong 20140506
    r.origin.x = showTotalLab.superview.frame.size.width - 12.0f - r.size.width;
    
    showTotalLab.frame = r;
    
    [headViewTitle setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [headViewTitle setTextColor:[UIColor colorWithRed:181.0f/255.0f green:181.0f/255.0f blue:181.0f/255.0f alpha:1]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//返回操作
- (IBAction)backAction:(id)sender
{
    if (didBack)
    {
        didBack(self);
    }
}
//选择已结未结
- (IBAction)changeAction:(id)sender
{
    [mainView reloadData];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
    
    if (segmentedControl.selectedSegmentIndex == 0)
    {
        return [dataSource1 count];
    }
    
    return [dataSource2 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString     *cellForCategory = [[NSString alloc] initWithFormat:@"OrderedFoodCell%d", indexPath.row];
    
    OrderedFoodCell *cell = [tableView dequeueReusableCellWithIdentifier:cellForCategory];
    
    if (!cell)
    {
        cell = /*[*/[[OrderedFoodCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellForCategory] /*autorelease]*/;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if ((indexPath.row + 1) % 2 == 0)
    {
        [cell.selectImageBg setBackgroundColor:[UIColor colorWithRed:238.0f/255.0f green:239.0f/255.0f blue:240.0f/255.0f alpha:1]];
    }
    else
    {
        [cell.selectImageBg setBackgroundColor:[UIColor clearColor]];
    }
    
    OrderedFood *sub = nil;
    /*
    if (segmentedControl.selectedSegmentIndex == 0)
    {
        __block typeof(self) obj = self;
        sub = [dataSource1 objectAtIndex:indexPath.row];
        cell.didClickTuidan = ^(OrderedFood *food)//点击退单操作
        {
            obj.curFood = food;
            NSMutableArray *first = [NSMutableArray arrayWithObjects:roomId, [Public getInstance].userCode, @"1", food.foodId, food.foodName, [NSString stringWithFormat:@"-%d", [food.buyCount intValue]], @"", nil];
            NSMutableArray *dataArray = [NSMutableArray arrayWithObject:first];
            
            NSString *str = [InstructionCreate getInStruction:INS_BOOK withContents:dataArray];
            str = [str stringByReplacingCharactersInRange:NSRangeFromString([NSString stringWithFormat:@"{%d, 1}", [str length] - 1]) withString:@"||;"];
            NSLog(@"%@", str);
            NSData * data = [str dataUsingEncoding:[Public getInstance].gbkEncoding];
            [Public getInstance].juhua.labelText = @"正在退单";
            [[Public getInstance].juhua show:YES];
            [obj->tuidanRequest receiveWithTimeout:MAX_TIMEOUT tag:[INS_BOOK intValue]];
            [obj->tuidanRequest sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_BOOK intValue]];
        };
    }
    else
    {
        sub = [dataSource2 objectAtIndex:indexPath.row];
        cell.didClickTuidan = nil;
    }
    */
    sub = [dataSource objectAtIndex:indexPath.row];
    cell.curOrderFood = sub;
    cell.didClickTuidan = nil;
    
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

@end
