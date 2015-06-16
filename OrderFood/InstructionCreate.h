//
//  InstructionCreate.h
//  OrderFood
//
//  Created by aplle on 7/22/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import <Foundation/Foundation.h>
//构造发送的数据
@interface InstructionCreate : NSObject
+ (NSString *)getInStruction:(NSString *)instruction withContents:(NSMutableArray *)contents;
+ (NSString *)getSerialNum;
@end
