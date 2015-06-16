//
//  FoodPictureView.h
//  OrderFood
//
//  Created by aplle on 8/14/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodObject.h"

typedef void(^ValueDidChangeAction)(FoodObject *);
typedef void(^NeedRefreshUserInterface)();
//图片模式显示食物视图
@interface FoodPictureView : UIView
@property (nonatomic, retain) FoodObject                *food;//当前食物
@property (nonatomic, copy) ValueDidChangeAction        didAddtion;//添加回调块
@property (nonatomic, copy) ValueDidChangeAction        didDelete;//删除回调块
@property (nonatomic, copy) ValueDidChangeAction        ValueDidChangeAction;//值改变回调块
@property (nonatomic, copy) ValueDidChangeAction        didDeleteZeroAlert;//清零回调块
@property (nonatomic, copy) NeedRefreshUserInterface    refreshBlock;//刷新回调块
@property (nonatomic, assign) BOOL                      showAlertView;//是否清零提示

- (id)initWithFrame:(CGRect)frame foodObject:(FoodObject *)obj;
@end
