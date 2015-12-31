//
//  BoxInforView.m
//  seeboss
//
//  Created by aplle on 5/26/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "BoxInforView.h"
#import "Public.h"

@interface BoxInforView ()
{
    UILabel     *titleLab;
    UILabel     *subTitleLab;
    UILabel     *timeLab;
    UILabel     *memberLab;
}
@property (nonatomic, retain) UIImageView   *bgImageView;
@end

@implementation BoxInforView
@synthesize curCellInfor;
@synthesize code, title, category, roomId, index;
@synthesize bgImageView;
@synthesize isMember;
@synthesize stat;
@synthesize time;
@synthesize roomCategory;
@synthesize usedTime;
@synthesize leaveTime;

@synthesize didOrderFoodAction, didChangeRoomAction, didOpenRoomAction;

- (void)dealloc
{
    self.curCellInfor = nil;
    self.roomId = nil;
    self.code = nil;
    self.title = nil;
    self.category = nil;
    
    [titleLab removeFromSuperview];
    //    [titleLab release],
    titleLab = nil;
    [subTitleLab removeFromSuperview];
    //    [subTitleLab release],
    subTitleLab = nil;
    [memberLab removeFromSuperview];
    //    [memberLab release],
    memberLab = nil;
    [timeLab removeFromSuperview];
    //    [timeLab release],
    timeLab = nil;
    
    self.bgImageView = nil;
    self.didOrderFoodAction = nil;
    self.didChangeRoomAction = nil;
    self.didOpenRoomAction = nil;
    
    //    [super dealloc];
}

- (id)initWithBoxCellInfor:(NSMutableArray *)cellInfor frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        CGSize fontSize = [@" " sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]];
        CGSize fontSize1 = [@" " sizeWithFont:[UIFont boldSystemFontOfSize:12.0f]];
        CGSize fontSize2 = [@" " sizeWithFont:[UIFont boldSystemFontOfSize:10.0f]];
        
        bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:bgImageView];
        [bgImageView setUserInteractionEnabled:NO];
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.bounds.size.width - 20, fontSize.height)];
        [titleLab setBackgroundColor:[UIColor clearColor]];
        [titleLab setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [titleLab setMinimumFontSize:7.0f];
        [titleLab setTextColor:[UIColor whiteColor]];
        [titleLab setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:titleLab];
        [titleLab setUserInteractionEnabled:NO];
        
        subTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLab.frame.size.height + titleLab.frame.origin.y, self.bounds.size.width - 20, fontSize1.height)];
        [subTitleLab setBackgroundColor:[UIColor clearColor]];
        [subTitleLab setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [subTitleLab setMinimumFontSize:6.0f];
        [subTitleLab setTextColor:[UIColor whiteColor]];
        [subTitleLab setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:subTitleLab];
        [subTitleLab setUserInteractionEnabled:NO];
        
        timeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, subTitleLab.frame.size.height + subTitleLab.frame.origin.y, self.bounds.size.width - 20, fontSize1.height)];
        [timeLab setBackgroundColor:[UIColor clearColor]];
        [timeLab setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [timeLab setMinimumFontSize:6.0f];
        [timeLab setTextColor:[UIColor whiteColor]];
        [timeLab setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:timeLab];
        [timeLab setUserInteractionEnabled:NO];
        
        memberLab = [[UILabel alloc] initWithFrame:CGRectMake(10, timeLab.frame.size.height + timeLab.frame.origin.y, self.bounds.size.width - 20, fontSize2.height)];
        [memberLab setBackgroundColor:[UIColor clearColor]];
        [memberLab setFont:[UIFont boldSystemFontOfSize:10.0f]];
        [memberLab setMinimumFontSize:6.0f];
        [memberLab setTextColor:[UIColor whiteColor]];
        [memberLab setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:memberLab];
        [memberLab setUserInteractionEnabled:NO];
        
        self.curCellInfor = cellInfor;
    }
    
    return self;
}

- (void)setCode:(NSString *)code1
{
    if (code)
    {
        //        [code release],
        code = nil;
    }
    
    code = /*[*/code1 /*retain]*/;
    
    if ([code isEqualToString:@"U"])//U使用
    {
        stat = 1;
    }
    else if ([code isEqualToString:@"D"])//Z整理20140823，服务端改D为预定
    {
        //MARK:整理包厢清空之前的订餐缓存数据
//        NSMutableArray *bookedArray = [[Public getInstance].bookHistoryDictionary objectForKey:roomId];
//        if (bookedArray)
//        {
//            [bookedArray removeAllObjects];
//        }
        stat = 2;
    }
    else if ([code isEqualToString:@"K"])//K空闲
    {
        stat = 3;
        NSMutableArray *bookedList = [[Public getInstance].bookHistoryDictionary objectForKey:roomId];
        if ([bookedList count] > 0)
        {
            [bookedList removeAllObjects];
        }
    }
    else if ([code isEqualToString:@"W"])//W维修中
    {
        stat = 4;
    }
    else if ([code isEqualToString:@"S"])//S试机
    {
        stat = 5;
    }
    else if ([code isEqualToString:@"Y"])//Y以结
    {
        stat = 6;
    }
    else if ([code isEqualToString:@"E"])//E整理
    {
        stat = 7;
        NSMutableArray *bookedList = [[Public getInstance].bookHistoryDictionary objectForKey:roomId];
        if ([bookedList count] > 0)
        {
            [bookedList removeAllObjects];
        }
    }
    
    switch (stat)
    {
        case 1:
            
        {
            //            [subTitleLab setText:@"使用中"];
            UIImage *image = [UIImage imageNamed:@"b_using.png"];
            [bgImageView setImage:[image stretchableImageWithLeftCapWidth:image.size.width/2.0f topCapHeight:image.size.height/2.0f]];
        }
            break;
            
        case 2:
        {
            //            [subTitleLab setText:@"已预定"];
            UIImage *image = [UIImage imageNamed:@"b_order.png"];
            [bgImageView setImage:[image stretchableImageWithLeftCapWidth:image.size.width/2.0f topCapHeight:image.size.height/2.0f]];
        }
            break;
            
        case 3:
        {
            //            [subTitleLab setText:@"空闲"];
            UIImage *image = [UIImage imageNamed:@"b_free.png"];
            [bgImageView setImage:[image stretchableImageWithLeftCapWidth:image.size.width/2.0f topCapHeight:image.size.height/2.0f]];
        }
            break;
            
        case 4:
        {
            //            [subTitleLab setText:@"维修中"];
            UIImage *image = [UIImage imageNamed:@"b_fix.png"];
            [bgImageView setImage:[image stretchableImageWithLeftCapWidth:image.size.width/2.0f topCapHeight:image.size.height/2.0f]];
        }
            break;
            
        case 5:
        {
            //            [subTitleLab setText:@"试机中"];
            UIImage *image = [UIImage imageNamed:@"b_test.png"];
            [bgImageView setImage:[image stretchableImageWithLeftCapWidth:image.size.width/2.0f topCapHeight:image.size.height/2.0f]];
            [bgImageView setImage:[UIImage imageNamed:@"b_test.png"]];
        }
            break;
            
        case 6:
        {
            UIImage *image = [UIImage imageNamed:@"b_over.png"];
            [bgImageView setImage:[image stretchableImageWithLeftCapWidth:image.size.width/2.0f topCapHeight:image.size.height/2.0f]];
            [bgImageView setImage:[UIImage imageNamed:@"b_over.png"]];
        }
            break;
            
        case 7:
        {
            UIImage *image = [UIImage imageNamed:@"b_cleanup.png"];
            [bgImageView setImage:[image stretchableImageWithLeftCapWidth:image.size.width/2.0f topCapHeight:image.size.height/2.0f]];
            [bgImageView setImage:[UIImage imageNamed:@"b_cleanup.png"]];
        }
            
        default:
            break;
    }
    
    if ([curCellInfor count] == 5)
    {
        NSString *value = [curCellInfor objectAtIndex:2];
        value = code;
    }
    else if ([curCellInfor count] == 4)
    {
        NSString *value = [curCellInfor objectAtIndex:1];
        value = code;
    }
}

- (void)setCurCellInfor:(NSMutableArray *)curCellInfor1
{
    if (curCellInfor)
    {
        curCellInfor = nil;
    }
    
    curCellInfor = /*[*/curCellInfor1/* retain]*/;
    self.code = @"U";
    
    if ([curCellInfor count] == 10)
    {
        self.title = [curCellInfor objectAtIndex:3];
        [titleLab setText:title];
        self.code = [curCellInfor objectAtIndex:2];
        self.category = [curCellInfor objectAtIndex:4];
        self.roomId = [curCellInfor objectAtIndex:1];
        self.isMember = [[curCellInfor objectAtIndex:5] boolValue];
        self.time = [curCellInfor objectAtIndex:6];
        self.roomCategory = [curCellInfor objectAtIndex:7];
        self.usedTime = [curCellInfor1 objectAtIndex:8];
        self.leaveTime = [curCellInfor1 objectAtIndex:9];
    }
    else if ([curCellInfor count] == 9)
    {
        self.title = [curCellInfor objectAtIndex:2];
        [titleLab setText:title];
        self.code = [curCellInfor objectAtIndex:1];
        self.category = [curCellInfor objectAtIndex:3];
        self.roomId = [curCellInfor objectAtIndex:0];
        self.isMember = [[curCellInfor objectAtIndex:4] boolValue];
        self.time = [curCellInfor objectAtIndex:5];
        self.roomCategory = [curCellInfor objectAtIndex:6];
        self.usedTime = [curCellInfor1 objectAtIndex:7];
        self.leaveTime = [curCellInfor1 objectAtIndex:8];
    }
    
    [subTitleLab setText:roomCategory];
    //    [timeLab setText:time];
    //MARK:显示已使用的时间,fix(7.包厢状态不显示包厢时间，这样时间快到的包厢续点餐时候会来不及做，显示时间就可以提醒客人先续房费，然后点餐).
    [timeLab setText:usedTime];
    
    if (isMember)
    {
        [memberLab setText:@"会员"];
    }
    else
    {
        [memberLab setText:@""];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 
 
 - (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
 {
 return YES;
 }
 
 - (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
 {
 
 }
 
 - (void)cancelTrackingWithEvent:(UIEvent *)event
 {
 
 }
 */
@end
