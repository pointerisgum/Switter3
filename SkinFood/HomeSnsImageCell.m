//
//  HomeSnsCell.m
//  Switter
//
//  Created by macpro15 on 2017. 8. 2..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "HomeSnsImageCell.h"

@implementation HomeSnsImageCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.iv_Thumb.layer.cornerRadius = 4.f;
    self.iv_Thumb.clipsToBounds = YES;
    [Util makeShadow:self.v_Bg];

    self.iv_User.clipsToBounds = YES;
    self.iv_User.layer.cornerRadius = self.iv_User.frame.size.width / 2;
    self.iv_User.layer.borderWidth = 0.7f;
    self.iv_User.layer.borderColor = [UIColor colorWithRed:140.f/255.f green:140.f/255.f blue:140.f/255.f alpha:1.0f].CGColor;
    
}

@end
