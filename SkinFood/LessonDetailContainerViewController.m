//
//  LessonDetailContainerViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 6..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "LessonDetailContainerViewController.h"
#import "LessonDetailListViewController.h"
#import "LessonDetailMoreViewController.h"

#define Segue1 @"Segue1"
#define Segue2 @"Segue2"

@interface LessonDetailContainerViewController ()
@property (nonatomic, strong) NSString *str_SegIdent;
@property (nonatomic, strong) LessonDetailListViewController *vc_LessonDetailListViewController;
@property (nonatomic, strong) LessonDetailMoreViewController *vc_LessonDetailMoreViewController;
@end

@implementation LessonDetailContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.str_SegIdent = Segue1;
    [self performSegueWithIdentifier:self.str_SegIdent sender:nil];
}

- (void)viewDidLayoutSubviews
{
    NSLog(@"container frame : %@", NSStringFromCGRect(self.view.frame));
    //    LessonDetailContainerViewController *vc = (SearchContainerViewController *)self.parentViewController;
    //    self.view.frame = CGRectMake(0, 0, vc.view.frame.size.width, vc.view.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [segue.identifier isEqualToString:Segue1] )
    {
        self.vc_LessonDetailListViewController = segue.destinationViewController;
    }
    else if( [segue.identifier isEqualToString:Segue2] )
    {
        self.vc_LessonDetailMoreViewController = segue.destinationViewController;
    }
    
    segue.destinationViewController.view.frame = self.view.frame;
    
    [self addChildViewController:segue.destinationViewController];
    [self.view addSubview:((UIViewController *)segue.destinationViewController).view];
    [segue.destinationViewController didMoveToParentViewController:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)updateData:(NSDictionary *)dic
{
    if( [self.str_SegIdent isEqualToString:Segue1] )
    {
        [self.vc_LessonDetailListViewController updateView:dic];
    }
    else if( [self.str_SegIdent isEqualToString:Segue2] )
    {
        [self.vc_LessonDetailMoreViewController updateView:dic];
    }
}

- (void)addViewWithIdx:(NSInteger)nIdx
{
    if( self.childViewControllers.count > 0 )
    {
        UIViewController *vc = [self.childViewControllers lastObject];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    
    switch (nIdx)
    {
        case 0:
            self.str_SegIdent = Segue1;
            break;
            
        case 1:
            self.str_SegIdent = Segue2;
            break;
            
        default:
            break;
    }
    
    [self performSegueWithIdentifier:self.str_SegIdent sender:nil];
}

@end
