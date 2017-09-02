//
//  MyPageViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 30..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "MyPageViewController.h"
#import "MyPageCell.h"
#import "MyPageHeaderCell.h"
#import "TotalWebViewController.h"

@interface MyPageViewController ()
@property (nonatomic, strong) NSMutableArray *arM_TitleList;
@property (nonatomic, strong) NSMutableDictionary *dicM_List;
@property (nonatomic, weak) IBOutlet UITableView *tbv_List;
@end

@implementation MyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dicM_List = [NSMutableDictionary dictionary];
    self.arM_TitleList = [NSMutableArray array];
    [self.arM_TitleList addObject:@"학습달력"];
    [self.arM_TitleList addObject:@"계정"];
    [self.arM_TitleList addObject:@"설정"];
    [self.arM_TitleList addObject:@"알림"];
    
    NSArray *ar = [NSArray arrayWithObjects:@"학습 달력 보기", @"출석부", nil];
    [self.dicM_List setObject:ar forKey:@"학습달력"];
    
    ar = [NSArray arrayWithObjects:@"나의 정보 변경", @"비밀번호 변경", @"포인트 정보", @"1대1 문의하기", @"이용약관", @"기기 권한 관리", nil];
    [self.dicM_List setObject:ar forKey:@"계정"];
    
    ar = [NSArray arrayWithObjects:@"버전", nil];
    [self.dicM_List setObject:ar forKey:@"설정"];
    
    ar = [NSArray arrayWithObjects:@"푸시알림", @"로그아웃", nil];
    [self.dicM_List setObject:ar forKey:@"알림"];

    self.tbv_List.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 8.f)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arM_TitleList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *str_Key = self.arM_TitleList[section];
    NSArray *ar = [self.dicM_List objectForKey:str_Key];
    
    return ar.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyPageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyPageCell class])];
    
    NSString *str_Key = self.arM_TitleList[indexPath.section];
    NSArray *ar = [self.dicM_List objectForKey:str_Key];
    NSString *str_Title = ar[indexPath.row];
    
    cell.lb_Title.text = str_Title;
    cell.sw.hidden = YES;
    
    cell.lc_TopLineLeft.constant = 0.f;
    
    if( indexPath.row == ar.count - 1 )
    {
        //마지막 인덱스일 경우
        cell.iv_BottomLine.hidden = NO;
    }
    else
    {
        cell.iv_BottomLine.hidden = YES;
    }
    
    if( indexPath.row != 0 )
    {
        cell.lc_TopLineLeft.constant = 15.f;
    }
    
    if( indexPath.section == 2 )
    {
        //설정
        if( [str_Title isEqualToString:@"버전"] )
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            CGFloat fStoreVer = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppStoreVersion"] floatValue];
            CGFloat currentVersion = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] floatValue];
            
            if( currentVersion >= fStoreVer )
            {
                cell.lb_SubTitle.text = @"최신 버전 입니다";
            }
            else
            {
                cell.lb_SubTitle.text = @"업데이트가 필요합니다";
            }
            
            cell.lb_Title.text = [NSString stringWithFormat:@"버전 (%@)", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        }
    }
    else if( indexPath.section == 3 )
    {
        //푸시
        if( [str_Title isEqualToString:@"푸시알림"] )
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            cell.lb_Title.text = @"푸시알림";
            cell.sw.hidden = NO;
            [cell.sw addTarget:self action:@selector(onPushToggle:) forControlEvents:UIControlEventValueChanged];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *str_Key = self.arM_TitleList[indexPath.section];
    NSArray *ar = [self.dicM_List objectForKey:str_Key];
    NSString *str_Title = ar[indexPath.row];
    
    if( [str_Title isEqualToString:@"학습 달력 보기"] )
    {
        TotalWebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TotalWebViewController"];
        vc.str_Title = str_Title;
        vc.webViewType = kClanender;
        vc.str_Url = @"calendar.html";
        [self presentViewController:vc
                           animated:YES
                         completion:^{
                             
                         }];
    }
    else if( [str_Title isEqualToString:@"출석부"] )
    {
        TotalWebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TotalWebViewController"];
        vc.str_Title = str_Title;
        vc.webViewType = kAttendance;
        vc.str_Url = @"";
        [self presentViewController:vc
                           animated:YES
                         completion:^{
                             
                         }];
    }
    else if( [str_Title isEqualToString:@"나의 정보 변경"] )
    {
        TotalWebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TotalWebViewController"];
        vc.str_Title = str_Title;
        vc.webViewType = kMyInfo;
        vc.str_Url = @"info.html";
        [self presentViewController:vc
                           animated:YES
                         completion:^{
                             
                         }];
    }
    else if( [str_Title isEqualToString:@"비밀번호 변경"] )
    {
        TotalWebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TotalWebViewController"];
        vc.str_Title = str_Title;
        vc.webViewType = kPwChange;
        vc.str_Url = @"password.html";
        [self presentViewController:vc
                           animated:YES
                         completion:^{
                             
                         }];
    }
    else if( [str_Title isEqualToString:@"포인트 정보"] )
    {
        TotalWebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TotalWebViewController"];
        vc.str_Title = str_Title;
        vc.webViewType = kPoin;
        vc.str_Url = @"point.html";
        [self presentViewController:vc
                           animated:YES
                         completion:^{
                             
                         }];
    }
    else if( [str_Title isEqualToString:@"1대1 문의하기"] )
    {
        TotalWebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TotalWebViewController"];
        vc.str_Title = str_Title;
        vc.webViewType = kOneOnOne;
        vc.str_Url = @"qna.html";
        [self presentViewController:vc
                           animated:YES
                         completion:^{
                             
                         }];
    }
    else if( [str_Title isEqualToString:@"이용약관"] )
    {
        ALERT_NOT_AT;
    }
    else if( [str_Title isEqualToString:@"기기 권한 관리"] )
    {
        ALERT_NOT_AT;
    }
//    else if( [str_Title isEqualToString:@"버전"] )
//    {
//        
//    }
//    else if( [str_Title isEqualToString:@"푸시알림"] )
//    {
//        
//    }
    else if( [str_Title isEqualToString:@"로그아웃"] )
    {
        [UIAlertController showAlertInViewController:self
                                           withTitle:@""
                                             message:@"로그아웃 하시겠습니까?"
                                   cancelButtonTitle:@"취소"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@[@"확인"]
                                            tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex){
                                                
                                                if (buttonIndex == controller.cancelButtonIndex)
                                                {
                                                    NSLog(@"Cancel Tapped");
                                                }
                                                else if (buttonIndex == controller.destructiveButtonIndex)
                                                {
                                                    NSLog(@"Delete Tapped");
                                                }
                                                else if (buttonIndex >= controller.firstOtherButtonIndex)
                                                {
                                                    [Common logOut:NO];
                                                }
                                            }];
    }

}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MyPageHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyPageHeaderCell class])];
    
    NSString *str_Key = self.arM_TitleList[section];

    cell.lb_Title.text = str_Key;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.f;
}


#pragma mark - IBAtion
- (void)onPushToggle:(UISwitch *)sw
{
    if( sw.on == NO )
    {
        ALERT_NOT_AT;
        
        sw.on = YES;
    }
}

@end
