//
//  BoxInforView.h
//  seeboss
//
//  Created by aplle on 5/26/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BoxInforView;
//显示房间视图
typedef void(^OrderFoodAction)(BoxInforView *);
typedef void(^ChangeRoomAction)(BoxInforView *);
typedef void(^OpenRoomAction)(BoxInforView *);

@interface BoxInforView : UIButton
@property (nonatomic, retain) NSMutableArray        *curCellInfor;
@property (nonatomic, retain) NSString              *code;//
@property (nonatomic, retain) NSString              *title;//房间名
@property (nonatomic, retain) NSString              *category;//类别
@property (nonatomic, retain) NSString              *roomId;//房间Id
@property (nonatomic, retain) NSString              *time;//开房时间
@property (nonatomic, retain) NSString              *roomCategory;//房间类型
@property (nonatomic, assign) int                   index;//下标
@property (nonatomic, assign) BOOL                  isMember;//是否会员
@property (nonatomic, assign) int                   stat;//开房状态
@property (nonatomic, strong) NSString              *usedTime;//使用时间

@property (nonatomic, copy) OrderFoodAction         didOrderFoodAction;
@property (nonatomic, copy) ChangeRoomAction        didChangeRoomAction;
@property (nonatomic, copy) OpenRoomAction          didOpenRoomAction;

- (id)initWithBoxCellInfor:(NSMutableArray *)cellInfor frame:(CGRect)frame;
@end
