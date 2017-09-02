//
//  HomeSnsTextCell.h
//  Switter
//
//  Created by macpro15 on 2017. 8. 2..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeSnsImageCell.h"

@interface HomeSnsTextCell : HomeSnsImageCell
@property (nonatomic, weak) IBOutlet UIView *v_TitleBg;
@property (nonatomic, weak) IBOutlet UILabel *lb_Title;
@end
