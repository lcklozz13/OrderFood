//
//  FoodObject.h
//  OrderFood
//
//  Created by aplle on 8/13/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASiHttpClass.h"
#import "TaoCanMingxi.h"

typedef void(^DownloadFinsh)(UIImage *);
typedef void(^QueryFoodListFinisg)(NSMutableArray *);
//食物对象
@interface FoodObject : NSObject<ASIHttpClassdelegate>
@property (nonatomic, retain) NSMutableArray    *parse;
@property (nonatomic, assign) int               bookCount;//选择个数
@property (nonatomic, retain) UIImage           *foodPrewview;//食物预览图
@property (nonatomic, retain) ASiHttpClass      *getImage;//获得图片请求
@property (nonatomic, copy)   DownloadFinsh     didFinish;//下载图片结束回调块

@property (nonatomic, retain) NSString          *foodId;//食物id
@property (nonatomic, retain) NSString          *foodName;//食物名称
@property (nonatomic, retain) NSString          *danwei;//单位
@property (nonatomic, retain) NSString          *price;//价格
@property (nonatomic, retain) NSString          *categoryId;//类别id
@property (nonatomic, retain) NSString          *url;//图片url
@property (nonatomic, retain) NSString          *description;//描述
@property (nonatomic, retain) NSString          *searchStr;//搜索字符
@property (nonatomic, retain) NSString          *addtionInfor;//

@property (nonatomic, retain) NSMutableArray    *foodlist;//套餐列表
@property (nonatomic, copy)   QueryFoodListFinisg   didFinishQuery;
@property (nonatomic, retain) NSMutableDictionary *taocanDict;
@property (nonatomic, retain) NSMutableDictionary *taocanCountDict;
@property (nonatomic, assign) BOOL              ischeck;
@property (nonatomic, retain) NSString          *isTaocan;
@property (nonatomic, assign) int               searchIndex;

@property (nonatomic, retain) FoodObject        *referenceObject;

- (id)initWitPase:(NSMutableArray *)ps;
- (void)getMingXi;
- (void)stopGetMingXi;
@end
//编号,名称,单位,价格,0,类别编号