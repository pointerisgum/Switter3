//
//  StudyStoryCell.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 7..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "StudyStoryCell.h"

@implementation StudyStoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.v_Bg.layer.cornerRadius = 4.f;
    self.v_Bg.clipsToBounds = YES;

    self.iv_User.layer.cornerRadius = self.iv_User.frame.size.width / 2;
    self.iv_User.layer.borderWidth = 0.7f;
    self.iv_User.layer.borderColor = [UIColor colorWithRed:140.f/255.f green:140.f/255.f blue:140.f/255.f alpha:1.0f].CGColor;

    [Util makeShadow:self];
    [Util makeShadow:self.v_VideoThumb];
    [Util makeShadow:self.v_OneThumb];
    [Util makeShadow:self.v_TwoThumb1];
    [Util makeShadow:self.v_TwoThumb2];
    [Util makeShadow:self.v_ThreeThumb1];
    [Util makeShadow:self.v_ThreeThumb2];
    [Util makeShadow:self.v_ThreeThumb3];

    self.v_VideoThumb.clipsToBounds = YES;
    self.iv_OneThumb.clipsToBounds = YES;
    self.iv_TwoThumb1.clipsToBounds = YES;
    self.iv_TwoThumb2.clipsToBounds = YES;
    self.iv_ThreeThumb1.clipsToBounds = YES;
    self.iv_ThreeThumb2.clipsToBounds = YES;
    self.iv_ThreeThumb3.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
