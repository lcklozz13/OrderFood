//
//  CheckUserViewController.h
//  OrderFood
//
//  Created by klozz on 13-10-27.
//  Copyright (c) 2013年 handcent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CheckUserViewController;

typedef void(^CheckUserViewControllerDidCancelCheck)(CheckUserViewController *);
typedef void(^CheckUserViewControllerDidCheckSuccessfully)(CheckUserViewController *);
//输入操作员
@interface CheckUserViewController : UIViewController
@property (nonatomic, copy) CheckUserViewControllerDidCancelCheck cancelCheck;//取消验证回调块
@property (nonatomic, copy) CheckUserViewControllerDidCheckSuccessfully checkSuccessfully;//验证成功回调块
@end
