//
//  SelectedListViewController.h
//  OrderFood
//
//  Created by aplle on 8/14/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectedListViewController;

typedef void(^BackAction)(SelectedListViewController *);
typedef void(^BookAction)(SelectedListViewController *);
//已选食物列表
@interface SelectedListViewController : UIViewController
- (id)initWithSelectArray:(NSMutableArray *)selectedArray;
@property (nonatomic, copy) BackAction      didBack;//点击返回回调块
@property (nonatomic, copy) BookAction      didBook;//点击下单回调块
@end
