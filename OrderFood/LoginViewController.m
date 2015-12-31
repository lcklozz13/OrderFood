//
//  LoginViewController.m
//  OrderFood
//
//  Created by aplle on 7/23/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"
#import "LoginViewCell.h"

@interface LoginViewController ()<UITextFieldDelegate, AsyncUdpSocketDelegate, UITableViewDataSource, UITableViewDelegate>
{
    CGRect      mainViewFrame;
    CGSize      keyboardSize;
    UITextField *curTextField;
    AsyncUdpSocket *sendSocket;//登录请求
    AsyncUdpSocket *checkSocket;//同步请求
    
    AsyncUdpSocket *getRoomsSocket;
    AsyncUdpSocket *getGoodCategorySocket;
    AsyncUdpSocket *getGoodSocket;
    AsyncUdpSocket *bookSocket;
    AsyncUdpSocket *checkBooksSocket;
    AsyncUdpSocket *roomBooksSocket;
    AsyncUdpSocket *publishDesSocket;
}

@property (nonatomic, retain) IBOutlet UITextField      *account;
@property (nonatomic, retain) IBOutlet UITextField      *pwd;
@property (nonatomic, retain) IBOutlet UITextField      *server;
@property (nonatomic, retain) IBOutlet UIScrollView     *mainView;
@property (nonatomic, retain) IBOutlet UIImageView      *backgroupImageView;
@property (nonatomic, retain) IBOutlet UIButton         *synchronousBtn;
@property (nonatomic, retain) IBOutlet UIButton         *loginBtn;
@property (nonatomic, retain) IBOutlet UITableView      *inputTableView;

- (IBAction)synchronousAction:(id)sender;//同步请求
- (IBAction)loginAction:(id)sender;//登录请求
//- (IBAction)publishDes11111Socket:(id)sender;
//- (IBAction)roomBooks111111Socket:(id)sender;
//- (IBAction)checkBooksSocket:(id)sender;
//- (IBAction)bookAction:(id)sender;
//- (IBAction)getGoodSocket:(id)sender;
//- (IBAction)getRoomList:(id)sender;
//- (IBAction)getGoodCategorySocketAction:(id)sender;

@end

@implementation LoginViewController
@synthesize account;
@synthesize pwd;
@synthesize mainView;
@synthesize backgroupImageView;
@synthesize synchronousBtn;
@synthesize loginBtn;
@synthesize inputTableView;
@synthesize server;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSIndexPath *index = [NSIndexPath indexPathForRow:2 inSection:0];
        [inputTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        if (self.pwd)
        {
            [self.pwd setText:@""];
        }
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
#if IS_DEMO_STYLE
    self.title = @"系统登陆（预览版）";
#else
    self.title = @"系统登陆";
#endif
    
    if ([[[Public getCurrentDeviceModel] lowercaseString] rangeOfString:@"mini"].location != NSNotFound)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CGRect frame = inputTableView.frame;
            frame.origin.x += 150;
            frame.origin.y += 130;
            
            inputTableView.frame = frame;
            
            frame = backgroupImageView.frame;
            frame.origin.x += 150;
            frame.origin.y += 150;
            backgroupImageView.frame = frame;
            
            frame = synchronousBtn.frame;
            frame.origin.x += 130;
            frame.origin.y += 150;
            synchronousBtn.frame = frame;
            
            frame = loginBtn.frame;
            frame.origin.x += 130;
            frame.origin.y += 150;
            loginBtn.frame = frame;
        });
    }
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view from its nib.
//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
//    [lab setTextColor:[UIColor blackColor]];
//    [lab setBackgroundColor:[UIColor clearColor]];
//    [lab setText:@"   帐号:"];
//    CGRect r = lab.frame;
//    r.size = [lab.text sizeWithFont:lab.font];
//    lab.frame = r;
//    account.leftViewMode = UITextFieldViewModeAlways;
//    account.leftView = lab;
//    [lab release], lab = nil;
//    
//    lab = [[UILabel alloc] initWithFrame:CGRectZero];
//    [lab setTextColor:[UIColor blackColor]];
//    [lab setBackgroundColor:[UIColor clearColor]];
//    [lab setText:@"   密码:"];
//    r = lab.frame;
//    r.size = [lab.text sizeWithFont:lab.font];
//    lab.frame = r;
//    pwd.leftViewMode = UITextFieldViewModeAlways;
//    pwd.leftView = lab;
//    [lab release], lab = nil;
    //初始化界面跟数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHide:) name:UIKeyboardWillHideNotification object:nil];
    mainViewFrame = CGRectZero;
    mainView.contentSize = CGSizeMake(1024, 748);
    
    account.layer.cornerRadius = 8.0f;
    account.layer.masksToBounds = YES;
    account.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    account.layer.borderWidth = 1.5f;
    
    pwd.layer.cornerRadius = 8.0f;
    pwd.layer.masksToBounds = YES;
    pwd.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    pwd.layer.borderWidth = 1.5f;
    
    sendSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    checkSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    
    getRoomsSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    getGoodCategorySocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    getGoodSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    bookSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    checkBooksSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    roomBooksSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    publishDesSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
//    [self publishDes11111Socket:nil];
}

- (IBAction)publishDes11111Socket:(id)sender
{
    NSString *str = [InstructionCreate getInStruction:INS_PUBLISH_DESCRIPTION withContents:nil];
    NSLog(@"%@", str);
    NSData * data = [str dataUsingEncoding:[Public getInstance].gbkEncoding];
    
    if (publishDesSocket)
    {
        publishDesSocket = nil;
        publishDesSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    }
    
    [publishDesSocket receiveWithTimeout:MAX_TIMEOUT tag:[INS_PUBLISH_DESCRIPTION intValue]];
    [publishDesSocket sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_PUBLISH_DESCRIPTION intValue]];
}
/*
- (IBAction)roomBooks111111Socket:(id)sender
{
    NSString *str = [InstructionCreate getInStruction:INS_ROOM_BOOK withContents:[NSMutableArray arrayWithObjects:@"610", nil]];
    NSLog(@"%@", str);
    NSData * data = [str dataUsingEncoding:[Public getInstance].gbkEncoding];
    [Public getInstance].juhua.labelText = @"开房定食";
    [[Public getInstance].juhua show:YES];
    [roomBooksSocket receiveWithTimeout:MAX_TIMEOUT tag:[INS_ROOM_BOOK intValue]];
    [roomBooksSocket sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_ROOM_BOOK intValue]];
}

- (IBAction)checkBooksSocket:(id)sender
{
    NSString *str = [InstructionCreate getInStruction:INS_CHECK_ORDER withContents:[NSMutableArray arrayWithObjects:@"603", nil]];
    NSLog(@"%@", str);
    NSData * data = [@"0100#603;" dataUsingEncoding:[Public getInstance].gbkEncoding];
    [Public getInstance].juhua.labelText = @"查单";
    [[Public getInstance].juhua show:YES];
    [checkBooksSocket receiveWithTimeout:MAX_TIMEOUT tag:[INS_CHECK_ORDER intValue]];
    [checkBooksSocket sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_CHECK_ORDER intValue]];
}

- (IBAction)bookAction:(id)sender
{
    NSString *str = [InstructionCreate getInStruction:INS_BOOK withContents:[NSMutableArray arrayWithObjects:@"610", nil]];
    NSLog(@"%@", str);
    NSData * data = [@"0006#603,ZC,2,110036,百威啤酒330ml（听）,1,||120026,绝对伏特加原味70cl,1,||;" dataUsingEncoding:[Public getInstance].gbkEncoding];
    [Public getInstance].juhua.labelText = @"下单";
    [[Public getInstance].juhua show:YES];
    [bookSocket receiveWithTimeout:MAX_TIMEOUT tag:[INS_BOOK intValue]];
    [bookSocket sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_BOOK intValue]];
}

- (IBAction)getGoodSocket:(id)sender
{
    //45,0020001,可口可乐,瓶,5,0,002||0020002,雪碧,瓶,6,0,002|
    NSString *str = [InstructionCreate getInStruction:INS_GET_GOODS_LIST withContents:nil];
    NSLog(@"%@", str);
    NSData * data = [@"0004#603,001;" dataUsingEncoding:[Public getInstance].gbkEncoding];
    [Public getInstance].juhua.labelText = @"正在获取物品列表";
    [[Public getInstance].juhua show:YES];
    [getGoodSocket receiveWithTimeout:MAX_TIMEOUT tag:[INS_GET_GOODS_LIST intValue]];
    [getGoodSocket sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_GET_GOODS_LIST intValue]];
}

- (IBAction)getRoomList:(id)sender
{
    NSString *str = [InstructionCreate getInStruction:INS_GET_ROOM_LIST withContents:nil];
    NSLog(@"%@", str);
    NSData * data = [@"0002#;" dataUsingEncoding:[Public getInstance].gbkEncoding];
    [Public getInstance].juhua.labelText = @"正在获取包厢列表";
    [[Public getInstance].juhua show:YES];
    [getRoomsSocket receiveWithTimeout:MAX_TIMEOUT tag:[INS_GET_ROOM_LIST intValue]];
    [getRoomsSocket sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_GET_ROOM_LIST intValue]];
}

- (IBAction)getGoodCategorySocketAction:(id)sender
{
    NSString *str = [InstructionCreate getInStruction:INS_GET_GOODS_CATEGORY_LIST withContents:nil];
    NSLog(@"%@", str);
    NSData * data = [@"0003#;" dataUsingEncoding:[Public getInstance].gbkEncoding];
    [Public getInstance].juhua.labelText = @"正在获取物品类别列表";
    [[Public getInstance].juhua show:YES];
    [getGoodCategorySocket receiveWithTimeout:MAX_TIMEOUT tag:[INS_GET_GOODS_CATEGORY_LIST intValue]];
    [getGoodCategorySocket sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_GET_GOODS_CATEGORY_LIST intValue]];
    
}
*/
#pragma mark keyboad show or hide notification
- (void)keyboardWasShown:(NSNotification *)notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyboardSize = CGSizeMake([value CGRectValue].size.height, [value CGRectValue].size.width);
    
    
    if (CGRectEqualToRect(mainViewFrame, CGRectZero))
    {
        mainViewFrame = [mainView frame];
    }
    
    CGRect r = mainViewFrame;
    r.size.height -= keyboardSize.height;
    
    [UIView beginAnimations:nil context:nil];
    //setAnimationCurve来定义动画加速或减速方式
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.2]; //动画时长
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    // operation>>>
    [mainView setFrame:r];
    CGPoint point = CGPointMake(0, r.size.height / 2.0f);
    [mainView setContentOffset:point animated:NO];
    // end<<<<<
    [UIView commitAnimations];
}

- (void)keyboardWasHide:(NSNotification *)notif
{
    CGRect r = mainView.frame;
    r.size.height += keyboardSize.height;
    [mainView setFrame:r];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.server = nil;
    self.account = nil;
    self.pwd = nil;
    self.mainView = nil;
    self.backgroupImageView = nil;
    self.synchronousBtn = nil;
    self.loginBtn = nil;
    self.inputTableView = nil;
    
//    [sendSocket release];
//    [checkSocket release];
//    
//    [super dealloc];
}
//同步
- (IBAction)synchronousAction:(id)sender
{
    [curTextField resignFirstResponder];
    
    if ([server.text length] == 0)
    {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"服务器地址不能为空" message:@"服务器地址不能为空，请输入服务器地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [view show];
//        [view release];
        return;
    }
    
    [Public getInstance].serviceIpAddr = [NSString stringWithString:server.text];
    
    NSString *str = [InstructionCreate getInStruction:INS_CHECK withContents:nil];
    NSData * data = [str dataUsingEncoding:[Public getInstance].gbkEncoding];
    [Public getInstance].juhua.labelText = @"正在同步";
    [[Public getInstance].juhua show:YES];
    
    if (checkSocket)
    {
        checkSocket = nil;
        checkSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    }
    
    [checkSocket receiveWithTimeout:MAX_TIMEOUT tag:[INS_CHECK intValue]];
    [checkSocket sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_CHECK intValue]];
}
//登录
- (IBAction)loginAction:(id)sender
{
    [curTextField resignFirstResponder];
    
    if ([server.text length] == 0)
    {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"服务器地址不能为空" message:@"服务器地址不能为空，请输入服务器地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [view show];
//        [view release];
        return;
    }
    
    if ([account.text length] == 0)
    {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"用户名不能为空" message:@"用户名不能为空，请输入一个用户名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [view show];
//        [view release];
        return;
    }
    
    if ([pwd.text length] == 0)
    {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"密码不能为空" message:@"密码不能为空，请输入密码后再次点登陆" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [view show];
//        [view release];
        return;
    }
    
#if IS_DEMO_STYLE
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDate *date = [userDefault objectForKey:@"LastTime"];
    
    if (!date)
    {
        [userDefault setObject:[NSDate date] forKey:@"LastTime"];
        [userDefault synchronize];
    }
    else
    {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
        
        if (interval >= 24 * 60 * 60 * 15)
        {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"警告⚠" message:@"预览版使用时间已到期，请联系有关部门！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [view show];
            return;
        }
    }
#endif
    
    [Public getInstance].serviceIpAddr = [NSString stringWithString:server.text];
    
    NSString *str = [InstructionCreate getInStruction:INS_LOGIN withContents:[NSMutableArray arrayWithObject:[NSMutableArray arrayWithObjects:account.text, pwd.text, nil]]];
    NSLog(@"%@", str);
    NSData * data = [str dataUsingEncoding:[Public getInstance].gbkEncoding];
    [Public getInstance].juhua.labelText = @"正在登陆";
    [[Public getInstance].juhua show:YES];
    
    if (sendSocket)
    {
        sendSocket = nil;
        sendSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    }
    
    [sendSocket receiveWithTimeout:MAX_TIMEOUT tag:[INS_LOGIN intValue]];
    [sendSocket sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_LOGIN intValue]];
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
    if (tag == [INS_LOGIN intValue])
    {
        //登陆反馈
        if ([str length] == 0)
        {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"登陆失败" message:@"用户名或者密码错误，请确认输入后再次登陆。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [view show];
//            [view release];
        }
        else
        {
            InstructionParse *parse = [[InstructionParse alloc] initWithInstructionString:[[Public getComponentsSeparated:str] objectAtIndex:1]];
            
            if ([[[[parse.contents objectAtIndex:0] objectAtIndex:0] substringToIndex:2] isEqualToString:@"OK"])
            {
                //登录成功进入主界面
                [Public getInstance].userName = [NSString stringWithString:account.text];
                [Public getInstance].userCode = [[parse.contents objectAtIndex:0] objectAtIndex:1];
                [[Public getInstance] saveDefaultIPAddress];//保存默认ip地址
                [self publishDes11111Socket:nil];
                MainViewController *view = [[MainViewController alloc] init];
                [self.navigationController pushViewController:view animated:NO];
//                [view release];
            }
            else
            {
                UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"登陆失败" message:@"用户名或者密码错误，请确认输入后再次登陆。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [view show];
//                [view release];
            }
            
//            [parse release];
            //进入主页面
        }
    }
    else if (tag == [INS_CHECK intValue])
    {
        //同步反馈
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"同步成功" message:@"服务器正常，可以进行交互操作。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [view show];
//        [view release];
        [[Public getInstance] saveDefaultIPAddress];//保存默认ip地址
        [self publishDes11111Socket:nil];
    }
    else if (tag == [INS_GET_ROOM_LIST intValue])
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
            NSLog(@"%@", [[[parse.contents objectAtIndex:0] objectAtIndex:0] substringToIndex:2]);
            
//            [parse release];
            //进入主页面
        }
    }
    else if (tag == [INS_GET_GOODS_CATEGORY_LIST intValue])
    {
        if ([str length] == 0)
        {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"获取物品类别列表失败" message:@"获取物品类别列表失败，稍后请重试。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [view show];
//            [view release];
        }
        else
        {
            InstructionParse *parse = [[InstructionParse alloc] initWithInstructionString:[[Public getComponentsSeparated:str] objectAtIndex:1]];
            NSLog(@"%@", parse.instruction);
            NSLog(@"%@", parse.contents);
            NSLog(@"%@", [[[parse.contents objectAtIndex:0] objectAtIndex:0] substringToIndex:2]);
            
//            [parse release];
        }
    }
    else if (tag == [INS_PUBLISH_DESCRIPTION intValue])
    {
        InstructionParse *parse = [[InstructionParse alloc] initWithInstructionString:[[Public getComponentsSeparated:str] objectAtIndex:1]];
        NSLog(@"%@", parse.instruction);
        NSLog(@"%@", parse.contents);
        [Public getInstance].curPublishDes = parse;
//        [parse release];

    }
    
//    [str release];
    
    return YES;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    if (tag == [INS_LOGIN intValue] || tag == [INS_CHECK intValue])
    {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"链接超时" message:@"链接超时，请重试。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [view show];
//        [view release];
    }
    
    NSLog(@"%@", error.userInfo);
    NSLog(@"%@", error.domain);
    [[Public getInstance].juhua hide:YES];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    textField.layer.cornerRadius = 8.0f;
//    textField.layer.masksToBounds = YES;
//    textField.layer.borderColor = [[UIColor greenColor] CGColor];
//    textField.layer.borderWidth = 1.5f;
    
    curTextField = textField;
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
//    textField.layer.cornerRadius = 8.0f;
//    textField.layer.masksToBounds = YES;
//    textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    textField.layer.borderWidth = 1.5f;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (server == textField)
    {
        [account becomeFirstResponder];
    }
    else if (account == textField)
    {
        [pwd becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
     
    return YES;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 56.0f;
    return 100.0f;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellForLogin";
    
    NSString *curIdentifier = [[NSString alloc] initWithFormat:@"%@%d", identifier, indexPath.row];
    LoginViewCell *cell = [tableView dequeueReusableCellWithIdentifier:curIdentifier];
    
    if (!cell)
    {
        cell = /*[*/[[LoginViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:curIdentifier] /*autorelease]*/;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if (indexPath.row == 0)
    {
        self.server = cell.content;
        self.server.delegate = self;
        [cell.titleLab setText:@"服务器地址："];
        [self.server setText:SERVICE_IPADDR];
        
        if ([[Public getInstance].getDefaultIPAddress length] > 0)//有默认ip地址填入默认ip地址
        {
            [self.server setText:[Public getInstance].getDefaultIPAddress];
        }
    }
    else if (indexPath.row == 1)
    {
        self.account = cell.content;
        self.account.delegate = self;
        [cell.titleLab setText:@"登录帐户："];
        
        if ([[Public getInstance].getDefaultUserName length] > 0)//有默认ip地址填入默认ip地址
        {
            [self.account setText:[Public getInstance].getDefaultUserName];
        }
//        [self.account setText:@"sa"];
    }
    else if (indexPath.row == 2)
    {
        self.pwd = cell.content;
        self.pwd.delegate = self;
        [self.pwd setSecureTextEntry:YES];
        [cell.titleLab setText:@"登录密码："];
//        [self.pwd setText:@"123456"];
    }
    
    return cell;
}
@end
