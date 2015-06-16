//
//  FoodListCell.h
//  OrderFood
//
//  Created by aplle on 8/13/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodObject.h"

typedef void(^ValueChangeAction)(FoodObject *);
typedef void(^NeedRefreshInterface)();
typedef void(^SelectedAddtionInfor) (NSString *);

//列表模式食物列表cell
@interface FoodListCell : UITableViewCell
@property (nonatomic, retain) FoodObject            *food;
@property (nonatomic, assign) BOOL                  showAlertView;//删除食物时候是否弹出提示栏
@property (nonatomic, copy) ValueChangeAction       didAddtion;//添加回调块
@property (nonatomic, copy) ValueChangeAction       didDelete;//删除回调块
@property (nonatomic, copy) ValueChangeAction       didDeleteZeroAlert;//清零回调块
@property (nonatomic, copy) NeedRefreshInterface    refreshBlock;//刷新回调块
@property (nonatomic, copy) SelectedAddtionInfor    selectedAddtion;
@property (nonatomic, readonly) UIImageView           *selectImageBg;//选中背景效果图
@property (nonatomic, assign) BOOL                  touchShowAddtion;
@end
