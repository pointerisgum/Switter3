//
//  Common.m
//  Pari
//
//  Created by KimYoung-Min on 2014. 12. 27..
//  Copyright (c) 2014년 KimYoung-Min. All rights reserved.
//

#import "Common.h"

static Common *shared = nil;

@implementation Common

+ (void)initialize
{
    NSAssert(self == [Common class], @"Singleton is not designed to be subclassed.");
    shared = [Common new];
}

+ (Common *)sharedData
{
    return shared;
}

+ (void)saveUserInfo:(NSDictionary *)dic
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [dic valueForKey:@"brandIdx"]] forKey:@"brandIdx"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [dic valueForKey:@"comIdx"]] forKey:@"comIdx"];
    [[NSUserDefaults standardUserDefaults] setObject:[dic valueForKey:@"comName"] forKey:@"comName"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [dic valueForKey:@"deptCdIdx"]] forKey:@"deptCdIdx"];
    [[NSUserDefaults standardUserDefaults] setObject:[dic valueForKey:@"deptName"] forKey:@"deptName"];
    [[NSUserDefaults standardUserDefaults] setObject:[dic valueForKey:@"dutiesPositionIdx"] forKey:@"dutiesPositionIdx"];
    [[NSUserDefaults standardUserDefaults] setObject:[dic valueForKey:@"dutiesPositionNm"] forKey:@"dutiesPositionNm"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [dic valueForKey:@"userAuth"]] forKey:@"userAuth"];
    [[NSUserDefaults standardUserDefaults] setObject:[dic valueForKey:@"userId"] forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [dic valueForKey:@"userIdx"]] forKey:@"userIdx"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [dic valueForKey:@"userIp"]] forKey:@"userIp"];
    [[NSUserDefaults standardUserDefaults] setObject:[dic valueForKey:@"userName"] forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] setObject:[dic valueForKey:@"DutiesPositionParentNm"] forKey:@"DutiesPositionParentNm"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeUserInfo
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"brandIdx"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"comIdx"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"comName"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"deptCdIdx"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"deptName"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"dutiesPositionIdx"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"dutiesPositionNm"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userAuth"];
//    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userIdx"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userIp"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"DutiesPositionParentNm"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setCntButton:(NSString *)aString withObj:(UIButton *)btn
{
    NSInteger cnt = [aString integerValue];
    
    if( cnt > 0 )
    {
        btn.hidden = NO;
        [btn setTitle:[NSString stringWithFormat:@"%ld", (long)cnt] forState:UIControlStateNormal];
    }
    else
    {
        btn.hidden = YES;
    }
}

+ (void)studyViewCountUp:(NSString *)aIdx
{
    //http://127.0.0.1:7080/api/learn/insertIntegrationCourseClickCnt.do?comBraRIdx=10001&userIdx=1004&integrationCourseIdx=1
    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionary];
    [dicM_Params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"comBraRIdx"] forKey:@"comBraRIdx"];
    [dicM_Params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userIdx"] forKey:@"userIdx"];
    [dicM_Params setObject:aIdx forKey:@"integrationCourseIdx"];
    
    [[WebAPI sharedData] callSyncWebAPIBlock:@"learn/insertIntegrationCourseClickCnt.do"
                                        param:dicM_Params
                                    withBlock:^(id resulte, NSError *error) {
                                        
                                        if( resulte )
                                        {

                                        }
                                    }];
}

+ (void)greenTubeViewCountUp:(NSString *)aIdx
{
    //http://127.0.0.1:7080/api/sns/updateSnsViewCnt.do?comBraRIdx=10001&userIdx=1004&snsFeedIdx=13
    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionary];
    [dicM_Params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"comBraRIdx"] forKey:@"comBraRIdx"];
    [dicM_Params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userIdx"] forKey:@"userIdx"];
    [dicM_Params setObject:aIdx forKey:@"snsFeedIdx"];
    
    [[WebAPI sharedData] callSyncWebAPIBlock:@"sns/updateSnsViewCnt.do"
                                       param:dicM_Params
                                   withBlock:^(id resulte, NSError *error) {
                                       
                                       if( resulte )
                                       {
                                           
                                       }
                                   }];
}

+ (void)greenWikiViewCountUp:(NSString *)aIdx
{
    
}

+ (void)registePushToken
{
    NSString *str_PushToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"Token"];
    if( str_PushToken && str_PushToken.length > 0 )
    {
        NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            @"IOS", @"type",
                                            [[NSUserDefaults standardUserDefaults] objectForKey:@"Token"], @"token",
                                            nil];
        
        [[WebAPI sharedData] callAsyncWebAPIBlock:@"membership/member/push"
                                            param:dicM_Params
                                       withMethod:@"PUT"
                                        withBlock:^(id resulte, NSError *error) {
                                            
                                            if( resulte )
                                            {
                                                
                                            }
                                        }];
    }
}

+ (void)login:(NSString *)aId withPw:(NSString *)aPw
{
    NSString *str_DeviceName = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceId];
    if( str_DeviceName == nil || str_DeviceName.length <= 0 )
    {
        str_DeviceName = @"";
    }
    
    NSDictionary *dic_DeviceInfo = @{@"type":@"IOS", @"id":str_DeviceName, @"name":[[UIDevice currentDevice] name]};
    
    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        aId, @"userId",
                                        aPw, @"password",
                                        dic_DeviceInfo, @"device",
                                        nil];
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:@"auth/login"
                                        param:dicM_Params
                                   withMethod:@"POST"
                                    withBlock:^(id resulte, NSError *error) {
                                        
                                        if( resulte )
                                        {
                                            NSDictionary *dic_Data = [resulte objectForKey:@"data"];
                                            id dic_Meta = [resulte objectForKey:@"meta"];
                                            if( [dic_Meta isKindOfClass:[NSNull class]] )
                                            {
                                                dic_Meta = nil;
                                            }

                                            NSInteger nCode = [[dic_Meta objectForKey_YM:@"errCode"] integerValue];
                                            if( nCode == 0 )
                                            {
                                                BOOL isChangePassWord = [[dic_Data objectForKey:@"changePasswordRequest"] boolValue];
                                                if( isChangePassWord )
                                                {
                                                    //비밀번호 변경 웹뷰 호출
                                                    
                                                }
                                                
                                                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kIsAutoLogin];
                                                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kIsLogin];
                                                [[NSUserDefaults standardUserDefaults] setObject:[dic_Data objectForKey:@"token"] forKey:kAuthToken];
                                                [[NSUserDefaults standardUserDefaults] setObject:[dic_Data objectForKey_YM:@"deviceId"] forKey:kDeviceId];
                                                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [dic_Data objectForKey:@"id"]]
                                                                                          forKey:kMyIdx];
                                                [[NSUserDefaults standardUserDefaults] setObject:aId forKey:kUserId];
                                                [[NSUserDefaults standardUserDefaults] setObject:aPw forKey:kUserPw];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                
                                                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                                [appDelegate showOnlyMainView];
                                            }
                                            else if( nCode == 1200 )
                                            {
                                                //로그인 정보가 일치하지 않을때
                                                [ALToastView toastInView:[UIApplication sharedApplication].keyWindow withText:[dic_Meta objectForKey:@"errMsg"]];
                                            }
                                            else if( nCode == 1335 )
                                            {
                                                //사용 정지된 사용자
                                                [ALToastView toastInView:[UIApplication sharedApplication].keyWindow withText:[dic_Meta objectForKey:@"errMsg"]];
                                            }
                                        }
                                        else
                                        {

                                        }
                                    }];

}

+ (void)logOut:(BOOL)isKill
{
    [[WebAPI sharedData] callAsyncWebAPIBlock:@"auth/logout"
                                        param:nil
                                   withMethod:@"PUT"
                                    withBlock:^(id resulte, NSError *error) {
                                        
                                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAuthToken];
                                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserId];
                                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserPw];
                                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kIsLogin];
                                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDeviceId];
                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                        
                                        if( isKill )
                                        {
                                            exit(0);
                                        }
                                        else
                                        {
                                            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                            UINavigationController *loginNavi = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavi"];
                                            [Util setLoginNaviBar:loginNavi.navigationBar];
                                            [appDelegate.sideMenuViewController setMainViewController:loginNavi animated:YES closeMenu:YES];
                                        }
                                    }];
}


+ (NSArray *)getCategoryColors
{
    NSMutableArray *arM = [NSMutableArray array];
    [arM addObject:@"564e42"];
    [arM addObject:@"BE7C6B"];
    [arM addObject:@"acad43"];
    [arM addObject:@"90b5c6"];
    [arM addObject:@"c8ac83"];
    [arM addObject:@"a486ac"];
    [arM addObject:@"d996a7"];
    [arM addObject:@"f08e85"];
    [arM addObject:@"6ba2b0"];
    [arM addObject:@"898ec0"];
    [arM addObject:@"c97783"];
    
    return arM;
}

@end
