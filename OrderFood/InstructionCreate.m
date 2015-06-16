//
//  InstructionCreate.m
//  OrderFood
//
//  Created by aplle on 7/22/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "InstructionCreate.h"

@implementation InstructionCreate
+ (NSString *)getSerialNum
{
    static int g_index = 1;
    
    return [NSString stringWithFormat:@"%07d", g_index++];
}

+ (NSString *)getInStruction:(NSString *)instruction withContents:(NSMutableArray *)contents
{
    NSMutableString *str = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@%@#", [InstructionCreate getSerialNum], instruction]];
    
    for (int i=0; i<[contents count]; i++)
    {
        id object = [contents objectAtIndex:i];
        
        if ([object isKindOfClass:[NSMutableArray class]])
        {
            if (i == 0)
            {
                for (int j=0; j<[object count]; j++)
                {
                    if (j == 0)
                    {
                        [str appendString:[object objectAtIndex:j]];
                    }
                    else
                    {
                        [str appendFormat:@",%@", [object objectAtIndex:j]];
                    }
                }
            }
            else
            {
                for (int j=0; j<[object count]; j++)
                {
                    if (j == 0)
                    {
                        [str appendFormat:@"||%@", [object objectAtIndex:j]];
                    }
                    else
                    {
                        [str appendFormat:@",%@", [object objectAtIndex:j]];
                    }
                }
            }
        }
        else if ([object isKindOfClass:[NSString class]])
        {
            if (i == 0)
            {
                [str appendString:object];
            }
            else
            {
                [str appendFormat:@"||%@", object];
            }
        }
    }
    
    [str appendString:@";"];
    
    return str;
}
@end
