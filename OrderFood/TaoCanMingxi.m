//
//  TaoCanMingxi.m
//  OrderFood
//
//  Created by klozz on 14-3-16.
//  Copyright (c) 2014年 handcent. All rights reserved.
//

#import "TaoCanMingxi.h"

@implementation TaoCanMingxi
@synthesize foodID;
@synthesize foodName;
@synthesize foodCount;
@synthesize danwei;
@synthesize isguding;
@synthesize fenzu;
@synthesize isSelected;

- (void)dealloc
{
    self.foodID = nil;
    self.foodName = nil;
    self.danwei = nil;
    self.fenzu = nil;
    
//    [super dealloc];
}

@end
