//
//  FootCafeWriteViewController.h
//  SkinFood
//
//  Created by macpro15 on 2017. 9. 1..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompletionAddBlock)(id completeResult);

@interface FootCafeWriteViewController : UIViewController
@property (nonatomic, assign) BOOL isModifyMode;
@property (nonatomic, strong) NSDictionary *dic_Info;
@property (nonatomic, strong) NSDictionary *dic_SelectCategory;
@property (nonatomic, copy) CompletionAddBlock completionAddBlock;

- (void)setCompletionAddBlock:(CompletionAddBlock)completionBlock;

@end
