//
//  SeachMainViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 5..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "SeachMainViewController.h"
#import "SearchBarCodeViewController.h"
#import "SearchKeyboardAccView.h"
#import "LessonSearchResultViewController.h"

@interface SeachMainViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *tf_Barcode;
@property (nonatomic, weak) IBOutlet UITextField *tf_Lesson;
@end

@implementation SeachMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"SearchKeyboardAccView" owner:self options:nil];
    SearchKeyboardAccView *v_Acc = [topLevelObjects objectAtIndex:0];
    [v_Acc.btn_Button setTitle:@"검색" forState:UIControlStateNormal];
    [v_Acc.btn_Button addTarget:self action:@selector(goSearch:) forControlEvents:UIControlEventTouchUpInside];
    self.tf_Lesson.inputAccessoryView = v_Acc;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if( textField == self.tf_Barcode )
    {
        [self goBarcode:nil];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if( textField == self.tf_Lesson )
    {
        if( textField.text.length > 0 )
        {
            [self goSearch:nil];
        }
    }
    
    return YES;
}


- (IBAction)goBarcode:(id)sender
{
    SearchBarCodeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchBarCodeViewController"];
    vc.mainNavi = self.navigationController;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    navi.navigationBarHidden = YES;
    [self presentViewController:navi animated:YES completion:^{
        
    }];
}

- (IBAction)goSearch:(id)sender
{
    if( self.tf_Lesson.text.length > 0 )
    {
        LessonSearchResultViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LessonSearchResultViewController"];
        vc.str_SearchWord = self.tf_Lesson.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
