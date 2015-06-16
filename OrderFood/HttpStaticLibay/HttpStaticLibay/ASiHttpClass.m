//
//  ASiHttpClass.m
//  RegisterInterface
//
//  Created by aplle on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ASiHttpClass.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#define DEFAULT_TIMEOUT     120

@interface ASiHttpClass ()<ASIHTTPRequestDelegate,ASIProgressDelegate>

@end

@implementation ASiHttpClass
@synthesize username;
@synthesize userword;
@synthesize requestData;
@synthesize Error_msg;
@synthesize delegate;
@synthesize Code;
@synthesize FileName;
@synthesize responseStatusCodeNum;
@synthesize httpKey;

- (id)copyWithZone:(NSZone *)zone
{
    if (!self)
    {
        ASiHttpClass *result = [[[self class] allocWithZone:zone] init];
        result->request = [self->request copy];
        result->request1 = [self->request1 copy];
        result->username = [self->username copy];
        result->userword = [self->userword copy];
        result->requestData = [self->requestData copy];
        result->Error_msg = [self->Error_msg copy];
        result->Code = [self->Code copy];
        result->FileName = [self->FileName copy];
        
        result->delegate = self->delegate;
        result->IsTiped = self->IsTiped;
        result->responseStatusCodeNum = self->responseStatusCodeNum;
        
        return result;
    }
    
    return [self retain];
}

-(id)init
{
    self=[super init];
    
    if (self)
    {
        Error_msg=nil;
        userword=nil;
        request = nil;
        username=nil;
        requestData=nil;
        Code = nil;
        FileName =nil;
        responseStatusCodeNum = 0;
        self.httpKey = nil;
        [ASIHTTPRequest setDefaultTimeOutSeconds:DEFAULT_TIMEOUT];
    }
    
    return self;
}

-(void) dealloc
{
    [Error_msg release];
    [username release];
    [userword release];
    [Code release];
    [FileName release];
    self.delegate = nil;
    self.httpKey = nil;
    self = nil;
    
    [super dealloc];
}
-(void)PostSeverUrl:(NSString *)url body:(NSMutableDictionary *) pist_dic
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible= YES;
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeOutSeconds:DEFAULT_TIMEOUT];
   // request.tag=100;
    NSArray* keys = [pist_dic allKeys];
    for (int i=0; i< [keys count]; i++)
    {
        id value = [pist_dic valueForKey: [keys objectAtIndex:i]];
        if ([value isKindOfClass:[NSData class]])
        {
             NSString *key=[NSString stringWithFormat:@"%@",[keys objectAtIndex:i]];
            
            [request setData:value forKey:key];
        }
        else
        {
            NSString *key=[NSString stringWithFormat:@"%@",[keys objectAtIndex:i]];
           [request setPostValue:value forKey:key];
        }
    }
        
    [request setRequestMethod:@"POST"]; 
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request setDidFinishSelector:@selector(requestDidSuccess:)];
    [request startAsynchronous];

}
-(void)PostNeedSignSeverUrl:(NSString *)url body:(NSMutableDictionary *)pist_data
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible= YES;
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeOutSeconds:DEFAULT_TIMEOUT];
    
    NSArray* keys = [pist_data allKeys];
    for (int i=0; i< [keys count]; i++)
    {
        id value = [pist_data valueForKey: [keys objectAtIndex:i]];
        if ([value isKindOfClass:[NSData class]])
        {
            NSString *key=[NSString stringWithFormat:@"%@",[keys objectAtIndex:i]];
            [request setData:value forKey:key];
        }
        else
        {
            NSString *key=[NSString stringWithFormat:@"%@",[keys objectAtIndex:i]];
            [request setPostValue:value forKey:key];
        }
    }
        
    [request setRequestMethod:@"POST"];
    [request setUsername:username];
    [request setPassword:userword];
    [request setUseSessionPersistence:YES]; 

    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request setDidFinishSelector:@selector(requestDidSuccess:)];
    [request startAsynchronous];
}

-(NSData *)PostNeedSignSeverSyUrl:(NSString *)url body:(NSMutableDictionary *)pist_data
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeOutSeconds:DEFAULT_TIMEOUT];
    
    NSArray* keys = [pist_data allKeys];
    for (int i=0; i< [keys count]; i++)
    {
        id value = [pist_data valueForKey: [keys objectAtIndex:i]];
        if ([value isKindOfClass:[NSData class]])
        {
            NSString *key=[NSString stringWithFormat:@"%@",[keys objectAtIndex:i]];
            [request setData:value forKey:key];
        }
        else
        {
            NSString *key=[NSString stringWithFormat:@"%@",[keys objectAtIndex:i]];
            [request setPostValue:value forKey:key];
        }
    }
    
    [request setRequestMethod:@"POST"];
    [request setUsername:username];
    [request setPassword:userword];
    [request setUseSessionPersistence:YES];
    
    [request setDelegate:nil];
    [request startSynchronous];
    
    return request.responseData;
}

-(void)PutNewSeverUrl:(NSString *)url AndDictionary:(NSMutableDictionary *)dic
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible= YES;
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeOutSeconds:DEFAULT_TIMEOUT];
    NSArray* keys = [dic allKeys];
    for (int i=0; i< [keys count]; i++)
    {
        id value = [dic valueForKey: [keys objectAtIndex:i]];
        if ([value isKindOfClass:[NSData class]])
        {
            NSString *key=[NSString stringWithFormat:@"%@",[keys objectAtIndex:i]];
            [request setData:value forKey:key];
        }
        else
        {
            NSString *key=[NSString stringWithFormat:@"%@",[keys objectAtIndex:i]];
            [request setPostValue:value forKey:key];
        }
    }
    
    
    
    [request setRequestMethod:@"PUT"]; 
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request setDidFinishSelector:@selector(requestDidSuccess:)];
    [request startAsynchronous];    
}

-(void)PutNewNeedSignSeverUrl:(NSString *)url AndDidctionary:(NSMutableDictionary *)dic
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible= YES;
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSArray* keys = [dic allKeys];
    for (int i=0; i< [keys count]; i++)
    {
        id value = [dic valueForKey: [keys objectAtIndex:i]];
        if ([value isKindOfClass:[NSData class]])
        {
            NSString *key=[NSString stringWithFormat:@"%@",[keys objectAtIndex:i]];
            
            [request setData:value forKey:key];
        }
        else
        {
            NSString *key=[NSString stringWithFormat:@"%@",[keys objectAtIndex:i]];
            [request setPostValue:value forKey:key];
        }
        
    }    
    
    [request setRequestMethod:@"PUT"];
    [request setUsername:username];
    [request setPassword:userword];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request setDidFinishSelector:@selector(requestDidSuccess:)];
    [request startAsynchronous];
    
}

#pragma mark ASIFormDataRequest Fail and finish methods

- (void)requestDidSuccess:(ASIFormDataRequest*)request2
{
    request2.delegate = nil;
    if ([request2 responseStatusCode]==200||[request2 responseStatusCode ]==201)
    {
        id  set=  [request2 responseHeaders];
        NSString *content = [set objectForKey:@"Content-Disposition"];
        NSArray *result = [content componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];
        if (result && [result count] > 1) {
            self.FileName = [result objectAtIndex:([result count] - 1)];
        }
        
        if (!self.FileName)
        {
            NSArray *subStrs = [[[request1 url] description] componentsSeparatedByString:@"/"];
            
            if ([subStrs count] > 0)
            {
                self.FileName = [subStrs objectAtIndex:[subStrs count] - 1];
            }
        }
        requestData = [request2 responseData];
        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(finished_Recevived:andASiHttpClass:)])
        {
            [self.delegate finished_Recevived:requestData andASiHttpClass:self];
        }
        
    }
    else
    {
        requestData = [request2 responseData];
        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(request_Error:andASiHttpClass:AndReceiveCode:)])
        {
            [self.delegate request_Error:requestData andASiHttpClass:self AndReceiveCode:[request2 responseStatusCode]];
        }
        if (IsTiped==NO)
        {
            int Id=[request2 responseStatusCode];
            NSString *str=[NSString string];
            if (Id==401)
            {
                str=NSLocalizedStringWithDefaultValue(@"key_a_errorinfo_0", nil, [NSBundle mainBundle], @"Unauthorized", nil);
            }
            else if (Id == 409)
            {
                str= NSLocalizedStringWithDefaultValue(@"key_a_errorinfo1_0", nil, [NSBundle mainBundle], @"Equipment already binding", nil);  
            }
            else if (Id == 503)
            {
                str= NSLocalizedStringWithDefaultValue(@"key_a_errorinfo3_0", nil, [NSBundle mainBundle], @"Service is unavailable", nil); 
            }
            else if (Id==402)
            {
                str= NSLocalizedStringWithDefaultValue(@"key_a_errorinfo2_0", nil, [NSBundle mainBundle], @"Unpaid", nil);  
            }
            else  if (Id==406)
            {
                str= NSLocalizedStringWithDefaultValue(@"key_a_errorinfo4_0", nil, [NSBundle mainBundle], @"The account is not active", nil); 
            }
            else if (Id == 412)
            {
                str= NSLocalizedStringWithDefaultValue(@"key_a_errorinfo5_0", nil, [NSBundle mainBundle], @"Super limit", nil); 
                
            }
            else 
            {
                str= [NSString stringWithFormat:@"Response:%d",[request2 responseStatusCode]];
                                                                
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!" 
                                                        message:[NSString stringWithFormat:@"%@",str] 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
		    [alert show];
            [alert release];
        }
    }
    
  [UIApplication sharedApplication].networkActivityIndicatorVisible= NO;
}

- (void)requestDidFailed:(ASIFormDataRequest*)request2
{
    request2.delegate = nil;
    NSError *error = [request2 error];
    self.responseStatusCodeNum = [request2 responseStatusCode];
    
    if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(Error_Rrcevived: andASiHttpClass:)])
    {
        [delegate Error_Rrcevived:error andASiHttpClass:self];
    }
        
    if (IsTiped==NO)
    {
        int Id=responseStatusCodeNum;
        NSString *str=[NSString string];
        //收到responseStatusCodeNum的各种错误信息
        if (Id==401)
        {
            str=NSLocalizedStringWithDefaultValue(@"key_a_errorinfo_0", nil, [NSBundle mainBundle], @"Unauthorized", nil);
        }
        else if (Id == 409)
        {
            str= NSLocalizedStringWithDefaultValue(@"key_a_errorinfo1_0", nil, [NSBundle mainBundle], @"Equipment already binding", nil);  
        }
        else if (Id == 503)
        {
            str= NSLocalizedStringWithDefaultValue(@"key_a_errorinfo3_0", nil, [NSBundle mainBundle], @"Service is unavailable", nil); 
        }
        else if (Id==402)
        {
            str= NSLocalizedStringWithDefaultValue(@"key_a_errorinfo2_0", nil, [NSBundle mainBundle], @"Unpaid", nil);  
        }
        else  if (Id==406)
        {
            str= NSLocalizedStringWithDefaultValue(@"key_a_errorinfo4_0", nil, [NSBundle mainBundle], @"The account is not active", nil); 
        }
        else if (Id == 412)
        {
            str= NSLocalizedStringWithDefaultValue(@"key_a_errorinfo5_0", nil, [NSBundle mainBundle], @"Super limit", nil); 
            
        }
        else
        {
            str= [error localizedDescription];
        }

        
        
	  UIAlertView  *alert;
	  alert = [[UIAlertView alloc] initWithTitle:@"Failed!" 
									   message:[NSString stringWithFormat:@"Errmsg:%@.",str] 
									  delegate:nil 
							 cancelButtonTitle:@"OK" 
							 otherButtonTitles:nil];
	  [alert show];
	  [alert release];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible= NO;
}

-(void)GetSeverUrl:(NSString *)url AndCode:(NSString *)code //不需要P1；
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *Murl=[NSURL URLWithString:url];
    request1 = [ASIHTTPRequest requestWithURL:Murl];
    [request1 setTimeOutSeconds:DEFAULT_TIMEOUT];
    [request1 setDelegate:self];
    [request1 startAsynchronous];
    self.Code = code;    
}

-(void)GetSeverNeedSignUrl:(NSString *)url AndCode:(NSString *)code //需要P1；
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *Murl=[NSURL URLWithString:url];
    request1 = [ASIHTTPRequest requestWithURL:Murl];
    [request1 setTimeOutSeconds:DEFAULT_TIMEOUT];
    [request1 setUsername:username];
    [request1 setPassword:userword];
    
    [request1 setDomain:@"my-domain"];
    [request1 setDelegate:self];
    [request1 startAsynchronous];
    self.Code = code;
}

-(void)GetSeverUrl:(NSString *)url
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *Murl=[NSURL URLWithString:url];
    request1 = [ASIHTTPRequest requestWithURL:Murl];
    [request1 setTimeOutSeconds:DEFAULT_TIMEOUT];
    [request1 setDelegate:self];
    [request1 startAsynchronous];
    
}

-(NSData *)GetSeverUrlSy:(NSString *)url
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *Murl=[NSURL URLWithString:url];
    request1 = [ASIHTTPRequest requestWithURL:Murl];
    [request1 setTimeOutSeconds:DEFAULT_TIMEOUT];
    [request1 setDelegate:self];
    [request1 startSynchronous];
    [request1 setDelegate:nil];
    
    return request1.responseData;
}

- (void)downloadFileWithURL:(NSString *)url
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *Murl=[NSURL URLWithString:url];
    request = [ASIFormDataRequest requestWithURL:Murl];
    [request setTimeOutSeconds:DEFAULT_TIMEOUT];
    [request setRequestMethod:@"GET"]; 
    [request setDelegate:self];
    [request setDownloadProgressDelegate:self];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request setDidFinishSelector:@selector(requestDidSuccess:)];
    [request startAsynchronous];
}

-(void)GetSeverNeedSignUrl:(NSString *)url
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *Murl=[NSURL URLWithString:url];
    request1 = [ASIHTTPRequest requestWithURL:Murl];
    [request1 setTimeOutSeconds:DEFAULT_TIMEOUT];
    [request1 setUsername:username];
    [request1 setPassword:userword];
    
    [request1 setDomain:@"my-domain"];
    [request1 setDelegate:self];
    [request1 startAsynchronous];    
}

- (NSData*)getDataFromPostDictionary:(NSDictionary*)dict
{
    NSArray* keys = [dict allKeys];
    NSMutableData* result = [NSMutableData data];
    
    for (int i = 0; i < [keys count]; i++)
    {
        id value = [dict valueForKey: [keys objectAtIndex:i]];
        if ([value isKindOfClass:[NSData class]])
        {
             [result appendData:value];
        }
        else
        {
            NSString *formstring = [NSString stringWithFormat:@"%@=%@&", [keys objectAtIndex:i],value];
            
            [result appendData:[formstring dataUsingEncoding:NSUTF8StringEncoding]];
        }        
    }
    
    return result;
}

-(void)PutSeverUrl:(NSString *)url AndParameter:(NSMutableDictionary *)dic
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *Murl=[NSURL URLWithString:url];
    request1 = [[ASIHTTPRequest requestWithURL:Murl] retain];
    [request1 setTimeOutSeconds:DEFAULT_TIMEOUT];

    if (dic!=nil)
    {
        NSData *data= [self getDataFromPostDictionary:dic];
        [request1 appendPostData:data];
    }
    [request1 setRequestMethod:@"PUT"]; 
    [request1 setDelegate:self];
    [request1 startAsynchronous];
}

-(void)PutNeedSignSeverUrl:(NSString *)url AndParameter:(NSMutableDictionary *)dic
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *Murl=[NSURL URLWithString:url];
    request1 = [ASIHTTPRequest requestWithURL:Murl];
    [request1 setTimeOutSeconds:DEFAULT_TIMEOUT];
    [request1 setUsername:username];
    [request1 setPassword:userword];
    [request1 setDomain:@"my-domain"];
    if (dic!=nil)
    {
        NSData *data= [self getDataFromPostDictionary:dic];
        [request1 appendPostData:data];
    }
    
    [request1 setRequestMethod:@"PUT"]; 
    [request1 setDelegate:self];
    [request1 startAsynchronous]; 
}

-(void)DeleteSeverUrl:(NSString *)url
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *Murl=[NSURL URLWithString:url];
    request1 = [ASIHTTPRequest requestWithURL:Murl];
    [request1 setTimeOutSeconds:DEFAULT_TIMEOUT];
    [request1 setRequestMethod:@"DELETE"]; 
    [request1 setDelegate:self];
    [request1 startAsynchronous]; 
}

-(void)DeleteNeedSignSeverUrl:(NSString *)url
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *Murl=[NSURL URLWithString:url];
    request1 = [ASIHTTPRequest requestWithURL:Murl];
    [request1 setTimeOutSeconds:DEFAULT_TIMEOUT];
    [request1 setUsername:username];
    [request1 setPassword:userword];
    [request1 setDomain:@"my-domain"];
    [request1 setRequestMethod:@"DELETE"]; 
    [request1 setDelegate:self];
    [request1 startAsynchronous];
}

- (void)StopRequest
{
    if (request)
    {
        [request setDelegate:nil];
        [request cancel];
    }
    
    if (request1)
    {
        [request1 setDelegate:nil];
        [request1 cancel];
    }
}

#pragma mark ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request2 
{
    request2.delegate = nil;
    // Use when fetching text data
    if ([request2 responseStatusCode]==200||[request2 responseStatusCode ]==201)
    {
        requestData = [request2 responseData];
      
        id  set=  [request1 responseHeaders];
        NSString *content = [set objectForKey:@"Content-Disposition"];
        NSArray *result = [content componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];
        if (result && [result count] > 1) {
           self.FileName = [result objectAtIndex:([result count] - 1)];
        }
        
        if (!self.FileName)
        {
            NSArray *subStrs = [[[request1 url] description] componentsSeparatedByString:@"/"];
            
            if ([subStrs count] > 0)
            {
                self.FileName = [subStrs objectAtIndex:[subStrs count] - 1];
            }
        }
        
        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(finished_Recevived:andASiHttpClass:)])
        {
            [self.delegate finished_Recevived:requestData andASiHttpClass:self];
        }
    }
    else
    {
        requestData = [request2 responseData];
        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(request_Error:andASiHttpClass:AndReceiveCode:)])
        {
            [self.delegate request_Error:requestData andASiHttpClass:self AndReceiveCode:[request2 responseStatusCode]];
        }
        if (IsTiped==NO)
        {
            int Id=[request2 responseStatusCode];
            NSString *str=[NSString string];
            if (Id==401)
            {
                str=NSLocalizedStringWithDefaultValue(@"key_a_errorinfo_0", nil, [NSBundle mainBundle], @"Unauthorized", nil);
            }
            else if (Id == 409)
            {
                str= NSLocalizedStringWithDefaultValue(@"key_a_errorinfo1_0", nil, [NSBundle mainBundle], @"Equipment already binding", nil);  
            }
            else if (Id == 503)
            {
                str= NSLocalizedStringWithDefaultValue(@"key_a_errorinfo3_0", nil, [NSBundle mainBundle], @"Service is unavailable", nil); 
            }
            else if (Id==402)
            {
                str= NSLocalizedStringWithDefaultValue(@"key_a_errorinfo2_0", nil, [NSBundle mainBundle], @"Unpaid", nil);  
            }
            else  if (Id==406)
            {
                str= NSLocalizedStringWithDefaultValue(@"key_a_errorinfo4_0", nil, [NSBundle mainBundle], @"The account is not active", nil); 
            }
            else if (Id == 412)
            {
                str= NSLocalizedStringWithDefaultValue(@"key_a_errorinfo5_0", nil, [NSBundle mainBundle], @"Super limit", nil); 
                
            }
            else
            {
                str=str= [NSString stringWithFormat:@"Response:%d",[request2 responseStatusCode]];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!" 
                                                        message:[NSString stringWithFormat:@"%@.",str] 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
		    [alert show];
            [alert release];
        }
    }    
}

- (void)requestFailed:(ASIHTTPRequest *)request2
{
    request2.delegate = nil;
    NSError *error = [request2 error];
    
    self.responseStatusCodeNum = [request2 responseStatusCode];
    
    if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(Error_Rrcevived: andASiHttpClass:)])
    {
        [delegate Error_Rrcevived:error andASiHttpClass:self];
    }
    
    if (IsTiped==NO)
    {
        int Id=responseStatusCodeNum;
        NSString *str=[NSString string];
        if (Id==401)
        {
            str=NSLocalizedStringWithDefaultValue(@"key_a_errorinfo_0", nil, [NSBundle mainBundle], @"Unauthorized", nil);
        }
        else if (Id == 409)
        {
            str= NSLocalizedStringWithDefaultValue(@"key_a_errorinfo1_0", nil, [NSBundle mainBundle], @"Equipment already binding", nil);  
        }
        else if (Id == 503)
        {
            str= NSLocalizedStringWithDefaultValue(@"key_a_errorinfo3_0", nil, [NSBundle mainBundle], @"Service is unavailable", nil); 
        }
        else if (Id==402)
        {
            str= NSLocalizedStringWithDefaultValue(@"key_a_errorinfo2_0", nil, [NSBundle mainBundle], @"Unpaid", nil);  
        }
        else  if (Id==406)
        {
            str= NSLocalizedStringWithDefaultValue(@"key_a_errorinfo4_0", nil, [NSBundle mainBundle], @"The account is not active", nil); 
        }
        else if (Id == 412)
        {
            str= NSLocalizedStringWithDefaultValue(@"key_a_errorinfo5_0", nil, [NSBundle mainBundle], @"Super limit", nil); 
            
        }
        else
        {
            str= [error localizedDescription];
        }
        
        UIAlertView  *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Failed!"
                                           message:[NSString stringWithFormat:@"Errmsg:%@.",str]
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}


-(void) SetIsTipOrNO:(BOOL) IsTip
{
    IsTiped = IsTip;
}

#pragma mark -
#pragma mark - ASIProgressDelegate
- (void)setProgress:(float)newProgress
{    
    if (delegate && [delegate respondsToSelector:@selector(request:setProgress:)])
    {
        [delegate request:self setProgress:newProgress];
    }
}

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes;
{
    if (delegate && [delegate respondsToSelector:@selector(request:didReceiveBytes:)])
    {
        [delegate request:self didReceiveBytes:bytes];
    }
}

// Called when a request needs to change the length of the content to download
- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{
    if (delegate && [delegate respondsToSelector:@selector(request:incrementDownloadSizeBy:)])
    {
        [delegate request:self incrementDownloadSizeBy:newLength];
    }
}

@end
