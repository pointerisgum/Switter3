//
//  LessonContainerViewController.h
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 6..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompletionMoreBlock)(id completeResult);

@interface LessonContainerViewController : YmBaseViewController
@property (nonatomic, strong) NSMutableArray *arM_List;
@property (nonatomic, weak) IBOutlet UITableView *tbv_List;
@property (nonatomic, copy) CompletionMoreBlock completionMoreBlock;

- (void)setCompletionMoreBlock:(CompletionMoreBlock)completionBlock;

@end
