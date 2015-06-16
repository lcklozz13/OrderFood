//
//  Constant.m
//  HttpStaticLibay
//
//  Created by aplle on 5/15/13.
//
//

#import "Constant.h"

@implementation Constant
@synthesize G_SYSTEM_NAME;
@synthesize G_NETREACHABILITY;
@synthesize G_WEBSERVICE_NAMESPACE;
@synthesize G_WEBSERVICE_ERROR;

@synthesize P_DIRECTORY_DOC;
@synthesize P_DIRECTORY_CACHES;
@synthesize P_DIRECTORY_TEMP;

/*
 构造函数，此类中主要用于只读属性的初始化
 */
- (id)init
{
    self = [super init];
    
    if (self) {
        //系统名称
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        G_SYSTEM_NAME = [[NSString alloc] initWithString:[infoDict objectForKey:@"CFBundleVersion"]];
        
        //检查网络连通性的地址
        G_NETREACHABILITY = [[NSString alloc] initWithString:@"www.baidu.com"];
        
        //远程Web Service的命名空间
        G_WEBSERVICE_NAMESPACE = [[NSString alloc] initWithString:@"http://iws.CP.ws/"];
        
        //远程Web Service调用失败后返回值前缀，即返回的字符串中如果以该字符串开头，则说明调用失败
        G_WEBSERVICE_ERROR = [[NSString alloc] initWithString:@"ResponseError\n"];
    }
    return self;
}

/*
 单例模式实现方法
 */
+ (Constant *)sharedConstant
{
    static Constant * sharedConstant;
    
    @synchronized(self)
    {
        if (!sharedConstant) {
            sharedConstant = [[Constant alloc] init];
        }
        return sharedConstant;
    }
}
@end
