//
//  HomeSnsTextCell.m
//  Switter
//
//  Created by macpro15 on 2017. 8. 2..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "HomeSnsTextCell.h"

@implementation HomeSnsTextCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.v_TitleBg.layer.cornerRadius = 4.f;
    self.v_TitleBg.clipsToBounds = YES;
    
    [Util makeShadow:self.v_TitleBg];
}

@end
