//
//  SnsMainViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 13..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "SnsMainViewController.h"
#import "SnsListViewController.h"
#import "NoDataView.h"

@interface SnsMainViewController ()
{
    BOOL isLoading;
    NSInteger nPage;
    NSInteger nTotalCount;
}
@property (nonatomic, weak) SnsListViewController *container;
@property (nonatomic, weak) IBOutlet UILabel *lb_MainTitle;
@property (nonatomic, weak) IBOutlet UIView *v_BadgeBg;
@property (nonatomic, weak) IBOutlet UILabel *lb_BadgeCount;
//@property (nonatomic, weak) IBOutlet UIView *v_Empty;
@property (nonatomic, weak) IBOutlet UIButton *btn_Alram;
@property (nonatomic, weak) IBOutlet UIButton *btn_Back;
@end

@implementation SnsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.screenName = @"SNS 리스트";
    
    nPage = 1;
    
    self.v_BadgeBg.layer.cornerRadius = self.v_BadgeBg.frame.size.width / 2;
    self.lb_BadgeCount.text = @"0";
    
    [self updateList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if( self.isBookMarkMode )
    {
        self.lb_MainTitle.text = @"SNS 북마크";
        self.v_BadgeBg.hidden = self.btn_Alram.hidden = YES;
        self.btn_Back.hidden = NO;
    }
    else
    {
        self.lb_MainTitle.text = @"SNS FEED";
        self.v_BadgeBg.hidden = self.btn_Alram.hidden = NO;
        self.btn_Back.hidden = YES;
    }

    [self updateBadgeCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)moveToDetail:(NSString *)aIdx
{
    [self performSelector:@selector(onMoveToDetailInterval:) withObject:aIdx afterDelay:0.3f];
}

- (void)onMoveToDetailInterval:(NSString *)aIdx
{
    [self.container moveToDetail:aIdx];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    __weak __typeof(&*self)weakSelf = self;
    
    if( [segue.identifier isEqualToString:@"List"] )
    {
        self.container = segue.destinationViewController;
        self.container.isBookMarkMode = self.isBookMarkMode;
        [self.container setCompletionMoreBlock:^(id completeResult) {
            
            [weakSelf updateList];
        }];
        
        [self.container setCompletionRefreshBlock:^(id completeResult) {
            
            nPage = 1;
            [weakSelf.container.arM_List removeAllObjects];
//            [weakSelf.container.tbv_List setContentOffset:CGPointZero];
            [weakSelf updateList];
        }];
        
        [self.container setCompletionRefreshBlock:^(id completeResult) {
            
            nPage = 1;
            [weakSelf.container.arM_List removeAllObjects];
            //            [weakSelf.container.tbv_List setContentOffset:CGPointZero];
            [weakSelf updateList];
        }];

    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)refreshData
{
    nPage = 1;
    [self.container.arM_List removeAllObjects];
    [self updateList];
}

- (void)updateBadgeCount
{
    __weak __typeof(&*self)weakSelf = self;

    [[WebAPI sharedData] callAsyncWebAPIBlock:@"record/board"
                                        param:nil
                                   withMethod:@"GET"
                                    withBlock:^(id resulte, NSError *error) {

                                        if( resulte )
                                        {
                                            id dic_Meta = [resulte objectForKey:@"meta"];
                                            if( [dic_Meta isKindOfClass:[NSNull class]] )
                                            {
                                                dic_Meta = nil;
                                            }
                                            
                                            NSInteger nCode = [[dic_Meta objectForKey_YM:@"errCode"] integerValue];
                                            if( nCode == 0 )
                                            {
                                                NSArray *ar_List = [resulte objectForKey:@"data"];
                                                for( NSInteger i = 0; i < ar_List.count; i++ )
                                                {
                                                    NSDictionary *dic = ar_List[i];
                                                    if( [[dic objectForKey_YM:@"identifier"] isEqualToString:@"SNS"] ||
                                                       [[dic objectForKey_YM:@"identifier"] isEqualToString:@"sns"] )
                                                    {
                                                        NSInteger nBadgeCnt = [[dic objectForKey_YM:@"count"] integerValue];
                                                        if( nBadgeCnt > 0 )
                                                        {
                                                            weakSelf.v_BadgeBg.hidden = NO;
                                                        }
                                                        else
                                                        {
                                                            weakSelf.v_BadgeBg.hidden = YES;
                                                        }
                                                        
                                                        weakSelf.lb_BadgeCount.text = [NSString stringWithFormat:@"%@", [dic objectForKey_YM:@"count"]];
                                                    }
                                                }
                                            }
                                        }
                                    }];
}

- (void)updateList
{
    UIView *v_Empty = [self.container.tbv_List viewWithTag:1982];
    [v_Empty removeFromSuperview];
    
    __weak __typeof(&*self)weakSelf = self;
    
    if( nTotalCount > 0 && self.container.arM_List.count >= nTotalCount )
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
                                        @"id,desc", @"sort",
                                        @"ALL", @"type",
                                        nil];
    
    if( self.isBookMarkMode )
    {
        [dicM_Params removeObjectForKey:@"page"];
        [dicM_Params setObject:@"1000" forKey:@"size"];
        [dicM_Params setObject:@"CLIPPING" forKey:@"type"];
    }
    
    isLoading = YES;
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:@"board/SNS/article"
                                        param:dicM_Params
                                   withMethod:@"GET"
                                    withBlock:^(id resulte, NSError *error) {
                                        
                                        isLoading = NO;
                                        
                                        nPage++;
                                        
                                        [weakSelf.container.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
                                        
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
                                                    if( weakSelf.isBookMarkMode == NO )
                                                    {
                                                        [weakSelf updateTime];
                                                    }
                                                    
                                                    weakSelf.container.arM_List = [NSMutableArray arrayWithArray:[dic_Data objectForKey:@"content"]];
                                                    [weakSelf.container.tbv_List reloadData];
                                                    
                                                    if( weakSelf.isBookMarkMode )
                                                    {
                                                        if( weakSelf.container.arM_List == nil || weakSelf.container.arM_List.count <= 0 )
                                                        {
                                                            NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"NoDataView" owner:self options:nil];
                                                            NoDataView *v_Empty = [topLevelObjects objectAtIndex:0];
                                                            v_Empty.center = weakSelf.container.tbv_List.center;
                                                            v_Empty.tag = 1982;
                                                            v_Empty.lb_Title.text = @"북마크 내역이 없습니다";
                                                            v_Empty.iv_Icon.image = BundleImage(@"sns_data_bookmark_icon.png");
                                                            [weakSelf.container.tbv_List addSubview:v_Empty];
                                                        }
                                                        
                                                    }
                                                        
//                                                    if( nTotalCount <= 0 || weakSelf.container.arM_List == nil || weakSelf.container.arM_List.count <= 0 )
//                                                    {
//                                                        weakSelf.v_Empty.hidden = NO;
//                                                    }
//                                                    else
//                                                    {
//                                                        weakSelf.v_Empty.hidden = YES;
//                                                    }
                                                }
                                            }
                                        }
                                    }];
}

- (void)updateTime
{
    //시간 기록 (뱃지 카운트 때문에 호출해 줘야 함)
    [[WebAPI sharedData] callAsyncWebAPIBlock:@"record/board/SNS"
                                        param:nil
                                   withMethod:@"POST"
                                    withBlock:^(id resulte, NSError *error) {
                                        
                                        if( resulte )
                                        {

                                        }
                                    }];
    
}

@end
