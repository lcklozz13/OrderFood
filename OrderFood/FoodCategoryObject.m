//
//  FoodCategoryObject.m
//  OrderFood
//
//  Created by aplle on 8/13/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "FoodCategoryObject.h"


@interface FoodCategoryObject ()
- (void)getFoodListAction;
@end

@implementation FoodCategoryObject
@synthesize foodListParse;
@synthesize foodCategory;
@synthesize getFoodList;
@synthesize foodListArray;
@synthesize roomId;
@synthesize didFinishDownload;
@synthesize index;
@synthesize categoryId;

- (void)closeSocket
{
    if (getFoodList && ![getFoodList isClosed])
    {
        [getFoodList close];
    }
    
    [foodListArray makeObjectsPerformSelector:@selector(stopGetMingXi)];
}

- (void)dealloc
{
    [self closeSocket];
    getFoodList.delegate = nil;
    self.getFoodList = nil;
    self.foodCategory = nil;
    self.foodListParse = nil;
    [foodListArray makeObjectsPerformSelector:@selector(stopGetMingXi)];
    [foodListArray removeAllObjects];
    self.foodListArray = nil;
    self.roomId = nil;
    self.didFinishDownload = nil;
    
//    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        getFoodList = [[AsyncUdpSocket alloc] initWithDelegate:self];
        [getFoodList setMaxReceiveBufferSize:92160];
        foodListArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}
//获取食物列表操作
- (void)getFoodListAction
{
    if ([foodCategory count] == 3)
    {
        self.categoryId = [foodCategory objectAtIndex:1];
    }
    else if ([foodCategory count] == 2)
    {
        self.categoryId = [foodCategory objectAtIndex:0];
    }
    
    NSString *str = [InstructionCreate getInStruction:INS_GET_GOODS_LIST withContents:[NSMutableArray arrayWithObject:[NSMutableArray arrayWithObjects:roomId, categoryId, nil]]];
    NSLog(@"%@", str);
    NSData * data = [str dataUsingEncoding:[Public getInstance].gbkEncoding];
    
    if (getFoodList)
    {
        getFoodList = nil;
        getFoodList = [[AsyncUdpSocket alloc] initWithDelegate:self];
        [getFoodList setMaxReceiveBufferSize:92160];
    }
    
    [getFoodList receiveWithTimeout:MAX_TIMEOUT tag:[INS_GET_GOODS_LIST intValue]];
    [getFoodList sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_GET_GOODS_LIST intValue]];
}

- (id)initWithParse:(NSMutableArray *)ps roomid:(NSString *)roomid
{
    self = [self init];
    
    if (self)
    {
        self.roomId = roomid;
        self.foodCategory = ps;
        //获取食物列表
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self getFoodListAction];
        });
    }
    
    return self;
}

#pragma mark AsyncUdpSocketDelegate

- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    if ([foodListArray count] == 0) {
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self getFoodListAction];
        });
    }
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSString *str = [[NSString alloc] initWithData:data encoding:[Public getInstance].gbkEncoding];
//    NSLog(@"tag:%ld recv:%@", tag, str);
    if (tag == [INS_GET_GOODS_LIST intValue])
    {
        if ([str length] == 0)
        {
            
        }
        else
        {
            if ([foodListArray count] > 0) {
                return NO;
            }
            //获取成功，解析
            [foodListArray removeAllObjects];
            InstructionParse *parse = [[InstructionParse alloc] initWithInstructionString:[[Public getComponentsSeparated:str] objectAtIndex:1]];
            NSLog(@"%@", str);

            self.foodListParse = parse;
//            [parse release];
            
            for (NSMutableArray *arr in foodListParse.contents)
            {
                FoodObject *object = [[FoodObject alloc] initWitPase:arr];
                [foodListArray addObject:object];
//                [object release];
            }
            
            if (didFinishDownload)
            {
                didFinishDownload(self);
            }
        }
    }
    
//    [str release];
    
    return YES;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    if ([foodListArray count] == 0) {
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self getFoodListAction];
        });
    }
    
    NSLog(@"%@", error.userInfo);
    NSLog(@"%@", error.domain);
}


@end
