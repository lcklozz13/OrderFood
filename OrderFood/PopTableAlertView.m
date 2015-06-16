//
//  PopTableAlertView.m
//  OrderFood
//
//  Created by klozz on 14-3-18.
//  Copyright (c) 2014年 handcent. All rights reserved.
//

#import "PopTableAlertView.h"
#import "SBTableAlert.h"
#import "TaoCanMingxi.h"
#import "FoodListCell.h"
#import "FoodPictureView.h"
#import "MyStep.h"

@interface PopTableAlertView ()<SBTableAlertDataSource, SBTableAlertDelegate>
@property (nonatomic, retain) SBTableAlert    *alertview;
@end


@implementation PopTableAlertView
@synthesize alertview;
@synthesize curFoodObject;
@synthesize curModel;
@synthesize delegate;

static PopTableAlertView *_PopTableAlertView = nil;

+ (PopTableAlertView *)getInstance
{
    @synchronized(_PopTableAlertView)
    {
        if (!_PopTableAlertView)
        {
            _PopTableAlertView = [[PopTableAlertView alloc] init];
        }
        
        return _PopTableAlertView;
    }
}

+ (void)freeInstance
{
    @synchronized(_PopTableAlertView)
    {
        if (_PopTableAlertView)
        {
//            [_PopTableAlertView release];
            _PopTableAlertView = nil;
        }
    }
}

- (void)dealloc
{
    if (alertview)
    {
//        [alertview release];
        alertview = nil;
    }
    
    self.curFoodObject = nil;
    
//    [super dealloc];
}

- (void)setCurModel:(ShowModel)curModelNew
{
    curModel = curModelNew;
    
    if (alertview)
    {
//        [alertview release];
        alertview = nil;
    }
    
    NSString *title = nil;
    NSString *btn = nil;
    
    if (curModel == ShowAddtionInfor)
    {
        title = @"请选择备注信息";
        btn = @"取消";
        self.curFoodObject = nil;
    }
    else
    {
        title = @"套餐明细";
        btn = @"确定";
    }
    
    if (delegate)
    {
        if ([delegate isKindOfClass:[FoodListCell class]])
        {
            title = ((FoodListCell *)delegate).food.foodName;
        }
        else if ([delegate isKindOfClass:[FoodPictureView class]])
        {
            title = ((FoodPictureView *)delegate).food.foodName;
        }
    }
    
    alertview = [[SBTableAlert alloc] initWithTitle:title cancelButtonTitle:btn messageFormat:nil];
    
    if (curModel == ShowFoodList)
    {
        alertview.type = SBTableAlertTypeMultipleSelct;
    }
    
    alertview.delegate = self;
    alertview.dataSource = self;
}

- (void)setCurFoodObject:(FoodObject *)curFoodObjectNew
{
    if (curFoodObject)
    {
        [curFoodObject stopGetMingXi];
//        [curFoodObject release];
        curFoodObject = nil;
    }
    
    curFoodObject = /*[*/curFoodObjectNew /*retain]*/;
}

- (void)show
{
    if (alertview)
    {
        [alertview show];
    }
}

- (void)reloadData
{
    [alertview.tableView reloadData];
}

- (void)changeFoodCount:(MyStep *)sender
{
    int total = 0;
    int increatment = sender.value;
    
    for (TaoCanMingxi *obj in sender.taocanArray)
    {
        if ([obj.foodID isEqualToString:sender.mingxi.foodID])
        {
            total += increatment;
        }
        else
        {
            total += obj.foodCount;
        }
    }
        
    if (total > /*[sender.taocanArray count]*/[[curFoodObject.taocanCountDict objectForKey:sender.mingxi.fenzu] intValue])
    {
        sender.value = sender.mingxi.foodCount;
    }
    else
    {
        sender.mingxi.foodCount = sender.value;
    }
    
    [self reloadData];
}

#pragma mark - SBTableAlertDataSource
- (NSInteger)numberOfSectionsInTableAlert:(SBTableAlert *)tableAlert
{
    if (curModel == ShowAddtionInfor)
    {
        return 1;
    }
    else
    {
        if (delegate && [delegate respondsToSelector:@selector(numberOfSectionInTable)])
        {
            return [delegate numberOfSectionInTable];
        }
    }
    
    return 1;
}
- (UITableViewCell *)tableAlert:(SBTableAlert *)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"SBTableAlert";
    
    UITableViewCell *cell = [tableAlert.tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell)
    {
        cell = /*[*/[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify] /*autorelease]*/;
    }
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    if (curModel == ShowAddtionInfor)
    {
        NSMutableArray *array = [[[Public getInstance].curPublishDes contents] objectAtIndex:indexPath.row];
        [cell.textLabel setText:[array lastObject]];
        MyStep *step = (MyStep *)[cell viewWithTag:10086];
        
        if (step)
        {
            [step removeFromSuperview];
        }
    }
    else if (delegate && [delegate respondsToSelector:@selector(PopTableAlertViewGetDataSourceInSection:)])
    {
        NSArray *array = [delegate PopTableAlertViewGetDataSourceInSection:indexPath.section];
        TaoCanMingxi *mingxi = [array objectAtIndex:indexPath.row];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@\t%d%@", mingxi.foodName, mingxi.foodCount, mingxi.danwei]];
        
        MyStep *step = (MyStep *)[cell viewWithTag:10086];
        if (!step) {
            step = [[MyStep alloc] init];
            step.frame = CGRectMake(260-9-94, 60-29, 94, 29);
            [cell addSubview:step];
            [step addTarget:self action:@selector(changeFoodCount:) forControlEvents:UIControlEventValueChanged];
            step.tag = 10086;
        }
        
        [step setMaximumValue:[delegate selectionCountInsection:indexPath.section]];
        [step setMinimumValue:0];
        
        if (mingxi.isguding)
        {
            [step removeFromSuperview];
        }
        else
        {
            [cell.detailTextLabel setText:@"  "];
            [step setValue:mingxi.foodCount];
            step.mingxi = mingxi;
            step.taocanArray = array;
        }
//        if (!mingxi.isguding && mingxi.isSelected) {
//            [cell.imageView setImage:[UIImage imageNamed:@"icon_checked.png"]];
//        } else {
//            [cell.imageView setImage:nil];
//        }
    }
    
    return cell;
}

- (NSInteger)tableAlert:(SBTableAlert *)tableAlert numberOfRowsInSection:(NSInteger)section
{
    if (curModel == ShowAddtionInfor)
    {
        return [[[Public getInstance].curPublishDes contents] count];
    }
    else if (delegate && [delegate respondsToSelector:@selector(PopTableAlertViewGetDataSourceInSection:)])
    {
        return [[delegate PopTableAlertViewGetDataSourceInSection:section] count];
    }
    
    return 0;
}

- (NSString *)tableAlert:(SBTableAlert *)tableAlert titleForHeaderInSection:(NSInteger)section
{
    if (curModel == ShowAddtionInfor) {
        return @"可选说明";
    }
    
    if (delegate && [delegate respondsToSelector:@selector(titleForSection:)]) {
        return [delegate titleForSection:section];
    }
    
    return nil;
}
#pragma mark - SBTableAlertDelegate
- (void)tableAlert:(SBTableAlert *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (delegate && [delegate respondsToSelector:@selector(PopTableAlertViewDidSelectIndex:)])
    {
        id object = nil;
        
        if (curModel == ShowAddtionInfor)
        {
            object = [[[Public getInstance].curPublishDes contents] objectAtIndex:indexPath.row];
        }
        
        [delegate PopTableAlertViewDidSelectIndex:indexPath];
    }
    
    [tableAlert.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableAlert:(SBTableAlert *)tableAlert heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (curModel == ShowAddtionInfor)
    {
        return 44.0f;
    }
    
    return 60;
}

@end
