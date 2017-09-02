//
//  HomeComplimentCell.m
//  Switter
//
//  Created by macpro15 on 2017. 8. 2..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "HomeComplimentCell.h"

@implementation HomeComplimentCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 4.f;
    self.clipsToBounds = YES;
    
    [Util makeShadow:self];
}

@end
