//
//  InstructionParse.h
//  OrderFood
//
//  Created by aplle on 7/21/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import <Foundation/Foundation.h>
//解析返回的数据
@interface InstructionParse : NSObject
@property (nonatomic, retain) NSString          *serialNum;
@property (nonatomic, retain) NSString          *instruction;
@property (nonatomic, retain) NSString          *returnState;
@property (nonatomic, retain) NSMutableArray    *contents;

- (id)initWithInstructionString:(NSString *)instruction;
@end
