//
//  SnsMainViewController.h
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 13..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnsMainViewController : YmBaseViewController
@property (nonatomic, assign) BOOL isBookMarkMode;
- (void)moveToDetail:(NSString *)aIdx;
- (void)refreshData;
@end
