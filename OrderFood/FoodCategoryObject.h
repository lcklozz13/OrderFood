//
//  FoodCategoryObject.h
//  OrderFood
//
//  Created by aplle on 8/13/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodObject.h"

@class FoodCategoryObject;

typedef void(^FinishedDownloadFoodList)(FoodCategoryObject *);
//食物类别
@interface FoodCategoryObject : NSObject<AsyncUdpSocketDelegate>
@property (nonatomic, retain) InstructionParse  *foodListParse;
@property (nonatomic, retain) NSMutableArray    *foodListArray;//存放类别对应的食物
@property (nonatomic, retain) NSMutableArray    *foodCategory;
@property (nonatomic, retain) AsyncUdpSocket    *getFoodList;//请求食物列表请求
@property (nonatomic, retain) NSString          *roomId;//房间id
@property (nonatomic, copy) FinishedDownloadFoodList  didFinishDownload;//下载食物列表回调函数
@property (nonatomic, assign) int               index;
@property (nonatomic, retain) NSString          *categoryId;//食物ID
- (id)initWithParse:(NSMutableArray *)ps roomid:(NSString *)roomid;
- (void)closeSocket;
@end
