//
//  SearchBarCodeViewController.h
//  SkinFood
//
//  Created by KimYoung-Min on 2015. 1. 25..
//  Copyright (c) 2015년 woody.kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMScannerView.h"

@interface SearchBarCodeViewController : UIViewController <RMScannerViewDelegate, UIAlertViewDelegate, UIBarPositioningDelegate>
@property (nonatomic, strong) UINavigationController *mainNavi;
@end
