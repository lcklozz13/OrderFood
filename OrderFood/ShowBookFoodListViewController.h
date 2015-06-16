//
//  ShowBookFoodListViewController.h
//  OrderFood
//
//  Created by aplle on 10/6/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShowBookFoodListViewController;

typedef void(^BackActionByUser)(ShowBookFoodListViewController *);
//已定列表
@interface ShowBookFoodListViewController : UIViewController
@property (nonatomic, copy) BackActionByUser    didBack;//点击返回
@property (nonatomic, retain) NSString                  *roomId;//房间ID
- (id)initWithDict:(NSMutableDictionary *)dict;
@end
