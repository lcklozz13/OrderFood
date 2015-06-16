//
//  HCSwitch.h
//  IM
//
//  Created by aplle on 8/16/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//开关按钮
@interface HCSwitch : UIControl
- (id)initWithOnImage:(UIImage *)onImage1 offImage:(UIImage *)offImage1;
@property (nonatomic, retain) UIImage       *onImage;//打开图片
@property (nonatomic, retain) UIImage       *offImage;//关闭图片
@property (nonatomic, assign) BOOL          isOn;//当前状态
@end
