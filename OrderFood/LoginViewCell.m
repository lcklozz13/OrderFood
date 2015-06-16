//
//  LoginViewCell.m
//  OrderFood
//
//  Created by aplle on 8/16/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "LoginViewCell.h"

@implementation LoginViewCell
@synthesize titleLab;
@synthesize content;

- (void)dealloc
{
    self.titleLab = nil;
    self.content = nil;
    
//    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 22)];
        [titleLab setTextAlignment:NSTextAlignmentRight];
        [titleLab setBackgroundColor:[UIColor clearColor]];
        [titleLab setTextColor:[UIColor lightGrayColor]];
        [titleLab setFont:[UIFont boldSystemFontOfSize:17.0f]];
        
        content = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 22)];
        content.leftViewMode = UITextFieldViewModeAlways;
        content.leftView = titleLab;
        [content setTextColor:[UIColor lightGrayColor]];
        [content setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [self addSubview:content];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect r = self.bounds;
    r.size.height = 22.0f;
    r.size.width -= 20.0f;
    r.origin = CGPointMake(10, (self.bounds.size.height - 22.0f)/2.0f);
    content.frame = r;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
