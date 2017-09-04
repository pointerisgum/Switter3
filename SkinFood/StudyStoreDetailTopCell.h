//
//  StudyStoreDetailTopCell.h
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 8..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudyStoreDetailTopCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *iv_User;
@property (nonatomic, weak) IBOutlet UILabel *lb_StoreAndDate;
@property (nonatomic, weak) IBOutlet UILabel *lb_Name;
@property (nonatomic, weak) IBOutlet UILabel *lb_Position;
@property (nonatomic, weak) IBOutlet UILabel *lb_Contents;
@property (nonatomic, weak) IBOutlet UIView *v_ImageBg;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_TotalImageHeight;
@property (nonatomic, weak) IBOutlet UILabel *lb_Tag;
@property (nonatomic, weak) IBOutlet UIButton *btn_Category;
@property (nonatomic, weak) IBOutlet UIButton *btn_Comment;
@property (nonatomic, weak) IBOutlet UIButton *btn_Like;
@property (nonatomic, weak) IBOutlet UIButton *btn_Participate; //참여하기
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_ParticipateHeight;
@property (nonatomic, weak) IBOutlet UIButton *btn_Link;
@end
