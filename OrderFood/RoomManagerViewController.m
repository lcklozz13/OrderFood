//
//  RoomManagerViewController.m
//  OrderFood
//
//  Created by aplle on 8/3/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "RoomManagerViewController.h"
#import "SelectedListViewController.h"
#import "FoodCategoryObject.h"
#import "FoodCategoryCell.h"
#import "FoodListCell.h"
#import "FoodPictureView.h"
#import "MBProgressHUD.h"
#import "HCSwitch.h"
#import "CheckUserViewController.h"
#import "ShowBookFoodListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "OrderedFood.h"
#import "TaoCanMingxi.h"


@interface RoomManagerViewController ()<UITableViewDataSource, UITableViewDelegate, AsyncUdpSocketDelegate, UISearchBarDelegate>
{
    CGRect          detailListViewFrame;
    AsyncUdpSocket  *getCategory;//获取食物类别
    AsyncUdpSocket  *getFoodList;//获取食物列表
    AsyncUdpSocket  *bookRequest;//下单操作
    AsyncUdpSocket  *bookAndFoodSocket;//查询已点清单
    AsyncUdpSocket  *checkRoomIDSocket;//查询已点清单
    NSMutableArray  *foodCategoryArray;//存放类别数据源
    NSMutableArray  *bookedArray;//存放已选列表
    NSMutableArray  *foodPictureViewArray;//存放食物view
    NSMutableArray  *searchArray;//存放搜索结果
    BOOL            isListStyple;//是否是列表模式
    BOOL            tableviewCategory;//是否是搜索模式
    BOOL            isEdit;//是否在操作搜索栏
    NSMutableDictionary *orderedFoodDic;//存放已预定
    SelectedListViewController          *selectedview;
    CheckUserViewController             *checkview;
    ShowBookFoodListViewController      *showBookListView;
}
@property (nonatomic, retain) SelectedListViewController*curSelectView;//显示已选列表
@property (nonatomic, retain) NSMutableArray            *bookedArray;
@property (nonatomic, retain) UILabel                   *showModelLab;
@property (nonatomic, retain) UITextField               *showTotalLab;
@property (nonatomic, retain) IBOutlet UITableView      *categoryListView;//类别list
@property (nonatomic, retain) IBOutlet UITableView      *detailListView;//类别对应的食物list
@property (nonatomic, retain) InstructionParse          *curBook;//当前的房间
@property (nonatomic, retain) InstructionParse          *curFoodCategroy;//当前类别
@property (nonatomic, retain) InstructionParse          *curFoodList;//当前食物列表
@property (nonatomic, retain) NSString                  *roomId;//房间id
@property (nonatomic, retain) NSString                  *roomName;//房间名称
@property (nonatomic, retain) IBOutlet UIToolbar        *myToobar;//底部工具栏
@property (nonatomic, retain) FoodCategoryObject        *curFoodCategoryObject;//当前类别对象
@property (nonatomic, retain) FoodObject                *curFoodObject;//当前食物对象
@property (nonatomic, retain) IBOutlet UIView           *bgView;//背景
@property (nonatomic, retain) IBOutlet UIView           *headView;//tableview的headview
@property (nonatomic, retain) IBOutlet UISearchBar      *searchbar;//搜索栏
@property (nonatomic, retain) IBOutlet UIImageView      *bgImageView;//背景图

@property (nonatomic, retain) NSMutableArray            *searchDataSource;

- (void)getGoodCategorySocketAction;//获得类别操作
- (void)getGoodListAction:(NSString *)foodCategory;//获得类别id为foodCategory的食物列表
- (void)closeAction:(id)sender;//返回操作
@end

@implementation RoomManagerViewController
@synthesize categoryListView;
@synthesize detailListView;
@synthesize curBook;
@synthesize roomId;
@synthesize curFoodCategroy;
@synthesize curFoodList;
@synthesize roomName;
@synthesize showModelLab;
@synthesize myToobar;
@synthesize showTotalLab;
@synthesize curFoodCategoryObject;
@synthesize bookedArray;
@synthesize curFoodObject;
@synthesize curSelectView;
@synthesize bgView;
@synthesize headView;
@synthesize searchbar;
@synthesize bgImageView;
@synthesize searchDataSource;

- (void)dealloc
{
    self.curSelectView = nil;
    self.showModelLab = nil;
    self.categoryListView = nil;
    self.detailListView = nil;
    self.curBook = nil;
    self.roomId = nil;
    self.curFoodCategroy = nil;
    self.curFoodList = nil;
    self.roomName = nil;
    self.myToobar = nil;
    self.showTotalLab = nil;
    self.curFoodCategoryObject = nil;
    self.curFoodObject = nil;
    self.bgView = nil;
    self.headView = nil;
    self.searchbar = nil;
    self.bgImageView = nil;
    self.searchDataSource = nil;
    
    bookAndFoodSocket.delegate = nil;
//    [bookAndFoodSocket release],
    bookAndFoodSocket = nil;
    [orderedFoodDic removeAllObjects];
//    [orderedFoodDic release],
    orderedFoodDic = nil;
    [searchArray removeAllObjects];
//    [searchArray release],
    searchArray = nil;
    
    [foodCategoryArray makeObjectsPerformSelector:@selector(closeSocket)];
    [foodCategoryArray removeAllObjects];
//    [foodCategoryArray release],
    foodCategoryArray = nil;
//    [bookedArray removeAllObjects];
//    [bookedArray release],
    bookedArray = nil;
    [foodPictureViewArray removeAllObjects];
//    [foodPictureViewArray release],
    foodPictureViewArray = nil;
    
    if (![getCategory isClosed])
        [getCategory close];
    getCategory.delegate = nil;
//    [getCategory release],
    getCategory = nil;
    if (![getFoodList isClosed])
        [getFoodList close];
    getFoodList.delegate = nil;
//    [getFoodList release],
    getFoodList = nil;
    if (![bookRequest isClosed])
        [bookRequest close];
    bookRequest.delegate = nil;
//    [bookRequest release],
    bookRequest = nil;
    if (![bookAndFoodSocket isClosed])
        [bookAndFoodSocket close];
    bookAndFoodSocket.delegate = nil;
//    [bookAndFoodSocket release],
    bookAndFoodSocket = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    selectedview = nil;
    checkview = nil;
    showBookListView = nil;
    
//    [super dealloc];
}
//键盘显示回调函数
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (CGRectEqualToRect(detailListViewFrame, CGRectZero))
    {
        detailListViewFrame = detailListView.frame;
    }
    
    //获得高度，重新设置detailListView的高度
    NSDictionary* info = [aNotification userInfo];
	
    // Get the size of the keyboard.
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    float keyboardheight = keyboardSize.height > keyboardSize.width ? keyboardSize.width : keyboardSize.height;
    keyboardheight -= 62;
    CGRect r = detailListViewFrame;
    r.size.height -= keyboardheight;
    
    [UIView beginAnimations:nil context:nil];
    //setAnimationCurve来定义动画加速或减速方式
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.2]; //动画时长
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    // operation>>>
    detailListView.frame = r;
    // end<<<<<
    [UIView commitAnimations];
}

//键盘隐藏回调函数
// Called when the UIKeyboardDidHideNotification is sent
- (void)keyboardWasHidden:(NSNotification*)aNotification
{
    //获得高度，重新设置detailListView的高度
    NSDictionary* info = [aNotification userInfo];
	
    // Get the size of the keyboard.
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    float keyboardheight = keyboardSize.height > keyboardSize.width ? keyboardSize.width : keyboardSize.height;
    keyboardheight -= 62;
    CGRect r = detailListView.frame;
    r.size.height += keyboardheight;
    detailListView.frame = r;
}

- (id)initBookedFood:(InstructionParse *)paser1 roomid:(NSString *)roonid roomName:(NSString *)name
{
    self = [super init];
    
    if (self)
    {
        self.curBook = paser1;
        self.roomId = roonid;
        self.roomName = name;
        searchArray = [[NSMutableArray alloc] init];
        orderedFoodDic = [[NSMutableDictionary alloc] init];
        searchDataSource = [[NSMutableArray alloc] init];
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

- (void)checkRoomID
{
    NSString *str = [InstructionCreate getInStruction:INS_BX_ZT withContents:[NSMutableArray arrayWithObject:[NSMutableArray arrayWithObjects:roomId, nil]]];
    
    NSData * data = [str dataUsingEncoding:[Public getInstance].gbkEncoding];
    [Public getInstance].juhua.labelText = @"查询房间状态。。。";
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[Public getInstance].juhua show:YES];
    });
    
    if (checkRoomIDSocket)
    {
        checkRoomIDSocket = nil;
        checkRoomIDSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    }
    
    [checkRoomIDSocket receiveWithTimeout:MAX_TIMEOUT tag:[INS_BX_ZT intValue]];
    [checkRoomIDSocket sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_BX_ZT intValue]];

}

- (void)viewDidLoad
{
    //初始化界面
    [super viewDidLoad];
    
    if ([[[Public getCurrentDeviceModel] lowercaseString] rangeOfString:@"mini"].location != NSNotFound)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CGRect frame = categoryListView.frame;
            frame.origin.x += 150;
            frame.origin.y += 130;
            
            categoryListView.frame = frame;
            
            frame = detailListView.frame;
            frame.origin.x += 150;
            frame.origin.y += 130;
            detailListView.frame = frame;
            
            frame = bgView.frame;
            frame.origin.x += 130;
            frame.origin.y += 150;
            bgView.frame = frame;
            
            frame = searchbar.frame;
            frame.origin.x += 130;
            frame.origin.y += 150;
            searchbar.frame = frame;
        });
    }
    
    // Do any additional setup after loading the view from its nib.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6.0;
    bgView.layer.borderWidth = 1.0;
    bgView.layer.borderColor = [[UIColor clearColor] CGColor];
    bgView.clipsToBounds = YES;
    
    detailListViewFrame = CGRectZero;
    tableviewCategory = NO;
    isEdit = YES;
    //左边列表背景
    UIImage *im = [UIImage imageNamed:@"mnu_left.png"];
    [bgImageView setImage:[im stretchableImageWithLeftCapWidth:im.size.width/2.0f topCapHeight:im.size.height/2.0f]];
    
    for (UIView *view in [searchbar subviews])
    {
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [view removeFromSuperview];
        }
        
        [view setBackgroundColor:[UIColor clearColor]];
    }
    [searchbar setBackgroundColor:[UIColor clearColor]];
    
    [headView setBackgroundColor:[UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1]];
    
    [categoryListView setBackgroundColor:/*[UIColor colorWithRed:237.0f/255.0f green:236.0f/255.0f blue:235.0f/255.0f alpha:1]*/[UIColor clearColor]];
    
    [detailListView setBackgroundColor:[UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1]];
    [categoryListView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line_mnu.png"]]];//类别列表分割线
    [detailListView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [detailListView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line_list.png"]]];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    foodCategoryArray = [[NSMutableArray alloc] init];
//MARK:Fixed by 2014-7-29 从bookHistoryDictionary里面取数据
    bookedArray = [[Public getInstance].bookHistoryDictionary objectForKey:roomId];
    if (!bookedArray) {
        [[Public getInstance].bookHistoryDictionary setObject:[NSMutableArray array] forKey:roomId];
        bookedArray = [[Public getInstance].bookHistoryDictionary objectForKey:roomId];
    }

    foodPictureViewArray = [[NSMutableArray alloc] init];
#if IS_DEMO_STYLE
    self.title = [[NSString alloc] initWithFormat:@"点餐-%@包厢（预览版）", roomName];//标题
#else
    self.title = [[NSString alloc] initWithFormat:@"点餐-%@包厢", roomName];//标题
#endif
    
    UIButton *btnL = [UIButton buttonWithType:UIButtonTypeCustom];//返回按钮
    [btnL setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    [btnL addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    CGRect r = btnL.frame;
    r.origin = CGPointZero;
    r.size = CGSizeMake(35, 50);
    btnL.frame = r;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnL];
    self.navigationItem.leftBarButtonItem = item;
//    [item release];
    //显示模式
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 35)];
    [view setBackgroundColor:[UIColor clearColor]];
    showModelLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 71, 21)];
    [showModelLab setBackgroundColor:[UIColor clearColor]];
    [showModelLab setText:@"列表模式"];
    [showModelLab setFont:[UIFont boldSystemFontOfSize:showModelLab.font.pointSize]];
    [showModelLab setTextColor:[UIColor lightGrayColor]];
    [view addSubview:showModelLab];
    
    //切换模式按钮
    HCSwitch *sw = [[HCSwitch alloc] initWithOnImage:[UIImage imageNamed:@"checkbox_on.png"] offImage:[UIImage imageNamed:@"checkbox_off.png"]];
    sw.frame = CGRectMake(71, 4, 77, 27);
    sw.isOn = YES;
    [sw addTarget:self action:@selector(changeTableViewStype:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:sw];
//    [sw release];
    
    item = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = item;
//    [item release];
//    [view release];
    //构造底下工具栏
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];//已定食物
    btn.frame = CGRectMake(0, 0, 100, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_curList.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showSelectedList) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *seletedList = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIBarButtonItem *fixedbtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //总共金额
    showTotalLab = [[UITextField alloc] init];
    [showTotalLab setBackgroundColor:[UIColor clearColor]];
    [showTotalLab setText:@"￥0.0"];
    [showTotalLab setTextColor:[UIColor colorWithRed:177.0f/255.0f green:150.0f/255.0f blue:2.0f/255.0f alpha:1]];
    showTotalLab.frame = CGRectMake(0, 0, 100, 35);
    showTotalLab.leftViewMode = UITextFieldViewModeAlways;
    [showTotalLab setEnabled:NO];
    [showTotalLab setFont:[UIFont boldSystemFontOfSize:26.0f]];
    [showTotalLab setUserInteractionEnabled:NO];
    UILabel *lab = [[UILabel alloc] init];
    [lab setText:@"共:"];
    [lab setBackgroundColor:[UIColor clearColor]];
    [lab setTextColor:[UIColor colorWithRed:177.0f/255.0f green:150.0f/255.0f blue:2.0f/255.0f alpha:1]];
    [lab setFont:[UIFont boldSystemFontOfSize:16.0f]];
    lab.frame = CGRectMake(0, 30, 30, 23);
    showTotalLab.leftView =lab;
//    [lab release];
    //已选列表
    UIBarButtonItem *showTotal = [[UIBarButtonItem alloc] initWithCustomView:showTotalLab];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 100, 30);
    [btn1 setBackgroundImage:[UIImage imageNamed:@"btn_list.png"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(showSelected) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *selected = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    //下单
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, 0, 100, 30);
    [btn2 setBackgroundImage:[UIImage imageNamed:@"btn_order.png"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(checkUser) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *order = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    
    [myToobar setItems:[NSArray arrayWithObjects:seletedList, fixedbtn, showTotal, selected, order, nil]];
//    [seletedList release];
//    [order release];
//    [selected release];
//    [showTotal release];
//    [fixedbtn release];
    
    if ([bookedArray count] > 0) {
        float total = 0.0f;
        
        for (FoodObject *food in self.bookedArray)
        {
            food.ischeck = NO;
            total += [food.price floatValue] * food.bookCount;
        }
        
        [self.showTotalLab setText:[[NSString alloc] initWithFormat:@"￥%.0f", total]];
        CGRect r = self.showTotalLab.frame;
        r.size.width = (30 + [self.showTotalLab.text sizeWithFont:self.showTotalLab.font].width);
        self.showTotalLab.frame = r;
    }
    
    detailListView.tableFooterView = /*[*/[[UIView alloc] initWithFrame:CGRectZero] /*autorelease]*/;
    categoryListView.tableFooterView = /*[*/[[UIView alloc] initWithFrame:CGRectZero] /*autorelease]*/;
    getCategory = [[AsyncUdpSocket alloc] initWithDelegate:self];
    getFoodList = [[AsyncUdpSocket alloc] initWithDelegate:self];
    bookRequest = [[AsyncUdpSocket alloc] initWithDelegate:self];
    bookAndFoodSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    checkRoomIDSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    [self checkRoomID];
//    [self getGoodCategorySocketAction];//获得食物类别
    isListStyple = YES;
    [myToobar setBackgroundImage:[UIImage imageNamed:@"b_footer.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
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
}
//显示已选列表
- (void)showSelected
{
    __block typeof(self) obj = self;
    selectedview = [[SelectedListViewController alloc] initWithSelectArray:bookedArray];
    CGRect r = [UIScreen mainScreen].bounds;
//    view.view.frame = r;
    selectedview.view.transform = CGAffineTransformMakeRotation([[Public getInstance] statubarUIInterfaceOrientationAngleOfOrientation]);
    selectedview.view.center = CGPointMake(r.size.width/2.0f, r.size.height/2.0f);
    //下单回调块
    selectedview.didBook = ^(SelectedListViewController *controller)
    {
        /*
        [controller.view removeFromSuperview];
        [self orderAction];
        obj.curSelectView = nil;
        float total = 0.0f;
        
        for (FoodObject *food in obj.bookedArray)
        {
            total += [food.price floatValue] * food.bookCount;
        }
        
        [obj.showTotalLab setText:[NSString stringWithFormat:@"￥%.0f", total]];
        CGRect r = obj.showTotalLab.frame;
        r.size.width = (30 + [obj.showTotalLab.text sizeWithFont:obj.showTotalLab.font].width);
        obj.showTotalLab.frame = r;
         */
        int count = [obj->bookedArray count];
        //没有选择食物
        if (count == 0)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"您还没有点菜，请选择需要的菜然后在点击下单。";
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:NO afterDelay:2];
            return;
        }
        
        /****************************/
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否提交点餐" delegate:obj cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 10010;
        [alert show];
        return;
        /****************************/
//        __block typeof(obj) ob1 = obj;
//        //显示校验界面
//        obj->checkview = [[CheckUserViewController alloc] init];
//        [obj->checkview.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
//        CGRect r = [UIScreen mainScreen].bounds;
//        obj->checkview.view.transform = CGAffineTransformMakeRotation([[Public getInstance] statubarUIInterfaceOrientationAngleOfOrientation]);
//        obj->checkview.view.center = CGPointMake(r.size.width/2.0f, r.size.height/2.0f);
//        
//        [[[UIApplication sharedApplication] keyWindow] addSubview:obj->checkview.view];
//        
//        obj->checkview.cancelCheck = ^(CheckUserViewController *viewController)//取消校验
//        {
//            [viewController.view removeFromSuperview];
//        };
//        
//        obj->checkview.checkSuccessfully = ^(CheckUserViewController *viewController)//确定校验
//        {
//            [viewController.view removeFromSuperview];
//            
//            [controller.view removeFromSuperview];
//            [ob1 orderAction];
//            ob1.curSelectView = nil;
//            float total = 0.0f;
//            
//            for (FoodObject *food in ob1.bookedArray)
//            {
//                total += [food.price floatValue] * food.bookCount;
//            }
//            
//            [ob1.showTotalLab setText:[NSString stringWithFormat:@"￥%.0f", total]];
//            CGRect r = ob1.showTotalLab.frame;
//            r.size.width = (30 + [ob1.showTotalLab.text sizeWithFont:ob1.showTotalLab.font].width);
//            ob1.showTotalLab.frame = r;
//        };
    };
    //返回回调块
    selectedview.didBack = ^(SelectedListViewController *controller)
    {
        [controller.view removeFromSuperview];
        obj.curSelectView = nil;
        float total = 0.0f;
        
        for (FoodObject *food in obj.bookedArray)
        {
            total += [food.price floatValue] * food.bookCount;
        }
        
        [obj.showTotalLab setText:[[NSString alloc] initWithFormat:@"￥%.0f", total]];
        CGRect r = obj.showTotalLab.frame;
        r.size.width = (30 + [obj.showTotalLab.text sizeWithFont:obj.showTotalLab.font].width);
        obj.showTotalLab.frame = r;
    };
    
    self.curSelectView = selectedview;
    [[[UIApplication sharedApplication] keyWindow] addSubview:selectedview.view];
//    [view release];
}
//查询已选清单操作
- (void)showSelectedList
{
    /*
    __block typeof(self) obj = self;
    ShowBookFoodListViewController *view = [[ShowBookFoodListViewController alloc] initWithDict:orderedFoodDic];
    view.roomId = roomId;
    CGRect r = [UIScreen mainScreen].bounds;
//    view.view.frame = r;
    view.view.transform = CGAffineTransformMakeRotation([[Public getInstance] statubarUIInterfaceOrientationAngleOfOrientation]);
    view.view.center = CGPointMake(r.size.width/2.0f, r.size.height/2.0f);
    
    view.didBack = ^(ShowBookFoodListViewController *controller)
    {
        [controller.view removeFromSuperview];
        [controller release];
        obj.curSelectView = nil;
        float total = 0.0f;
        
        for (FoodObject *food in obj.bookedArray)
        {
            total += [food.price floatValue] * food.bookCount;
        }
        
        [obj.showTotalLab setText:[NSString stringWithFormat:@"￥%.0f", total]];
        CGRect r = obj.showTotalLab.frame;
        r.size.width = (30 + [obj.showTotalLab.text sizeWithFont:obj.showTotalLab.font].width);
        obj.showTotalLab.frame = r;
    };
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:view.view];
    */
    NSString *str = [InstructionCreate getInStruction:INS_ROOM_BOOK withContents:[NSMutableArray arrayWithObjects:roomId, nil]];
    NSLog(@"%@", str);
    NSData * data = [str dataUsingEncoding:[Public getInstance].gbkEncoding];
    [Public getInstance].juhua.labelText = @"查询已下清单";
    [[Public getInstance].juhua show:YES];
    
    if (bookAndFoodSocket)
    {
        bookAndFoodSocket = nil;
        bookAndFoodSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    }
    
    [bookAndFoodSocket receiveWithTimeout:MAX_TIMEOUT tag:[INS_ROOM_BOOK intValue]];
    [bookAndFoodSocket sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_ROOM_BOOK intValue]];
}
//校验操作员
- (void)checkUser
{
    int count = [bookedArray count];
    //没有选择食物
    if (count == 0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您还没有点菜，请选择需要的菜然后在点击下单。";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:NO afterDelay:2];
        
        return;
    }
    
    /****************************/
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否提交点餐" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 10010;
    [alert show];
    return;
    /****************************/
//    //显示校验界面
//    checkview = [[CheckUserViewController alloc] init];
//    [checkview.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
//    CGRect r = [UIScreen mainScreen].bounds;
//    checkview.view.transform = CGAffineTransformMakeRotation([[Public getInstance] statubarUIInterfaceOrientationAngleOfOrientation]);
//    checkview.view.center = CGPointMake(r.size.width/2.0f, r.size.height/2.0f);
//    
//    [[[UIApplication sharedApplication] keyWindow] addSubview:checkview.view];
//    __block typeof(self) obj = self;
//    checkview.cancelCheck = ^(CheckUserViewController *viewController)//取消校验
//    {
//        [viewController.view removeFromSuperview];
//    };
//    
//    checkview.checkSuccessfully = ^(CheckUserViewController *viewController)//确定校验
//    {
//        [viewController.view removeFromSuperview];
//        [obj orderAction];
//    };
}

//下单操作
- (void)orderAction
{
    int count = 0;
    
    for (FoodObject *ibj in bookedArray)
    {
        count += [ibj.foodlist count] + 1;
    }
    
    if ([bookedArray count] == 0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您还没有点菜，请选择需要的菜然后在点击下单。";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:NO afterDelay:2];
        return;
    }
    
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[bookedArray count]; i++)
    {
        FoodObject *food = [bookedArray objectAtIndex:i];
        NSString *addtion = @"";
        
        if (food.addtionInfor)
        {
            addtion = food.addtionInfor;
        }
        
        NSMutableArray *ar = nil;
        
        if (i==0)
        {
            ar = [NSMutableArray arrayWithObjects:roomId, [Public getInstance].userCode, [[NSString alloc] initWithFormat:@"%d", count], food.foodId, food.foodName, [[NSString alloc] initWithFormat:@"%d", food.bookCount], addtion, food.price, nil];
        }
        else
        {
            ar = [NSMutableArray arrayWithObjects:food.foodId, food.foodName, [[NSString alloc] initWithFormat:@"%d", food.bookCount], addtion, food.price, nil];
        }
        
        [dataArray addObject:ar];
        if ([food.foodlist count] > 0 && [[food.isTaocan lowercaseString] isEqualToString:@"false"])
        {
            NSArray *allkey = [food.taocanDict allKeys];
            
            for (NSString *key in allkey)
            {
                NSArray *foods = [food.taocanDict objectForKey:key];
                
                for (TaoCanMingxi *mingxi in foods)
                {
                    NSMutableArray *ar = nil;
                    
                    if (!mingxi.isguding)
                    {
                        //可选套餐
                        ar = [NSMutableArray arrayWithObjects:mingxi.foodID, mingxi.foodName, [[NSString alloc] initWithFormat:@"%d", mingxi.foodCount/* * food.bookCount*/], @"", @"0", nil];
                    }
                    else
                    {
                        //固定套餐
                        ar = [NSMutableArray arrayWithObjects:mingxi.foodID, mingxi.foodName, [[NSString alloc] initWithFormat:@"%d", mingxi.foodCount * food.bookCount], @"", @"0", nil];
                    }
                    
                    [dataArray addObject:ar];
                }
            }
        }
    }
    
    NSString *str = [InstructionCreate getInStruction:INS_BOOK withContents:dataArray];
    NSString *lastString = [[NSString alloc] initWithFormat:@"||@%@;", [Public getInstance].userName];
    str = [str stringByReplacingCharactersInRange:NSRangeFromString([[NSString alloc] initWithFormat:@"{%d, 1}", [str length] - 1]) withString:lastString];
    NSLog(@"%@", str);
    
    NSData * data = [str dataUsingEncoding:[Public getInstance].gbkEncoding];
    [Public getInstance].juhua.labelText = @"正在提交订单";
    [[Public getInstance].juhua show:YES];
    
    if (getCategory)
    {
        getCategory = nil;
        getCategory = [[AsyncUdpSocket alloc] initWithDelegate:self];
    }
    
    [getCategory receiveWithTimeout:MAX_TIMEOUT tag:[INS_BOOK intValue]];
    [getCategory sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_BOOK intValue]];
}
//获取食物类别列表
- (void)getGoodCategorySocketAction
{
    NSString *str = [InstructionCreate getInStruction:INS_GET_GOODS_CATEGORY_LIST withContents:nil];
    NSLog(@"%@", str);
    NSData * data = [str dataUsingEncoding:[Public getInstance].gbkEncoding];
    [Public getInstance].juhua.labelText = @"正在获取物品类别列表";
    dispatch_async(dispatch_get_main_queue(), ^{
        [[Public getInstance].juhua show:YES];
    });
    
    if (getCategory)
    {
        getCategory = nil;
        getCategory = [[AsyncUdpSocket alloc] initWithDelegate:self];
    }
    
    [getCategory receiveWithTimeout:MAX_TIMEOUT tag:[INS_GET_GOODS_CATEGORY_LIST intValue]];
    [getCategory sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_GET_GOODS_CATEGORY_LIST intValue]];
    
}
//获得食物列表
- (void)getGoodListAction:(NSString *)foodCategory
{
    NSString *str = [InstructionCreate getInStruction:INS_GET_GOODS_LIST withContents:[NSMutableArray arrayWithObject:[NSMutableArray arrayWithObjects:roomId, foodCategory, nil]]];
    NSLog(@"%@", str);
    NSData * data = [str dataUsingEncoding:[Public getInstance].gbkEncoding];
    [Public getInstance].juhua.labelText = @"正在获取物品列表";
    [[Public getInstance].juhua show:YES];
    
    if (getFoodList)
    {
        getFoodList = nil;
        getFoodList = [[AsyncUdpSocket alloc] initWithDelegate:self];
    }
    
    [getFoodList receiveWithTimeout:MAX_TIMEOUT tag:[INS_GET_GOODS_LIST intValue]];
    [getFoodList sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_GET_GOODS_LIST intValue]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//关闭操作
- (void)closeAction:(id)sender
{
    [foodCategoryArray makeObjectsPerformSelector:@selector(closeSocket)];
    [self.navigationController popViewControllerAnimated:NO];
}
//改变列表模式
- (void)changeTableViewStype:(id)sender
{
    for (FoodPictureView *view in foodPictureViewArray)
    {
        [view removeFromSuperview];
    }
    
    [foodPictureViewArray removeAllObjects];
    
    if (![(UISwitch *)sender isOn])//图片模式
    {
        isListStyple = NO;
        if (curFoodCategoryObject)
        {
            __block typeof(self) obj = self;
            
            for (FoodObject *obj1 in curFoodCategoryObject.foodListArray)
            {
                FoodPictureView *view = [[FoodPictureView alloc] initWithFrame:CGRectMake(0, 0, 247, 290) foodObject:obj1];
                [foodPictureViewArray addObject:view];
                [view setBackgroundColor:[UIColor clearColor]];
//                [view release];
                view.didAddtion = ^(FoodObject *object) {
                    BOOL exist = NO;
                    for (FoodObject *food in obj.bookedArray)
                    {
                        if (food == object)
                        {
                            exist = YES;
                            break;
                        }
                    }
                    
                    if (!exist)
                    {
                        [obj.bookedArray addObject:object];
                    }
                };
                
                view.didDelete = ^(FoodObject *object) {//删除
                    if ([obj.bookedArray containsObject:object])
                    {
                        [obj.bookedArray removeObject:object];
                    }
                    else
                    {
                        object.bookCount = 0;
                    }
                };
                
                view.refreshBlock = ^(){//刷新
                    float total = 0.0f;
                    
                    for (FoodObject *food in obj.bookedArray)
                    {
                        total += [food.price floatValue] * food.bookCount;
                    }
                    
                    [obj.showTotalLab setText:[[NSString alloc] initWithFormat:@"￥%.0f", total]];
                    CGRect r = obj.showTotalLab.frame;
                    r.size.width = (30 + [obj.showTotalLab.text sizeWithFont:obj.showTotalLab.font].width);
                    obj.showTotalLab.frame = r;
                };
            }
        }
    }
    else//列表模式
    {
        isListStyple = YES;
    }
    
    [detailListView reloadData];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10010 && buttonIndex == 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self orderAction];
        });
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
    if (tag == [INS_GET_GOODS_CATEGORY_LIST intValue])//食物类别
    {
        if ([str length] == 0)
        {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"获取物品类别列表失败" message:@"获取物品类别列表失败，稍后请重试。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [view show];
        }
        else
        {
            [foodCategoryArray removeAllObjects];
            InstructionParse *parse = [[InstructionParse alloc] initWithInstructionString:[[Public getComponentsSeparated:str] objectAtIndex:1]];
            NSLog(@"%@", parse.instruction);
            NSLog(@"%@", parse.contents);
            self.curFoodCategroy = parse;
            
            __block typeof(self) obje = self;
            int index = 0;
            
            for (NSMutableArray *arr in curFoodCategroy.contents)
            {
                FoodCategoryObject *obj = [[FoodCategoryObject alloc] initWithParse:arr roomid:roomId];
                [foodCategoryArray addObject:obj];
                obj.index = index++;
                
                
                obj.didFinishDownload = ^(FoodCategoryObject *ta)
                {
                    if ([obje.bookedArray count] > 0) {
                        for (FoodObject *objfood in obje.bookedArray)
                        {
                            if (!objfood.ischeck && [objfood.categoryId isEqualToString:ta.categoryId]) {
                                for (FoodObject *showobj in ta.foodListArray)
                                {
                                    if ([showobj.foodId isEqualToString:objfood.foodId]) {
                                        showobj.bookCount = objfood.bookCount;
                                        objfood.referenceObject = showobj;
                                    }
                                }
                                objfood.ischeck = YES;
                            }
                        }
                    }
                    [obje.categoryListView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:ta.index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    
                    if (!obje.curFoodCategoryObject)
                    {
                        obje.curFoodCategoryObject = ta;
                        [obje.detailListView reloadData];
                        [obje.categoryListView selectRowAtIndexPath:[NSIndexPath indexPathForRow:ta.index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                    }
                };
            }
            
            [categoryListView reloadData];
        }
    }
    else if (tag == [INS_GET_GOODS_LIST intValue])//食物列表
    {
        if ([str length] == 0)
        {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"获取物品列表失败" message:@"获取物品列表失败，稍后请重试。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [view show];
        }
        else
        {
            InstructionParse *parse = [[InstructionParse alloc] initWithInstructionString:[[Public getComponentsSeparated:str] objectAtIndex:1]];
            NSLog(@"%@", parse.instruction);
            NSLog(@"%@", parse.contents);
            self.curFoodList = parse;
            [detailListView reloadData];
        }
    }
    else if (tag == [INS_BOOK intValue])//下单
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"提交订单成功";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:NO afterDelay:1];
        
        for (FoodObject *object in bookedArray)
        {
            object.bookCount = 0;
            
            if ([object.foodlist count] > 0 && [[object.isTaocan lowercaseString] isEqualToString:@"false"])
            {
                NSArray *allkey = [object.taocanDict allKeys];
                
                for (NSString *key in allkey)
                {
                    NSArray *foods = [object.taocanDict objectForKey:key];
                    
                    for (TaoCanMingxi *mingxi in foods)
                    {
                        if (!mingxi.isguding)
                        {
                            mingxi.foodCount = 0;
                        }
                    }
                }
            }
        }
        
        [bookedArray removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [showTotalLab setText:@"￥0.0"];
            CGRect r = showTotalLab.frame;
            r.size.width = (30 + [showTotalLab.text sizeWithFont:showTotalLab.font].width);
            showTotalLab.frame = r;
        });
        
        if (curSelectView)
        {
            [curSelectView.view removeFromSuperview];
            self.curSelectView = nil;
        }
    }
    else if (tag == [INS_ROOM_BOOK intValue])//查询已选列表
    {
        if ([str length] == 0)//查询失败
        {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"查询失败" message:@"查询已选列表操作失败，稍后请重试。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [view show];
        }
        else
        {
            InstructionParse *parse = [[InstructionParse alloc] initWithInstructionString:[[Public getComponentsSeparated:str] objectAtIndex:1]];
            NSLog(@"%@", parse.instruction);
            NSLog(@"%@", parse.contents);
            if (parse)
            {
                [orderedFoodDic removeAllObjects];
                self.curBook = parse;
                
                for (NSMutableArray *array in curBook.contents)
                {
                    OrderedFood *food = [[OrderedFood alloc] initWithNSArray:array];
                    
                    if ([food.unknow3 isEqualToString:@"1"])
                    {
                        NSMutableArray *ret = [orderedFoodDic objectForKey:Ordered_Had_Checkout];
                        if (!ret)
                        {
                            ret = [NSMutableArray array];
                            [orderedFoodDic setObject:ret forKey:Ordered_Had_Checkout];
                            ret = [orderedFoodDic objectForKey:Ordered_Had_Checkout];
                        }
                        
                        [ret addObject:food];
                    }
                    else
                    {
                        NSMutableArray *ret = [orderedFoodDic objectForKey:Ordered_No_Checkout];
                        if (!ret)
                        {
                            ret = [NSMutableArray array];
                            [orderedFoodDic setObject:ret forKey:Ordered_No_Checkout];
                            ret = [orderedFoodDic objectForKey:Ordered_No_Checkout];
                        }
                        
                        [ret addObject:food];
                    }
                }
                
                __block typeof(self) obj = self;
                showBookListView = [[ShowBookFoodListViewController alloc] initWithDict:orderedFoodDic];
                showBookListView.roomId = roomId;
                CGRect r = [UIScreen mainScreen].bounds;
                showBookListView.view.transform = CGAffineTransformMakeRotation([[Public getInstance] statubarUIInterfaceOrientationAngleOfOrientation]);
                showBookListView.view.center = CGPointMake(r.size.width/2.0f, r.size.height/2.0f);
                
                showBookListView.didBack = ^(ShowBookFoodListViewController *controller)//返回回调块
                {
                    [controller.view removeFromSuperview];
                    obj.curSelectView = nil;
                    float total = 0.0f;
                    
                    for (FoodObject *food in obj.bookedArray)
                    {
                        total += [food.price floatValue] * food.bookCount;
                    }
                    
                    [obj.showTotalLab setText:[[NSString alloc] initWithFormat:@"￥%.0f", total]];
                    CGRect r = obj.showTotalLab.frame;
                    r.size.width = (30 + [obj.showTotalLab.text sizeWithFont:obj.showTotalLab.font].width);
                    obj.showTotalLab.frame = r;
                };
                
                [[[UIApplication sharedApplication] keyWindow] addSubview:showBookListView.view];
            }
        }
    }
    else if (tag == [INS_BX_ZT intValue])
    {
        if ([str length] == 0)//查询失败tr
        {
            return NO;
        }
        else
        {
            NSString *curRoomID = [[Public getInstance].roomIDAndBookID objectForKey:roomId];
            
            if (![curRoomID isEqualToString:str])
            {
                [[Public getInstance].roomIDAndBookID setValue:str forKey:roomId];
                //清空缓存
                [bookedArray removeAllObjects];
            }
            
            [self getGoodCategorySocketAction];//获得食物类别
            
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
    if (tableView == categoryListView)
    {
        return [foodCategoryArray count];
    }
    else if (tableView == detailListView)
    {
        if (isListStyple)
        {
            if (tableviewCategory)
            {
                return [searchArray count];
            }
            
            return [curFoodCategoryObject.foodListArray count];
        }
        else
        {
            if (tableviewCategory)
            {
                int count = [searchArray count] / 3;
                
                if ([searchArray count] % 3 > 0)
                {
                    count += 1;
                }
                
                return count;
            }
            
            int count = [foodPictureViewArray count] / 3;
            
            if ([foodPictureViewArray count] % 3 > 0)
            {
                count += 1;
            }
            
            return count;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == categoryListView)
    {
        static NSString     *cellForCategory = @"cellForCategory";
        
        FoodCategoryCell *cell = [categoryListView dequeueReusableCellWithIdentifier:cellForCategory];
        if (!cell)
        {
            cell = /*[*/[[FoodCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellForCategory] /*autorelease]*/;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        NSString *title = nil;
        FoodCategoryObject *sub = [foodCategoryArray objectAtIndex:indexPath.row];
        if ([sub.foodCategory count] == 3)
        {
            title = [sub.foodCategory objectAtIndex:2];
        }
        else if ([sub.foodCategory count] == 2)
        {
            title = [sub.foodCategory objectAtIndex:1];
        }
        
        [cell.textLabel setText:[[NSString alloc] initWithFormat:@"%@(%d)", title, [sub.foodListArray count]]];
        
        return cell;
    }
    else if (tableView == detailListView)
    {
        if (isListStyple)
        {
            NSString     *cellForCategory = [[NSString alloc] initWithFormat:@"cellForCategory%d", indexPath.row];
            
            FoodListCell *cell = [detailListView dequeueReusableCellWithIdentifier:cellForCategory];
            
            if (!cell)
            {
                cell = /*[*/[[FoodListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellForCategory]/* autorelease]*/;
                [cell setBackgroundColor:[UIColor clearColor]];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            
            __block typeof(self) obj = self;
            cell.didAddtion = ^(FoodObject *object) {//添加食物
                BOOL exist = NO;
                for (FoodObject *food in obj.bookedArray)
                {
                    if (food == object)
                    {
                        exist = YES;
                        break;
                    }
                }
                
                if (!exist)
                {
                    [obj.bookedArray addObject:object];
                }
            };
            
            cell.didDelete = ^(FoodObject *object) {//删除食物
                if ([obj.bookedArray containsObject:object])
                {
                    [obj.bookedArray removeObject:object];
                }
                else
                {
                    object.bookCount = 0;
                }
            };
            
            cell.refreshBlock = ^(){//刷新食物
                float total = 0.0f;
                
                for (FoodObject *food in obj.bookedArray)
                {
                    total += [food.price floatValue] * food.bookCount;
                }
                
                [obj.showTotalLab setText:[[NSString alloc] initWithFormat:@"￥%.0f", total]];
                CGRect r = obj.showTotalLab.frame;
                r.size.width = (30 + [obj.showTotalLab.text sizeWithFont:obj.showTotalLab.font].width);
                obj.showTotalLab.frame = r;
            };
            
            FoodObject *sub = nil;
            
            if (tableviewCategory)
            {
                sub = [searchArray objectAtIndex:indexPath.row];
            }
            else
            {
                sub = [curFoodCategoryObject.foodListArray objectAtIndex:indexPath.row];
            }
            
            cell.food = sub;
            
            return cell;
        }
        else
        {
            NSString     *cellForCategory = [[NSString alloc] initWithFormat:@"cellForImageViewCategory%d", indexPath.row];
            UITableViewCell *cell = [detailListView dequeueReusableCellWithIdentifier:cellForCategory];
            
            if (!cell)
            {
                cell = /*[*/[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellForCategory] /*autorelease]*/;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setBackgroundColor:[UIColor clearColor]];
            }
            
            NSArray *curShowArray = nil;
            if (tableviewCategory)
            {
                curShowArray = searchArray;
            }
            else
            {
                curShowArray = foodPictureViewArray;
            }
            
            int count = [curShowArray count];
            BOOL  divisibility = NO;
            
            if (count % 3 == 0)
            {
                count /= 3;
                divisibility = YES;
            }
            else
            {
                count = count / 3 + 1;
            }
            
            float start_x = 0;
            
            if (indexPath.row == count - 1 && !divisibility)
            {
                for (int i = indexPath.row * 3; i < [curShowArray count]; i++)
                {
                    FoodPictureView *view = [curShowArray objectAtIndex:i];
                    CGRect r = view.frame;
                    r.origin.x = start_x;
                    view.frame = r;
                    [cell addSubview:view];
                    start_x += view.frame.size.width;
                }
            }
            else
            {
                for (int i=0; i<3; i++)
                {
                    FoodPictureView *view = [curShowArray objectAtIndex:i + indexPath.row * 3];
                    CGRect r = view.frame;
                    r.origin.x = start_x;
                    view.frame = r;
                    [cell addSubview:view];
                    start_x += view.frame.size.width;
                }
            }
            
            return cell;
        }
    }
    
    return nil;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == detailListView)
    {
        return headView.frame.size.height;
    }
 
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == detailListView)
    {
        return headView;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == categoryListView)
    {
        return 74.0f;
    }
    else if (tableView == detailListView)
    {
        if (isListStyple)
        {
            return 94.0f;
        }
        else
        {
            if ([foodPictureViewArray count] > 0)
            {
                FoodPictureView *view = [foodPictureViewArray lastObject];
                
                return view.frame.size.height;
            }
        }
        
    }
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == categoryListView)
    {
        [searchbar resignFirstResponder];
        [searchbar setShowsCancelButton:NO animated:NO];
        tableviewCategory = NO;
        
        self.curFoodCategoryObject = [foodCategoryArray objectAtIndex:indexPath.row];
        
        if (!isListStyple)
        {
            for (FoodPictureView *view in foodPictureViewArray)
            {
                [view removeFromSuperview];
            }
            
            [foodPictureViewArray removeAllObjects];
            if (curFoodCategoryObject)
            {
                __block typeof(self) obj = self;
                
                for (FoodObject *obj1 in curFoodCategoryObject.foodListArray)
                {
                    FoodPictureView *view = [[FoodPictureView alloc] initWithFrame:CGRectMake(0, 0, 247, 290) foodObject:obj1];
                    [foodPictureViewArray addObject:view];
                    [view setBackgroundColor:[UIColor clearColor]];

                    view.didAddtion = ^(FoodObject *object) {//添加食物
                        BOOL exist = NO;
                        for (FoodObject *food in obj.bookedArray)
                        {
                            if (food == object)
                            {
                                exist = YES;
                                break;
                            }
                        }
                        
                        if (!exist)
                        {
                            [obj.bookedArray addObject:object];
                        }
                    };
                    
                    view.didDelete = ^(FoodObject *object) {//删除已选食物
                        
                        if ([obj.bookedArray containsObject:object])
                        {
                            [obj.bookedArray removeObject:object];
                        }
                        else
                        {
                            object.bookCount = 0;
                        }
                    };
                    
                    view.refreshBlock = ^(){//刷新界面
                        float total = 0.0f;
                        
                        for (FoodObject *food in obj.bookedArray)
                        {
                            total += [food.price floatValue] * food.bookCount;
                        }
                        
                        [obj.showTotalLab setText:[[NSString alloc] initWithFormat:@"￥%.0f", total]];
                        CGRect r = obj.showTotalLab.frame;
                        r.size.width = (30 + [obj.showTotalLab.text sizeWithFont:obj.showTotalLab.font].width);
                        obj.showTotalLab.frame = r;
                    };
                }
            }
        }
        
        [detailListView reloadData];
    }
    else if (tableView == detailListView)
    {
        [detailListView deselectRowAtIndexPath:indexPath animated:YES];
    }
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
        
        tableviewCategory = NO;
        
        if (!isListStyple)
        {
            for (FoodPictureView *view in foodPictureViewArray)
            {
                [view removeFromSuperview];
            }
        }
        
        [detailListView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
//    [searchBar setText:@""];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    tableviewCategory = YES;
    
    if (!isListStyple)
    {
        if ([searchArray count] == 0)
        {
            for (FoodPictureView *view in foodPictureViewArray)
            {
                [view removeFromSuperview];
            }
        }
        else
        {
            for (FoodPictureView *view in searchArray)
            {
                [view removeFromSuperview];
            }
        }
        
        [searchArray removeAllObjects];
        
        for (FoodCategoryObject *category in foodCategoryArray)
        {
            for (FoodObject *obj1 in category.foodListArray)
            {
                NSString *str = [[NSString alloc] initWithFormat:@"%@%@", obj1.searchStr, obj1.foodName];
                BOOL isMember = NO;
                obj1.searchIndex = 0;
                NSString *searchTextNew = [searchText uppercaseString];
                for (int j=0; j<[searchTextNew length]; j++)
                {
                    NSRange range = NSRangeFromString([[NSString alloc] initWithFormat:@"{%d, 1}", j]);
                    NSString *searchStr = [searchTextNew substringWithRange:range];
                    
                    unichar charValue = [searchStr characterAtIndex:0];
                    
                    if (charValue >= 0x4e00 && charValue <= 0x9fa5)
                    {
                        str = [[NSString alloc] initWithFormat:@"%@%@", obj1.foodName, obj1.searchStr];
                    }
                    
                    if ([str rangeOfString:searchStr].location != NSNotFound)
                    {
                        obj1.searchIndex += ([searchTextNew length] - j) << [str rangeOfString:searchStr].location;
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
                    __block typeof(self) obj = self;
                    
                    FoodPictureView *view = [[FoodPictureView alloc] initWithFrame:CGRectMake(0, 0, 247, 290) foodObject:obj1];
                    [view setBackgroundColor:[UIColor clearColor]];
                    view.didAddtion = ^(FoodObject *object) {//添加食物
                        BOOL exist = NO;
                        for (FoodObject *food in obj.bookedArray)
                        {
                            if (food == object)
                            {
                                exist = YES;
                                break;
                            }
                        }
                        
                        if (!exist)
                        {
                            [obj.bookedArray addObject:object];
                        }
                    };
                    
                    view.didDelete = ^(FoodObject *object) {//删除已选食物
                        if ([obj.bookedArray containsObject:object])
                        {
                            [obj.bookedArray removeObject:object];
                        }
                        else
                        {
                            object.bookCount = 0;
                        }
                    };
                    
                    view.refreshBlock = ^(){//刷新界面
                        float total = 0.0f;
                        
                        for (FoodObject *food in obj.bookedArray)
                        {
                            total += [food.price floatValue] * food.bookCount;
                        }
                        
                        [obj.showTotalLab setText:[[NSString alloc] initWithFormat:@"￥%.0f", total]];
                        CGRect r = obj.showTotalLab.frame;
                        r.size.width = (30 + [obj.showTotalLab.text sizeWithFont:obj.showTotalLab.font].width);
                        obj.showTotalLab.frame = r;
                    };
                    
                    [searchArray addObject:view];
                }
            }
        }
        
        //排序
        [searchArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
         {
             FoodPictureView *ob1 = obj1;
             FoodPictureView *ob2 = obj2;
             
             if (ob1.food.searchIndex > ob2.food.searchIndex)
             {
                 return NSOrderedDescending;
             }
             else if (ob1.food.searchIndex < ob2.food.searchIndex)
             {
                 return NSOrderedAscending;
             }
             
             return NSOrderedSame;
         }];
    }
    else
    {
        [searchArray removeAllObjects];
        
        for (FoodCategoryObject *category in foodCategoryArray)
        {
            for (FoodObject *obj1 in category.foodListArray)
            {
                NSString *str = [[NSString alloc] initWithFormat:@"%@%@", obj1.searchStr, obj1.foodName];
                BOOL isMember = NO;
                
                NSString *searchTextNew = [searchText uppercaseString];
                obj1.searchIndex = 0;
                
                for (int j=0; j<[searchTextNew length]; j++)
                {
                    NSRange range = NSRangeFromString([[NSString alloc] initWithFormat:@"{%d, 1}", j]);
                    NSString *searchStr = [searchTextNew substringWithRange:range];
                    unichar charValue = [searchStr characterAtIndex:0];
                    
                    if (charValue >= 0x4e00 && charValue <= 0x9fa5)
                    {
                        str = [[NSString alloc] initWithFormat:@"%@%@", obj1.foodName, obj1.searchStr];
                    }
                    
                    if ([str rangeOfString:searchStr].location != NSNotFound)
                    {
                        obj1.searchIndex += ([searchTextNew length] - j) << [str rangeOfString:searchStr].location;
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
                    [searchArray addObject:obj1];
                }
            }
        }
        
        //排序
        [searchArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
        {
            FoodObject *ob1 = obj1;
            FoodObject *ob2 = obj2;
            
            if (ob1.searchIndex > ob2.searchIndex)
            {
                return NSOrderedDescending;
            }
            else if (ob1.searchIndex < ob2.searchIndex)
            {
                return NSOrderedAscending;
            }
            
            return NSOrderedSame;
        }];
    }

    isEdit = NO;
    [detailListView reloadData];
    isEdit = YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return isEdit;
}
@end
