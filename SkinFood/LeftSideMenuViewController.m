//
//  LeftSideMenuViewController.m
//  SMBA_EN
//
//  Created by KimYoung-Min on 2016. 5. 5..
//  Copyright © 2016년 youngmin.kim. All rights reserved.
//

#import "LeftSideMenuViewController.h"
#import "TotalWebViewController.h"
//#import "TotalWeb2ViewController.h"
#import "MFSideMenuContainerViewController.h"

@interface LeftSideMenuViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *iv_User;
//@property (nonatomic, weak) IBOutlet UILabel *lb_Home;
//@property (nonatomic, weak) IBOutlet UILabel *lb_Information;
//@property (nonatomic, weak) IBOutlet UILabel *lb_Course;
//@property (nonatomic, weak) IBOutlet UILabel *lb_Notice;
//@property (nonatomic, weak) IBOutlet UILabel *lb_Setting;
//@property (nonatomic, weak) IBOutlet UILabel *lb_Logout;
@property (nonatomic, weak) IBOutlet UILabel *lb_UserName;
@end

@implementation LeftSideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.iv_User.layer.masksToBounds = YES;
    self.iv_User.layer.cornerRadius = self.iv_User.frame.size.width/2;
    self.iv_User.contentMode = UIViewContentModeScaleAspectFill;
//    self.iv_User.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.iv_User.layer.borderWidth = 2.0f;
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

- (void)sideMenuWillOpen
{
    self.screenName = @"SideMenu";
    
}



#pragma mark - IBAction
- (IBAction)goSideMenuClose:(id)sender
{
    [self.sideMenuViewController closeMenuAnimated:YES completion:^(BOOL finished) {
        
    }];
}

- (IBAction)goLogout:(id)sender
{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    MsgPopUpViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MsgPopUpViewController"];
//    vc.type = kTwoButton;
//    vc.str_Msg = [Common localizingString:@"Do you want to logout?"];
//    [vc setCompletionBlock:^ {
//        
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LanguageDic"];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserId"];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserPw"];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserIdx"];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserAuth"];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"BrandIdx"];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserName"];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ImgUrl"];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IsLogin"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        exit(0);
//
////        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
////        [appDelegate showLoginView];
//        
//    }];
//    [self presentViewController:vc animated:YES completion:nil];
}

@end
