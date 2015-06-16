//
//  OrderedFood.m
//  OrderFood
//
//  Created by aplle on 10/7/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "OrderedFood.h"

@implementation OrderedFood
@synthesize orderedId;
@synthesize foodName;
@synthesize danwei;
@synthesize buyCount;
@synthesize price;
@synthesize totalCount;
@synthesize unknow1;
@synthesize yesOrNo;
@synthesize unknow2;
@synthesize unknow3;
@synthesize foodId;
@synthesize url;
@synthesize orderedDate;

@synthesize foodPrewview;
@synthesize getImage;

- (id)initWithNSArray:(NSArray *)array
{
    self = [super init];
    
    if (self)
    {
        getImage = [[ASiHttpClass alloc] init];
        [getImage SetIsTipOrNO:YES];
        getImage.delegate = self;
        
        if ([array count] >= 13)
        {
            self.orderedId = [array objectAtIndex:0];
            self.foodName = [array objectAtIndex:1];
            self.danwei = [array objectAtIndex:2];
            self.buyCount = [array objectAtIndex:3];
            self.price = [array objectAtIndex:4];
            self.totalCount = [array objectAtIndex:5];
            self.unknow1 = [array objectAtIndex:6];
            self.yesOrNo = [array objectAtIndex:7];
            self.unknow2 = [array objectAtIndex:8];
            self.unknow3 = [array objectAtIndex:9];
            self.foodId = [array objectAtIndex:10];
            self.url = [array objectAtIndex:11];
            self.orderedDate = [array objectAtIndex:12];
            
            dispatch_async([Public getInstance].getImageQueue, ^(){
                               [getImage GetSeverUrl:url];
                           });
        }
    }
    
    return self;
}

- (void)dealloc
{
    self.orderedId = nil;
    self.foodName = nil;
    self.danwei = nil;
    self.buyCount = nil;
    self.price = nil;
    self.totalCount = nil;
    self.unknow1 = nil;
    self.yesOrNo = nil;
    self.unknow2 = nil;
    self.unknow3 = nil;
    self.foodId = nil;
    self.url = nil;
    getImage.delegate = nil;
    self.getImage = nil;
    self.foodPrewview = nil;
    self.orderedDate = nil;
    
//    [super dealloc];
}

#pragma mark ASIHttpClassdelegate
-(void)finished_Recevived:(NSData *)receiveData andASiHttpClass:(ASiHttpClass *)asiHttpClass
{
    self.foodPrewview = [UIImage imageWithData:receiveData];
}

-(void)Error_Rrcevived:(NSError *)error andASiHttpClass:(ASiHttpClass *)asiHttpClass
{
    NSLog(@"Error_Rrcevived");
}

-(void)request_Error:(NSData *)date andASiHttpClass:(ASiHttpClass *)asiHttpClass AndReceiveCode:(int) Id
{
    NSLog(@"request_Error:%@", url);
}
@end
