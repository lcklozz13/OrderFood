//
//  TaoCanMingxi.h
//  OrderFood
//
//  Created by klozz on 14-3-16.
//  Copyright (c) 2014年 handcent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaoCanMingxi : NSObject
//物品编号，物品名称，物品数量，物品单位
@property (nonatomic, retain) NSString  *foodID;
@property (nonatomic, retain) NSString  *foodName;
@property (nonatomic, assign) int        foodCount;
@property (nonatomic, retain) NSString  *danwei;
@property (nonatomic, assign) BOOL      isguding;
@property (nonatomic, retain) NSString  *fenzu;
@property (nonatomic, assign) BOOL      isSelected;
@end