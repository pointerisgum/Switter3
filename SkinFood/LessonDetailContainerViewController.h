//
//  LessonDetailContainerViewController.h
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 6..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessonDetailContainerViewController : UIViewController
//@property (nonatomic, strong) NSDictionary *dic_Info;
- (void)addViewWithIdx:(NSInteger)nIdx;
- (void)updateData:(NSDictionary *)dic;
@end
