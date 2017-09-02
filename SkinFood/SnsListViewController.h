//
//  SnsListViewController.h
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 13..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODRefreshControl.h"

typedef void (^CompletionMoreBlock)(id completeResult);
typedef void (^CompletionRefreshBlock)(id completeResult);

@interface SnsListViewController : YmBaseViewController

@property (nonatomic, assign) BOOL isBookMarkMode;
@property (nonatomic, strong) NSMutableArray *arM_List;
@property (nonatomic, strong) ODRefreshControl *refreshControl;
@property (nonatomic, weak) IBOutlet UITableView *tbv_List;
@property (nonatomic, copy) CompletionMoreBlock completionMoreBlock;
@property (nonatomic, copy) CompletionRefreshBlock completionRefreshBlock;

- (void)moveToDetail:(NSString *)aIdx;
- (void)setCompletionMoreBlock:(CompletionMoreBlock)completionBlock;
- (void)setCompletionRefreshBlock:(CompletionRefreshBlock)completionBlock;

@end
