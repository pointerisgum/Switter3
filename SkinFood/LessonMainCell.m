//
//  LessonMainCell.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 5..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "LessonMainCell.h"

@implementation LessonMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.v_BottomBg.layer.cornerRadius = 4.f;
    self.v_TagBg.layer.cornerRadius = 4.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
