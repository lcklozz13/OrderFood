//
//  InquiryOrderCell.m
//  OrderFood
//
//  Created by aplle on 8/4/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "InquiryOrderCell.h"

@implementation InquiryOrderCell
@synthesize dataShow;

- (void)dealloc
{
    self.dataShow = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"InquiryOrderViewController" owner:nil options:nil];
        
        for (id object in nibs)
        {
            if ([object isKindOfClass:[InquiryOrderCell class]])
            {
                [self release];
                self = [object retain];
                break;
            }
        }
    }
    
    return self;
}

- (void)setDataShow:(NSMutableArray *)dataShow1
{
    if (dataShow)
    {
        [dataShow release], dataShow = nil;
    }
    
    dataShow = [dataShow1 retain];
    int tag = 0;
    UILabel *lab = nil;
    
    for (NSString *sub in dataShow)
    {
        lab = (UILabel *)[self viewWithTag:tag++];
        [lab setText:sub];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
