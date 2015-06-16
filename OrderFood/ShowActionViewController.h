//
//  ShowActionViewController.h
//  OrderFood
//
//  Created by aplle on 9/26/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxInforView.h"

@class ShowActionViewController;
typedef void(^PopUpAction)(ShowActionViewController *);
typedef void(^OrderingFood)(ShowActionViewController *);
typedef void(^MemberOrderingFood)(ShowActionViewController *);
typedef void(^BookRoom)(ShowActionViewController *);
//显示对房间操作的界面
@interface ShowActionViewController : UIViewController
@property (nonatomic, copy) PopUpAction  backAction;//返回回调块
@property (nonatomic, retain) BoxInforView  *curBoxInforView;//当前的房间视图
@property (nonatomic, copy) OrderingFood orderFood;//定食回调块
@property (nonatomic, copy) MemberOrderingFood memberOrderFood;//会员定食回调块
@property (nonatomic, copy) BookRoom    bookRoom;//开房回调块
- (id)initWithBoxInforView:(BoxInforView *)view;
@end
