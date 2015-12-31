//
//  OrderedFoodCell.m
//  OrderFood
//
//  Created by aplle on 10/7/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "OrderedFoodCell.h"
#import "OrderedFood.h"

@interface OrderedFoodCell ()
@property (nonatomic, strong) UIImageView     *selectImageBg;//选中背景图
@property (nonatomic, strong) UIImageView     *imageBg;//预览图片背景
@property (nonatomic, strong) UIImageView     *showPrewview;//预览图
@property (nonatomic, strong) UITextField     *showPrice;//显示价格
@property (nonatomic, strong) UILabel         *danwei1;//单位
@property (nonatomic, strong) UIButton        *tuidanBtn;//退订按钮

@property (nonatomic, strong) UILabel           *showCount;
@property (nonatomic, strong) UILabel           *danwei2;
@end

@implementation OrderedFoodCell

@synthesize curOrderFood;
@synthesize imageBg;
@synthesize showPrewview;
@synthesize showPrice;
@synthesize danwei1;
@synthesize tuidanBtn;
@synthesize selectImageBg;
@synthesize didClickTuidan;
@synthesize showCount;
@synthesize danwei2;

- (void)dealloc
{
    self.curOrderFood = nil;
    self.imageBg = nil;
    self.showPrewview = nil;
    self.showPrice = nil;
    self.danwei1 = nil;
    self.tuidanBtn = nil;
    self.selectImageBg = nil;
    self.didClickTuidan = nil;
    
//    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        selectImageBg = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:selectImageBg];
        [self.textLabel setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
        [self.textLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
        
        showPrice = [[UITextField alloc] initWithFrame:CGRectZero];
        [showPrice setFont:[UIFont boldSystemFontOfSize:24.0f]];
        showPrice.rightViewMode = UITextFieldViewModeAlways;
        [showPrice setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
        UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 30, 22)];
        [lab setBackgroundColor:[UIColor clearColor]];
        [lab setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
        [lab setFont:[UIFont boldSystemFontOfSize:18.0f]];
        self.danwei1 = lab;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 32.0f)];
        CGSize labSzie = [@" " sizeWithFont:lab.font];
        lab.frame = CGRectMake(0, (32.0f-labSzie.height)/2, labSzie.width, labSzie.height);
        [view addSubview:lab];
        showPrice.rightView = view;
        [showPrice setUserInteractionEnabled:NO];
        [showPrice setEnabled:NO];
        [self addSubview:showPrice];
//        [lab release];
//        [view release];
        
        UIImage *bg = [UIImage imageNamed:@"b_pic.png"];
        imageBg = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageBg setImage:[bg stretchableImageWithLeftCapWidth:bg.size.width/2.0f topCapHeight:bg.size.height/2.0f]];
        [self insertSubview:imageBg belowSubview:self.imageView];
        
        showPrewview = [[UIImageView alloc] init];
        [self insertSubview:showPrewview aboveSubview:imageBg];
        
        [self.showPrewview setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.showPrewview addGestureRecognizer:tap];
//        [tap release];
        /*
        self.tuidanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tuidanBtn setBackgroundImage:[UIImage imageNamed:@"btn_returnSales.png"] forState:UIControlStateNormal];
        [self addSubview:tuidanBtn];
        [tuidanBtn addTarget:self action:@selector(tuidanAction) forControlEvents:UIControlEventTouchUpInside];
         */
        showCount = [[UILabel alloc] initWithFrame:CGRectZero];
        danwei2 = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:showCount];
        [self addSubview:danwei2];
        [showCount setTextAlignment:NSTextAlignmentRight];
        [danwei2 setTextAlignment:NSTextAlignmentRight];
        [showCount setBackgroundColor:[UIColor clearColor]];
        [danwei2 setBackgroundColor:[UIColor clearColor]];
        [showCount setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [danwei2 setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [showCount setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
        [danwei2 setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
        
        [self sendSubviewToBack:selectImageBg];
         
    }
    return self;
}

- (void)tuidanAction
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请到超市柜台退单" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    /*
    if (didClickTuidan)
    {
        didClickTuidan(curOrderFood);
    }
     */
}

- (void)tapAction
{
    /*
    ShowDetailViewController *view = [[ShowDetailViewController alloc] initWithFoodObject:food];
    CGRect r = [UIScreen mainScreen].bounds;
    view.view.frame = r;
    view.view.transform = CGAffineTransformMakeRotation([[Public getInstance] statubarUIInterfaceOrientationAngleOfOrientation]);
    view.view.center = CGPointMake(r.size.width/2.0f, r.size.height/2.0f);
    
    view.didBackAction = ^(ShowDetailViewController *controller)
    {
        [controller.view removeFromSuperview];
        [controller release];
    };
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:view.view];
    */
}
//设置数据，初始化界面
- (void)setCurOrderFood:(OrderedFood *)curOrderFood1
{
    if (curOrderFood)
    {
        [curOrderFood removeObserver:self forKeyPath:@"foodPrewview"];
//        [curOrderFood release],
        curOrderFood = nil;
    }
    
    curOrderFood = /*[*/curOrderFood1/* retain]*/;
    
    [self.textLabel setText:curOrderFood.foodName];
    [self.textLabel setMinimumFontSize:12];
    [showPrice setText:[[NSString alloc] initWithFormat:@"￥%@", curOrderFood.price]];
    [danwei1 setText:[[NSString alloc] initWithFormat:@"  /%@", curOrderFood.danwei]];
    [showPrewview setImage:curOrderFood.foodPrewview];
    
    [showCount setText:[[NSString alloc] initWithFormat:@"已下:%@%@ 共:￥%@", curOrderFood.buyCount, curOrderFood.danwei, curOrderFood.totalCount]];
    [danwei2 setText:[[NSString alloc] initWithFormat:@"下单时间：%@", curOrderFood.orderedDate]];
    
    if ([curOrderFood.unknow3 isEqualToString:@"1"])
    {
        [tuidanBtn setHidden:YES];
    }
    else
    {
        [tuidanBtn setHidden:NO];
    }
    
    if (curOrderFood)
    {
        //对foodPrewview注册观察者
        [curOrderFood addObserver:self forKeyPath:@"foodPrewview" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"foodPrewview"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.showPrewview setImage:curOrderFood.foodPrewview];//将图片设置上去
        });
    }
}

- (void)layoutSubviews
{
    //排版
    [super layoutSubviews];
    selectImageBg.frame = self.bounds;
    CGRect r = self.imageView.frame;
    r.origin = CGPointMake(20, (self.bounds.size.height - 55) / 2.0f);
    r.size = CGSizeMake(80, 55);
    self.imageView.frame = r;
    showPrewview.frame = r;
    r = self.textLabel.frame;
    r.size.width = [self.textLabel.text sizeWithFont:self.textLabel.font].width;
    r.origin.y = 15.0f;
    r.origin.x = self.imageView.frame.origin.x + self.imageView.frame.size.width + 10.0f;
    self.textLabel.frame = r;
    
    CGRect subLab = [danwei1 frame];
    subLab.size.width = [danwei1.text sizeWithFont:danwei1.font].width;
    danwei1.frame = subLab;
    
    r = showPrice.rightView.frame;
    r.size.width = subLab.size.width;
    showPrice.rightView.frame = r;
    
    r = showPrice.frame;
    r.size = CGSizeMake([showPrice.text sizeWithFont:showPrice.font].width + subLab.size.width + 10, 32.0f);
    r.origin.y = self.bounds.size.height - 15.0f - 32.0f;
    r.origin.x = self.imageView.frame.origin.x + self.imageView.frame.size.width + 10.0f;
    showPrice.frame = r;
    
    r.origin.x = 361;
    r.origin.y = self.bounds.size.height - 15.0f - 21.0f;
    r.size = CGSizeMake(290, 21);
    showCount.frame = r;
    
    r.origin.x = 361;
    r.origin.y = 15;
    r.size = CGSizeMake(290, 21);
    danwei2.frame = r;
    
    
//    r = CGRectMake(self.bounds.size.width - 95, (self.bounds.size.height - 32)/2.0f, 85, 32);
//    tuidanBtn.frame = r;
    
    r = CGRectInset(self.imageView.frame, -5, -5);
    imageBg.frame = r;
    
    r = self.textLabel.frame;
    r.size.width = danwei2.frame.origin.x - 5 - r.origin.x;
    self.textLabel.frame = r;
//    [self sendSubviewToBack:imageBg];    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
