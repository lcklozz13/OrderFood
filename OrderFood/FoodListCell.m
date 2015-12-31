//
//  FoodListCell.m
//  OrderFood
//
//  Created by aplle on 8/13/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "FoodListCell.h"
#import "ShowDetailViewController.h"

@interface FoodListCell ()<UITextFieldDelegate, PopTableAlertViewDelegate>
{
    int     startCount;//已选个数
    ShowDetailViewController *showDetailView;
}
@property (nonatomic, strong) UIImageView     *selectImageBg;
@property (nonatomic, strong) UIImageView     *imageBg;
@property (nonatomic, strong) UIImageView     *sep;
@property (nonatomic, strong) UIImageView     *showPrewview;
@property (nonatomic, strong) UIButton        *addBtn;
@property (nonatomic, strong) UIButton        *delBtn;
@property (nonatomic, strong) UITextField     *showCount;
@property (nonatomic, strong) UITextField     *showPrice;
@property (nonatomic, strong) UIImageView     *bottonSepView;
@property (nonatomic, strong) UILabel         *danwei1;
@property (nonatomic, strong) UILabel         *danwei2;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@end

@implementation FoodListCell
@synthesize food;
@synthesize showAlertView;
@synthesize sep, addBtn, delBtn, showCount;
@synthesize didAddtion, didDelete, didDeleteZeroAlert, refreshBlock;
@synthesize imageBg;
@synthesize showPrice;
@synthesize showPrewview;
@synthesize bottonSepView;
@synthesize danwei1;
@synthesize danwei2;
@synthesize selectImageBg;
@synthesize touchShowAddtion;
@synthesize selectedAddtion;
@synthesize tap;

- (void)dealloc
{
    self.selectImageBg = nil;
    self.danwei2 = nil;
    self.danwei1 = nil;
    self.showPrewview = nil;
    self.imageBg = nil;
    self.food = nil;
    self.showCount = nil;
    self.delBtn = nil;
    self.addBtn = nil;
    self.sep = nil;
    self.didDeleteZeroAlert = nil;
    self.didAddtion = nil;
    self.didDelete = nil;
    self.refreshBlock = nil;
    self.showPrice = nil;
    self.bottonSepView = nil;
    self.selectedAddtion = nil;
    self.tap = nil;
    
//    [super dealloc];
}

- (void)setTouchShowAddtion:(BOOL)touchShowAddtion1
{
    UIButton *btn = (UIButton *)[self viewWithTag:10086];
    if (btn) {
        [btn removeFromSuperview];
    }
    
    touchShowAddtion = touchShowAddtion1;
    
    if (touchShowAddtion) {
        btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        btn.frame = CGRectMake((671 - 22)/2, (94 - 22)/2, 22, 22);
        [self addSubview:btn];
        [btn addTarget:self action:@selector(clickAddtion) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCellAction)];
        [self addGestureRecognizer:tap];
        touchShowAddtion = NO;
        // Initialization code 102,94,90
        selectImageBg = [[UIImageView alloc] initWithFrame:self.bounds];//背景
        [self addSubview:selectImageBg];
        
        [self.textLabel setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
        [self.textLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
        //已选个数
        showCount = [[UITextField alloc] initWithFrame:CGRectZero];
        showCount.leftViewMode = UITextFieldViewModeAlways;
        showCount.rightViewMode = UITextFieldViewModeAlways;
        [showCount setTextAlignment:NSTextAlignmentCenter];
        [showCount setFont:[UIFont boldSystemFontOfSize:24]];
        [showCount setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 40, 22)];
        [lab setBackgroundColor:[UIColor clearColor]];
        [lab setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
        [lab setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [lab setText:@"已点"];
        UIView *v_l = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, [@" " sizeWithFont:showCount.font].height)];
        lab.frame = CGRectMake(0, [@" " sizeWithFont:showCount.font].height-[@" " sizeWithFont:lab.font].height + 2, 40, [@" " sizeWithFont:lab.font].height);
        [v_l addSubview:lab];
        showCount.leftView = v_l;
//        [lab release];
//        [v_l release];
        
        lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 20, 22)];
        [lab setBackgroundColor:[UIColor clearColor]];
        [lab setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
        [lab setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [lab setText:@"份"];
        self.danwei2 = lab;
        UIView *vr = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, [@" " sizeWithFont:showCount.font].height)];
        lab.frame = CGRectMake(0, [@" " sizeWithFont:showCount.font].height - [@" " sizeWithFont:lab.font].height + 2, 20, [@" " sizeWithFont:lab.font].height);
        [vr addSubview:lab];
        showCount.rightView = vr;
//        [lab release];
//        [vr release];
        showCount.delegate = self;
        showCount.keyboardType = UIKeyboardTypeNumberPad;
//        [showCount setUserInteractionEnabled:NO];
//        [showCount setEnabled:NO];
        [self addSubview:showCount];
        [showCount setFont:[UIFont boldSystemFontOfSize:36.0f]];
        //价格
        showPrice = [[UITextField alloc] initWithFrame:CGRectZero];
        [showPrice setFont:[UIFont boldSystemFontOfSize:24.0f]];
        showPrice.rightViewMode = UITextFieldViewModeAlways;
        [showPrice setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
        lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 30, 22)];
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
        //减按钮
        self.delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delBtn.frame = CGRectMake(0, 0, 40, 40);
        [delBtn setImage:[UIImage imageNamed:@"btn_-.png"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:delBtn];
        //加按钮
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(0, 0, 40, 40);
        [addBtn setImage:[UIImage imageNamed:@"btn_+.png"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addBtn];
        //分割线
        sep = [[UIImageView alloc] initWithFrame:CGRectZero];
        [sep setImage:[UIImage imageNamed:@"spe.png"]];
        [self addSubview:sep];
        //背景
        UIImage *bg = [UIImage imageNamed:@"b_pic.png"];
        imageBg = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageBg setImage:[bg stretchableImageWithLeftCapWidth:bg.size.width/2.0f topCapHeight:bg.size.height/2.0f]];
        [self insertSubview:imageBg belowSubview:self.imageView];
        //预览图
        showPrewview = [[UIImageView alloc] init];
        [self insertSubview:showPrewview aboveSubview:imageBg];
        
        [self.showPrewview setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.showPrewview addGestureRecognizer:tap];
//        [tap release];
        //底部分割线
        bottonSepView = [[UIImageView alloc] init];
        [bottonSepView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line_list.png"]]];
        [self addSubview:bottonSepView];
        
        [self sendSubviewToBack:selectImageBg];
    }
    
    return self;
}
//点击预览图，查看详情页面
- (void)tapAction
{
    showDetailView = [[ShowDetailViewController alloc] initWithFoodObject:food];
    CGRect r = [UIScreen mainScreen].bounds;
//    view.view.frame = r;
    showDetailView.view.transform = CGAffineTransformMakeRotation([[Public getInstance] statubarUIInterfaceOrientationAngleOfOrientation]);
    showDetailView.view.center = CGPointMake(r.size.width/2.0f, r.size.height/2.0f);
    
    showDetailView.didBackAction = ^(ShowDetailViewController *controller)
    {
        [controller.view removeFromSuperview];
//        [controller release];
    };
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:showDetailView.view];
}
//设置食物，刷新界面
- (void)setFood:(FoodObject *)food1
{
    if (food)
    {
        [food removeObserver:self forKeyPath:@"bookCount"];
        [food removeObserver:self forKeyPath:@"foodPrewview"];
//        [food release],
        food = nil;
    }
    
    food = /*[*/food1 /*retain]*/;
    
    if (!food.foodPrewview)
    {
        [self.showPrewview setImage:nil];
    }
    else
    {
        [self.showPrewview setImage:food.foodPrewview];
    }
    
    [self.textLabel setText:food.foodName];
    [showPrice setText:[[NSString alloc] initWithFormat:@"￥%@", food.price]];
    [danwei1 setText:[[NSString alloc] initWithFormat:@"  /%@", food.danwei]];
    [danwei2 setText:food.danwei];
    showCount.text = [[NSString alloc] initWithFormat:@"%d", food.bookCount];
    
    if (food)
    {
        //对bookCount、foodPrewview注册观察者
        [food addObserver:self forKeyPath:@"bookCount" options:NSKeyValueObservingOptionNew context:nil];
        [food addObserver:self forKeyPath:@"foodPrewview" options:NSKeyValueObservingOptionNew context:nil];
    }
}
//bookCount、foodPrewview值改变回调函数
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"bookCount"])
    {
        UILabel *left = (UILabel *)(showCount.leftView);
        UILabel *right = (UILabel *)(showCount.rightView);
        
        [showCount setText:[[NSString alloc] initWithFormat:@"%d", food.bookCount]];
        CGRect r = showCount.frame;
        
        r.size = [showCount.text sizeWithFont:showCount.font];
        r.size.width += (right.frame.size.width + left.frame.size.width);
        r.origin.x = sep.frame.origin.x - r.size.width - 10;
        showCount.frame = r;
    }
    else if ([keyPath isEqualToString:@"foodPrewview"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.showPrewview setImage:food.foodPrewview];
        });
    }
}

//删除操作
- (void)deleteAction
{
    if ([[food.isTaocan lowercaseString] isEqualToString:@"false"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您当前选择的是可选套餐,请注意修改明细" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alertView.tag = 10010;
        [alertView show];
    }
    else
    {
        [self Decrease];
    }
}
//添加操作
- (void)addAction
{
    if ([[food.isTaocan lowercaseString] isEqualToString:@"false"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您当前选择的是可选套餐,请注意修改明细" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alertView.tag = 10086;
        [alertView show];
    }
    else
    {
        [self Increase];
    }
}

- (void)Increase
{
    food.bookCount = food.bookCount + 1;
    
    if (food.bookCount == 1)
    {
        if (didAddtion)
        {
            didAddtion(food);
        }
    }
    
    if (refreshBlock)
    {
        refreshBlock();
    }
}

- (void)Decrease
{
    if (food.bookCount > 0)
    {
        food.bookCount = food.bookCount - 1;
        
        if (food.bookCount == 0)
        {
            if (showAlertView)
            {
                if (didDeleteZeroAlert)
                {
                    didDeleteZeroAlert(food);
                }
            }
            else
            {
                if (didDelete)
                {
                    didDelete(food);
                }
            }
        }
    }
    
    if (refreshBlock)
    {
        refreshBlock();
    }
}

//界面排布
- (void)layoutSubviews
{
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
    
    r = showPrice.frame;
    r.origin.y -= 5;
    r.origin.x = self.bounds.size.width - 60.0f;
    r.size = delBtn.frame.size;
    delBtn.frame = r;
    
    r.origin.x = delBtn.frame.origin.x - 50.0f;
    r.size = addBtn.frame.size;
    addBtn.frame = r;
    
    r.origin.y += 5;
    r.origin.x = addBtn.frame.origin.x - 10.0f;
    r.size = CGSizeMake(1, 32);
    sep.frame = r;
    
    subLab = [danwei2 frame];
    subLab.size.width = [danwei2.text sizeWithFont:danwei2.font].width;
    danwei2.frame = subLab;
    
    r = showCount.rightView.frame;
    r.size.width = subLab.size.width;
    showCount.rightView.frame = r;
    
    r = showCount.frame;
    r.origin.y = addBtn.frame.origin.y;
    r.size = [showCount.text sizeWithFont:showCount.font];
    r.size.width += (40 + subLab.size.width);
    r.origin.x = sep.frame.origin.x - r.size.width - 10;
    showCount.frame = r;
    
    r = CGRectInset(self.imageView.frame, -5, -5);
    imageBg.frame = r;
    [self sendSubviewToBack:imageBg];
    
    r = CGRectMake(imageBg.frame.origin.x, self.bounds.size.height - 1, self.bounds.size.width - (2 * imageBg.frame.origin.x), 1);
    bottonSepView.frame = r;
}

- (int)numberOfSectionInTable
{
    if (!touchShowAddtion)
    {
        return [[food.taocanDict allKeys] count];
    }
    
    return 1;
}

- (NSString *)titleForSection:(int)section
{
    if (!touchShowAddtion)
    {
        NSArray *cate = [[food.taocanDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            NSString *ob1 = (NSString *)obj1;
            NSString *ob2 = (NSString *)obj2;
            
            if ([ob1 isEqualToString:ob2])
            {
                return NSOrderedSame;
            }
            else if ([ob1 isEqualToString:@"guding"])
            {
                return NSOrderedAscending;
            }
            else if ([ob2 isEqualToString:@"guding"])
            {
                return NSOrderedDescending;
            }
            else
            {
                return [[ob1 lowercaseString] compare:[ob2 lowercaseString]];
            }
        }];
        
        NSString *ret = [cate objectAtIndex:section];
        if ([ret isEqualToString:@"guding"])
        {
            ret = @"固定选项";
        }
        else
        {
            ret = [[NSString alloc] initWithFormat:@"%@   可任选%d X %d个", ret, [[food.taocanCountDict objectForKey:ret] intValue], food.bookCount];
        }
        
        return ret;
    }
    
    return nil;
}

- (NSArray *)PopTableAlertViewGetDataSourceInSection:(int)section
{
    if (!touchShowAddtion)
    {
        //return food.foodlist;
        NSArray *cate = [[food.taocanDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            NSString *ob1 = (NSString *)obj1;
            NSString *ob2 = (NSString *)obj2;
            
            if ([ob1 isEqualToString:ob2])
            {
                return NSOrderedSame;
            }
            else if ([ob1 isEqualToString:@"guding"])
            {
                return NSOrderedAscending;
            }
            else if ([ob2 isEqualToString:@"guding"])
            {
                return NSOrderedDescending;
            }
            else
            {
                return [[ob1 lowercaseString] compare:[ob2 lowercaseString]];
            }
        }];
        
        return [food.taocanDict objectForKey:[cate objectAtIndex:section]];
    }
    
    return nil;
}

- (int)selectionCountInsection:(int)section
{
    if (!touchShowAddtion)
    {
        //return food.foodlist;
        NSArray *array = [food.taocanDict allKeys];
        NSString *key = [array objectAtIndex:section];
        NSNumber *num = [food.taocanCountDict objectForKey:key];
        return [num intValue] * food.bookCount;
    }
    
    return 0;
}

- (void)PopTableAlertViewDidSelectIndex:(NSIndexPath *)indexPath
{
    if (touchShowAddtion)
    {
        selectedAddtion([[[Public getInstance].curPublishDes.contents objectAtIndex:indexPath.row] lastObject]);
    }
    else
    {
        NSString *ret = [[food.taocanDict allKeys] objectAtIndex:indexPath.section];
        if (![ret isEqualToString:@"guding"]) {
//            TaoCanMingxi *mingxi = [[food.taocanDict objectForKey:ret] objectAtIndex:indexPath.row];
//            if (!mingxi.isSelected) {
//                for (TaoCanMingxi *mingx in [food.taocanDict objectForKey:ret])
//                {
//                    mingx.isSelected = NO;
//                }
//                
//                mingxi.isSelected = YES;
//                [[PopTableAlertView getInstance] reloadData];
//            }
        }
    }
}

- (void)clickAddtion
{
    [PopTableAlertView getInstance].delegate = self;
    [PopTableAlertView getInstance].curModel = ShowAddtionInfor;
    [[PopTableAlertView getInstance] show];
}

- (void)showFoodList
{
    if ([food.foodlist count] == 0)
    {
        [Public getInstance].juhua.labelText = @"正在查询套餐明细";
        [[Public getInstance].juhua show:YES];
        [food getMingXi];
        __block typeof(self) obj = self;
        food.didFinishQuery = ^(NSMutableArray *ret) {
            
            [[Public getInstance].juhua show:NO];
            
            if ([ret count] == 0)
            {
                obj->food.bookCount = 0;
                if (obj->refreshBlock)
                {
                    obj->refreshBlock();
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //提示:查询套餐明细失败
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                    
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"查询套餐明细失败，请重试。";
                    hud.margin = 10.f;
                    hud.removeFromSuperViewOnHide = YES;
                    
                    [hud hide:NO afterDelay:2];
                    
                });
                return;
            }
            else
            {
                [PopTableAlertView getInstance].delegate = obj;
                [PopTableAlertView getInstance].curModel = ShowFoodList;
                [PopTableAlertView getInstance].curFoodObject = obj->food;
                [[PopTableAlertView getInstance] show];
            }
        };
    }
    else
    {
        [PopTableAlertView getInstance].delegate = self;
        [PopTableAlertView getInstance].curModel = ShowFoodList;
        [PopTableAlertView getInstance].curFoodObject = food;
        [[PopTableAlertView getInstance] show];
    }
}

- (void)tapCellAction
{
    CGFloat startX = self.textLabel.frame.origin.x;
    CGFloat endX = showCount.frame.origin.x;
    
    CGRect range = CGRectMake(startX, 0, endX - startX, self.frame.size.height);
    
    if (CGRectContainsPoint(range, [tap locationInView:self]))
    {
        if (touchShowAddtion)
        {
//            [PopTableAlertView getInstance].delegate = self;
//            [PopTableAlertView getInstance].curModel = ShowAddtionInfor;
//            [[PopTableAlertView getInstance] show];
        }
        else
        {
            if (![[food.isTaocan lowercaseString] isEqualToString:@"false"])
            {
                if ([food.foodlist count] == 0)
                {
                    [food getMingXi];
                    __block typeof(self) obj = self;
                    food.didFinishQuery = ^(NSMutableArray *ret)
                    {
                        if ([ret count] > 0)
                        {
                            [PopTableAlertView getInstance].delegate = obj;
                            [PopTableAlertView getInstance].curModel = ShowFoodList;
                            [PopTableAlertView getInstance].curFoodObject = obj->food;
                            [[PopTableAlertView getInstance] show];
                        }
                    };
                }
                else
                {
                    [PopTableAlertView getInstance].delegate = self;
                    [PopTableAlertView getInstance].curModel = ShowFoodList;
                    [PopTableAlertView getInstance].curFoodObject = food;
                    [[PopTableAlertView getInstance] show];
                }
            }
            else
            {
                [self showFoodList];
            }
        }
    }
}
/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected)
    {
        if (touchShowAddtion)
        {
//            [PopTableAlertView getInstance].delegate = self;
//            [PopTableAlertView getInstance].curModel = ShowAddtionInfor;
//            [[PopTableAlertView getInstance] show];
        }
        else
        {
            if (![[food.isTaocan lowercaseString] isEqualToString:@"false"])
            {
                if ([food.foodlist count] == 0)
                {
                    [food getMingXi];
                    __block typeof(self) obj = self;
                    food.didFinishQuery = ^(NSMutableArray *ret)
                    {
                        if ([ret count] > 0)
                        {
                            [PopTableAlertView getInstance].delegate = obj;
                            [PopTableAlertView getInstance].curModel = ShowFoodList;
                            [PopTableAlertView getInstance].curFoodObject = obj->food;
                            [[PopTableAlertView getInstance] show];
                        }
                    };
                }
                else
                {
                    [PopTableAlertView getInstance].delegate = self;
                    [PopTableAlertView getInstance].curModel = ShowFoodList;
                    [PopTableAlertView getInstance].curFoodObject = food;
                    [[PopTableAlertView getInstance] show];
                }
            }
            else
            {
                [self showFoodList];
            }
        }
    }
 
    // Configure the view for the selected state
}
*/
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10010)//减操作
    {
        [self Decrease];
    }
    else if (alertView.tag == 10086)//加操作
    {
        [self Increase];
    }
    
    [self showFoodList];
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    startCount = [textField.text intValue];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *retString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([retString length] == 0)
    {
        return YES;
    }
    UILabel *left = (UILabel *)(showCount.leftView);
    UILabel *right = (UILabel *)(showCount.rightView);
    
    CGRect r = showCount.frame;
    
    r.size = [retString sizeWithFont:showCount.font];
    r.size.width += (right.frame.size.width + left.frame.size.width);
    r.origin.x = sep.frame.origin.x - r.size.width - 10;
    showCount.frame = r;
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text length] > 0)
    {
        food.bookCount = [textField.text intValue];
    }
    else
    {
        food.bookCount = 0;
    }
    
    if (startCount == 0)
    {
        if (food.bookCount > startCount)
        {
            if (didAddtion)
            {
                didAddtion(food);
            }
        }
    }
    else
    {
        if (food.bookCount == 0)
        {
            if (showAlertView)
            {
                if (didDeleteZeroAlert)
                {
                    didDeleteZeroAlert(food);
                }
            }
            else
            {
                if (didDelete)
                {
                    didDelete(food);
                }
            }
        }
    }
    
    if (refreshBlock)
    {
        refreshBlock();
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
