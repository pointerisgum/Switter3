//
//  MyPageCell.h
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 30..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPageCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *iv_TopLine;
@property (nonatomic, weak) IBOutlet UIImageView *iv_BottomLine;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_TopLineLeft;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_BottomLineLeft;
@property (nonatomic, weak) IBOutlet UILabel *lb_Title;
@property (nonatomic, weak) IBOutlet UILabel *lb_SubTitle;
@property (nonatomic, weak) IBOutlet UISwitch *sw;
@end
