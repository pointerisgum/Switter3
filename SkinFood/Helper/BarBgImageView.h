//
//  BarBgImageView.h
//  SMBA_EN
//
//  Created by KimYoung-Min on 2016. 5. 22..
//  Copyright © 2016년 youngmin.kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BarBgImageViewDelegate;

@interface BarBgImageView : UIImageView
@property (nonatomic, strong) id <BarBgImageViewDelegate> delegate;
@end

@protocol BarBgImageViewDelegate
- (void)touchBegan:(CGFloat)x;
- (void)touchMove:(CGFloat)x;
- (void)touchEnd:(CGFloat)x;
- (void)touchCancel:(CGFloat)x;
@end
