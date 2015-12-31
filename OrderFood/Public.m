//
//  Public.m
//  OrderFood
//
//  Created by aplle on 8/3/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "Public.h"
#import "sys/utsname.h"

@implementation Public
@synthesize gbkEncoding;
@synthesize juhua;
@synthesize userName;
@synthesize userCode;
@synthesize curPublishDes;
@synthesize serviceIpAddr;
@synthesize getImageQueue;
@synthesize getCategoryQueue;
@synthesize bookHistoryDictionary;
@synthesize roomIDAndBookID;

static Public *_Public = nil;

+ (Public *)getInstance
{
    @synchronized(_Public)
    {
        if (!_Public)
        {
            _Public = [[Public alloc] init];
        }
        
        return _Public;
    }
}
+ (void)freeInstance
{
    @synchronized(_Public)
    {
        if (_Public)
        {
//            [_Public release];
            _Public = nil;
        }
    }
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        juhua = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
        [[[UIApplication sharedApplication] keyWindow] addSubview:juhua];
        self.serviceIpAddr = SERVICE_IPADDR;
        self.getImageQueue = dispatch_queue_create("com.handcent.getImageQueue", NULL);
        self.getCategoryQueue = dispatch_queue_create("com.handcent.getCategoryQueue", NULL);
        /*
         MARK:
         1.进入房间的时候，查找key为房间id的array，若不存在则创建key为房间id，value为已选的但是还没下单餐品array的键值对
         2.当下单的时候清除array里面的数据
         3.当房间状态为以结的时候清空房间对应的array里面的值
         */
        bookHistoryDictionary = [[NSMutableDictionary alloc] init];
        roomIDAndBookID = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)saveDefaultIPAddress
{
    if (serviceIpAddr)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        path = [[NSString alloc] initWithFormat:@"%@/configure", path];
        
//        NSDictionary *dic = [NSDictionary dictionaryWithObject:serviceIpAddr forKey:@"IPAddress"];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:serviceIpAddr, userName, nil] forKeys:[NSArray arrayWithObjects:@"IPAddress", @"UserName", nil]];
        [dic writeToFile:path atomically:NO];
    }
}

- (NSString *)getDefaultIPAddress
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [[NSString alloc] initWithFormat:@"%@/configure", path];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    if (dic)
    {
        return [dic objectForKey:@"IPAddress"];
    }
    
    return @"";
}

- (NSString *)getDefaultUserName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [[NSString alloc] initWithFormat:@"%@/configure", path];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    if (dic)
    {
        return [dic objectForKey:@"UserName"];
    }
    
    return @"";
}

- (MBProgressHUD *)juhua
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:juhua];
    });
    
    return juhua;
}
//16进制转10进制
+ (long)hexToDec:(NSString *)hexStr
{
    long sum = 0;
    int  tmp;
    
    for (int i=0; i<[hexStr length]; i++)
    {
        char subStr = [hexStr characterAtIndex:i];
        
        if (subStr <= '9')
        {
            tmp = subStr - '0';
        }
        else
        {
            tmp = subStr - 'a' + 10;
        }
        
        sum = sum * 16 + tmp;
    }
    
    return sum;
}

+ (UIColor *)getColorFromString:(NSString *)colorStr
{
    if (!colorStr)
    {
        return nil;
    }
    
    NSArray *retArray = [colorStr componentsSeparatedByString:@"#"];
    
    if ([retArray count] != 2)
    {
        return nil;
    }
    
    NSString *color = [retArray objectAtIndex:1];
    
    if ([color length] == 6)
    {
        NSRange r = {0, 2};
        NSRange g = {2, 2};
        NSRange b = {4, 2};
        
        NSString *red = [color substringWithRange:r];
        NSString *green = [color substringWithRange:g];
        NSString *blue = [color substringWithRange:b];
        
        UIColor *returnColor = [UIColor colorWithRed:[Public hexToDec:red]/255.0
                                               green:[Public hexToDec:green]/255.0
                                                blue:[Public hexToDec:blue]/255.0
                                               alpha:1];
        
        return returnColor;
    }
    
    return nil;
}

- (float)statubarUIInterfaceOrientationAngleOfOrientation
{
    CGFloat angle;
    
    switch ([UIApplication sharedApplication].statusBarOrientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle = -M_PI_2;
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle = M_PI_2;
            break;
        default:
            angle = 0.0;
            break;
    }
    
    return angle;
}

- (void)dealloc
{
    [juhua removeFromSuperview];
    self.juhua = nil;
    self.userName = nil;
    self.userCode = nil;
    self.curPublishDes = nil;
    self.serviceIpAddr = nil;
    dispatch_release(getImageQueue);
    self.getImageQueue = nil;
    dispatch_release(getCategoryQueue);
    self.getCategoryQueue = nil;
    [roomIDAndBookID removeAllObjects];
    self.roomIDAndBookID = nil;
    
//    [super dealloc];
}

+ (NSArray *)getComponentsSeparated:(NSString *)string
{
    if (!string)
    {
        return nil;
    }
    /*
    NSArray *arr = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([arr count] == 0)
    {
        return nil;
    }
    else if ([arr count] > 2)
    {
        return [NSArray arrayWithObjects:[arr firstObject], [arr lastObject], nil];
    }
    
    return arr;
     */
    return [string componentsSeparatedByString:@"    "];
}

//获得设备型号
+ (NSString *)getCurrentDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([deviceString isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([deviceString isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([deviceString isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([deviceString isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    if ([deviceString isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    if ([deviceString isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([deviceString isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([deviceString isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])   return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    if ([deviceString isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    if ([deviceString isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    if ([deviceString isEqualToString:@"iPad4,7"])   return @"iPad Mini 3G";
    
    if ([deviceString isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([deviceString isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return deviceString;
}
@end
