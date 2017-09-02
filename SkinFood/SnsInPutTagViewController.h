//
//  SnsInPutTagViewController.h
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 19..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompletionTagBlock)(id completeResult);

@interface SnsInPutTagViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *arM_SelectedTag;
@property (nonatomic, copy) CompletionTagBlock completionTagBlock;
- (void)setCompletionTagBlock:(CompletionTagBlock)completionTagBlock;
@end
