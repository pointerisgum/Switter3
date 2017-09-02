//
//  InputProductViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 5..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "InputProductViewController.h"
#import "LessonContainerViewController.h"
#import "SearchKeyboardAccView.h"

@interface InputProductViewController ()
{
    BOOL isLoading;
    NSInteger nPage;
    NSInteger nTotalCount;
}
@property (nonatomic, strong) NSMutableArray *arM_List;
@property (nonatomic, weak) LessonContainerViewController *container;
@property (nonatomic, weak) IBOutlet UITextField *tf_Search;
@end

@implementation InputProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"SearchKeyboardAccView" owner:self options:nil];
    SearchKeyboardAccView *v_Acc = [topLevelObjects objectAtIndex:0];
    [v_Acc.btn_Button setTitle:@"제품명 검색하기" forState:UIControlStateNormal];
    [v_Acc.btn_Button addTarget:self action:@selector(goSearch:) forControlEvents:UIControlEventTouchUpInside];
    self.tf_Search.inputAccessoryView = v_Acc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    __weak __typeof(&*self)weakSelf = self;
    
    self.container = segue.destinationViewController;
    [self.container setCompletionMoreBlock:^(id completeResult) {
        
        [weakSelf updateList];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)updateList
{
    __weak __typeof(&*self)weakSelf = self;
    
    if( nTotalCount > 0 && self.arM_List.count >= nTotalCount )
    {
        isLoading = NO;
        return;
    }
    
    if( isLoading )
    {
//        [self updateList];
        return;
    }
    
    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSString stringWithFormat:@"%ld", nPage], @"page",
                                        @"0", @"size",
                                        @"LATELY_UPDATE", @"sorting",
                                        @"CURRENT", @"type",
                                        self.tf_Search.text, @"name",
                                        nil];
    
    isLoading = YES;
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:@"learn/degree"
                                        param:dicM_Params
                                   withMethod:@"GET"
                                    withBlock:^(id resulte, NSError *error) {
                                        
                                        isLoading = NO;
                                        
                                        nPage++;
                                        
                                        if( resulte )
                                        {
                                            NSDictionary *dic_Data = [resulte objectForKey:@"data"];
                                            id dic_Meta = [resulte objectForKey:@"meta"];
                                            if( [dic_Meta isKindOfClass:[NSNull class]] )
                                            {
                                                dic_Meta = nil;
                                            }
                                            
                                            NSInteger nCode = [[dic_Meta objectForKey_YM:@"errCode"] integerValue];
                                            if( nCode == 0 )
                                            {
                                                nTotalCount = [[dic_Data objectForKey:@"totalElements"] integerValue];
                                                
                                                if( weakSelf.container.arM_List && weakSelf.container.arM_List.count > 0 )
                                                {
                                                    //더보기시
                                                    [weakSelf.container.arM_List addObjectsFromArray:[dic_Data objectForKey:@"content"]];
                                                    [weakSelf.container.tbv_List reloadData];
                                                }
                                                else
                                                {
                                                    //최초 로딩시
                                                    weakSelf.container.arM_List = [NSMutableArray arrayWithArray:[dic_Data objectForKey:@"content"]];
                                                    [weakSelf.container.tbv_List reloadData];
                                                    
                                                    if( nTotalCount <= 0 || weakSelf.container.arM_List == nil || weakSelf.container.arM_List.count <= 0 )
                                                    {
                                                        [UIAlertController showAlertInViewController:weakSelf
                                                                                           withTitle:@""
                                                                                             message:@"검색결과가 없습니다"
                                                                                   cancelButtonTitle:nil
                                                                              destructiveButtonTitle:nil
                                                                                   otherButtonTitles:@[@"확인"]
                                                                                            tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex){
                                                                                                
                                                                                                if (buttonIndex == controller.cancelButtonIndex)
                                                                                                {
                                                                                                    NSLog(@"Cancel Tapped");
                                                                                                }
                                                                                                else if (buttonIndex == controller.destructiveButtonIndex)
                                                                                                {
                                                                                                    NSLog(@"Delete Tapped");
                                                                                                }
                                                                                                else if (buttonIndex >= controller.firstOtherButtonIndex)
                                                                                                {
                                                                                                    NSLog(@"Other Button Index %ld", (long)buttonIndex - controller.firstOtherButtonIndex);
                                                                                                }
                                                                                            }];
                                                    }
                                                }
                                            }
                                        }
                                    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self goSearch:nil];
    return YES;
}

- (IBAction)goSearch:(id)sender
{
    if( self.tf_Search.text.length > 0 )
    {
        [self.view endEditing:YES];
        
        nPage = 1;
        
        [self.container.arM_List removeAllObjects];
        self.container.arM_List = nil;
        
        [UIView animateWithDuration:0.3f animations:^{
            
            [self.container.tbv_List setContentOffset:CGPointZero];
        }];
        
        [self updateList];
    }
}

@end
