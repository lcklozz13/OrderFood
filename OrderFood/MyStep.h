//
//  MyStep.h
//  OrderFood
//
//  Created by klozz on 14-8-5.
//  Copyright (c) 2014年 handcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaoCanMingxi.h"

@interface MyStep : UIStepper
@property (nonatomic, retain) TaoCanMingxi  *mingxi;
@property (nonatomic, retain) NSArray       *taocanArray;
@end
