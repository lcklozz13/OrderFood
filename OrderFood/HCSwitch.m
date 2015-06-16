//
//  HCSwitch.m
//  IM
//
//  Created by aplle on 8/16/13.
//
//

#import "HCSwitch.h"

#define DEFAULT_SIZE CGSizeMake(77, 27)

@interface HCSwitch ()
@property (nonatomic, retain) UIImageView   *onImageView;
@property (nonatomic, retain) UIImageView   *offImageView;

@end


@implementation HCSwitch
@synthesize onImageView;
@synthesize offImageView;
@synthesize onImage;
@synthesize offImage;
@synthesize isOn;

- (void)dealloc
{
    self.onImageView = nil;
    self.offImageView = nil;
    self.onImage = nil;
    self.offImage = nil;
    
//    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithOnImage:(UIImage *)onImage1 offImage:(UIImage *)offImage1
{
    self = [super initWithFrame:CGRectMake(0, 0, DEFAULT_SIZE.width, DEFAULT_SIZE.height)];
    
    if (self)
    {
        self.clipsToBounds = YES;
        onImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-(self.bounds.size.width - DEFAULT_SIZE.height), 0, self.bounds.size.width, self.bounds.size.height)];
        [onImageView setImage:onImage1];
        [self addSubview:onImageView];
        
        offImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [offImageView setImage:offImage1];
        [self addSubview:offImageView];
        self.isOn = NO;
        [onImageView setHidden:!isOn];
        [offImageView setHidden:isOn];
    }
    
    return self;
}

- (void)setOffImage:(UIImage *)offImage1
{
    [offImageView setImage:offImage1];
}


- (void)setOnImage:(UIImage *)onImage1
{
    [onImageView setImage:onImage1];
}

- (UIImage *)offImage
{
    return offImageView.image;
}

- (UIImage *)onImage
{
    return onImageView.image;
}

- (void)setIsOn:(BOOL)isOn1
{
    if (isOn == isOn1)
    {
        return;
    }
    
    isOn = isOn1;
    
    CGRect r1 = onImageView.frame;
    CGRect r2 = offImageView.frame;
    
    if (isOn)
    {
        r1.origin.x = 0.0f;
        r2.origin.x = self.bounds.size.width - DEFAULT_SIZE.height;
    }
    else
    {
        r1.origin.x = - (self.bounds.size.width - DEFAULT_SIZE.height);
        r2.origin.x = 0.0f;
    }
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.199f] forKey:kCATransactionAnimationDuration];
    onImageView.frame = r1;
    offImageView.frame = r2;
    [onImageView setHidden:!isOn];
    [offImageView setHidden:isOn];
    [CATransaction commit];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.isOn = !isOn;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return [super continueTrackingWithTouch:touch withEvent:event];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
