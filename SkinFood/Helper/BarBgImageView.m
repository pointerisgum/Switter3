//
//  BarBgImageView.m
//  SMBA_EN
//
//  Created by KimYoung-Min on 2016. 5. 22..
//  Copyright © 2016년 youngmin.kim. All rights reserved.
//

#import "BarBgImageView.h"

@implementation BarBgImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
//    NSLog(@"touch");
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
//    NSLog(@"%f", touchPoint.x);

    if( self.delegate )
    {
        [self.delegate touchBegan:touchPoint.x];
    }

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
//    NSLog(@"move");
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
//    NSLog(@"%f", touchPoint.x);

    if( self.delegate )
    {
        [self.delegate touchMove:touchPoint.x];
    }

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
//    NSLog(@"end");
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
//    NSLog(@"%f", touchPoint.x);
    
    if( self.delegate )
    {
        [self.delegate touchEnd:touchPoint.x];
    }

}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    NSLog(@"Cancel");
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    NSLog(@"%f", touchPoint.x);

    if( self.delegate )
    {
        [self.delegate touchCancel:touchPoint.x];
    }

}

@end
