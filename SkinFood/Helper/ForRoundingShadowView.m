//
//  ForRoundingShadowView.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 7..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "ForRoundingShadowView.h"

@implementation ForRoundingShadowView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    self.layer.cornerRadius = 4.f;

    [Util makeShadow:self];
    
//    [self layoutIfNeeded];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
