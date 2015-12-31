//
//  FoodObject.m
//  OrderFood
//
//  Created by aplle on 8/13/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "FoodObject.h"

@interface FoodObject ()<AsyncUdpSocketDelegate>
{
    AsyncUdpSocket *getmingxi;
}

@end

@implementation FoodObject
@synthesize parse;
@synthesize bookCount;
@synthesize foodPrewview;
@synthesize getImage;
@synthesize didFinish;
@synthesize price;
@synthesize foodId;
@synthesize foodName;
@synthesize danwei;
@synthesize categoryId;
@synthesize url;
@synthesize description;
@synthesize searchStr;
@synthesize foodlist;
@synthesize didFinishQuery;
@synthesize addtionInfor;
@synthesize taocanDict;
@synthesize ischeck;
@synthesize taocanCountDict;
@synthesize isTaocan;
@synthesize searchIndex;
@synthesize referenceObject;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        bookCount = 0;
        getImage = [[ASiHttpClass alloc] init];
        [getImage SetIsTipOrNO:YES];
        getImage.delegate = self;
        foodlist = [[NSMutableArray alloc] init];
        getmingxi = [[AsyncUdpSocket alloc] initWithDelegate:self];
        taocanDict = [[NSMutableDictionary alloc] init];
        taocanCountDict = [[NSMutableDictionary alloc] init];
        ischeck = YES;
    }
    
    return self;
}

- (id)initWitPase:(NSMutableArray *)ps
{
    self = [self init];
    
    if (self)
    {
        self.parse = ps;
        
        if ([parse count] == 11)
        {
            self.foodId = [parse objectAtIndex:1];
            self.foodName = [parse objectAtIndex:2];
            self.danwei = [parse objectAtIndex:3];
            self.price = [parse objectAtIndex:4];
            self.categoryId = [parse objectAtIndex:6];
            self.url = [parse objectAtIndex:7];
            self.description = [parse objectAtIndex:8];
            self.searchStr = [parse objectAtIndex:9];
            self.isTaocan = parse[10];
        }
        else if ([parse count] == 10)
        {
            self.foodId = [parse objectAtIndex:0];
            self.foodName = [parse objectAtIndex:1];
            self.danwei = [parse objectAtIndex:2];
            self.price = [parse objectAtIndex:3];
            self.categoryId = [parse objectAtIndex:5];
            self.url = [parse objectAtIndex:6];
            self.description = [parse objectAtIndex:7];
            self.searchStr = [parse objectAtIndex:8];
            self.isTaocan = parse[9];
        }
        //开始下载预览图
        
        __block typeof(self) Obj = self;
        
        dispatch_async([Public getInstance].getImageQueue, ^(){
            [Obj->getImage GetSeverUrl:url];
        });
    }
    
    return self;
}

- (void)dealloc
{
    getImage.delegate = nil;
//    [getImage release];
    [self stopGetMingXi];
    getmingxi.delegate = nil;
//    [getmingxi release];
    self.searchStr = nil;
    self.getImage = nil;
    self.foodPrewview = nil;
    self.parse = nil;
    self.didFinish = nil;
    self.price = nil;
    self.foodId = nil;
    self.foodName = nil;
    self.danwei = nil;
    self.categoryId = nil;
    self.url = nil;
    self.description = nil;
    self.foodlist = nil;
    self.didFinishQuery = nil;
    self.addtionInfor = nil;
    self.taocanDict = nil;
    self.taocanCountDict = nil;
    
//    [super dealloc];
}

- (void)getMingXi
{
    NSString *str = [InstructionCreate getInStruction:INS_TC_MX withContents:[NSMutableArray arrayWithObject:foodId]];
    NSData * data = [str dataUsingEncoding:[Public getInstance].gbkEncoding];
    
    if (getmingxi)
    {
        getmingxi = nil;
        getmingxi = [[AsyncUdpSocket alloc] initWithDelegate:self];
    }
    
    [getmingxi receiveWithTimeout:MAX_TIMEOUT tag:[INS_TC_MX intValue]];
    [getmingxi sendData:data toHost:[Public getInstance].serviceIpAddr port:SERVICE_PORT withTimeout:MAX_TIMEOUT tag:[INS_TC_MX intValue]];
}

- (void)stopGetMingXi
{
    if (![getmingxi isClosed])
    {
        [getmingxi close];
    }
}

#pragma mark ASIHttpClassdelegate
-(void)finished_Recevived:(NSData *)receiveData andASiHttpClass:(ASiHttpClass *)asiHttpClass
{
    self.foodPrewview = [UIImage imageWithData:receiveData];
    if (didFinish)
    {
        didFinish(foodPrewview);
    }
}

-(void)Error_Rrcevived:(NSError *)error andASiHttpClass:(ASiHttpClass *)asiHttpClass
{
    if (didFinish)
    {
        didFinish(foodPrewview);
    }
}

-(void)request_Error:(NSData *)date andASiHttpClass:(ASiHttpClass *)asiHttpClass AndReceiveCode:(int) Id
{
    if (didFinish)
    {
        didFinish(foodPrewview);
    }
}


#pragma mark AsyncUdpSocketDelegate
/**
 * Called when the datagram with the given tag has been sent.
 **/
//- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
//{
//    
//}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
 **/
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    if (didFinishQuery)
    {
        didFinishQuery(foodlist);
    }
}

/**
 * Called when the socket has received the requested datagram.
 *
 * Due to the nature of UDP, you may occasionally receive undesired packets.
 * These may be rogue UDP packets from unknown hosts,
 * or they may be delayed packets arriving after retransmissions have already occurred.
 * It's important these packets are properly ignored, while not interfering with the flow of your implementation.
 * As an aid, this delegate method has a boolean return value.
 * If you ever need to ignore a received packet, simply return NO,
 * and AsyncUdpSocket will continue as if the packet never arrived.
 * That is, the original receive request will still be queued, and will still timeout as usual if a timeout was set.
 * For example, say you requested to receive data, and you set a timeout of 500 milliseconds, using a tag of 15.
 * If rogue data arrives after 250 milliseconds, this delegate method would be invoked, and you could simply return NO.
 * If the expected data then arrives within the next 250 milliseconds,
 * this delegate method will be invoked, with a tag of 15, just as if the rogue data never appeared.
 *
 * Under normal circumstances, you simply return YES from this method.
 **/
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    [[Public getInstance].juhua hide:YES];
    NSString *str = [[NSString alloc] initWithData:data encoding:[Public getInstance].gbkEncoding]/*@"IP:115.28.9.219    0102#7,30137,丽丽薯片100g,1,包,1,||30103,柠檬菊花茶（吉香宝）,1,包,1,||90001,佰迪乐盒装纸巾,1,盒,1,||30653,60g粤秀麻辣牛肉干,1,包,0,A||30851,广之乐红瓜子100g,1,包,0,A||88888,大果盘(套),1,盘,0,B||30866,佰迪乐(艾尔发)玉米花奶甜味袋装120g,1,包,0,B||;"*/;
    InstructionParse *Parse = [[InstructionParse alloc] initWithInstructionString:[[Public getComponentsSeparated:str] objectAtIndex:1]];
    NSLog(@"%@:%@", foodId, str);
    
    if (Parse && [Parse.contents count] > 0 && [[[Parse.contents objectAtIndex:0] objectAtIndex:0] intValue] > 0)
    {
        [foodlist removeAllObjects];
        int index = 0;
        for (NSArray *sub_arr in Parse.contents)
        {
            TaoCanMingxi *obj = [[TaoCanMingxi alloc] init];
//            obj.isSelected = NO;
            
            if (index++ == 0)
            {
                obj.foodID = [sub_arr objectAtIndex:1];
                obj.foodName = [sub_arr objectAtIndex:2];
                obj.foodCount = [[sub_arr objectAtIndex:3] intValue];
                obj.danwei = [sub_arr objectAtIndex:4];
                obj.isguding = [[sub_arr objectAtIndex:5] boolValue];
                obj.fenzu = [sub_arr objectAtIndex:6];
            }
            else
            {
                obj.foodID = [sub_arr objectAtIndex:0];
                obj.foodName = [sub_arr objectAtIndex:1];
                obj.foodCount = [[sub_arr objectAtIndex:2] intValue];
                obj.danwei = [sub_arr objectAtIndex:3];
                obj.isguding = [[sub_arr objectAtIndex:4] boolValue];
                obj.fenzu = [sub_arr objectAtIndex:5];
            }
            
            NSString *key = nil;
            
            if (obj.isguding) {
                
                key = @"guding";
            }
            else {
                
                key = obj.fenzu;
            }
            
            NSMutableArray *arra = [taocanDict objectForKey:key];
            
            if (arra == nil) {
                arra = [[NSMutableArray alloc] init];
                [taocanDict setObject:arra forKey:key];
                arra = [taocanDict objectForKey:key];
            }
            
            [arra addObject:obj];
            [foodlist addObject:obj];
//            [obj release];
        }
        
        NSArray *keys = [taocanDict allKeys];
        
        
        for (NSString *key in keys)
        {
            if (![key isEqualToString:@"guding"])
            {
                NSArray *arr = [taocanDict objectForKey:key];
                int total = ((TaoCanMingxi *)[arr firstObject]).foodCount;
                
                for (TaoCanMingxi *obj in arr)
                {
                    obj.foodCount = 0;
                }
                
                [taocanCountDict setObject:[NSNumber numberWithInt:total] forKey:key];
            }
        }
        
        if (didFinishQuery)
        {
            didFinishQuery(foodlist);
        }
    }
    
    NSLog(@"taocanDict:%@", taocanCountDict);
    
//    [Parse release];
//    [str release];
    
    return YES;
}

/**
 * Called if an error occurs while trying to receive a requested datagram.
 * This is generally due to a timeout, but could potentially be something else if some kind of OS error occurred.
 **/
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    if (didFinishQuery)
    {
        didFinishQuery(foodlist);
    }
}

/**
 * Called when the socket is closed.
 * A socket is only closed if you explicitly call one of the close methods.
 **/
//- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock
//{
//    
//}

@end

