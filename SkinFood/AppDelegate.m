//
//  AppDelegate.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 4..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "AppDelegate.h"
#import "pushcat.h"
#import "SBJson.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>
//#import "ActionSheetStringPicker.h"
#import "iToast.h"
#import "TotalWebViewController.h"
#import "UpdateViewController.h"
#import "LoginViewController.h"
#import <KakaoLink/KakaoLink.h>
#import "SnsMainViewController.h"
#import "StudyStoryDetailViewController.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface AppDelegate ()
@property (nonatomic, strong) UINavigationController *loginNavi;
@property (nonatomic, strong) NSDictionary *dic_UserInfo;
@property(nonatomic, assign) BOOL okToWait;
@property(nonatomic, copy) void (^dispatchHandler)(GAIDispatchResult result);
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"IsShowPopUp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
#if TARGET_IPHONE_SIMULATOR
    [[NSUserDefaults standardUserDefaults] setObject:@"a092f3aad2d92a4d3749de6189b13df99242c04809441f7715727bd9ee85d445" forKey:@"Token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
#else
    if( SYSTEM_VERSION_LESS_THAN( @"10.0" ) )
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        if( launchOptions != nil )
        {
            NSLog( @"registerForPushWithOptions:" );
        }
    }
    else
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
         {
             if( !error )
             {
                 [[UIApplication sharedApplication] registerForRemoteNotifications]; // required to get the app to do anything at all about push notifications
                 NSLog( @"Push registration success." );
             }
             else
             {
                 NSLog( @"Push registration FAILED" );
                 NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                 NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
             }
         }];
    }
#endif
    
    
    
    if( ![[NSUserDefaults standardUserDefaults] valueForKey:@"FirstBoot"] )
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"PushOnOff"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"AutoLogin"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"IsLogin"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"DeviceId"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"FirstBoot"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    
    
    
    //    UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.main = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    //    [Util setMainNaviBar:self.main.navigationBar];
    
    self.loginNavi = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavi"];
    [Util setLoginNaviBar:self.loginNavi.navigationBar];
    
    //    UIView *v_StatusBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
    //    v_StatusBg.backgroundColor = [UIColor blackColor];
    //    [self.mainNavi.view addSubview:v_StatusBg];
    
    self.vc_LeftMenu = [storyboard instantiateViewControllerWithIdentifier:@"LeftSideMenuViewController"];
    
    
    //    UIView *v_LoginStatusBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
    //    v_LoginStatusBg.backgroundColor = [UIColor blackColor];
    //    [self.loginNavi.view addSubview:v_LoginStatusBg];
    
    
    //구글아날리틱스 초기화
    [self initializeGoogleAnalytics];
    
    [self initViewControllers];
    
    [[WebAPI sharedData] getAppStoreInfo:^(id resulte, NSError *error) {
        
        if( resulte )
        {
            NSString *str_Ver = @"";
            NSArray *ar = [resulte objectForKey:@"results"];
            for( NSInteger i = 0; i < ar.count; i++ )
            {
                NSDictionary *dic = ar[i];
                str_Ver = [dic objectForKey:@"version"];
                if( str_Ver != nil && str_Ver.length > 0 )
                {
                    break;
                }
            }
            
            CGFloat appStoreVersion = [str_Ver floatValue];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:appStoreVersion] forKey:@"AppStoreVersion"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            CGFloat currentVersion = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] floatValue];
            
            if( appStoreVersion > currentVersion )
            {
                UIAlertView *alert = CREATE_ALERT(nil, @"최신 버전이 출시되었습니다.\n업데이트 후 사용해 주세요.", @"닫기", @"업데이트");
                [alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    
                    if( buttonIndex == 1 )
                    {
                        NSURL *appStoreURL = [NSURL URLWithString:kAppStoreURL];
                        [[UIApplication sharedApplication] openURL:appStoreURL];
                    }
                }];
            }
        }
    }];
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    self.dic_UserInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if( self.dic_UserInfo != nil )
    {
        //앱이 죽어 있을때 푸시타고 오면 여기가 호출됨
        //        ALERT_ONE(@"launchOptions");
        //        [self performSelector:@selector(showPushPage:) withObject:dic_UserInfo afterDelay:7.0f];
        //        [self showPushPage:dic_UserInfo];
    }
    
    // Override point for customization after application launch.
    return YES;
}

- (void)initializeGoogleAnalytics
{
    NSDictionary *appDefaults = @{kAllowTracking: @(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    // User must be able to opt out of tracking
    [GAI sharedInstance].optOut =
    ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    // Initialize Google Analytics with a 120-second dispatch interval. There is a
    // tradeoff between battery usage and timely dispatch.
    [GAI sharedInstance].dispatchInterval = 120;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    self.tracker = [[GAI sharedInstance] trackerWithName:@"SkinFood"
                                              trackingId:kTrackingId];
}

- (void)initViewControllers
{
    BOOL isAutoLogin = [[[NSUserDefaults standardUserDefaults] valueForKey:kIsAutoLogin] boolValue];
    if( !isAutoLogin )
    {
        //오토로그인이 아니면 무조건 로그인창 틀기
        [self showLoginView];
    }
    else
    {
        //로그인 유무에 따른 분기처리
        BOOL isLogin = [[[NSUserDefaults standardUserDefaults] valueForKey:kIsLogin] boolValue];
        if( isLogin )
        {
            //오토 로그인 상태이고 로그인된 상태면
            [self showMainView];
        }
        else
        {
            //로그인화면 틀기
            [self showLoginView];
        }
    }
}

- (void)showLoginView
{
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self.sideMenuViewController setMainViewController:self.loginNavi animated:YES closeMenu:YES];
    
    if( self.dic_UserInfo )
    {
        [self showPushPage:self.dic_UserInfo];
        //        [self performSelector:@selector(showPushPage:) withObject:self.dic_UserInfo afterDelay:3.0f];
        self.dic_UserInfo = nil;
    }
}

- (void)showMainView
{
    [Common login:[[NSUserDefaults standardUserDefaults] objectForKey:kUserId] withPw:[[NSUserDefaults standardUserDefaults] objectForKey:kUserPw]];
}

//통신 빼고 메인뷰만 띄우기
- (void)showOnlyMainView
{
    //    //메인네비에 있는 메인뷰컨트롤러를 제외한 기존 뷰컨트롤러들을 날려준다
    //    NSMutableArray *arM = [NSMutableArray arrayWithArray:self.mainNavi.viewControllers];
    //    for( NSInteger i = 1; i < arM.count; i++ )
    //    {
    //        [arM removeObjectAtIndex:i];
    //    }
    //    self.mainNavi.viewControllers = [NSMutableArray arrayWithArray:arM];
    //    /////////////////
    
    self.main.selectedIndex = 0;
    
    self.sideMenuViewController = [[TWTSideMenuViewController alloc] initWithMenuViewController:self.vc_LeftMenu
                                                                             mainViewController:self.main];
    self.sideMenuViewController.shadowColor = [UIColor blackColor];
    self.sideMenuViewController.edgeOffset = (UIOffset) { .horizontal = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 18.0f : 0.0f };
    self.sideMenuViewController.zoomScale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 0.5634f : 0.85f;
    self.sideMenuViewController.delegate = self;
    self.window.rootViewController = self.sideMenuViewController;
    
    
    
    /***********************************************************/
    NSString *str_Token = [[NSUserDefaults standardUserDefaults] valueForKey:@"Token"];
    NSLog(@"showOnlyMainView : %@", str_Token);
    
    NSString *str_UserId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    //    [[Pushcat get] registerPushcatWithTag:str_UserId Token:str_Token];
    /***********************************************************/
    
    
    BOOL isShowConfirm = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ShowConfirm"] boolValue];
    if( isShowConfirm )
    {
        NSString *str_Contents = @"앱 이용에 적합하지 않은 컨텐츠를 등록 하실 경우 게시자의 동의 없이 관리자에 의해 삭제 될 수 있음을 알려 드립니다.";
        
        UIAlertView *alert = CREATE_ALERT(nil, str_Contents, @"확인", nil);
        [alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
            if( buttonIndex == 0 )
            {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"ShowConfirm"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }];
    }
    
    if( self.dic_UserInfo )
    {
        //        [self performSelector:@selector(showPushPage:) withObject:self.dic_UserInfo afterDelay:3.0f];
        [self showPushPage:self.dic_UserInfo];
        self.dic_UserInfo = nil;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Kakao
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[KLKTalkLinkCenter sharedCenter] isTalkLinkCallback:url])
    {
        [self performSelector:@selector(onShowKakaoLinkInterval:) withObject:url.query afterDelay:0.3f];
        return YES;
    }

    return NO;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if ([[KLKTalkLinkCenter sharedCenter] isTalkLinkCallback:url])
    {
        [self performSelector:@selector(onShowKakaoLinkInterval:) withObject:url.query afterDelay:0.3f];
        return YES;
    }
    
    return NO;
}

- (void)onShowKakaoLinkInterval:(NSString *)aParam
{
    BOOL isLogin = [[[NSUserDefaults standardUserDefaults] valueForKey:kIsLogin] boolValue];
    if( isLogin )
    {
        //오토 로그인 상태이고 로그인된 상태면
        self.main.selectedIndex = 3;
        
        self.sideMenuViewController = [[TWTSideMenuViewController alloc] initWithMenuViewController:self.vc_LeftMenu
                                                                                 mainViewController:self.main];
        self.sideMenuViewController.shadowColor = [UIColor blackColor];
        self.sideMenuViewController.edgeOffset = (UIOffset) { .horizontal = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 18.0f : 0.0f };
        self.sideMenuViewController.zoomScale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 0.5634f : 0.85f;
        self.sideMenuViewController.delegate = self;
        self.window.rootViewController = self.sideMenuViewController;
        
        NSArray *ar_Seper = [aParam componentsSeparatedByString:@";"];
        if( ar_Seper.count == 2 )
        {
            NSString *str_Type = [ar_Seper objectAtIndex:0];
            NSString *str_Id = [ar_Seper objectAtIndex:1];
            
            if( [str_Type isEqualToString:@"SNS"] )
            {
                UINavigationController *navi = [self.main.viewControllers objectAtIndex:3];
                [navi popToRootViewControllerAnimated:NO];
                SnsMainViewController *vc = [navi.viewControllers firstObject];
                [vc moveToDetail:str_Id];
            }
        }
        else
        {
            //이건 정의 안됨 여기로 오면 안됨
            //SNS;12인데 앞에가 타입인데 타입없이 온 경우임
        }
    }
    else
    {
        //로그인화면 틀기
        [self showLoginView];
    }
}



#pragma mark -
#pragma mark APNS Method
//iOS8 때문에 이 메소드 추가해 줘야 함 (ㅅㅂ -_-)
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    if (notificationSettings.types == UIUserNotificationTypeNone)
    {
        //푸쉬 허용 안함
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"PushOnOff"];
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        //        [self initViewControllers];
    }
    else
    {
        //푸쉬 허용 함
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"PushOnOff"];
        [application registerForRemoteNotifications];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)notification completionHandler:(void(^)())completionHandler
{
    NSLog(@"Received push notification: %@, identifier: %@", notification, identifier); // iOS 8
    completionHandler();
}

//APNS에 장치 등록 성공시 호출되는 콜백
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSMutableString *deviceId = [NSMutableString string];
    const unsigned char* ptr = (const unsigned char*) [deviceToken bytes];
    
    for(NSInteger i = 0 ; i < 32 ; i++)
    {
        [deviceId appendFormat:@"%02x", ptr[i]];
    }
    
    NSLog(@"Token : %@", deviceId);
    
    //    ALERT_ONE(deviceId);
    //    [[UIPasteboard generalPasteboard] setString:deviceId];
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceId forKey:@"Token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//APNS에 장치 등록 실패시 호출되는 콜백
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"PushOnOff"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"deviceToken error : %@", error);
    
    [[NSUserDefaults standardUserDefaults] setObject:@"2c691a9f63bc901ac6631e796f134d79dd7c5bf6b44f9c10bbdda05144c918de" forKey:@"Token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //    [self initViewControllers];
}

//어플 실행중에 알림도착
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //    ALERT_ONE(@"어플 실행중에 알림도착 / didReceiveRemoteNotification / 10 over");
    //실행중엔 여기가 아니라 willPresentNotification 여기가 콜 됨
    [self showPushPage:userInfo];
}

-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void
                                                                                                                               (^)(UIBackgroundFetchResult))completionHandler
{
    // iOS 10 will handle notifications through other methods
    //    ALERT_ONE(@"푸시 받음 iOS10보다 아래버전");
    
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO( @"10.0" ) )
    {
        NSLog( @"iOS version >= 10. Let NotificationCenter handle this one." );
        // set a member variable to tell the new delegate that this is background
        return;
    }
    NSLog( @"HANDLE PUSH, didReceiveRemoteNotification: %@", userInfo );
    
    // custom code to handle notification content
    
    if( [UIApplication sharedApplication].applicationState == UIApplicationStateInactive )
    {
        NSLog( @"INACTIVE" );
        completionHandler( UIBackgroundFetchResultNewData );
    }
    else if( [UIApplication sharedApplication].applicationState == UIApplicationStateBackground )
    {
        NSLog( @"BACKGROUND" );
        completionHandler( UIBackgroundFetchResultNewData );
    }
    else
    {
        NSLog( @"FOREGROUND" );
        completionHandler( UIBackgroundFetchResultNewData );
    }
    
    //    ALERT_ONE(@"어플 실행중에 알림도착 didReceiveRemoteNotification / 10 under");
    
    [self showPushPage:userInfo];
}

//- (void)userNotificationCenter:(UNUserNotificationCenter *)center
//       willPresentNotification:(UNNotification *)notification
//         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
//{
//    NSLog( @"Handle push from foreground" );
//    ALERT_ONE(@"포그라운드에서 푸시 받음 iOS10");
//    // custom code to handle push while app is in the foreground
//}
//
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center
//didReceiveNotificationResponse:(UNNotificationResponse *)response
//         withCompletionHandler:(void (^)())completionHandler
//{
//    NSLog( @"Handle push from background or closed" );
//    ALERT_ONE(@"백그라운드에서 푸시 받음 iOS10");
//    // if you set a member variable in didReceiveRemoteNotification, you will know if this is from closed or background
//}

//-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
//
//    //Called when a notification is delivered to a foreground app.
//
//    NSLog(@"Userinfo %@",notification.request.content.userInfo);
//
//    completionHandler(UNNotificationPresentationOptionAlert);
//}
//
//-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
//
//    //Called to let your app know which action was selected by the user for a given notification.
//
//    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
//
//}

//iOS10용
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    //    ALERT_ONE(@"앱이 포그라운드에 있을때는 여기가 실행됨");
    NSLog(@"@@@@@@@@@@@@@@@@@@@@@@@@@");
    //10버전 이상일경우 이곳으로 메세지가 온다
    [self showPushPage:notification.request.content.userInfo];
    
    //    completionHandler(UNNotificationPresentationOptionAlert); //푸시 배너를 띄운다.
    //    NSLog(@"userNotificationCenter push data = %@",notification.request.content.userInfo);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    //앱이 백그라운드거나 죽어 있을땐 여기가 실행됨
    //    ALERT_ONE(@"앱이 백그라운드거나 죽어 있을땐 여기가 실행됨");
    NSLog(@"userNotificationCenter Userinfo %@",response.notification.request.content.userInfo);
    if( self.dic_UserInfo )
    {
        //        //앱이 죽었던 상태에서 실행
        //        BOOL isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:kIsLogin] boolValue];
        //        if( isLogin )
        //        {
        //            ALERT_ONE(@"로긴");
        //            [self performSelector:@selector(showPushPage:) withObject:response.notification.request.content.userInfo afterDelay:3.0f];
        //        }
        //        else
        //        {
        //            ALERT_ONE(@"비로긴");
        //        }
    }
    else
    {
        //앱이 살았던 상태에서 실행
        [self showPushPage:response.notification.request.content.userInfo];
    }
}

- (void)showPushPage:(NSDictionary *)userInfo
{
    
}

@end
