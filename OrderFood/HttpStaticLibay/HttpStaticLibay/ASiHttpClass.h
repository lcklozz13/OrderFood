//
//  ASiHttpClass.h
//  RegisterInterface
//
//  Created by aplle on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"

//@class ASIHTTPRequest;
//@class ASIFormDataRequest;
@protocol  ASIHttpClassdelegate;
//@protocol  ASIHTTPRequestDelegate;
//@protocol  ASIProgressDelegate;

@interface ASiHttpClass : NSObject<NSCopying>
{
    NSString  *username; // 用户名
    NSString  *userword; // 密码
    NSData    *requestData; // 返回的数据流
    NSString  *Error_msg; //错误信息；
    id<ASIHttpClassdelegate> delegate;
    BOOL   IsTiped; //是否要提示错误
    ASIFormDataRequest *request;
    ASIHTTPRequest *request1;
    NSString *Code;//新加的属性
    NSString *FileName;//新加的属性
    int  responseStatusCodeNum; // 返回接口
    NSString      *httpKey;
}

@property (nonatomic,assign) int responseStatusCodeNum;
@property (nonatomic,retain) NSString *Code;
@property (nonatomic,retain) NSString *FileName;
@property (nonatomic,retain) NSString  *username;
@property (nonatomic,retain) NSString  *userword;
@property (nonatomic,retain) NSData    *requestData;
@property (nonatomic,retain) NSString  *Error_msg;
@property (nonatomic,assign) id<ASIHttpClassdelegate> delegate;
@property (nonatomic,retain) NSString      *httpKey;

-(void)PostSeverUrl:(NSString *)url body:(NSMutableDictionary *) pist_dic; //post不需要验证 参数：url，pist_dic上传对象
-(void)PostNeedSignSeverUrl:(NSString *)url body:(NSMutableDictionary *)pist_data; //post需要验证 参数：url，pist_dic上传对象
-(void)GetSeverUrl:(NSString *)url; //get 不需要验证
-(NSData *)GetSeverUrlSy:(NSString *)url; //get 不需要验证
-(void)GetSeverNeedSignUrl:(NSString *)url; // get 需要验证
-(void)PutSeverUrl:(NSString *)url AndParameter:(NSMutableDictionary *)dic; //put 不需要验证 参数：url，dic上传对象
-(void)PutNeedSignSeverUrl:(NSString *)url AndParameter:(NSMutableDictionary *)dic;// put 需要验证 参数：url，dic上传对象
-(void)DeleteSeverUrl:(NSString *)url; // Delete 不需要验证
-(void)DeleteNeedSignSeverUrl:(NSString *)url; // Delete 需要验证
//新增接口
-(void)PutNewSeverUrl:(NSString *)url AndDictionary:(NSMutableDictionary *)dic;//新 put 不需要验证 参数：url，dic上传对象
-(void)PutNewNeedSignSeverUrl:(NSString *)url AndDidctionary:(NSMutableDictionary *)dic;//新 put 需要验证 参数：url，dic上传对象

//新加的接口
-(void)GetSeverUrl:(NSString *)url AndCode:(NSString *)code;//不需要P1；
-(void)GetSeverNeedSignUrl:(NSString *)url AndCode:(NSString *)code;//需要P1；
- (void)downloadFileWithURL:(NSString *)url;
-(void) StopRequest; // 停止请求
-(void) SetIsTipOrNO:(BOOL) IsTip;//设置是否提示YES->不提示NO->提示
-(NSData *)PostNeedSignSeverSyUrl:(NSString *)url body:(NSMutableDictionary *)pist_data;
@end

@protocol ASIHttpClassdelegate <NSObject> //http 委托
//http 请求成功返回的数据receiveData，asiHttpClass = 请求的对象
-(void)finished_Recevived:(NSData *)receiveData andASiHttpClass:(ASiHttpClass *)asiHttpClass;
@optional
//http 请求失败主要是网络连接问题，error = 错误信息；asiHttpClass = 请求对象；
-(void)Error_Rrcevived:(NSError *)error andASiHttpClass:(ASiHttpClass *)asiHttpClass;
//http 请求失败，失败原因=date； asiHttpClass = 请求对象；Id = 收到的Num；

//调用downloadFileWithURL:这个函数的时候才会调到这三个代理函数
-(void)request_Error:(NSData *)date andASiHttpClass:(ASiHttpClass *)asiHttpClass AndReceiveCode:(int) Id;
- (void)request:(ASiHttpClass *)request setProgress:(float)newProgress;
- (void)request:(ASiHttpClass *)request didReceiveBytes:(long long)bytes;
- (void)request:(ASiHttpClass *)request incrementDownloadSizeBy:(long long)newLength;
@end


