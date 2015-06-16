//
//  OFNavigationBar.m
//  OrderFood
//
//  Created by aplle on 8/16/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "OFNavigationBar.h"

@interface OFNavigationBar ()
@property (nonatomic, retain) UIImage       *bgImage;

@end

@implementation OFNavigationBar
@synthesize bgImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (!bgImage)
    {
        self.bgImage = [UIImage imageNamed:@"b_top.png"];//背景图片
    }
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:bgImage]];
}

- (void)dealloc
{
    self.bgImage = nil;
//    [super dealloc];
}

@end
