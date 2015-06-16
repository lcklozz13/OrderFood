//
//  InstructionParse.m
//  OrderFood
//
//  Created by aplle on 7/21/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "InstructionParse.h"

@implementation InstructionParse

@synthesize serialNum;
@synthesize instruction;
@synthesize returnState;
@synthesize contents;

- (id)initWithInstructionString:(NSString *)instructionStr
{
    self = [super init];
    
    if (self)
    {
        contents = [[NSMutableArray alloc] init];
        instructionStr = [instructionStr stringByReplacingOccurrencesOfString:@";" withString:@""];
        NSArray *a1 = [instructionStr componentsSeparatedByString:@"#"];
        if ([a1 count] > 0)
        {
            NSString *strCMD = [a1 objectAtIndex:0];
            if ([strCMD length] > 4)
            {
                self.serialNum = [strCMD substringToIndex:[strCMD length] - 4];
                self.instruction = [strCMD substringFromIndex:[strCMD length] - 4];
            }
            else
            {
                self.instruction = strCMD;
            }
            
            if ([a1 count] > 1)
            {
                NSArray *a2 = [[a1 objectAtIndex:1] componentsSeparatedByString:@"||"];
                NSMutableArray *contentObject = nil;
                
                for (NSString *subStr in a2)
                {
                    if ([subStr length] == 0)
                    {
                        continue;
                    }
                    
                    NSArray *subArr = [subStr componentsSeparatedByString:@","];
                    contentObject = nil;
                    
                    for (NSString *sub in subArr)
                    {
                        if (!contentObject)
                        {
                            contentObject = [NSMutableArray array];
                        }
                        
                        [contentObject addObject:sub];
                    }
                    
                    if (contentObject)
                    {
                        [contents addObject:contentObject];
                    }
                }
            }
        }
    }
    
    return self;
}

- (void)dealloc
{
    self.serialNum = nil;
    self.instruction = nil;
    self.returnState = nil;
    self.contents = nil;
    
//    [super dealloc];
}
@end
