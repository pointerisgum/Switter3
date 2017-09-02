//
//  StudyStoreDetailTopCell.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 8..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "StudyStoreDetailTopCell.h"

@implementation StudyStoreDetailTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iv_User.layer.cornerRadius = self.iv_User.frame.size.width / 2;
    self.iv_User.layer.borderWidth = 0.7f;
    self.iv_User.layer.borderColor = [UIColor colorWithRed:140.f/255.f green:140.f/255.f blue:140.f/255.f alpha:1.0f].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    self.contentView.frame = self.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    
    self.lb_Contents.preferredMaxLayoutWidth = CGRectGetWidth(self.lb_Contents.frame);
}

@end
