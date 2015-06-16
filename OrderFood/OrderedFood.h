//
//  OrderedFood.h
//  OrderFood
//
//  Created by aplle on 10/7/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASiHttpClass.h"
//已定食物数据结构
@interface OrderedFood : NSObject<ASIHttpClassdelegate>
@property (nonatomic, retain) NSString      *orderedId;//已定食物id
@property (nonatomic, retain) NSString      *foodName;//食物名称
@property (nonatomic, retain) NSString      *danwei;//单位
@property (nonatomic, retain) NSString      *buyCount;//购买个数
@property (nonatomic, retain) NSString      *price;//价格
@property (nonatomic, retain) NSString      *totalCount;//总价
@property (nonatomic, retain) NSString      *unknow1;
@property (nonatomic, retain) NSString      *yesOrNo;
@property (nonatomic, retain) NSString      *unknow2;
@property (nonatomic, retain) NSString      *unknow3;
@property (nonatomic, retain) NSString      *foodId;//食物id
@property (nonatomic, retain) NSString      *url;//食物预览图url
@property (nonatomic, retain) NSString      *orderedDate;//下单时间

@property (nonatomic, retain) UIImage           *foodPrewview;//食物预览图
@property (nonatomic, retain) ASiHttpClass      *getImage;//获取食物请求
- (id)initWithNSArray:(NSArray *)array;
@end
