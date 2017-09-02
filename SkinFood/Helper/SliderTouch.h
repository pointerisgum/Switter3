//
//  SliderTouch.h
//  SMBA_EN
//
//  Created by KimYoung-Min on 2016. 5. 26..
//  Copyright © 2016년 youngmin.kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SliderTouchViewDelegate;

@interface SliderTouch : UISlider
@property (nonatomic, strong) id <SliderTouchViewDelegate> delegate;
@end

@protocol SliderTouchViewDelegate
- (void)touchBegan:(CGFloat)x;
- (void)touchMove:(CGFloat)x;
- (void)touchEnd:(CGFloat)x;
- (void)touchCancel:(CGFloat)x;
@end