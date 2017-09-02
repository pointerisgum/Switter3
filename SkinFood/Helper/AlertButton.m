//
//  AlertButton.m
//  JawsFood
//
//  Created by KimYoung-Min on 2016. 10. 3..
//  Copyright © 2016년 emcast. All rights reserved.
//

#import "AlertButton.h"

@implementation AlertButton

- (void)awakeFromNib
{
    self.layer.cornerRadius = 5.f;
    self.layer.borderColor = [UIColor colorWithHexString:@"8B8B8B"].CGColor;
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
