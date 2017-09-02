//
//  HomeNewLessonCell.h
//  Switter
//
//  Created by macpro15 on 2017. 8. 2..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeNewLessonCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIView *v_TagBg;
@property (nonatomic, weak) IBOutlet UILabel *lb_Tag;
@property (nonatomic, weak) IBOutlet UILabel *lb_Title;
@property (nonatomic, weak) IBOutlet UILabel *lb_Date;
@property (nonatomic, weak) IBOutlet UIImageView *iv_Thumb;
@end
