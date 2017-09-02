//
//  LessonMainViewController.h
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 5..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessonMainViewController : YmBaseViewController
@property (nonatomic, assign) BOOL isMainJump;
@property (nonatomic, strong) NSDictionary *dic_NonPassSelectedCategory;
@property (nonatomic, strong) NSDictionary *dic_PassSelectedCategory;
@end
