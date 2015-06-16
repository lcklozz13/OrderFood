//
//  ShowDetailViewController.h
//  OrderFood
//
//  Created by aplle on 8/14/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodObject.h"

@class ShowDetailViewController;

typedef void(^BackAction)(ShowDetailViewController *);
//显示食物详情
@interface ShowDetailViewController : UIViewController
@property (nonatomic, copy) BackAction  didBackAction;//返回操作
- (id)initWithFoodObject:(FoodObject *)object;
@end
