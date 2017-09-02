//
//  HomeSnsCell.h
//  Switter
//
//  Created by macpro15 on 2017. 8. 2..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeSnsImageCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIView *v_Bg;
@property (nonatomic, weak) IBOutlet UIImageView *iv_Thumb;
@property (nonatomic, weak) IBOutlet UIImageView *iv_User;
@property (nonatomic, weak) IBOutlet UILabel *lb_SubTitle1;
@property (nonatomic, weak) IBOutlet UILabel *lb_SubTitle2;
@end
