//
//  MoviePlayerViewController.m
//  EmAritaum
//
//  Created by Kim Young-Min on 2014. 4. 7..
//  Copyright (c) 2014년 Kim Young-Min. All rights reserved.
//

#import "MoviePlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SliderTouch.h"

static CGFloat kTimerInterval = 0.5f;

@interface MoviePlayerViewController () <SliderTouchViewDelegate>
{
    BOOL isPlayingAtOnce;   //플레이를 시작했는지 여부
    //    BOOL isStudyMode;
    NSInteger nCount;
    NSInteger nStudyCompletePage;   //학습완료한 페이지
    NSInteger nTotalPage;
    NSInteger nCurrentPage;
}
//@property (nonatomic, assign) BOOL isFullSee;   //끝까지 다 시청 했는지 여부
@property (nonatomic, strong) NSTimer *tm;
@property (nonatomic, weak) IBOutlet SliderTouch *silder;
@property (nonatomic, weak) IBOutlet UIView *v_Contents;
@property (nonatomic, weak) IBOutlet UIView *v_Menu;
@property (nonatomic, weak) IBOutlet UIButton *btn_Back;
@property (nonatomic, weak) IBOutlet UIButton *btn_PlayOrPause;
@property (nonatomic, weak) IBOutlet UIButton *btn_Stop;
@property (nonatomic, weak) IBOutlet UIView *v_Bar;
@property (nonatomic, weak) IBOutlet UIView *v_MenuTouchArea;
@property (nonatomic, weak) IBOutlet UILabel *lb_PlayTime;
@property (nonatomic, weak) IBOutlet UILabel *lb_TotalTime;
@property (nonatomic, weak) IBOutlet UIView *v_Loading;
@end

@implementation MoviePlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.screenName = @"VodStudy";
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.v_MenuTouchArea addGestureRecognizer:singleTap];
    
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    self.vc_Movie = [[MPMoviePlayerViewController alloc]init];
    self.vc_Movie.view.userInteractionEnabled = NO;
    self.vc_Movie.moviePlayer.controlStyle = MPMovieControlStyleNone;
    self.silder.delegate = self;
    
    self.vc_Movie.moviePlayer.contentURL = [NSURL URLWithString:self.str_Url];
    self.vc_Movie.moviePlayer.view.frame = window.bounds;
    [self.v_Contents addSubview:self.vc_Movie.moviePlayer.view];
    self.vc_Movie.moviePlayer.repeatMode = MPMovieRepeatModeOne;
    self.vc_Movie.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    self.vc_Movie.moviePlayer.shouldAutoplay = YES;
    self.vc_Movie.moviePlayer.repeatMode = NO;
    [self.vc_Movie.moviePlayer setFullscreen:NO animated:NO];
    //    self.vc_Movie.moviePlayer.currentPlaybackTime = self.fStartTime;
    [self.vc_Movie.moviePlayer prepareToPlay];
    
    if( self.isStudyMode )
    {
        nCurrentPage = self.fStartTime;
        self.silder.userInteractionEnabled = NO;
    }
    else
    {
        nCurrentPage = 0;
        self.silder.userInteractionEnabled = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerPlaybackStateDidChange)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
}

- (void)viewDidLayoutSubviews
{
    self.vc_Movie.moviePlayer.view.frame = self.view.bounds;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.tm invalidate];
    self.tm = nil;
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    //                                        @"video", @"contentType",
    //                                        nil];
    //    //course/getSubProcessImageList
    //    [[WebAPI sharedData] callAsyncWebAPIBlockHideIndicator:@"course/inLearningSubProcessInfo"
    //                                                     param:dicM_Params
    //                                                 withBlock:^(id resulte, NSError *error) {
    //
    //                                                     [GMDCircleLoader hide];
    //
    //                                                     if( resulte )
    //                                                     {
    //                                                         NSLog(@"%@", resulte);
    //
    //                                                         NSDictionary *dic_Data = [resulte objectForKey:@"Data"];
    //                                                         NSDictionary *dic_Meta = [resulte objectForKey:@"Meta"];
    //                                                         NSInteger nCode = [[dic_Meta objectForKey_YM:@"ResultCd"] integerValue];
    //                                                         if( nCode == 1 )
    //                                                         {
    //                                                             [GMDCircleLoader show];
    //
    //                                                             NSDictionary *dic_SubProcessInfoMap = [dic_Data objectForKey:@"SubProcessInfoMap"];
    //                                                             NSString *str_ContentsUrl = [dic_SubProcessInfoMap objectForKey:@"ContentUrl"];
    //                                                             str_ContentsUrl = [str_ContentsUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //                                                             NSURL *url = [NSURL URLWithString:str_ContentsUrl];
    //                                                             //                                                NSURL *url = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/52138005/%EC%84%B1%ED%81%B0%ED%96%84%EA%B2%B0%ED%98%BC%EC%8B%9D.mp4"];
    //
    //                                                             self.vc_Movie.moviePlayer.contentURL = url;
    //                                                             //                                                [self.moviePlayer prepareToPlay];
    //
    //                                                             NSDictionary *dic_IntegrationCourseInfo = [dic_Data objectForKey:@"IntegrationCourseInfo"];
    //                                                             NSString *str_Status = [dic_IntegrationCourseInfo objectForKey:@"StatusType"];
    //                                                             if( [str_Status isEqualToString:@"B3"] || [str_Status isEqualToString:@"W5"] )
    //                                                             {
    //                                                                 //완료
    //                                                                 isStudyMode = NO;
    //                                                                 self.silder.userInteractionEnabled = YES;
    //
    //                                                                 //사용자의 진도율
    //                                                                 id obj = [dic_SubProcessInfoMap objectForKey:@"ProcessingPoint"];
    //                                                                 if( [obj isEqual:[NSNull null]] )
    //                                                                 {
    //                                                                     nStudyCompletePage = 0;
    //                                                                 }
    //                                                                 else
    //                                                                 {
    //                                                                     nStudyCompletePage = [[dic_SubProcessInfoMap objectForKey:@"ProcessingPoint"] integerValue];
    //                                                                 }
    //
    //                                                                 nCurrentPage = nStudyCompletePage;
    //                                                                 nTotalPage = [[dic_SubProcessInfoMap objectForKey:@"ContentQuantity"] integerValue];
    //                                                                 ///////////////////////
    //                                                             }
    //                                                             else
    //                                                             {
    //                                                                 self.silder.userInteractionEnabled = NO;
    //
    //                                                                 //학습중
    //                                                                 isStudyMode = YES;
    //
    //                                                                 //사용자의 진도율
    //                                                                 id obj = [dic_SubProcessInfoMap objectForKey:@"ProcessingPoint"];
    //                                                                 if( [obj isEqual:[NSNull null]] )
    //                                                                 {
    //                                                                     nStudyCompletePage = 0;
    //                                                                 }
    //                                                                 else
    //                                                                 {
    //                                                                     nStudyCompletePage = [[dic_SubProcessInfoMap objectForKey:@"ProcessingPoint"] integerValue];
    //                                                                 }
    //
    //                                                                 nCurrentPage = nStudyCompletePage;
    //                                                                 nTotalPage = [[dic_SubProcessInfoMap objectForKey:@"ContentQuantity"] integerValue];
    //                                                                 if( nCurrentPage < nTotalPage )
    //                                                                 {
    //                                                                     //진행중이라면 마지막으로 본 시점으로 점프
    //                                                                     //                                                        self.moviePlayer.currentPlaybackTime = nCurrentPage;
    //                                                                 }
    //                                                                 else
    //                                                                 {
    //                                                                     nCurrentPage = 0;
    //                                                                     self.silder.userInteractionEnabled = YES;
    //                                                                 }
    //                                                             }
    //
    //                                                             //                                                [self.moviePlayer play];
    //
    //
    //
    //                                                             self.vc_Movie.moviePlayer.view.frame = self.view.frame;
    //                                                             [self.v_Contents addSubview:self.vc_Movie.moviePlayer.view];
    //                                                             //                                                [self.view sendSubviewToBack:self.v_Contents];
    //                                                             //        vc.isSave = NO;
    //
    //                                                             //                                                self.vc_Movie.moviePlayer.controlStyle = MPMovieControlStyleNone;
    //                                                             self.vc_Movie.moviePlayer.repeatMode = MPMovieRepeatModeOne;
    //                                                             //                                                self.vc_Movie.moviePlayer.fullscreen = NO;
    //                                                             self.vc_Movie.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    //                                                             self.vc_Movie.moviePlayer.shouldAutoplay = YES;
    //                                                             self.vc_Movie.moviePlayer.repeatMode = NO;
    //                                                             [self.vc_Movie.moviePlayer setFullscreen:NO animated:NO];
    //                                                             [self.vc_Movie.moviePlayer prepareToPlay];
    //
    //                                                             //                                                MPVolumeView *systemVolumeSlider = [[MPVolumeView alloc] initWithFrame: self.view.bounds];
    //                                                             //                                                [systemVolumeSlider setHidden:YES];
    //                                                             //                                                [systemVolumeSlider setUserInteractionEnabled:NO];
    //                                                             //                                                [self.view addSubview:systemVolumeSlider];
    //
    //                                                         }
    //                                                         else
    //                                                         {
    ////                                                             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ////                                                             MsgPopUpViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MsgPopUpViewController"];
    ////                                                             vc.type = kOneButton;
    ////                                                             vc.str_Msg = [dic_Meta objectForKey_YM:@"FailMsg"];
    ////                                                             [vc setCompletionBlock:^ {
    ////
    ////
    ////                                                             }];
    ////                                                             [self presentViewController:vc animated:YES completion:nil];
    //                                                         }
    //                                                     }
    //                                                 }];
}

#pragma mark - MPMoviePlayerNotification
- (void)MPMoviePlayerPlaybackStateDidChange
{
    [GMDCircleLoader hide];
    
    //    self.silder.value = (self.vc_Movie.moviePlayer.duration / (self.vc_Movie.moviePlayer.currentPlaybackTime * 100) * 0.01);
    
    [self.view bringSubviewToFront:self.btn_Temp];
    
    MPMoviePlaybackState playbackState = self.vc_Movie.moviePlayer.playbackState;
    
    switch (playbackState)
    {
        case MPMoviePlaybackStateStopped:
            //            if( self.dic_InfoMap && self.isStudyMode )
            
            if( self.vc_Movie.moviePlayer.currentPlaybackTime > 0 && self.vc_Movie.moviePlayer.currentPlaybackTime >= self.vc_Movie.moviePlayer.duration - 3 )
            {
                //끝까지 다 시청한 경우
                self.vc_Movie.moviePlayer.currentPlaybackTime = self.vc_Movie.moviePlayer.duration;
            }
            
            //학습중이거나 완료를 했어도 끝까지 시청하지 않은 경우엔 진도율을 저장한다
            if( self.isStudyMode || self.fStartTime < self.vc_Movie.moviePlayer.duration - 1 )
            {
                [self updateVod];
            }
            
            //            if( isStudyMode )
            //            {
            //                if( self.vc_Movie.moviePlayer.currentPlaybackTime > 0 && self.vc_Movie.moviePlayer.currentPlaybackTime >= self.vc_Movie.moviePlayer.duration - 3 )
            //                {
            //                    //끝까지 다 시청한 경우
            //                    self.vc_Movie.moviePlayer.currentPlaybackTime = self.vc_Movie.moviePlayer.duration;
            //                    [self updateVod];
            //                }
            //                else
            //                {
            //                    //중간에 종료한 경우
            //                    //기존시간보다 더 봤을 경우에만 진도저장
            //                    if( nCurrentPage < self.vc_Movie.moviePlayer.currentPlaybackTime )
            //                    {
            //                        [self updateVod];
            //                    }
            //                }
            //                NSLog(@"시청한 시간: %f", self.vc_Movie.moviePlayer.currentPlaybackTime);
            //                NSLog(@"종료이벤트 발생");
            //            }
            //            else
            //            {
            //                [self updateVod];
            //            }
            break;
        case MPMoviePlaybackStatePlaying:
        {
            if( self.isStudyMode )
            {
                if( isPlayingAtOnce == NO )
                {
                    [self performSelector:@selector(onIsPlayingAtOnceInterval) withObject:nil afterDelay:0.5f];
                }
            }
            else
            {
                [self performSelector:@selector(onIsPlayingAtOnceInterval) withObject:nil afterDelay:0.5f];
            }
            
            self.vc_Movie.moviePlayer.currentPlaybackTime = nCurrentPage;
            
            self.btn_PlayOrPause.selected = NO;
            
            if( self.v_Loading.alpha )
            {
                [UIView animateWithDuration:0.5f animations:^{
                    self.v_Loading.alpha = NO;
                    
                    if( self.tm == nil )
                    {
                        self.tm = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(onSliderTimer) userInfo:nil repeats:YES];
                    }
                }];
            }
        }
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"MPMoviePlaybackStatePaused");
            
            if( isPlayingAtOnce )
            {
                self.btn_PlayOrPause.selected = YES;
            }
            break;
        case MPMoviePlaybackStateInterrupted:
            NSLog(@"MPMoviePlaybackStateInterrupted");
            break;
        case MPMoviePlaybackStateSeekingForward:
            NSLog(@"MPMoviePlaybackStateSeekingForward");
            break;
        case MPMoviePlaybackStateSeekingBackward:
            NSLog(@"MPMoviePlaybackStateSeekingBackward");
            break;
        default:
            break;
    }
}

- (void)playbackDidFinish:(NSNotification *)noti
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self]; // 동영상 상태 노티 제거
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:self]; // 동영상 상태 노티 제거
    
    
    NSDictionary *userInfo = [noti userInfo]; // 종료 원인 파악
    if ([[userInfo objectForKey:@"MPMoviePlayerPlaybackDidFinishReasonUserInfoKey"] intValue] == MPMovieFinishReasonUserExited)
    {
        NSLog(@"유저종료");
    }
    else
    {
        //        self.isFullSee = YES;
        NSLog(@"자연종료");
    }
    
    //    if( isStudyMode == NO )
    //    {
    //        [self dismissViewControllerAnimated:YES completion:^{
    //
    //        }];
    //    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
    }];
}

- (void)onIsPlayingAtOnceInterval
{
    isPlayingAtOnce = YES;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (void)handleSingleTap:(UITouch *)touch
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.btn_Back.alpha = !self.btn_Back.alpha;
                         self.v_Bar.alpha = !self.v_Bar.alpha;
                         self.silder.alpha = !self.silder.alpha;
                     }];
    
}



#pragma mark - BarBgImageViewDelegate
- (void)touchBegan:(CGFloat)x
{
    //    if( self.isStudyMode )
    //    {
    //        self.silder.userInteractionEnabled = NO;
    //
    //        AlertViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
    //        vc.str_Title = @"화면 이동은 수강을 완료한 후에\n시도해 주세요.";
    //        vc.ar_Buttons = @[@"닫기"];
    //        [vc setCompletionBlock:^(id completeResult) {
    //
    //        }];
    //
    //        [self presentViewController:vc animated:NO completion:nil];
    //
    //        return;
    //    }
    
    if( self.tm )
    {
        [self.tm invalidate];
        self.tm = nil;
    }
}

- (void)touchMove:(CGFloat)x
{
    
}

- (void)touchEnd:(CGFloat)x
{
    if( self.tm )
    {
        [self.tm invalidate];
        self.tm = nil;
    }
    
    self.vc_Movie.moviePlayer.currentPlaybackTime = self.vc_Movie.moviePlayer.duration * self.silder.value;
    self.tm = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(onSliderTimer) userInfo:nil repeats:YES];
}



- (void)updateVod
{
    NSLog(@"update");
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    if( self.vc_Movie.moviePlayer.currentPlaybackTime > nCurrentPage )
    {
        //        __weak __typeof(&*self)weakSelf = self;
        
        NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionary];
        [dicM_Params setObject:self.str_LangId forKey:@"languageId"];
        [dicM_Params setObject:[NSString stringWithFormat:@"%f", self.vc_Movie.moviePlayer.currentPlaybackTime * 1000] forKey:@"current"];
        [dicM_Params setObject:[NSString stringWithFormat:@"%f", self.vc_Movie.moviePlayer.duration * 1000] forKey:@"total"];
        
        [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"learn/learning/%@/progression/%@", self.str_DegreeId, self.str_LessonId]
                                            param:dicM_Params
                                       withMethod:@"PUT"
                                        withBlock:^(id resulte, NSError *error) {
                                            
                                            if( resulte )
                                            {
                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateStudyDetailNoti" object:nil];
                                            }
                                        }];
        
    }
    
    //    if( isStudyMode == NO )
    //    {
    //        nCurrentPage = self.vc_Movie.moviePlayer.currentPlaybackTime;
    //    }
    //
    //    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
    //                                        [[NSUserDefaults standardUserDefaults] objectForKey:@"UserIdx"], @"userIdx",
    //                                        [[NSUserDefaults standardUserDefaults] objectForKey:@"BrandIdx"], @"brandIdx",
    //                                        self.str_Idx, @"integrationCourseIdx",
    //                                        [NSString stringWithFormat:@"%ld", [[self.dic_Info objectForKey:@"ProcessIdx"] integerValue]], @"processIdx",
    //                                        [NSString stringWithFormat:@"%ld", [[self.dic_Info objectForKey:@"SubProcessIdx"] integerValue]], @"subProcessIdx",
    //                                        @"831", @"contentType",
    //                                        [NSString stringWithFormat:@"%ld", nCurrentPage], @"currentTime",
    //                                        [NSString stringWithFormat:@"%ld", nTotalPage], @"runningTime",
    //                                        nil];
    //
    //    [[WebAPI sharedData] callAsyncWebAPIBlock:@"course/updateSubProcessProgressRateVod"
    //                                        param:dicM_Params
    //                                     withType:@"POST"
    //                                    withBlock:^(id resulte, NSError *error) {
    //
    //                                        [GMDCircleLoader hide];
    //
    //                                        if( resulte )
    //                                        {
    //                                            //                                            NSDictionary *dic_Data = [resulte objectForKey:@"Data"];
    //                                            NSDictionary *dic_Meta = [resulte objectForKey:@"Meta"];
    //                                            NSInteger nCode = [[dic_Meta objectForKey_YM:@"ResultCd"] integerValue];
    //                                            if( nCode == 1 )
    //                                            {
    //
    //                                                nStudyCompletePage = nCurrentPage;
    //
    //                                                if( nCurrentPage == nTotalPage )
    //                                                {
    //                                                    //학습완료
    //                                                    //                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"StudyFinish" object:nil userInfo:nil];
    //                                                }
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
    //
    //                                        if( self.tm )
    //                                        {
    //                                            [self.tm invalidate];
    //                                            self.tm = nil;
    //                                        }
    //
    //                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadStudyDetailView" object:nil userInfo:nil];
    //                                    }];
}

- (void)onSliderTimer
{
    self.silder.value = self.vc_Movie.moviePlayer.currentPlaybackTime / self.vc_Movie.moviePlayer.duration;
    if( isPlayingAtOnce )
    {
        if( self.vc_Movie.moviePlayer.currentPlaybackTime > nCurrentPage )
        {
            nCurrentPage = self.vc_Movie.moviePlayer.currentPlaybackTime;
        }
    }
    
    NSInteger nCurrentTime = self.vc_Movie.moviePlayer.currentPlaybackTime;
    NSInteger nHour = nCurrentTime / (60*60);
    NSInteger nMinute = (nCurrentTime % (60*60)) / 60;
    NSInteger nSecond = (nCurrentTime % 60) % 60;
    
    if( nHour < 0 )
    {
        nHour = 0;
    }
    if( nMinute < 0 )
    {
        nMinute = 0;
    }
    if( nSecond < 0 )
    {
        nSecond = 0;
    }
    
    if( nHour > 0 )
    {
        //1시간 이상일때
        self.lb_PlayTime.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", nHour, nMinute, nSecond];
    }
    else
    {
        self.lb_PlayTime.text = [NSString stringWithFormat:@"%02ld:%02ld", nMinute, nSecond];
    }
    
    nCurrentTime = self.vc_Movie.moviePlayer.duration;
    nHour = nCurrentTime / (60*60);
    nMinute = (nCurrentTime % (60*60)) / 60;
    nSecond = (nCurrentTime % 60) % 60;
    
    if( nHour < 0 )
    {
        nHour = 0;
    }
    if( nMinute < 0 )
    {
        nMinute = 0;
    }
    if( nSecond < 0 )
    {
        nSecond = 0;
    }
    
    if( nHour > 0 )
    {
        //1시간 이상일때
        self.lb_TotalTime.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", nHour, nMinute, nSecond];
    }
    else
    {
        self.lb_TotalTime.text = [NSString stringWithFormat:@"%02ld:%02ld", nMinute, nSecond];
    }
}

- (IBAction)goMoveToPlayTime:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    NSLog(@"%f", slider.value);
}

- (IBAction)goPlayOrPause:(id)sender
{
    self.btn_PlayOrPause.selected = !self.btn_PlayOrPause.selected;
    if( self.btn_PlayOrPause.selected )
    {
        [self.vc_Movie.moviePlayer pause];
    }
    else
    {
        [self.vc_Movie.moviePlayer play];
    }
}

//- (IBAction)goStop:(id)sender
//{
//    self.btn_Stop.selected = !self.btn_Stop.selected;
//    if( self.btn_Stop.selected )
//    {
//        self.vc_Movie.moviePlayer.currentPlaybackTime = 0;
//        [self.vc_Movie.moviePlayer stop];
//    }
//    else
//    {
//        [self.vc_Movie.moviePlayer play];
//    }
//}

- (IBAction)goModalBack:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    if( self.tm )
    {
        [self.tm invalidate];
        self.tm = nil;
    }
    
    [self.vc_Movie.moviePlayer stop];
    //    self.vc_Movie = nil;
    
    //    [self dismissViewControllerAnimated:YES completion:^{
    //        
    //        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //        
    //    }];
    
    //    [super goModalBack:sender];
}


@end
