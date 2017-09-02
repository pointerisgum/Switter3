//
//  VideoPlayViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 24..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "VideoPlayViewController.h"
@import AVFoundation;
#import <UIKit/UIKit.h>
@import AVKit;

@interface VideoPlayViewController ()
@property (nonatomic, strong) AVPlayer * player;
@end

@implementation VideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.player = [AVPlayer playerWithURL:[NSURL URLWithString:self.str_Url]];
    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
    
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    
    controller.view.frame = self.view.frame;
    controller.player = self.player;
    controller.showsPlaybackControls = YES;
    self.player.closedCaptionDisplayEnabled = NO;
    [self.player pause];
    [self.player play];
    

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

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationLandscapeLeft];
//    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    //    return UIInterfaceOrientationMaskLandscapeLeft;
    return UIInterfaceOrientationMaskAll;
}

@end
