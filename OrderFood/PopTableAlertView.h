//
//  PopTableAlertView.h
//  OrderFood
//
//  Created by klozz on 14-3-18.
//  Copyright (c) 2014年 handcent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodObject.h"

typedef enum{
    ShowFoodList,
    ShowAddtionInfor
}ShowModel;

@protocol PopTableAlertViewDelegate <NSObject>

- (NSArray *)PopTableAlertViewGetDataSourceInSection:(int)section;
- (void)PopTableAlertViewDidSelectIndex:(NSIndexPath *)indexPath;
- (int)numberOfSectionInTable;
- (NSString *)titleForSection:(int)section;
- (int)selectionCountInsection:(int)section;
@end

@interface PopTableAlertView : NSObject
@property (nonatomic, retain) FoodObject        *curFoodObject;
@property (nonatomic, assign) ShowModel         curModel;
@property (nonatomic, assign) id<PopTableAlertViewDelegate>delegate;
+ (PopTableAlertView *)getInstance;
+ (void)freeInstance;
- (void)show;
- (void)reloadData;
@end
