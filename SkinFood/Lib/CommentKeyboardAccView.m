//
//  CommentKeyboardAccView.m
//  ThoThing
//
//  Created by KimYoung-Min on 2016. 8. 4..
//  Copyright © 2016년 youngmin.kim. All rights reserved.
//

#import "CommentKeyboardAccView.h"

@implementation CommentKeyboardAccView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.tv_Contents.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)layoutSubviews
{
    //    [self.lb_PlaceHolder layoutSubviews];
    //    [self.lb_PlaceHolder setNeedsLayout];
    //    [self.lb_PlaceHolder setNeedsUpdateConstraints];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self performSelector:@selector(onChangeInterval) withObject:nil afterDelay:0.1f];
    NSUInteger length = [[textView text] length] - range.length + text.length;
    if( length <= 0 )
    {
        self.lb_PlaceHolder.hidden = NO;
        self.btn_Done.selected = NO;
    }
    else
    {
        self.lb_PlaceHolder.hidden = YES;
        self.btn_Done.selected = YES;
    }
    
    
    return YES;
}

- (void)onChangeInterval
{
    CGFloat fHeight = [Util getTextViewHeight:self.tv_Contents];
    if( fHeight <= 45.f )
    {
        self.lc_TfWidth.constant = 45.f;
    }
    else if( fHeight > 100 )
    {
        self.lc_TfWidth.constant = 100.f;
    }
    else
    {
        self.lc_TfWidth.constant = fHeight;
    }
    
    [self.tv_Contents setNeedsLayout];
    [self.tv_Contents setNeedsUpdateConstraints];
    [self.tv_Contents updateConstraints];
    
    [self setNeedsLayout];
    [self setNeedsUpdateConstraints];
    [self updateConstraints];
    
    [self setNeedsLayout];
}

- (void)removeContents
{
    self.tv_Contents.text = @"";
    [self onChangeInterval];
}

@end
