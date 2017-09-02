//
//  SnsWriteViewController.h
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 17..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompletionAddBlock)(id completeResult);

@interface SnsWriteViewController : UIViewController

@property (nonatomic, assign) BOOL isModifyMode;
@property (nonatomic, strong) NSDictionary *dic_Info;
@property (nonatomic, copy) CompletionAddBlock completionAddBlock;

- (void)setCompletionAddBlock:(CompletionAddBlock)completionBlock;

@end
