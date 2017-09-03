//
//  FoodCafeMainViewController.h
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 31..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodCafeMainViewController : YmBaseViewController
@property (nonatomic, strong) NSString *str_Id;
- (void)moveToCategory:(NSString *)aMoveTitle;
@end
