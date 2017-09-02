//
//  LoginViewController.m
//  Switter
//
//  Created by macpro15 on 2017. 8. 1..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "LoginViewController.h"
#import "TotalWebViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *tf_Id;
@property (nonatomic, weak) IBOutlet UITextField *tf_Pw;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_ContentsHieght;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.screenName = @"로그인";
    
//    self.tf_Id.text = @"skw815@emcast.com";
//    self.tf_Pw.text = @"skw815@emcast.com";
    self.tf_Id.text = @"ios";
    self.tf_Pw.text = @"password1";
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
//    self.lc_ContentsHieght.constant
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if( textField == self.tf_Id )
    {
        [self.tf_Pw becomeFirstResponder];
    }
    else if( textField == self.tf_Pw )
    {
        [self goLogin:nil];
    }
    
    return YES;
}



#pragma mark - Notification
- (void)keyboardWillAnimate:(NSNotification *)notification
{
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        [UIView setAnimationCurve:[curve intValue]];
        if([notification name] == UIKeyboardWillShowNotification)
        {
            self.sv_Main.contentOffset = CGPointMake(0, keyboardBounds.size.height - 100.f);
            self.sv_Main.contentSize = CGSizeMake(self.sv_Main.frame.size.width, self.sv_Main.frame.size.height + (keyboardBounds.size.height - 100.f));
        }
        else if([notification name] == UIKeyboardWillHideNotification)
        {
            self.sv_Main.contentOffset = CGPointZero;
            self.sv_Main.contentSize = CGSizeMake(self.sv_Main.frame.size.width, self.sv_Main.frame.size.height);
        }
    }completion:^(BOOL finished) {
        
    }];
}


- (IBAction)goLogin:(id)sender
{
//    [self showMainView];
//    return;
    if( self.tf_Id.text.length <= 0 )
    {
        [UIAlertController showAlertInViewController:self
                                           withTitle:@""
                                             message:@"아이디를 입력해 주세요"
                                   cancelButtonTitle:nil
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
                                                    NSLog(@"Other Button Index %ld", (long)buttonIndex - controller.firstOtherButtonIndex);
                                                }
                                            }];

        return;
    }
    
    if( self.tf_Pw.text.length <= 0 )
    {
        [UIAlertController showAlertInViewController:self
                                           withTitle:@""
                                             message:@"비밀번호를 입력해 주세요"
                                   cancelButtonTitle:@"확인"
                              destructiveButtonTitle:@""
                                   otherButtonTitles:nil
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
                                                    NSLog(@"Other Button Index %ld", (long)buttonIndex - controller.firstOtherButtonIndex);
                                                }
                                            }];
        
        return;
    }
    
//    if( [Util isUsableEmail:self.tf_Id.text] == NO || self.tf_Id.text.length <= 4 )
//    {
//        [UIAlertController showAlertInViewController:self
//                                           withTitle:@""
//                                             message:@"아이디는 이메일 형식 입니다"
//                                   cancelButtonTitle:nil
//                              destructiveButtonTitle:nil
//                                   otherButtonTitles:@[@"확인"]
//                                            tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex){
//                                                
//                                                if (buttonIndex == controller.cancelButtonIndex)
//                                                {
//                                                    NSLog(@"Cancel Tapped");
//                                                }
//                                                else if (buttonIndex == controller.destructiveButtonIndex)
//                                                {
//                                                    NSLog(@"Delete Tapped");
//                                                }
//                                                else if (buttonIndex >= controller.firstOtherButtonIndex)
//                                                {
//                                                    NSLog(@"Other Button Index %ld", (long)buttonIndex - controller.firstOtherButtonIndex);
//                                                }
//                                            }];
//        
//        return;
//    }
    
    [self.view endEditing:YES];
    
    [self login];
    
//    [self showMainView];
}

- (void)login
{
    [Common login:self.tf_Id.text withPw:self.tf_Pw.text];
}


- (IBAction)goTap:(id)sender
{
    NSLog(@"@@@@@@@@@@@@");
}

- (IBAction)goJoin:(id)sender
{
    NSString *str_Url = [NSString stringWithFormat:@"%@/%@", kBaseWebUrl, @"join.html"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str_Url]];
}

- (IBAction)goFindIdAndPw:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TotalWebViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TotalWebViewController"];
    vc.str_Url = @"find.html";
    vc.str_Title = @"아이디 / 비밀번호 찾기";
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

@end
