//
//  AppDelegate.h
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 4..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
#import "TWTSideMenuViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "LeftSideMenuViewController.h"
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, TWTSideMenuViewControllerDelegate, UNUserNotificationCenterDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MainViewController *main;
@property(nonatomic, strong) id<GAITracker> tracker;
@property (nonatomic, strong) TWTSideMenuViewController *sideMenuViewController;
@property (nonatomic, strong) LeftSideMenuViewController *vc_LeftMenu;
- (void)initViewControllers;
- (void)showMainView;
- (void)showOnlyMainView;
- (void)showLoginView;
@end

//1
//2
//3
//4
//5
//enable bitcode YES


//카카오 번들 이름 바꿔야 함 현재 com.emcast.Test2로 되어 있음
//kr.skinfood.Switter
