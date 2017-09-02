//
//  HarfPixelImageView.m
//  JawsFood
//
//  Created by KimYoung-Min on 2016. 10. 6..
//  Copyright © 2016년 emcast. All rights reserved.
//

#import "HarfPixelImageView.h"

@implementation HarfPixelImageView

- (void)awakeFromNib
{
    CGRect frame = self.frame;
    frame.size.height = 0.5f;
    self.frame = frame;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
