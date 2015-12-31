//
//  FoodPictureView.m
//  OrderFood
//
//  Created by aplle on 8/14/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "FoodPictureView.h"
#import "ShowDetailViewController.h"

@interface FoodPictureView ()<UITextFieldDelegate, PopTableAlertViewDelegate>
{
    int     startCount;//食物已选个数
    ShowDetailViewController *detailview;
}
@property (nonatomic, retain) UIImageView       *sep;//分段线
@property (nonatomic, retain) UIButton          *addBtn;//添加按钮
@property (nonatomic, retain) UIButton          *delBtn;//删除按钮
@property (nonatomic, retain) UITextField       *showCount;//显示已选个数
@property (nonatomic, retain) UIImageView       *imageView;//预览图
@property (nonatomic, retain) UILabel           *textLabel;//食物名称
@property (nonatomic, retain) UITextField       *detailTextLabel;//食物价格
@property (nonatomic, retain) UIImageView       *bgImage;//背景图
@property (nonatomic, retain) UILabel           *danweiLab1;
@property (nonatomic, retain) UILabel           *danweiLab2;
@end

@implementation FoodPictureView
@synthesize food;
@synthesize sep, addBtn, delBtn, showCount;
@synthesize didAddtion, didDelete, refreshBlock;
@synthesize detailTextLabel;
@synthesize imageView, textLabel;
@synthesize bgImage;
@synthesize danweiLab1;
@synthesize danweiLab2;
@synthesize showAlertView;
@synthesize ValueDidChangeAction;
@synthesize didDeleteZeroAlert;


- (id)initWithFrame:(CGRect)frame foodObject:(FoodObject *)obj
{
    self = [self initWithFrame:frame];
    
    if (self)
    {
        self.food = obj;
    }
    
    return self;
}
//设置食物，并刷新界面
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
    
    if (food)//对bookCount、foodPrewview注册观察者
    {
        [food addObserver:self forKeyPath:@"bookCount" options:NSKeyValueObservingOptionNew context:nil];
        [food addObserver:self forKeyPath:@"foodPrewview" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    [imageView setImage:food.foodPrewview];
    [showCount setText:[[NSString alloc] initWithFormat:@"%d", food.bookCount]];
    [textLabel setText:food.foodName];
    
    [danweiLab1 setText:[[NSString alloc] initWithFormat:@"/%@", food.danwei]];
    CGRect r = danweiLab1.frame;
    r.size.width = [danweiLab1.text sizeWithFont:danweiLab1.font].width;
    danweiLab1.frame = r;
    r = detailTextLabel.rightView.frame;
    r.size.width = danweiLab1.frame.size.width;
    detailTextLabel.rightView.frame = r;
    
    [detailTextLabel setText:food.price];
    r = detailTextLabel.frame;
    r.size.height = [detailTextLabel.text sizeWithFont:detailTextLabel.font].height;
    r.size.width = [detailTextLabel.text sizeWithFont:detailTextLabel.font].width + danweiLab1.frame.size.width +  10.0f;
    detailTextLabel.frame = r;
    
    r = showCount.frame;
    r.size.width = [showCount.text sizeWithFont:showCount.font].width + showCount.leftView.frame.size.width;
    showCount.frame = r;
}
//bookCount、foodPrewview值改变时候刷新界面
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"bookCount"])
    {
        [showCount setText:[[NSString alloc] initWithFormat:@"%d", food.bookCount]];
        CGRect r = showCount.frame;
        r.size.width = [showCount.text sizeWithFont:showCount.font].width + showCount.leftView.frame.size.width;
        showCount.frame = r;
    }
    else if ([keyPath isEqualToString:@"foodPrewview"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageView setImage:food.foodPrewview];
        });
    }
}

- (void)dealloc
{
    self.sep = nil;
    self.addBtn = nil;
    self.delBtn = nil;
    self.showCount = nil;
    self.imageView = nil;
    self.textLabel = nil;
    self.detailTextLabel = nil;
    self.food = nil;
    self.didAddtion = nil;
    self.didDelete = nil;
    self.refreshBlock = nil;
    self.bgImage = nil;
    self.danweiLab1 = nil;
    self.ValueDidChangeAction = nil;
    self.didDeleteZeroAlert = nil;
    
//    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect r = self.bounds;
        
        UIImage *bg = [UIImage imageNamed:@"b_pic.png"];
        CGSize s1 = CGSizeMake(r.size.width - 44, (r.size.width - 44) * 3 /4.0f);
        bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(22, 17, s1.width, s1.height)];
        [bgImage setImage:[bg stretchableImageWithLeftCapWidth:bg.size.width/2.0f topCapHeight:bg.size.height/2.0f]];
        [self addSubview:bgImage];
        
        CGSize s2 = CGSizeMake(r.size.width - 54, (r.size.width - 54) * 3 /4.0f);
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(22+(s1.width-s2.width)/2.0f, 17+(s1.height-s2.height)/2.0f, s2.width, s2.height)];
        [self addSubview:imageView];
        
        r = bgImage.frame;
        r.origin.y = r.origin.y + r.size.height + 12.0f;
        r.size = CGSizeMake(r.size.width, 21);
        textLabel = [[UILabel alloc] initWithFrame:r];
        [textLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
        [self addSubview:textLabel];
        
        r.origin.y += (r.size.height + 8.0f);
        r.size = CGSizeMake(150, [@" " sizeWithFont:[UIFont boldSystemFontOfSize:22.0f]].height);
        detailTextLabel = [[UITextField alloc] initWithFrame:r];
        [detailTextLabel setEnabled:NO];
        [detailTextLabel setBorderStyle:UITextBorderStyleNone];
        detailTextLabel.rightViewMode = UITextFieldViewModeAlways;
        [detailTextLabel setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
        [detailTextLabel setFont:[UIFont boldSystemFontOfSize:22.0f]];
        UILabel *danweiLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [danweiLab setBackgroundColor:[UIColor clearColor]];
        [danweiLab setFont:[UIFont boldSystemFontOfSize:18.0f]];
        self.danweiLab1 = danweiLab;
        UIView  *v_r = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, [@" " sizeWithFont:detailTextLabel.font].height)];
        danweiLab.frame = CGRectMake(0, [@" " sizeWithFont:detailTextLabel.font].height - [@" " sizeWithFont:danweiLab.font].height, 30, [@" " sizeWithFont:danweiLab.font].height);
        [v_r addSubview:danweiLab];
        detailTextLabel.rightView = v_r;
//        [danweiLab release];
//        [v_r release];
        [danweiLab setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
        [self addSubview:detailTextLabel];
        
        r.origin.y += r.size.height + 15;
        r.size.width = imageView.frame.size.width;
        r.size.height = 1;
        
        UIImageView *v_image = [[UIImageView alloc] initWithFrame:r];
        [v_image setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dotted.png"]]];
        [self addSubview:v_image];
        
        r.origin.y += r.size.height + 13;
        r.size = CGSizeMake(v_image.frame.size.width/2.0f - 2.0f, [@" " sizeWithFont:[UIFont boldSystemFontOfSize:22.0f]].height);
//        [v_image release];
        
        showCount = [[UITextField alloc] initWithFrame:r];
        showCount.leftViewMode = UITextFieldViewModeAlways;
        [showCount setFont:[UIFont boldSystemFontOfSize:22.0f]];
        danweiLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [danweiLab setBackgroundColor:[UIColor clearColor]];
        [danweiLab setText:@"已点"];
        [danweiLab setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [danweiLab setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
        self.danweiLab2 = danweiLab;
        
        UIView *v_l = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [danweiLab.text sizeWithFont:danweiLab.font].width + 10, [@" " sizeWithFont:showCount.font].height)];
        danweiLab.frame = CGRectMake(0, [@" " sizeWithFont:showCount.font].height - [danweiLab.text sizeWithFont:danweiLab.font].height - 2.0f, [danweiLab.text sizeWithFont:danweiLab.font].width + 10, [danweiLab.text sizeWithFont:danweiLab.font].height);
        [v_l addSubview:danweiLab];
        
        showCount.leftView = v_l;
        [showCount setTextColor:[UIColor colorWithRed:102.0f/255.0f green:94.0f/255.0f blue:90.0f/255.0f alpha:1]];
        [showCount setBackgroundColor:[UIColor clearColor]];
//        [danweiLab release];
//        [v_l release];
        [self addSubview:showCount];
        showCount.delegate = self;
        showCount.keyboardType = UIKeyboardTypeNumberPad;
//        [showCount setEnabled:NO];
//        [showCount setUserInteractionEnabled:NO];
        
        r.origin.y -= 5;
        r.origin.x += r.size.width + 1.0f;
        r.size = CGSizeMake(2, 30);
        UIImageView *h_image = [[UIImageView alloc] initWithFrame:r];
        [h_image setImage:[UIImage imageNamed:@"spe.png"]];
        [self addSubview:h_image];
//        [h_image release];
        
        r.origin.y -= 5.0f;
        r.origin.x = imageView.frame.origin.x + imageView.frame.size.width - 29.0f;
        r.size = CGSizeMake(40.0f, 40.0f);
        self.delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setImage:[UIImage imageNamed:@"btn_-.png"] forState:UIControlStateNormal];
        delBtn.frame = r;
        [self addSubview:delBtn];
        
        r.origin.x -= 50.0f;
        r.size = CGSizeMake(40.0f, 40.0f);
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setImage:[UIImage imageNamed:@"btn_+.png"] forState:UIControlStateNormal];
        addBtn.frame = r;
        [self addSubview:addBtn];
        [delBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.imageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.imageView addGestureRecognizer:tap];
//        [tap release];
    }
    return self;
}
//点击预览图查看详情界面
- (void)tapAction
{
    detailview = [[ShowDetailViewController alloc] initWithFoodObject:food];
    CGRect r = [UIScreen mainScreen].bounds;
//    view.view.frame = r;
    detailview.view.transform = CGAffineTransformMakeRotation([[Public getInstance] statubarUIInterfaceOrientationAngleOfOrientation]);
    detailview.view.center = CGPointMake(r.size.width/2.0f, r.size.height/2.0f);
    
    detailview.didBackAction = ^(ShowDetailViewController *controller)
    {
        [controller.view removeFromSuperview];
//        [controller release];
    };
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:detailview.view];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

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

#pragma make UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    startCount = [textField.text intValue];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (refreshBlock)
    {
        refreshBlock();
    }
    
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
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
//    __block typeof(self) ob = self;
//    [showCount resignFirstResponder];
//    if ([food.foodlist count] == 0)
//    {
//        [food getMingXi];
//        food.didFinishQuery = ^(NSMutableArray *ret) {
//            [PopTableAlertView getInstance].delegate = ob;
//            [PopTableAlertView getInstance].curModel = ShowFoodList;
//            [PopTableAlertView getInstance].curFoodObject = ob->food;
//            [[PopTableAlertView getInstance] show];
//        };
//    }
//    else
//    {
//        [PopTableAlertView getInstance].delegate = self;
//        [PopTableAlertView getInstance].curModel = ShowFoodList;
//        [PopTableAlertView getInstance].curFoodObject = food;
//        [[PopTableAlertView getInstance] show];
//    }
}

- (NSArray *)PopTableAlertViewGetDataSource
{
    return food.foodlist;
}

- (int)numberOfSectionInTable
{
    return [[food.taocanDict allKeys] count];
}

- (NSString *)titleForSection:(int)section
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

- (NSArray *)PopTableAlertViewGetDataSourceInSection:(int)section
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
    
    return [food.taocanDict objectForKey:[cate objectAtIndex:section]];
}

- (int)selectionCountInsection:(int)section
{
    //return food.foodlist;
    NSArray *array = [food.taocanDict allKeys];
    NSString *key = [array objectAtIndex:section];
    NSNumber *num = [food.taocanCountDict objectForKey:key];
    return [num intValue] * food.bookCount;
}

- (void)PopTableAlertViewDidSelectIndex:(NSIndexPath *)indexPath
{
    
}

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

@end
