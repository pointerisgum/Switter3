//
//  UpdateViewController.m
//  JawsFood
//
//  Created by KimYoung-Min on 2016. 12. 24..
//  Copyright © 2016년 emcast. All rights reserved.
//

#import "UpdateViewController.h"

@interface UpdateViewController ()
@property (nonatomic, weak) IBOutlet UIButton *btn_Update;
@end

@implementation UpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btn_Update.layer.cornerRadius = 4.f;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
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


- (IBAction)goUpdate:(id)sender
{
    NSURL *appStoreURL = [NSURL URLWithString:kAppStoreURL];
    [[UIApplication sharedApplication] openURL:appStoreURL];
    
    exit(0);
}

@end
