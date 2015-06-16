//
//  Constant.h
//  HttpStaticLibay
//
//  Created by aplle on 5/15/13.
//
//

#import <Foundation/Foundation.h>

@interface Constant : NSObject
//--------------------------------------------------------------------
//系统基本信息-常量，运行时不可修改
//--------------------------------------------------------------------
//系统名称
@property (retain, nonatomic) NSString * G_SYSTEM_NAME;
//检查网络连通性的地址
@property (readonly) NSString * G_NETREACHABILITY;
//远程Web Service的命名空间
@property (retain, nonatomic) NSString * G_WEBSERVICE_NAMESPACE;
//远程Web Service调用失败后返回值前缀，即返回的字符串中如果以该字符串开头，则说明调用失败
@property (readonly) NSString * G_WEBSERVICE_ERROR;
//--------------------------------------------------------------------

//--------------------------------------------------------------------
//应用程序目录常量
//--------------------------------------------------------------------
//应用程序数据文件目录----用于存储用户数据或其它应该定期备份的信息
@property (retain, nonatomic) NSString * P_DIRECTORY_DOC;
//应用程序临时文件目录----用于存放临时文件，保存应用程序再次启动过程中不需要的信息
//                      系统可能在应用程序不运行的时候清理留在这个目录下的文件
@property (retain, nonatomic) NSString * P_DIRECTORY_TEMP;
//应用程序缓存目录----
@property (retain, nonatomic) NSString * P_DIRECTORY_CACHES;
//--------------------------------------------------------------------

+ (Constant *)sharedConstant;
/*
//初始化应用程序系统目录
//应用程序数据文件目录
[Constant sharedConstant].P_DIRECTORY_DOC = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//应用程序临时文件目录
[Constant sharedConstant].P_DIRECTORY_TEMP = NSTemporaryDirectory();
//应用程序缓存目录
[Constant sharedConstant].P_DIRECTORY_CACHES = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
*/
@end
