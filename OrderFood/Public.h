//
//  Public.h
//  OrderFood
//
//  Created by aplle on 8/3/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "PopTableAlertView.h"

@class InstructionParse;

#define Ordered_No_Checkout         @"NoCheckout"
#define Ordered_Had_Checkout         @"HadCheckout"

@interface Public : NSObject
@property (nonatomic, assign) NSStringEncoding  gbkEncoding;//编码模式
@property (nonatomic, retain) MBProgressHUD     *juhua;//显示等待控件
@property (nonatomic, retain) NSString          *userName;//用户名
@property (nonatomic, retain) NSString          *userCode;//用户code
@property (nonatomic, retain) InstructionParse  *curPublishDes;
@property (nonatomic, copy) NSString          *serviceIpAddr;//ip地址
@property (nonatomic, retain) NSMutableDictionary *bookHistoryDictionary;//订餐记录
@property (nonatomic, unsafe_unretained) dispatch_queue_t getImageQueue;//获得图片的线程队列
@property (nonatomic, unsafe_unretained) dispatch_queue_t getCategoryQueue;//获得类别的线程队列
@property (nonatomic, retain) NSMutableDictionary *roomIDAndBookID;//房间号与订餐

+ (Public *)getInstance;//返回实例
+ (void)freeInstance;//释放实例
+ (UIColor *)getColorFromString:(NSString *)colorStr;//获得颜色
- (float)statubarUIInterfaceOrientationAngleOfOrientation;//获得状态栏旋转位置
- (void)saveDefaultIPAddress;//保存默认ip
- (NSString *)getDefaultIPAddress;//获得默认ip
- (NSString *)getDefaultUserName;//获得默认UserName
+ (NSArray *)getComponentsSeparated:(NSString *)string;
+ (NSString *)getCurrentDeviceModel;
@end
