//
//  HomeNotiCell.m
//  Switter
//
//  Created by macpro15 on 2017. 8. 2..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "HomeNotiCell.h"

@implementation HomeNotiCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 4.f;
    self.clipsToBounds = YES;
    
    self.iv_Thumb.layer.cornerRadius = 4.f;
    
    [Util makeShadow:self];
}

@end
