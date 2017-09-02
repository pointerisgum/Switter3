//
//  ImagePlayerViewController.m
//  SMBA_EN
//
//  Created by KimYoung-Min on 2016. 5. 22..
//  Copyright © 2016년 youngmin.kim. All rights reserved.
//

#import "ImagePlayerViewController.h"
#import "BarBgImageView.h"
#import "SPXFrameScroller.h"

static NSInteger kNextTimeInterval = 3;

@interface ImagePlayerViewController () <BarBgImageViewDelegate>
{
    NSInteger nCount;
    NSInteger nStudyCompletePage;   //학습완료한 페이지
    NSInteger nTotalPage;
    NSInteger nCurrentPage;
}
@property (nonatomic, strong) NSTimer *tm;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_PageWidth;
@property (nonatomic, weak) IBOutlet UIScrollView *sv_Contents;
@property (nonatomic, weak) IBOutlet BarBgImageView *iv_BarBg;
@property (nonatomic, weak) IBOutlet UILabel *lb_Page;
@property (nonatomic, weak) IBOutlet UIButton *btn_Back;
@property (nonatomic, weak) IBOutlet UIView *v_Bar;

//@property (nonatomic, weak) IBOutlet UIView *v_Bar;

@end

@implementation ImagePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.screenName = @"ImageStudy";
    
    if( self.nStartPage <= 0 )
    {
        self.nStartPage = 1;
    }
    
    self.iv_BarBg.delegate = self;
    nStudyCompletePage = self.nStartPage;
    nCurrentPage = self.nStartPage;
//    nTotalPage = 1000;
    nTotalPage = self.ar_List.count;
    
    if( nTotalPage > 1 && nCurrentPage == nTotalPage )
    {
        nCurrentPage = 1;
    }
    

    //페이지가 하나일 경우 바로 업뎃하기
    if( self.isStudyMode )
    {
        if( nTotalPage == 1 )
        {
            [self updatePercent];
        }
    }

    
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
////    [panGesture setDelegate:self];
//    panGesture.maximumNumberOfTouches = 1;
//    [self.sv_Bar addGestureRecognizer:panGesture];

//    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//    [self.sv_Bar addGestureRecognizer:gesture];

//    UILongPressGestureRecognizer *singleTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
////    [singleTap setNumberOfTapsRequired:1];
//    [self.sv_Bar addGestureRecognizer:singleTap];

//    self.sv_Bar.delegate = self;
    
//    [self performSelector:@selector(onTest) withObject:nil afterDelay:2.0f];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if( self.tm )
    {
        [self.tm invalidate];
        self.tm = nil;
    }
}

- (IBAction)goModalBack:(id)sender
{
    [super goModalBack:sender];
    
//    if( isStudyMode == NO )
//    {
//        //복습시 현재 진도율 저장
//        NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                            [[NSUserDefaults standardUserDefaults] objectForKey:@"UserIdx"], @"userIdx",
//                                            [[NSUserDefaults standardUserDefaults] objectForKey:@"BrandIdx"], @"brandIdx",
//                                            self.str_Idx, @"integrationCourseIdx",
//                                            [NSString stringWithFormat:@"%ld", [[self.dic_Info objectForKey:@"ProcessIdx"] integerValue]], @"processIdx",
//                                            [NSString stringWithFormat:@"%ld", [[self.dic_Info objectForKey:@"SubProcessIdx"] integerValue]], @"subProcessIdx",
//                                            @"829", @"contentType",
//                                            [NSString stringWithFormat:@"%ld", nCurrentPage], @"frameProcessingCnt",
//                                            [NSString stringWithFormat:@"%ld", nTotalPage], @"frameTotalCnt",
//                                            //                                        @"4", @"frameProcessingCnt",
//                                            //                                        @"17", @"frameTotalCnt",
//                                            nil];
//        
//        [[WebAPI sharedData] callAsyncWebAPIBlock:@"course/updateSubProcessProgressRateFrame"
//                                            param:dicM_Params
//                                         withType:@"POST"
//                                        withBlock:^(id resulte, NSError *error) {
//                                            
//                                            [GMDCircleLoader hide];
//                                            
//                                            if( resulte )
//                                            {
//
//                                            }
//                                            
//                                            [super goModalBack:sender];
//                                        }];
//    }
}

- (void)handleGesture:(UILongPressGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:gesture.view];
    NSLog(@"%@", NSStringFromCGPoint(location));

    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        // user held down their finger on the screen
        
        // gesture started, entering the "toggle mode"
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        // user did not lift finger, but now proceeded to move finger
        
        // do here whatever you wanted to do in the touchesMoved
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        // user lifted their finger
        
        // all done, leaving the "toggle mode"
    }
}

- (void)onTest
{
//    self.lc_PageX.constant = 100.0f;
//    [self.view setNeedsLayout];
    
//    self.sv_Bar.contentInset = UIEdgeInsetsMake(0, self.v_Bar.frame.size.width, 0, 0);
    
//    self.lc_PageWidth.constant = 100;
    
    [self.view setNeedsLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.view setNeedsLayout];
    
    [self updateImageList];
    [self updatePageLabel];

    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.sv_Contents addGestureRecognizer:swipeLeft];
    [self.sv_Contents addGestureRecognizer:swipeRight];

    self.sv_Contents.contentOffset = CGPointMake(self.sv_Contents.frame.size.width * (nCurrentPage - 1), 0);

//    [self updateList];
    
//    [self performSelector:@selector(onTest) withObject:nil afterDelay:2.0f];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.sv_Contents.contentSize = CGSizeMake(self.sv_Contents.frame.size.width * nTotalPage, self.sv_Contents.frame.size.height);
    
    CGFloat fOnePageWidth = self.iv_BarBg.frame.size.width / nTotalPage;
    self.lc_PageWidth.constant = nCurrentPage * fOnePageWidth;

//    self.sv_Bar.contentSize = CGSizeMake(-self.sv_Bar.frame.size.width * 2, -self.sv_Bar.frame.size.width * 2);
//    self.sv_Bar.contentOffset = CGPointMake(self.sv_Bar.frame.size.width, 0);
//    self.sv_Bar.contentInset = UIEdgeInsetsMake(0, self.lc_PageX.constant, 0, 0);
//    self.sv_Bar.contentInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width - (63 * 3), 0, 0);

//    self.sv_Bar.contentSize = CGSizeMake(self.sv_Bar.frame.size.width * 1, 0);
//    
//    self.sv_Bar.contentInset = UIEdgeInsetsMake(0, self.sv_Bar.frame.size.width * 1, 0, 0);
//    self.sv_Bar.contentOffset = CGPointMake(-self.sv_Bar.frame.size.width, 0);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationLandscapeLeft];
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
//    return UIInterfaceOrientationMaskLandscapeLeft;
    return UIInterfaceOrientationMaskLandscape;
}

- (void)updateList
{
//    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                        [[NSUserDefaults standardUserDefaults] objectForKey:@"UserIdx"], @"userIdx",
//                                        [[NSUserDefaults standardUserDefaults] objectForKey:@"BrandIdx"], @"brandIdx",
//                                        self.str_Idx, @"integrationCourseIdx",
//                                        [NSString stringWithFormat:@"%ld", [[self.dic_Info objectForKey:@"ProcessIdx"] integerValue]], @"processIdx",
//                                        [NSString stringWithFormat:@"%ld", [[self.dic_Info objectForKey:@"SubProcessIdx"] integerValue]], @"subProcessIdx",
//                                        @"image", @"contentType",
//                                        nil];
//    //course/getSubProcessImageList
//    [[WebAPI sharedData] callAsyncWebAPIBlock:@"course/inLearningSubProcessInfo"
//                                        param:dicM_Params
//                                    withBlock:^(id resulte, NSError *error) {
//                                        
//                                        [GMDCircleLoader hide];
//                                        
//                                        if( resulte )
//                                        {
//                                            NSLog(@"%@", resulte);
//                                            
//                                            NSDictionary *dic_Data = [resulte objectForKey:@"Data"];
//                                            NSDictionary *dic_Meta = [resulte objectForKey:@"Meta"];
//                                            NSInteger nCode = [[dic_Meta objectForKey_YM:@"ResultCd"] integerValue];
//                                            if( nCode == 1 )
//                                            {
//                                                NSDictionary *dic_SubProcessInfoMap = [dic_Data objectForKey:@"SubProcessInfoMap"];
//                                                NSString *str_ContentsPath = [dic_SubProcessInfoMap objectForKey:@"ContentPath"];
//                                                NSString *str_ContentsUrl = [dic_SubProcessInfoMap objectForKey:@"ContentUrl"];
//                                                [self setImageListWithPath:str_ContentsPath withUrl:str_ContentsUrl];
//                                                
//                                                NSDictionary *dic_IntegrationCourseInfo = [dic_Data objectForKey:@"IntegrationCourseInfo"];
//                                                NSString *str_Status = [dic_IntegrationCourseInfo objectForKey:@"StatusType"];
//                                                if( [str_Status isEqualToString:@"B3"] || [str_Status isEqualToString:@"W5"] )
//                                                {
//                                                    //완료
//                                                    isStudyMode = NO;
//                                                    self.iv_BarBg.userInteractionEnabled = YES;
//                                                    
//                                                    //사용자의 진도율
//                                                    id obj = [dic_SubProcessInfoMap objectForKey:@"ProcessingPoint"];
//                                                    if( [obj isEqual:[NSNull null]] )
//                                                    {
//                                                        nStudyCompletePage = 0;
//                                                    }
//                                                    else
//                                                    {
//                                                        nStudyCompletePage = [[dic_SubProcessInfoMap objectForKey:@"ProcessingPoint"] integerValue];
//                                                    }
//                                                    
//                                                    nCurrentPage = nStudyCompletePage;
//                                                    nTotalPage = [[dic_SubProcessInfoMap objectForKey:@"ContentQuantity"] integerValue];
//
//                                                    [self updatePageLabel];
//                                                    self.sv_Contents.contentOffset = CGPointMake(self.sv_Contents.frame.size.width * (nCurrentPage - 1), 0);
//                                                }
//                                                else
//                                                {
//                                                    //학습시 터치로 페이지 이동 못하게 막는다
//                                                    isStudyMode = YES;
//                                                    
//                                                    //사용자의 진도율
//                                                    id obj = [dic_SubProcessInfoMap objectForKey:@"ProcessingPoint"];
//                                                    if( [obj isEqual:[NSNull null]] )
//                                                    {
//                                                        nStudyCompletePage = 0;
//                                                    }
//                                                    else
//                                                    {
//                                                        nStudyCompletePage = [[dic_SubProcessInfoMap objectForKey:@"ProcessingPoint"] integerValue];
//                                                    }
//                                                    
//                                                    nCurrentPage = nStudyCompletePage + 1;
//                                                    nTotalPage = [[dic_SubProcessInfoMap objectForKey:@"ContentQuantity"] integerValue];
//                                                    if( nCurrentPage > nTotalPage )
//                                                    {
//                                                        nCurrentPage = nTotalPage;
//                                                    }
//                                                    [self updatePageLabel];
//                                                    self.sv_Contents.contentOffset = CGPointMake(self.sv_Contents.frame.size.width * (nCurrentPage - 1), 0);
//
//                                                    self.iv_BarBg.userInteractionEnabled = NO;
//                                                    
//                                                    if( nCurrentPage < nTotalPage )
//                                                    {
//                                                        nCount = kNextTimeInterval;
//                                                        self.tm = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkCountdown:) userInfo:nil repeats:YES];
//                                                    }
//                                                    else
//                                                    {
//                                                        self.iv_BarBg.userInteractionEnabled = YES;
//                                                        
//                                                        nCurrentPage = 1;
//
//                                                        [self updatePageLabel];
//                                                        self.sv_Contents.contentOffset = CGPointMake(self.sv_Contents.frame.size.width * (nCurrentPage - 1), 0);
//                                                    }
//                                                }
//                                                
//                                                
//                                                UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
//                                                UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
//                                                [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
//                                                [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
//                                                [self.sv_Contents addGestureRecognizer:swipeLeft];
//                                                [self.sv_Contents addGestureRecognizer:swipeRight];
//                                            }
//                                            else
//                                            {
////                                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
////                                                MsgPopUpViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MsgPopUpViewController"];
////                                                vc.type = kOneButton;
////                                                vc.str_Msg = [dic_Meta objectForKey_YM:@"FailMsg"];
////                                                [vc setCompletionBlock:^ {
////                                                    
////                                                    
////                                                }];
////                                                [self presentViewController:vc animated:YES completion:nil];
//                                            }
//                                        }
//                                    }];
}

- (void)updatePageLabel
{
    self.lb_Page.text = [NSString stringWithFormat:@"%ld / %ld", nCurrentPage, nTotalPage];
}

- (void)setImageListWithPath:(NSString *)aPath withUrl:(NSString *)aUrl
{
    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        aPath, @"contentPath",
                                        aUrl, @"contentUrl",
                                        nil];

    [[WebAPI sharedData] callAsyncWebAPIBlock:@"course/getSubProcessImageList"
                                        param:dicM_Params
                                    withBlock:^(id resulte, NSError *error) {
                                        
                                        [GMDCircleLoader hide];
                                        
                                        
                                        if( resulte )
                                        {
                                            NSDictionary *dic_Data = [resulte objectForKey:@"Data"];
                                            NSDictionary *dic_Meta = [resulte objectForKey:@"Meta"];
                                            NSInteger nCode = [[dic_Meta objectForKey_YM:@"ResultCd"] integerValue];
                                            if( nCode == 1 )
                                            {
                                                self.ar_List = [NSArray arrayWithArray:[dic_Data objectForKey:@"ResultList"]];
                                                [self updateImageList];

                                            }
                                            else
                                            {
//                                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                                                MsgPopUpViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MsgPopUpViewController"];
//                                                vc.type = kOneButton;
//                                                vc.str_Msg = [dic_Meta objectForKey_YM:@"FailMsg"];
//                                                [vc setCompletionBlock:^ {
//                                                    
//                                                    
//                                                }];
//                                                [self presentViewController:vc animated:YES completion:nil];
                                            }
                                        }
                                    }];
}

/*
 (lldb) po dic_StudyInfo
 {
 FileName = "a01.JPG";
 FileUrl = "http://siel.mobileb2bacademy.com/api/contents_upload/1352/Galaxy_J5-J7_Sales Playbook_IMG_160114/a01.JPG";
 }
 
 (lldb)
 
 
 (lldb) po dic_StudyInfo
 {
 FileName = "a01.JPG";
 FileUrl = "http://siel.mobileb2bacademy.com/api/contents_upload/1365/What_is_KNOX_Workspace/a01.JPG";
 }
 
 (lldb)
 */

- (void)updateImageList
{
    nTotalPage = self.ar_List.count;
    
    for( NSInteger i = 0; i < self.ar_List.count; i++ )
    {
        NSString *str_Url = self.ar_List[i];
        
        SPXFrameScroller *sv = [[SPXFrameScroller alloc]initWithFrame:CGRectMake(i * self.sv_Contents.frame.size.width, 0, self.sv_Contents.frame.size.width, self.sv_Contents.frame.size.height)];
        sv.tag = i + 1;
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.sv_Contents.frame.size.width, self.sv_Contents.frame.size.height)];
        iv.clipsToBounds = YES;
//        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [singleTap setNumberOfTapsRequired:1];
        [iv addGestureRecognizer:singleTap];

        str_Url = [str_Url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:str_Url];
        [iv sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        [sv addSubview:iv];
        [self.sv_Contents addSubview:sv];
//        self.sv_Contents.contentSize = CGSizeMake(self.sv_Contents.frame.size.width * self.ar_List.count, 0);
    }
    
    [self.view setNeedsLayout];
}

- (void)handleSingleTap:(UITouch *)touch
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                        
                         self.btn_Back.alpha = !self.btn_Back.alpha;
                         self.v_Bar.alpha = !self.v_Bar.alpha;
                     }];
    
}
//
//#pragma mark - UIScrollviewDelegate
////-(void)scrollViewDidScroll:(UIScrollView *)sender
////{
////    [NSObject cancelPreviousPerformRequestsWithTarget:self];
////    //ensure that the end of scroll is fired.
////    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.3];
////    
////}
////
////-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
////{
////    [NSObject cancelPreviousPerformRequestsWithTarget:self];
////}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if( decelerate )
//    {
//        //스크롤중인지 여부
//        
//        
//    }
//    if( scrollView == self.sv_Bar )
//    {
//        [self.sv_Bar setContentOffset:CGPointMake(scrollView.contentOffset.x, 0) animated:NO];
//    }
//    
//    NSLog(@"@@@@@@@@@@@@@@");
//}
//
////스크롤 멈추기
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
//                     withVelocity:(CGPoint)velocity
//              targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    *targetContentOffset = scrollView.contentOffset;
//}


- (void)updatePage
{
    //한 페이지가 몇 픽셀인지 구하기
    if( self.lc_PageWidth.constant > 0 && self.lc_PageWidth.constant <= self.iv_BarBg.frame.size.width )
    {
        CGFloat fOnePageWidth = self.iv_BarBg.frame.size.width / nTotalPage;
        nCurrentPage = (self.lc_PageWidth.constant / fOnePageWidth) + 1;
//        if( nCurrentPage < 1 )
//        {
//            nCurrentPage = 1;
//        }
        
        if( nCurrentPage > nTotalPage )
        {
            nCurrentPage = nTotalPage;
        }
        NSLog(@"currnet page : %ld", nCurrentPage);
        
        [UIView animateWithDuration:0.3f animations:^{
            self.sv_Contents.contentOffset = CGPointMake(self.sv_Contents.frame.size.width * (nCurrentPage - 1), 0);
        }];
    }
    else
    {
        NSLog(@"over");
    }
    
    [self updatePageLabel];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        //뒤로
        if( nCurrentPage >= nTotalPage )
        {
            return;
        }

        if( self.isStudyMode )
        {
            if( nCurrentPage <= nStudyCompletePage )
            {
                //pass
                [self moveToNextPage];
            }
            else
            {
                //show msg (다음 페이지 넘어갈라믄 10초 기다료)
//                AlertViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
//                NSString *str_Msg = [NSString stringWithFormat:@"%ld초 후에 이동할 수 있습니다." ,nCount == 0 ? 1 : nCount];
//                vc.str_Title = str_Msg;
//                vc.ar_Buttons = @[@"닫기"];
//                [vc setCompletionBlock:^(id completeResult) {
//                    
//                }];
//                
//                [self presentViewController:vc animated:NO completion:nil];

//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                MsgPopUpViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MsgPopUpViewController"];
//                vc.type = kOneButton;
//                NSString *msg = [NSString stringWithFormat:@"%@ %ld %@",
//                                 [Common localizingString:@"You can view the next slide in"],
//                                 nCount == 0 ? 1 : nCount,
//                                 [Common localizingString:@"seconds."]];
//                vc.str_Msg = msg;
//                [vc setCompletionBlock:^ {
//                    
//                    
//                }];
//                [self presentViewController:vc animated:YES completion:nil];
            }
        }
        else
        {
            if( nCurrentPage < nTotalPage )
            {
                [self moveToNextPage];
                
                if( nCurrentPage > nStudyCompletePage )
                {
                    [self updatePercent];
                }
            }
        }
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        //앞으로
        [self moveToPrev];
    }
}



#pragma mark - BarBgImageViewDelegate
- (void)touchBegan:(CGFloat)x
{
    self.lc_PageWidth.constant = x;
    [self updatePage];
}

- (void)touchMove:(CGFloat)x
{
    self.lc_PageWidth.constant = x;
    [self updatePage];
}

- (void)touchEnd:(CGFloat)x
{
    self.lc_PageWidth.constant = x;
    [self updatePage];
    [self.view setNeedsLayout];
    NSLog(@"@@@@@@@@@@@@");
    NSLog(@"%ld", nCurrentPage);
    NSLog(@"@@@@@@@@@@@@");
}

- (void)touchCancel:(CGFloat)x
{
    
}



#pragma mark - UIScrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if( scrollView == self.sv_Contents )
    {
        NSInteger nPage = self.sv_Contents.contentOffset.x / self.sv_Contents.frame.size.width;
        nCurrentPage = nPage + 1;
        
        [UIView animateWithDuration:0.3f animations:^{
            self.sv_Contents.contentOffset = CGPointMake(self.sv_Contents.frame.size.width * (nCurrentPage - 1), 0);
        }completion:^(BOOL finished) {
            [self.view setNeedsLayout];
        }];
    }
}



#pragma mark - IBAction
- (IBAction)goFirstPage:(id)sender
{
    nCurrentPage = 1;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.sv_Contents.contentOffset = CGPointMake(self.sv_Contents.frame.size.width * (nCurrentPage - 1), 0);
    }completion:^(BOOL finished) {
        [self.view setNeedsLayout];
    }];
    
    [self updatePageLabel];
}

- (IBAction)goPrev:(id)sender
{
    [self moveToPrev];
}

- (IBAction)goNext:(id)sender
{
    if( nCurrentPage >= nTotalPage )
    {
        return;
    }

    if( self.isStudyMode )
    {
        if( nCurrentPage <= nStudyCompletePage )
        {
            //pass
            [self moveToNextPage];
        }
        else
        {
//            show msg (다음 페이지 넘어갈라믄 10초 기다료)
//            AlertViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
//            NSString *str_Msg = [NSString stringWithFormat:@"%ld초 후에 이동할 수 있습니다." ,nCount == 0 ? 1 : nCount];
//            vc.str_Title = str_Msg;
//            vc.ar_Buttons = @[@"닫기"];
//            [vc setCompletionBlock:^(id completeResult) {
//                
//            }];
//            
//            [self presentViewController:vc animated:NO completion:nil];

//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            MsgPopUpViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MsgPopUpViewController"];
//            vc.type = kOneButton;
//            NSString *msg = [NSString stringWithFormat:@"%@ %ld %@",
//                             [Common localizingString:@"You can view the next slide in"],
//                             nCount == 0 ? 1 : nCount,
//                             [Common localizingString:@"seconds."]];
//            vc.str_Msg = msg;
//            [vc setCompletionBlock:^ {
//                
//                
//            }];
//            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    else
    {
        if( nCurrentPage < nTotalPage )
        {
            [self moveToNextPage];
            
            if( nCurrentPage > nStudyCompletePage )
            {
                [self updatePercent];
            }
        }
    }
}

- (void)moveToPrev
{
    if( nCurrentPage > 1 )
    {
        nCurrentPage--;
        
        [UIView animateWithDuration:0.3f animations:^{
            self.sv_Contents.contentOffset = CGPointMake(self.sv_Contents.frame.size.width * (nCurrentPage - 1), 0);
        }completion:^(BOOL finished) {
            [self.view setNeedsLayout];
        }];
    }
    
    [self updatePageLabel];
}

- (void)moveToNextPage
{
    nCurrentPage++;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.sv_Contents.contentOffset = CGPointMake(self.sv_Contents.frame.size.width * (nCurrentPage - 1), 0);
    }completion:^(BOOL finished) {
        [self.view setNeedsLayout];
    }];

//    if( self.isStudyMode && nCurrentPage > nStudyCompletePage )
    if( 0 )
    {
        if( self.tm )
        {
            [self.tm invalidate];
            self.tm = nil;
        }
        
        nCount = kNextTimeInterval;
        self.tm = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(checkCountdown:) userInfo:nil repeats:YES];
    }
    
    [self updatePercent];
    [self updatePageLabel];
    
//    else
//    {
//        [UIView animateWithDuration:0.3f animations:^{
//            self.sv_Contents.contentOffset = CGPointMake(self.sv_Contents.frame.size.width * (nCurrentPage - 1), 0);
//        }completion:^(BOOL finished) {
//            [self.view setNeedsLayout];
//        }];
//    }
}

-(void)checkCountdown:(NSTimer*)_timer
{
    nCount--;
    if( nCount <= 0 )
    {
        if( self.tm )
        {
            [self.tm invalidate];
            self.tm = nil;
        }

        [self updatePercent];
    }
}

- (void)updatePercent
{
    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionary];
    [dicM_Params setObject:self.str_LangId forKey:@"languageId"];
    [dicM_Params setObject:[NSString stringWithFormat:@"%ld", nCurrentPage] forKey:@"current"];
    [dicM_Params setObject:[NSString stringWithFormat:@"%ld", nTotalPage] forKey:@"total"];
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"learn/learning/%@/progression/%@", self.str_DegreeId, self.str_LessonId]
                                        param:dicM_Params
                                   withMethod:@"PUT"
                                    withBlock:^(id resulte, NSError *error) {
                                        
                                        if( resulte )
                                        {
                                            nStudyCompletePage = nCurrentPage;
                                            
                                            if( nCurrentPage == nTotalPage )
                                            {
                                                //학습완료
                                                
                                            }
                                        }
                                    }];
}

- (void)onNextPageCheck
{
    nStudyCompletePage = nCurrentPage;
    
    [self.tm invalidate];
    self.tm = nil;
}

- (void)onCount:(NSTimer *)tm
{
    
}

@end
