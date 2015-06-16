//
//  ChangebleRoomsSelectionViewController.h
//  OrderFood
//
//  Created by aplle on 8/4/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectedRoomById)(NSString *);

@interface ChangebleRoomsSelectionViewController : UIViewController
@property (nonatomic, copy) selectedRoomById    didSelectAction;
@end
