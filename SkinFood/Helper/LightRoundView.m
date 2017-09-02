//
//  LightRoundView.m
//  JawsFood
//
//  Created by KimYoung-Min on 2016. 11. 3..
//  Copyright © 2016년 emcast. All rights reserved.
//

#import "LightRoundView.h"

@implementation LightRoundView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //    NSLayoutConstraint *c = self.constraints[0];
    //    self.layer.cornerRadius = c.constant / 2;
    
    [self layoutIfNeeded];
    
    self.layer.cornerRadius = 4.f;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor colorWithRed:220.f/255.f green:220.f/255.f blue:220.f/255.f alpha:1].CGColor;
    self.layer.borderWidth = 1.f;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
