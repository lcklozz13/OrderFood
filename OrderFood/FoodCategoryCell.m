//
//  FoodCategoryCell.m
//  OrderFood
//
//  Created by aplle on 8/13/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "FoodCategoryCell.h"

@interface FoodCategoryCell ()
@property (nonatomic, strong) UIImageView   *selectedFlagView;//选中背景效果图
@end

@implementation FoodCategoryCell
@synthesize selectedFlagView;

- (void)dealloc
{
    self.selectedFlagView = nil;
    
//    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.textLabel setTextColor:[UIColor colorWithRed:156.0f/255.0f green:112.0f/255.0f blue:98.0f/255.0f alpha:1]];
        [self.textLabel setHighlightedTextColor:[UIColor colorWithRed:163.0f/255.0f green:40.0f/255.0f blue:3.0f/255.0f alpha:1]];
        [self.textLabel setFont:[UIFont boldSystemFontOfSize:24.0f]];
        selectedFlagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 27, 32)];
        [selectedFlagView setHighlightedImage:[UIImage imageNamed:@"selmark_mnu.png"]];
        [self addSubview:selectedFlagView];
    }
    return self;
}

- (void)layoutSubviews
{
    //排布界面
    [super layoutSubviews];
    CGRect r = self.textLabel.frame;
    r.origin.x = 40;
    r.size.width = self.bounds.size.width - 40;
    self.textLabel.frame = r;
    [self.textLabel setTextAlignment:NSTextAlignmentLeft];
    r = selectedFlagView.frame;
    r.origin = CGPointMake(self.bounds.size.width - r.size.width, (self.bounds.size.height - r.size.height) / 2.0f);
    selectedFlagView.frame = r;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    [self.textLabel setHighlighted:selected];
    [selectedFlagView setHighlighted:selected];//选中效果是否高亮
    
    // Configure the view for the selected state
}

@end
