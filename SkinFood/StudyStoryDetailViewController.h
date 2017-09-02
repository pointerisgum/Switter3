//
//  StudyStoryDetailViewController.h
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 8..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompletionUpdateBlock)(id completeResult);
typedef void (^CompletionDeleteBlock)(id completeResult);

@interface StudyStoryDetailViewController : YmBaseViewController
@property (nonatomic, assign) BOOL isComunnytiMode;
@property (nonatomic, assign) BOOL isSnsMode;
@property (nonatomic, assign) BOOL isFoodMode;
@property (nonatomic, assign) BOOL isUnAbleWrite;
@property (nonatomic, strong) NSString *str_Id;
@property (nonatomic, strong) NSString *str_Title;  //필수는 아님 푸드카페에서 쓰임
@property (nonatomic, strong) NSString *str_FoodIdenti; //NOTICE 등등 푸드카페에서 쓰임
@property (nonatomic, copy) CompletionUpdateBlock completionUpdateBlock;
@property (nonatomic, copy) CompletionDeleteBlock completionDeleteBlock;
- (void)setCompletionUpdateBlock:(CompletionUpdateBlock)completionBlock;
- (void)setCompletionDeleteBlock:(CompletionDeleteBlock)completionBlock;
@end
