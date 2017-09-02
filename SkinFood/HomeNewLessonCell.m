//
//  HomeNewLessonCell.m
//  Switter
//
//  Created by macpro15 on 2017. 8. 2..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "HomeNewLessonCell.h"

@implementation HomeNewLessonCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.layer.cornerRadius = 4.f;
    self.clipsToBounds = YES;
    
    [Util makeShadow:self];
}

- (void)updateConstraints
{
    // add your constraints if not already there
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:self.v_TagBg.bounds
                              byRoundingCorners:(UIRectCornerBottomRight)
                              cornerRadii:CGSizeMake(4, 4)
                              ];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.v_TagBg.layer.mask = maskLayer;

    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
}

@end
