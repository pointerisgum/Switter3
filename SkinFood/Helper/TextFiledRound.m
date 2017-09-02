//
//  TextFiledRound.m
//  JawsFood
//
//  Created by KimYoung-Min on 2016. 10. 3..
//  Copyright © 2016년 emcast. All rights reserved.
//

#import "TextFiledRound.h"

@implementation TextFiledRound

- (void)awakeFromNib
{
    self.layer.cornerRadius = 5.f;
    self.layer.borderColor = [UIColor colorWithRed:170.f/255.f green:170.f/255.f blue:170.f/255.f alpha:1].CGColor;
    self.layer.borderWidth = 1.f;
    
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, self.frame.size.height)];
    self.leftViewMode = UITextFieldViewModeAlways;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
