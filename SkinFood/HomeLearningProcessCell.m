//
//  HomeLearningProcessCell.m
//  Switter
//
//  Created by macpro15 on 2017. 8. 2..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "HomeLearningProcessCell.h"

@implementation HomeLearningProcessCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.btn_Item.layer.cornerRadius = 4.f;
    self.btn_Item.clipsToBounds = YES;
    
    [Util makeShadow:self];
}

@end
