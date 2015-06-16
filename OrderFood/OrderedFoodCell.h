//
//  OrderedFoodCell.h
//  OrderFood
//
//  Created by aplle on 10/7/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderedFood;

typedef void(^TuidanAction)(OrderedFood *);
//食物列表cell
@interface OrderedFoodCell : UITableViewCell
@property (nonatomic, retain) OrderedFood               *curOrderFood;//当前已定食物
@property (nonatomic, readonly) UIImageView             *selectImageBg;//背景图片
@property (nonatomic, copy) TuidanAction                didClickTuidan;//点击退订
@end
