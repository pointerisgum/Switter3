//
//  YmBaseViewController.m
//  PB
//
//  Created by KimYoung-Min on 2014. 12. 7..
//  Copyright (c) 2014년 KimYoung-Min. All rights reserved.
//

#import "YmBaseViewController.h"

@interface YmBaseViewController ()

@end

@implementation YmBaseViewController

//- (void)change:(UIView *)view
//{
//    for( id subView in view.subviews )
//    {
//        if( [subView isKindOfClass:[UILabel class]] )
//        {
//            UILabel *lb = (UILabel *)subView;
//            if( lb.text.length > 0 )
//            {
//                NSLog(@"localizing : %@", lb.text);
//                lb.text = [Common localizingString:lb.text];
//            }
//        }
//        else if( [subView isKindOfClass:[UIButton class]] )
//        {
//            UIButton *button = (UIButton *)subView;
//            NSString *str = [button titleForState:UIControlStateNormal];
//            if( str.length > 0 )
//            {
//                NSLog(@"localizing : %@", str);
//                [button setTitle:[Common localizingString:str] forState:UIControlStateNormal];
//            }
//            str = [button titleForState:UIControlStateHighlighted];
//            if( str.length > 0 )
//            {
//                NSLog(@"localizing : %@", str);
//                [button setTitle:[Common localizingString:str] forState:UIControlStateHighlighted];
//            }
//            str = [button titleForState:UIControlStateSelected];
//            if( str.length > 0 )
//            {
//                NSLog(@"localizing : %@", str);
//                [button setTitle:[Common localizingString:str] forState:UIControlStateSelected];
//            }
//        }
//        else if( [subView isKindOfClass:[UITextField class]] )
//        {
//            UITextField *tf = (UITextField *)subView;
//            if( tf.placeholder.length > 0 )
//            {
//                NSLog(@"localizing : %@", tf.placeholder);
//                tf.placeholder = [Common localizingString:tf.placeholder];
//            }
//        }
//        else if( [subView isKindOfClass:[UIView class]] || [subView isKindOfClass:[UIScrollView class]] )
//        {
//            [self change:subView];
//        }
//        
//    }
//}

//- (void)changeReverse:(UIView *)view
//{
//    for( id subView in view.subviews )
//    {
//        if( [subView isKindOfClass:[UILabel class]] )
//        {
//            UILabel *lb = (UILabel *)subView;
//            if( lb.text.length > 0 )
//            {
//                NSLog(@"localizing : %@", lb.text);
//                lb.text = [Common reverseLocalizingString:lb.text];
//            }
//        }
//        else if( [subView isKindOfClass:[UIButton class]] )
//        {
//            UIButton *button = (UIButton *)subView;
//            NSString *str = [button titleForState:UIControlStateNormal];
//            if( str.length > 0 )
//            {
//                NSLog(@"localizing : %@", str);
//                [button setTitle:[Common reverseLocalizingString:str] forState:UIControlStateNormal];
//            }
//            str = [button titleForState:UIControlStateHighlighted];
//            if( str.length > 0 )
//            {
//                NSLog(@"localizing : %@", str);
//                [button setTitle:[Common reverseLocalizingString:str] forState:UIControlStateHighlighted];
//            }
//            str = [button titleForState:UIControlStateSelected];
//            if( str.length > 0 )
//            {
//                NSLog(@"localizing : %@", str);
//                [button setTitle:[Common reverseLocalizingString:str] forState:UIControlStateSelected];
//            }
//        }
//        else if( [subView isKindOfClass:[UITextField class]] )
//        {
//            UITextField *tf = (UITextField *)subView;
//            if( tf.placeholder.length > 0 )
//            {
//                NSLog(@"localizing : %@", tf.placeholder);
//                tf.placeholder = [Common reverseLocalizingString:tf.placeholder];
//            }
//        }
//        else if( [subView isKindOfClass:[UIView class]] || [subView isKindOfClass:[UIScrollView class]] )
//        {
//            [self change:subView];
//        }
//
//    }
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self change:self.view];
    
    self.sv_Main.contentSize = CGSizeMake(self.sv_Main.frame.size.width, [self getLastObjectHeight:self.sv_Main] + 20);
    //    self.sv_Main.contentSize = CGSizeMake(self.sv_Main.frame.size.width, [self getLastObjectHeight:self.sv_Main]);
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarTappedAction:)
                                                 name:kStatusBarTappedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAnimate:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAnimate:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [GMDCircleLoader hide];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kStatusBarTappedNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)statusBarTappedAction:(NSNotification*)notification
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         [self.sv_Main setContentOffset:CGPointZero animated:NO];
                     }];
}

- (void)addTabGesture
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.sv_Main addGestureRecognizer:singleTap];
}

- (void)addViewTabGesture
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:singleTap];
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
            self.sv_Main.contentSize = CGSizeMake(self.sv_Main.frame.size.width, [self getLastObjectHeight:self.sv_Main] + keyboardBounds.size.height + 20);
        }
        else if([notification name] == UIKeyboardWillHideNotification)
        {
            self.sv_Main.contentSize = CGSizeMake(self.sv_Main.frame.size.width, [self getLastObjectHeight:self.sv_Main] + 20);
        }
    }completion:^(BOOL finished) {
        
    }];
}

- (CGFloat)getLastObjectHeight:(UIView *)view
{
    CGFloat fLastHeight = 0.0f;
    for( id obj in view.subviews )
    {
        if( [obj isKindOfClass:[UIImageView class]] )
        {
            continue;
        }
        
        UIView *subView = (UIView *)obj;
        
        CGRect frame = subView.frame;
        if( fLastHeight < frame.origin.y + frame.size.height )
        {
            fLastHeight = frame.origin.y + frame.size.height;
        }
    }
    
    return fLastHeight;
}


#pragma mark - UIGesture
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    [self.sv_Main endEditing:YES];
}

- (void)viewTap:(UIGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}



@end
