//
//  SOAPRequest.h
//  HttpStaticLibay
//
//  Created by aplle on 5/15/13.
//
//

#import <Foundation/Foundation.h>
@class ASIHTTPRequest;
@class SOAPRequest;

@protocol RequestOperationDelegate <NSObject>
- (void)SOAPRequest:(SOAPRequest *)request didFinishRequest:(NSData*)responseData;
- (void)SOAPRequest:(SOAPRequest *)request responseErrorOccurred:(NSError *)error;
@end

@interface SOAPRequest : NSObject
+ (ASIHTTPRequest *)getASISOAP11Request:(NSString *) WebURL
                         webServiceFile:(NSString *) wsFile
                           xmlNameSpace:(NSString *) xmlNS
                         webServiceName:(NSString *) wsName
                           wsParameters:(NSMutableArray *) wsParas;

+ (NSString *)getSOAP11WebServiceResponse:(NSString *) WebURL
                           webServiceFile:(NSString *) wsFile
                             xmlNameSpace:(NSString *) xmlNS
                           webServiceName:(NSString *) wsName
                             wsParameters:(NSMutableArray *) wsParas;

+ (NSString *)getSOAP11WebServiceResponseWithNTLM:(NSString *) WebURL
                                   webServiceFile:(NSString *) wsFile
                                     xmlNameSpace:(NSString *) xmlNS
                                   webServiceName:(NSString *) wsName
                                     wsParameters:(NSMutableArray *) wsParas
                                         userName:(NSString *) userName
                                         passWord:(NSString *) passWord;

+ (NSString *)checkResponseError:(NSString *) theResponse;
/*
 //Mark: 使用SOAP1.1异步调用WebService请求
 参数 webURL：                远程WebService的地址，不含*.asmx
 参数 webServiceFile：        远程WebService的访问文件名，如service.asmx
 参数 xmlNS：                 远程WebService的命名空间
 参数 webServiceName：        远程WebService的名称
 参数 wsParameters：          调用参数数组，形式为[参数1名称，参数1值，参数2名称，参数2值……]，如果没有调用参数，此参数为nil
 参数 t_delegate：            代理对象
 */
- (void)getAsyn_SOAP11WebServiceResponse:(NSString*) WebURL
                          webServiceFile:(NSString*) wsFile
                            xmlNameSpace:(NSString*) xmlNS
                          webServiceName:(NSString*) wsName
                            wsParameters:(NSMutableArray*) wsParas
                                delegate:(id<RequestOperationDelegate>) t_delegate;
@property (nonatomic, retain) id<RequestOperationDelegate>delegate;
@end
