//
//  SnsCategoryViewController.h
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 17..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompletionCategoryBlock)(id completeResult);

@interface SnsCategoryViewController : UIViewController
@property (nonatomic, assign) BOOL isFoodCafeMode;
@property (nonatomic, assign) BOOL isFoodCafeHeaderMode;
@property (nonatomic, strong) NSString *str_Title;
@property (nonatomic, strong) NSDictionary *dic_CateInfo;   //수정할때 사용
@property (nonatomic, strong) NSDictionary *dic_Header;
@property (nonatomic, copy) CompletionCategoryBlock completionCategoryBlock;
- (void)setCompletionCategoryBlock:(CompletionCategoryBlock)completionCategoryBlock;
@end
