//
//  AllRoundView.m
//  ASKing
//
//  Created by Kim Young-Min on 2013. 11. 28..
//  Copyright (c) 2013년 Kim Young-Min. All rights reserved.
//

#import "ForRoundView.h"

@implementation ForRoundView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self layoutIfNeeded];
    
    self.layer.cornerRadius = 4.f;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
