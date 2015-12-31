//
//  AppDelegate.m
//  OrderFood
//
//  Created by aplle on 7/18/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

@implementation AppDelegate
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 40000
	UIBackgroundTaskIdentifier backgroundTask;//将程序挂到后台返回的句柄
	dispatch_block_t    expirationHandler;
	BOOL                multitaskingSupported;
#endif /* __IPHONE_OS_VERSION_MIN_REQUIRED */
}

- (void)dealloc
{
//    [_window release];
//    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = /*[*/[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]/* autorelease]*/;
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [bg setImage:[UIImage imageNamed:@"b.png"]];
    CGRect r = [UIScreen mainScreen].bounds;
    bg.transform = CGAffineTransformMakeRotation(M_PI/2.0f);
    bg.center = CGPointMake(r.size.width/2.0f, r.size.height/2.0f);
    [self.window addSubview:bg];
//    [bg release];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    LoginViewController *view = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    NSArray *ret = [[NSBundle mainBundle] loadNibNamed:@"OFNavigationController" owner:nil options:nil];
    UINavigationController *rootController = [ret lastObject];
    [rootController setViewControllers:[NSArray arrayWithObject:view]];
    [self.window setRootViewController:rootController];
    [self.window addSubview:rootController.view];
    [rootController.navigationBar setBarStyle:UIBarStyleBlack];
//    [view release];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 40000
//	multitaskingSupported = [[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)] && [[UIDevice currentDevice] isMultitaskingSupported];
//	backgroundTask = UIBackgroundTaskInvalid;
//	expirationHandler = ^{
//		AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication];
//		if(app->multitaskingSupported)
//        {
//			[(UIApplication*)app endBackgroundTask:app->backgroundTask];
//			app->backgroundTask = UIBackgroundTaskInvalid;
//			
//			app->backgroundTask = [(UIApplication*)app beginBackgroundTaskWithExpirationHandler:app->expirationHandler];
//		}
//    };
#endif /* __IPHONE_OS_VERSION_MIN_REQUIRED */
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    application.idleTimerDisabled = YES;//自动锁屏
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 40000
//    BOOL backgroundAccepted = [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{
//        
//    }];
//    
//    if (backgroundAccepted)
//        
//    {
//        NSLog(@"backgrounding accepted");
//    }
//    
//	if(self->multitaskingSupported)
//    {
//		NSLog(@"applicationDidEnterBackground (Registered or Regitering)");
//		self->backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:self->expirationHandler];
//	}
#endif /* __IPHONE_OS_VERSION_MIN_REQUIRED */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    application.idleTimerDisabled = NO;//不锁屏
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSLog(@"程序将切换到前台运行！");
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 40000
//    [[UIApplication sharedApplication] clearKeepAliveTimeout];
//	AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication];
//	// terminate background task
//	if(self->backgroundTask != UIBackgroundTaskInvalid)
//    {
//		[(UIApplication*)app endBackgroundTask:self->backgroundTask];
//		self->backgroundTask = UIBackgroundTaskInvalid;
//	}
#endif
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
