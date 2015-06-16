//
//  CheckUserViewController.m
//  OrderFood
//
//  Created by klozz on 13-10-27.
//  Copyright (c) 2013年 handcent. All rights reserved.
//

#import "CheckUserViewController.h"
#import "AsyncUdpSocket.h"

@interface CheckUserViewController ()<UITextFieldDelegate, AsyncUdpSocketDelegate>
{
    AsyncUdpSocket      *sendSocket;//校验请求
}
@property (nonatomic, retain) IBOutlet  UITextField     *username;//用户名称
@property (nonatomic, retain) IBOutlet  UITextField     *pwd;//密码
- (IBAction)cancelAction:(id)sender;//取消操作
- (IBAction)doneAction:(id)sender;//验证操作
@end

@implementation CheckUserViewController
@synthesize checkSuccessfully;
@synthesize cancelCheck;
@synthesize username;
@synthesize pwd;

- (void)dealloc
{
    self.cancelCheck = nil;
    self.checkSuccessfully = nil;
    self.username = nil;
    self.pwd = nil;
    sendSocket.delegate = nil;
//    [sendSocket release],
    sendSocket = nil;
    
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [username resignFirstResponder];
    [pwd resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    sendSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAction:(id)sender
{
    //取消操作
    if (cancelCheck)
    {
        cancelCheck(self);
    }
}

- (IBAction)doneAction:(id)sender
{
    //确定操作
    [username resignFirstResponder];
    [pwd resignFirstResponder];
    //判断用户名是否为空
    if ([username.text length] == 0)
    {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"工号不能为空" message:@"工号不能为空，请输入一个用户名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [view show];
//        [view release];
        return;
    }
    //判断密码是否为空
    if ([pwd.text length] == 0)
    {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"密码不能为空" message:@"密码不能为空，请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [view show];
//        [view release];
        return;
    }
    //发送校验请求
    NSString *str = [InstructionCreate getInStruction:INS_LOGIN withContents:[NSMutableArray arrayWithObject:[NSMutableArray arrayWithObjects:username.text, pwd.text, nil]]];

    NSData * data = [str dataUsingEncoding:[Public getInstance].gbkEncoding];
    [Public getInstance].juhua.labelText = @"正在验证。。。";
    [[Public getInstance].juhua show:YES];
    [sendSocket receiveWithTimeout:MAX_TIMEOUT tag:[INS_LOGIN intValue]];
    [sendSocket sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_LOGIN intValue]];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == username)
    {
        [pwd becomeFirstResponder];
        return NO;
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - AsyncUdpSocketDelegate
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
    //校验请求成功
    [[Public getInstance].juhua hide:YES];
    NSString *str = [[NSString alloc] initWithData:data encoding:[Public getInstance].gbkEncoding];
    NSLog(@"tag:%ld recv:%@", tag, str);
    if (tag == [INS_LOGIN intValue])
    {
        //登陆反馈
        if ([str length] == 0)
        {
            //用户名密码不匹配
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"验证失败" message:@"用户名或者密码错误，请确认输入。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [view show];
//            [view release];
        }
        else
        {
            InstructionParse *parse = [[InstructionParse alloc] initWithInstructionString:[[Public getComponentsSeparated:str] objectAtIndex:1]];
            
            if ([[[[parse.contents objectAtIndex:0] objectAtIndex:0] substringToIndex:2] isEqualToString:@"OK"])
            {
                //校验成功
                if(checkSuccessfully)
                {
                    checkSuccessfully(self);
                }
            }
            else
            {
                 //用户名密码不匹配
                UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"验证失败" message:@"用户名或者密码错误，请确认输入。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [view show];
//                [view release];
            }
            
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

@end
