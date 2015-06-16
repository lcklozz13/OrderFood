//
//  MainViewController.m
//  OrderFood
//
//  Created by aplle on 7/25/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "MainViewController.h"
#import "BoxInforView.h"
#import "RoomManagerViewController.h"
#import "ShowActionViewController.h"
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(int, RoomCategory) {
    AllRoom,
    SubTitle,
    SearchRoom
};

#define TABLEVIEWCELL_DEFAULT_HEIGHT    84.0f
#define PRE_ROW_SHOW_COUNT              8

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UISearchBarDelegate>
{
    CGRect          tableViewFrame;
    AsyncUdpSocket *getRoomsSocket;//获取包厢列表请求
    AsyncUdpSocket *changeRoomsSocket;
    AsyncUdpSocket *bookAndFoodSocket;//开房定食请求
    AsyncUdpSocket *checkBooksSocket;
    NSMutableArray  *boxViewArray;//存放包厢视图
    NSMutableArray  *searchArray;//存放搜索结果
    int             showLineCount;//每行显示包厢个数
    NSMutableArray  *freeRoomList;
    IBOutlet UISearchBar *searchbar;//搜索栏
    
    IBOutlet UILabel   *kongxian;
    IBOutlet UILabel   *shiyong;
    IBOutlet UILabel   *yuding;
    IBOutlet UILabel   *shijizhong;
    IBOutlet UILabel   *weixiuzhong;
    IBOutlet UILabel   *yijie;
    
    IBOutlet UILabel   *kongxianLab;//显示空闲个数
    IBOutlet UILabel   *shiyongLab;//显示使用个数
    IBOutlet UILabel   *yudingLab;//显示预定个数
    IBOutlet UILabel   *shijizhongLab;//显示使用中个数
    IBOutlet UILabel   *weixiuzhongLab;//显示维修中个数
    IBOutlet UILabel   *yijieLab;//显示以结个数
    
    int                 kongxianCount;//空闲个数
    int                 shiyongCount;//使用个数
    int                 yudingCount;//预定个数
    int                 shijizhongCount;//使用中个数
    int                 weixiuzhongCount;//维修中个数
    int                 yijieCount;//以结个数
    NSMutableDictionary *dic;//存放搜索结果
    RoomCategory        tableviewCategory;//当前显示模式
    BOOL                isEdit;//是否在查询
    BOOL                needRefresh;//是否需要刷新
    ShowActionViewController *popview;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl   *roomCategory;
@property (nonatomic, retain) BoxInforView          *curRoomId;
@property (nonatomic, retain) IBOutlet  UITableView *tableView;
@property (nonatomic, retain) IBOutlet  UIView      *headView;
@property (nonatomic, retain) InstructionParse      *curParse;
@property (nonatomic, retain) NSTimer               *refreshTimer;
- (void)colseAction:(id)sender;//返回操作
- (IBAction)valueChange:(id)sender;//选择不同的类别
- (void)getRoomList;//获得房间列表
- (void)bookAndFoodAction;//开房定食操作
- (void)checkBookAction;
- (void)changeRoom;
@end

@implementation MainViewController
@synthesize curRoomId;
@synthesize tableView;
@synthesize curParse;
@synthesize headView;
@synthesize roomCategory;
@synthesize refreshTimer;

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
    //初始化界面
    // Do any additional setup after loading the view from its nib.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    tableViewFrame = CGRectZero;
    dic = [[NSMutableDictionary alloc] init];
    searchArray = [[NSMutableArray alloc] init];
    
    tableView.layer.masksToBounds = YES;
    tableView.layer.cornerRadius = 6.0;
    tableView.layer.borderWidth = 1.0;
    tableView.layer.borderColor = [[UIColor clearColor] CGColor];
    tableView.clipsToBounds = YES;
    [tableView setBackgroundColor:[UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1]];
    [headView setBackgroundColor:[UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1]];
    
    self.title = @"包厢列表";
    [self.view setBackgroundColor:[UIColor clearColor]];
    //返回按钮
    UIButton *btnL = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnL setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    [btnL addTarget:self action:@selector(colseAction:) forControlEvents:UIControlEventTouchUpInside];
    CGRect r = btnL.frame;
    r.origin = CGPointZero;
    r.size = CGSizeMake(35, 50);
    btnL.frame = r;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnL];
    self.navigationItem.leftBarButtonItem = item;
    //    [item release];
    //刷新按钮
    btnL = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnL setImage:[UIImage imageNamed:@"icon_refresh.png"] forState:UIControlStateNormal];
    [btnL addTarget:self action:@selector(getRoomList) forControlEvents:UIControlEventTouchUpInside];
    r = btnL.frame;
    r.origin = CGPointZero;
    r.size = CGSizeMake(35, 50);
    btnL.frame = r;
    
    item = [[UIBarButtonItem alloc] initWithCustomView:btnL];
    self.navigationItem.rightBarButtonItem = item;
    //    [item release];
    //搜索栏
    for (UIView *view in [searchbar subviews])
    {
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [view removeFromSuperview];
        }
        
        [view setBackgroundColor:[UIColor clearColor]];
    }
    [searchbar setBackgroundColor:[UIColor clearColor]];
    //使用、预定、空闲、维修、使用中图标初始化
    [shiyong setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mark_using.png"]]];
    [yuding setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mark_order.png"]]];
    [kongxian setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mark_free.png"]]];
    [shijizhong setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mark_test.png"]]];
    [weixiuzhong setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mark_fix.png"]]];
    [yijie setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mark_over.png"]]];
    
    boxViewArray = [[NSMutableArray alloc] init];
    freeRoomList = [[NSMutableArray alloc] init];
    showLineCount = PRE_ROW_SHOW_COUNT;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    getRoomsSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    changeRoomsSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    bookAndFoodSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    checkBooksSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    tableviewCategory = AllRoom;
    //点击操作
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    //    [tap release];
    isEdit = YES;
    needRefresh = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardWillShowNotification object:nil];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasHidden:)
												 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设定定时器、每15秒刷新列表
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(getRoomListInBackground) userInfo:nil repeats:YES];
    
    if (needRefresh)
    {
        [self getRoomList];
    }
    else
    {
        [refreshTimer fire];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //停止定时器
    if ([refreshTimer isValid])
    {
        [refreshTimer invalidate];
    }
}

- (void)tap
{
    //点击列表操作
    if ([searchbar canResignFirstResponder])
    {
        [searchbar resignFirstResponder];
        [searchbar setShowsCancelButton:NO animated:NO];
    }
}
//后台刷新列表
- (void)getRoomListInBackground
{
    NSString *str = [InstructionCreate getInStruction:INS_GET_ROOM_LIST withContents:nil];
    NSData * data = [str dataUsingEncoding:[Public getInstance].gbkEncoding];
    [getRoomsSocket receiveWithTimeout:MAX_TIMEOUT tag:[INS_GET_ROOM_LIST intValue]];
    [getRoomsSocket sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_GET_ROOM_LIST intValue]];
}
//请求列表
- (void)getRoomList
{
    [searchbar resignFirstResponder];
    [searchbar setShowsCancelButton:NO];
    NSString *str = [InstructionCreate getInStruction:INS_GET_ROOM_LIST withContents:nil];
    NSData * data = [str dataUsingEncoding:[Public getInstance].gbkEncoding];
    [Public getInstance].juhua.labelText = @"正在获取包厢列表";
    [[Public getInstance].juhua show:YES];
    [getRoomsSocket receiveWithTimeout:MAX_TIMEOUT tag:[INS_GET_ROOM_LIST intValue]];
    [getRoomsSocket sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_GET_ROOM_LIST intValue]];
}
//开房定食操作
- (void)bookAndFoodAction
{
    NSString *str = [InstructionCreate getInStruction:INS_ROOM_BOOK withContents:[NSMutableArray arrayWithObjects:curRoomId.roomId, nil]];
    NSData * data = [str dataUsingEncoding:[Public getInstance].gbkEncoding];
    [Public getInstance].juhua.labelText = @"开房定食";
    [[Public getInstance].juhua show:YES];
    [bookAndFoodSocket receiveWithTimeout:MAX_TIMEOUT tag:[INS_ROOM_BOOK intValue]];
    [bookAndFoodSocket sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_ROOM_BOOK intValue]];
}

- (void)checkBookAction
{
    NSString *str = [InstructionCreate getInStruction:INS_CHECK_ORDER withContents:[NSMutableArray arrayWithObjects:curRoomId.roomId, nil]];
    NSLog(@"%@", str);
    NSData * data = [str dataUsingEncoding:[Public getInstance].gbkEncoding];
    [Public getInstance].juhua.labelText = @"查单";
    [[Public getInstance].juhua show:YES];
    [checkBooksSocket receiveWithTimeout:MAX_TIMEOUT tag:[INS_CHECK_ORDER intValue]];
    [checkBooksSocket sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_CHECK_ORDER intValue]];
}

- (void)changeRoom
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSMutableArray *sub in curParse.contents)
    {
        if ([sub count] == 5)
        {
            if ([[sub objectAtIndex:2] isEqualToString:@"K"] && ![[sub objectAtIndex:1] isEqualToString:curRoomId.roomId])
            {
                [array addObject:sub];
            }
        }
        else if ([sub count] == 4)
        {
            if ([[sub objectAtIndex:1] isEqualToString:@"K"] && ![[sub objectAtIndex:0] isEqualToString:curRoomId.roomId])
            {
                [array addObject:sub];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
    {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
    else
    {
        return (interfaceOrientation == UIDeviceOrientationPortrait);
    }
}
//返回操作
- (void)colseAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}
//改变当前模式
- (IBAction)valueChange:(id)sender
{
    //    [searchbar setText:@""];
    [searchbar resignFirstResponder];
    [searchbar setShowsCancelButton:NO animated:NO];
    
    if (roomCategory.selectedSegmentIndex == 0)
    {
        tableviewCategory = AllRoom;
    }
    else
    {
        tableviewCategory = SubTitle;
    }
    
    for (BoxInforView *view in boxViewArray)
    {
        [view removeFromSuperview];
    }
    
    [tableView reloadData];
}

- (void)showPopView:(BoxInforView *)view
{
    //弹出包厢操作界面
    popview = [[ShowActionViewController alloc] initWithBoxInforView:view];
    
    CGRect r = [UIScreen mainScreen].bounds;
    popview.view.transform = CGAffineTransformMakeRotation([[Public getInstance] statubarUIInterfaceOrientationAngleOfOrientation]);
    popview.view.center = CGPointMake(r.size.width/2.0f, r.size.height/2.0f);
    __block typeof(self) obj = self;
    popview.backAction = ^(ShowActionViewController *controller)//返回操作
    {
        [controller.view removeFromSuperview];
    };
    
    popview.bookRoom = ^(ShowActionViewController *controller)//开房操作
    {
        [obj bookAndFoodAction];
    };
    
    popview.memberOrderFood =  ^(ShowActionViewController *controller)//会员订餐操作
    {
        [obj bookAndFoodAction];
    };
    
    popview.orderFood = ^(ShowActionViewController *controller)//订餐操作
    {
        [obj bookAndFoodAction];
    };
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:popview.view];
    
    self.curRoomId = view;
}

//点击包厢视图回调函数
- (void)clickCellRoom:(BoxInforView *)view
{
    if ([view.leaveTime intValue] < 30*60)
    {
        self.curRoomId = view;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前包厢使用时间快要结束，是否继续点餐" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 10010;
        [alert show];
        
        
        return;
    }
    else
    {
        [self showPopView:view];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10010)
    {
        return;
    }
    
    if (buttonIndex == 1)
    {
        //开房
        [self bookAndFoodAction];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10010 && buttonIndex == 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self performSelectorOnMainThread:@selector(showPopView:) withObject:curRoomId waitUntilDone:NO];
        });
    }
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //转房
            [self changeRoom];
        }
            break;
            
        case 1:
        {
            //点餐
            [self bookAndFoodAction];
        }
            break;
            
        case 2:
        {
            //查单
            [self checkBookAction];
        }
            break;
            
        default:
            break;
    }
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
    if (tag == [INS_GET_ROOM_LIST intValue])//获取包厢列表
    {
        if ([str length] == 0)
        {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"获取包厢列表失败" message:@"获取包厢列表失败，稍后请重试。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [view show];
            //            [view release];
        }
        else
        {
            InstructionParse *parse = [[InstructionParse alloc] initWithInstructionString:[[Public getComponentsSeparated:str] objectAtIndex:1]];
            NSLog(@"%@", parse.instruction);
            NSLog(@"%@", parse.contents);
            self.curParse = parse;
            //            [parse release];
            int index = 0;
            //            __block typeof(self) ob = self;
            kongxianCount = 0;
            shiyongCount = 0;
            yudingCount = 0;
            shijizhongCount = 0;
            weixiuzhongCount = 0;
            yijieCount = 0;
            
            for (NSString *key in [dic allKeys])
            {
                NSArray *array = [dic objectForKey:key];
                for (UIView *view in array)
                {
                    [view removeFromSuperview];
                }
            }
            
            [dic removeAllObjects];
            
            for (UIView *subView in boxViewArray)
            {
                [subView removeFromSuperview];
            }
            
            [boxViewArray removeAllObjects];
            
            for (BoxInforView *view in searchArray)
            {
                [view removeFromSuperview];
            }
            
            [searchArray removeAllObjects];
            
            for (NSMutableArray *sub in curParse.contents)
            {
                BoxInforView *view = [[BoxInforView alloc] initWithBoxCellInfor:sub frame:CGRectMake(0, 0, /*77.5*/120, /*64*/84)];
                view.index = index++;
                
                [boxViewArray addObject:view];
                
                NSMutableArray *array = [dic objectForKey:view.category];
                
                if (!array)
                {
                    array = [NSMutableArray arrayWithObject:view];
                    [dic setValue:array forKey:view.category];
                }
                else
                {
                    [array addObject:view];
                }
                
                if ([view.code isEqualToString:@"U"])//U使用
                {
                    shiyongCount++;
                }
                else if ([view.code isEqualToString:@"D"])//Z整理20140823，服务端改D为预定
                {
                    yudingCount++;
                }
                else if ([view.code isEqualToString:@"K"])//K空闲
                {
                    kongxianCount++;
                }
                else if ([view.code isEqualToString:@"S"])//试机中
                {
                    shijizhongCount++;
                }
                else if ([view.code isEqualToString:@"W"])//维修中
                {
                    weixiuzhongCount++;
                }
                else if ([view.code isEqualToString:@"Y"])//以结
                {
                    yijieCount++;
                }
                
                [view addTarget:self action:@selector(clickCellRoom:) forControlEvents:UIControlEventTouchDown];
                //                [view release];
            }
            
            [roomCategory removeAllSegments];
            [roomCategory insertSegmentWithTitle:@"全部" atIndex:0 animated:NO];
            
            NSArray *allkey = [dic allKeys];
            int segmentIndex = 1;
            
            for (NSString *category in allkey)
            {
                [roomCategory insertSegmentWithTitle:category atIndex:segmentIndex++ animated:NO];
            }
            
            [roomCategory setSelectedSegmentIndex:0];
            
            [kongxianLab setText:[NSString stringWithFormat:@"%d", kongxianCount]];
            [shiyongLab setText:[NSString stringWithFormat:@"%d", shiyongCount]];
            [yudingLab setText:[NSString stringWithFormat:@"%d", yudingCount]];
            [shijizhongLab setText:[NSString stringWithFormat:@"%d", shijizhongCount]];
            [weixiuzhongLab setText:[NSString stringWithFormat:@"%d", weixiuzhongCount]];
            [yijieLab setText:[NSString stringWithFormat:@"%d", yijieCount]];
            
            [tableView reloadData];
        }
    }
    else if (tag == [INS_ROOM_BOOK intValue])//开房定食操作
    {
        if ([str length] == 0)
        {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"开房定食失败" message:@"开房定食操作失败，稍后请重试。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [view show];
            //            [view release];
        }
        else
        {
            InstructionParse *parse = [[InstructionParse alloc] initWithInstructionString:[[Public getComponentsSeparated:str] objectAtIndex:1]];
            NSLog(@"%@", parse.instruction);
            NSLog(@"%@", parse.contents);
            if (parse)
            {
                curRoomId.code = @"U";
                [searchbar resignFirstResponder];
                [searchbar setShowsCancelButton:NO animated:NO];
                
                RoomManagerViewController *view = [[RoomManagerViewController alloc] initBookedFood:parse roomid:curRoomId.roomId roomName:curRoomId.title];
                [self.navigationController pushViewController:view animated:NO];
                //                [view release];
            }
            //            [parse release];
        }
    }
    else if (tag == [INS_CHANGE_ROOM intValue])
    {
        
    }
    else if (tag == [INS_CHECK_ORDER intValue])
    {
        if ([str length] == 0)
        {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"查单失败" message:@"查单失败，稍后请重试。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [view show];
            //            [view release];
        }
        else
        {
            InstructionParse *parse = [[InstructionParse alloc] initWithInstructionString:[[Public getComponentsSeparated:str] objectAtIndex:1]];
            NSLog(@"%@", parse.instruction);
            NSLog(@"%@", parse.contents);
            //            [parse release];
        }
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

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    
    if (tableviewCategory == SubTitle)
    {
        count = [[dic objectForKey:[roomCategory titleForSegmentAtIndex:roomCategory.selectedSegmentIndex]] count];
    }
    else if (tableviewCategory == SearchRoom)
    {
        count = [searchArray count];
    }
    else
    {
        count = [boxViewArray count];
    }
    
    if (count % showLineCount == 0)
    {
        count /= showLineCount;
    }
    else
    {
        count = count / showLineCount + 1;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifies = [NSString stringWithFormat:@"cell%d", indexPath.row];
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifies];
    
    if (!cell)
    {
        cell = /*[*/[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifies] /*autorelease]*/;
        [cell setBackgroundColor:[UIColor clearColor]];
        UIView *bg = /*[*/[[UIView alloc] initWithFrame:cell.bounds] /*autorelease]*/;
        [bg setBackgroundColor:[UIColor clearColor]];
        [cell setSelectedBackgroundView:bg];
    }
    
    NSArray *curShowArray = nil;
    
    if (tableviewCategory == SubTitle)
    {
        curShowArray = [dic objectForKey:[roomCategory titleForSegmentAtIndex:roomCategory.selectedSegmentIndex]];
    }
    else if (tableviewCategory == SearchRoom)
    {
        curShowArray = searchArray;
    }
    else
    {
        curShowArray = boxViewArray;
    }
    
    int count = [curShowArray count];
    
    BOOL  divisibility = NO;
    
    if (count % showLineCount == 0)
    {
        count /= showLineCount;
        divisibility = YES;
    }
    else
    {
        count = count / showLineCount + 1;
    }
    
    BoxInforView *view = [curShowArray objectAtIndex:0];
    float start_x = 0;
    float dev = (self.tableView.frame.size.width - (view.bounds.size.width * showLineCount)) / (1.0f * (showLineCount + 1));
    float height = (TABLEVIEWCELL_DEFAULT_HEIGHT - view.frame.size.height) / 2.0f;
    start_x = dev;
    
    if (indexPath.row == count - 1 && !divisibility)
    {
        for (int i = indexPath.row * showLineCount; i < [curShowArray count]; i++)
        {
            BoxInforView *view = [curShowArray objectAtIndex:i];
            CGRect r = view.frame;
            r.origin.x = start_x;
            r.origin.y = height;
            view.frame = r;
            [cell addSubview:view];
            start_x += (view.frame.size.width + dev);
        }
    }
    else
    {
        for (int i=0; i<showLineCount; i++)
        {
            BoxInforView *view = [curShowArray objectAtIndex:i + indexPath.row * showLineCount];
            CGRect r = view.frame;
            r.origin.x = start_x;
            r.origin.y = height;
            view.frame = r;
            [cell addSubview:view];
            start_x += (view.frame.size.width + dev);
        }
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLEVIEWCELL_DEFAULT_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return headView.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return headView;
}

- (void)dealloc
{
    [searchArray removeAllObjects];
    //    [searchArray release],
    searchArray = nil;
    [dic removeAllObjects];
    //    [dic release],
    dic = nil;
    [boxViewArray removeAllObjects];
    //    [boxViewArray release],
    boxViewArray = nil;
    getRoomsSocket.delegate = nil;
    //    [getRoomsSocket release];
    getRoomsSocket = nil;
    changeRoomsSocket.delegate = nil;
    //    [changeRoomsSocket release],
    changeRoomsSocket = nil;
    bookAndFoodSocket.delegate = nil;
    //    [bookAndFoodSocket release],
    bookAndFoodSocket = nil;
    checkBooksSocket.delegate = nil;
    //    [checkBooksSocket release],
    checkBooksSocket = nil;
    [freeRoomList removeAllObjects];
    //    [freeRoomList release],
    freeRoomList = nil;
    
    if ([refreshTimer isValid])
    {
        [refreshTimer invalidate];
    }
    
    self.refreshTimer = nil;
    
    self.curParse = nil;
    self.tableView = nil;
    self.headView = nil;
    self.curRoomId = nil;
    self.roomCategory = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //    [super dealloc];
}

#pragma mark - keyboard Notifications callback
//键盘显示，根据键盘高度调整tableView高度
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (CGRectEqualToRect(tableViewFrame, CGRectZero))
    {
        tableViewFrame = tableView.frame;
    }
    
    NSDictionary* info = [aNotification userInfo];
	
    // Get the size of the keyboard.
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    float keyboardheight = keyboardSize.height > keyboardSize.width ? keyboardSize.width : keyboardSize.height;
    keyboardheight -= 20;
    CGRect r = tableViewFrame;
    r.size.height -= keyboardheight;
    
    [UIView beginAnimations:nil context:nil];
    //setAnimationCurve来定义动画加速或减速方式
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.2]; //动画时长
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    // operation>>>
    tableView.frame = r;
    // end<<<<<
    [UIView commitAnimations];
}

//键盘隐藏，根据键盘高度调整tableView高度
// Called when the UIKeyboardDidHideNotification is sent
- (void)keyboardWasHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
	
    // Get the size of the keyboard.
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    float keyboardheight = keyboardSize.height > keyboardSize.width ? keyboardSize.width : keyboardSize.height;
    keyboardheight -= 20;
    CGRect r = tableView.frame;
    r.size.height += keyboardheight;
    tableView.frame = r;
}

#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (!searchbar.showsCancelButton)
    {
        [searchbar setShowsCancelButton:YES animated:YES];
        [searchArray removeAllObjects];
    }
    
    [searchbar setText:@""];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if ([searchbar.text length] == 0)
    {
        [searchArray removeAllObjects];
        [searchbar setShowsCancelButton:NO animated:YES];
        
        if (roomCategory.selectedSegmentIndex ==  0)
        {
            tableviewCategory = AllRoom;
        }
        else
        {
            tableviewCategory = SubTitle;
        }
        
        for (BoxInforView *view in boxViewArray)
        {
            [view removeFromSuperview];
        }
        
        [tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    //    [searchbar setText:@""];
    [searchbar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    tableviewCategory = SearchRoom;
    [searchArray removeAllObjects];
    
    for (BoxInforView *view in boxViewArray)
    {
        [view removeFromSuperview];
        NSString *str = [NSString stringWithFormat:@"%@%@", view.roomId, view.title];
        
        BOOL isMember = NO;
        
        for (int j=0; j<[searchText length]; j++)
        {
            unichar char1 = [searchText characterAtIndex:j];
            if ([str rangeOfString:[NSString stringWithFormat:@"%c", char1]].location != NSNotFound)
            {
                isMember = YES;
            }
            else
            {
                isMember = NO;
                break;
            }
        }
        
        if (isMember)
        {
            [searchArray addObject:view];
        }
    }
    
    isEdit = NO;
    [tableView reloadData];
    isEdit = YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return isEdit;
}
@end
