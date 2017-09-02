//
//  LessonMainCell.h
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 5..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessonMainCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *iv_Thumb;
@property (nonatomic, weak) IBOutlet UILabel *lb_Title;
@property (nonatomic, weak) IBOutlet UIView *v_BottomBg;
@property (nonatomic, weak) IBOutlet UILabel *lb_ReqDate;       //수강신청가능기간
@property (nonatomic, weak) IBOutlet UILabel *lb_StudyDate;     //학습기간
@property (nonatomic, weak) IBOutlet UIView *v_TagBg;
@property (nonatomic, weak) IBOutlet UILabel *lb_Tag;
@end
