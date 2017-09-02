//
//  HomeNotiCell.h
//  Switter
//
//  Created by macpro15 on 2017. 8. 2..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeNotiCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UILabel *lb_Date;
@property (nonatomic, weak) IBOutlet UILabel *lb_Title;
@property (nonatomic, weak) IBOutlet UIButton *btn_CommentCnt;
@property (nonatomic, weak) IBOutlet UIImageView *iv_Thumb;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_ImageWidth;
@end
