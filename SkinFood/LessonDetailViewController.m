//
//  LessonDetailViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 6..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "LessonDetailViewController.h"
#import "LessonDetailContainerViewController.h"

@interface LessonDetailViewController ()
@property (nonatomic, strong) NSDictionary *dic_Info;
@property (nonatomic, weak) LessonDetailContainerViewController *container;
@property (nonatomic, weak) IBOutlet UILabel *lb_MainTitle;
@property (nonatomic, weak) IBOutlet UIImageView *iv_Thumb;
@property (nonatomic, weak) IBOutlet UILabel *lb_Title;
@property (nonatomic, weak) IBOutlet UILabel *lb_ReqDate;       //수강신청가능기간
@property (nonatomic, weak) IBOutlet UILabel *lb_StudyDate;     //학습기간
@property (nonatomic, weak) IBOutlet UILabel *lb_Tag;
@property (nonatomic, weak) IBOutlet UIButton *btn_Study;
@property (nonatomic, weak) IBOutlet UIButton *btn_Study2;
@property (nonatomic, weak) IBOutlet UIButton *btn_List;    //목록
@property (nonatomic, weak) IBOutlet UIButton *btn_More;    //더보기
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_LessonHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_TabTop;
@end

@implementation LessonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.screenName = @"교육과정 상세";
    self.lc_LessonHeight.constant = 0.f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateLearning];
}

- (void)viewDidLayoutSubviews
{
    NSLog(@"%@", NSStringFromCGRect(self.container.view.frame));
//    LessonDetailContainerViewController *vc = (SearchContainerViewController *)self.parentViewController;
//    self.view.frame = CGRectMake(0, 0, vc.view.frame.size.width, vc.view.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedContainer"])
    {
        self.container = segue.destinationViewController;
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

- (void)updateTopView
{
    self.lb_MainTitle.text = [self.dic_Info objectForKey:@"name"];
    
    NSDictionary *dic_Category = [self.dic_Info objectForKey:@"category"];
    self.lb_Tag.text = [dic_Category objectForKey_YM:@"text"];
    
    self.lb_Title.text = [self.dic_Info objectForKey_YM:@"name"];
    
    id thumbnail = [self.dic_Info objectForKey:@"thumbnail"];
    if( [thumbnail isKindOfClass:[NSNull class]] == NO )
    {
        NSDictionary *dic_Thumb = [self.dic_Info objectForKey:@"thumbnail"];
        NSString *str_ImageUrl = [dic_Thumb objectForKey:@"resourceUri"];
        [self.iv_Thumb sd_setImageWithURL:[NSURL URLWithString:str_ImageUrl]];
    }
    
    //        cell.iv_Thumb.image = BundleImage(@"main_banner_thumnail.png");
    //        cell.lb_Title.text = @"title";
    
    //수강신청가능기간
    NSDictionary *dic_PeriodPolicy = [self.dic_Info objectForKey:@"periodPolicy"];
    NSDictionary *dic_Register = [dic_PeriodPolicy objectForKey:@"register"];
    BOOL isUnLimited = [[dic_Register objectForKey:@"unlimited"] boolValue];
    TimeStruct *startTime =  [Util makeTimeWithTimeStamp:[[dic_Register objectForKey:@"start"] doubleValue]];
    if( isUnLimited )
    {
        //무제한 학습
        self.lb_ReqDate.text = [NSString stringWithFormat:@"%04ld.%02ld.%02ld~무제한",
                                startTime.nYear, startTime.nMonth, startTime.nDay];
    }
    else
    {
        TimeStruct *endTime =  [Util makeTimeWithTimeStamp:[[dic_Register objectForKey:@"end"] doubleValue]];
        self.lb_ReqDate.text = [NSString stringWithFormat:@"%04ld.%02ld.%02ld~%04ld.%02ld.%02ld",
                                startTime.nYear, startTime.nMonth, startTime.nDay,
                                endTime.nYear, endTime.nMonth, endTime.nDay];
    }
    
    //학습기간
    NSDictionary *dic_Learning = [dic_PeriodPolicy objectForKey:@"learning"];
    isUnLimited = [[dic_Learning objectForKey:@"unlimited"] boolValue];
    startTime = nil;
    startTime =  [Util makeTimeWithTimeStamp:[[dic_Learning objectForKey:@"start"] doubleValue]];
    if( isUnLimited )
    {
        //무제한 학습
        self.lb_StudyDate.text = [NSString stringWithFormat:@"%04ld.%02ld.%02ld~무제한",
                                startTime.nYear, startTime.nMonth, startTime.nDay];
    }
    else
    {
        TimeStruct *endTime =  [Util makeTimeWithTimeStamp:[[dic_Learning objectForKey:@"end"] doubleValue]];
        self.lb_StudyDate.text = [NSString stringWithFormat:@"%04ld.%02ld.%02ld~%04ld.%02ld.%02ld",
                                startTime.nYear, startTime.nMonth, startTime.nDay,
                                endTime.nYear, endTime.nMonth, endTime.nDay];
    }

    
    //필수와 선택이 있다
    
    //버튼 상태 업데이트
//    NSDictionary *dic_LearningStatus = [self.dic_Info objectForKey:@"learningStatus"];
//    NSString *str_Status = [dic_LearningStatus objectForKey:@"value"];
    
    NSDictionary *dic_LearnerType = [self.dic_Info objectForKey_YM:@"learnerType"];
    NSString *str_LearnerType = [dic_LearnerType objectForKey_YM:@"value"];
    if( [str_LearnerType isEqualToString:@"LEARNER"] ||
       [str_LearnerType isEqualToString:@"REVIEW"] ||
       [str_LearnerType isEqualToString:@"AFTER_LEARNING"] ||
       [str_LearnerType isEqualToString:@"LEARNING"] )
    {
        //학습중이거나 복습일 경우 window api를 호출해서 학습할 내용을 가져온다
//        [self callWindowApi];
    }
    
    NSArray *ar_Action = [self.dic_Info objectForKey:@"actions"];
    self.lc_LessonHeight.constant = ar_Action.count * 48.f;
    for( NSInteger i = 0; i < ar_Action.count; i++ )
    {
        NSString *str_Status = ar_Action[i];
        NSLog(@"%@", str_Status);
        
        if( i == 0 )
        {
            if( [str_Status isEqualToString:@"REGIST"] )
            {
                //학습하기 버튼 노출
                //REGIST: 수강신청 행동 가능
                [self.btn_Study setTitle:@"수강신청" forState:0];
                [self.btn_Study addTarget:self action:@selector(onReqStudy:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if( [str_Status isEqualToString:@"REGIST_CANCEL"] )
            {
                //REGIST_CANCEL: 수강 신청 취소 행동 가능
                [self.btn_Study setTitle:@"수강신청 취소" forState:0];
                [self.btn_Study addTarget:self action:@selector(onCancelStudy:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if( [str_Status isEqualToString:@"LEARNING"] )
            {
                //LEARNING: 학습하기 행동 가능
                [self.btn_Study setTitle:@"학습하기" forState:0];
                [self.btn_Study addTarget:self action:@selector(onStartStudy:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if( [str_Status isEqualToString:@"REVIEW"] || [str_Status isEqualToString:@"AFTER_LEARNING"] )
            {
                //REVIEW: 복습하기 행동 가능
                [self.btn_Study setTitle:@"복습하기" forState:0];
                [self.btn_Study addTarget:self action:@selector(onStartStudy:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else if( i == 1 )
        {
            if( [str_Status isEqualToString:@"REGIST"] )
            {
                //학습하기 버튼 노출
                //REGIST: 수강신청 행동 가능
                [self.btn_Study2 setTitle:@"수강신청" forState:0];
                [self.btn_Study2 addTarget:self action:@selector(onReqStudy:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if( [str_Status isEqualToString:@"REGIST_CANCEL"] )
            {
                //REGIST_CANCEL: 수강 신청 취소 행동 가능
                [self.btn_Study2 setTitle:@"수강신청 취소" forState:0];
                [self.btn_Study2 addTarget:self action:@selector(onCancelStudy:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if( [str_Status isEqualToString:@"LEARNING"] )
            {
                //LEARNING: 학습하기 행동 가능
                [self.btn_Study setTitle:@"학습하기" forState:0];
                [self.btn_Study addTarget:self action:@selector(onStartStudy:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if( [str_Status isEqualToString:@"REVIEW"] || [str_Status isEqualToString:@"AFTER_LEARNING"] )
            {
                //REVIEW: 복습하기 행동 가능
                [self.btn_Study2 setTitle:@"복습하기" forState:0];
                [self.btn_Study addTarget:self action:@selector(onStartStudy:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    
}

- (void)updateLearning
{
    __weak __typeof(&*self)weakSelf = self;

    [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"learn/degree/%@", self.str_Id]
                                        param:nil
                                   withMethod:@"GET"
                                    withBlock:^(id resulte, NSError *error) {
                                        
                                        if( resulte )
                                        {
                                            weakSelf.dic_Info = [resulte objectForKey:@"data"];
                                            id dic_Meta = [resulte objectForKey:@"meta"];
                                            if( [dic_Meta isKindOfClass:[NSNull class]] )
                                            {
                                                dic_Meta = nil;
                                            }
                                            
                                            NSInteger nCode = [[dic_Meta objectForKey_YM:@"errCode"] integerValue];
                                            if( nCode == 0 )
                                            {
                                                [weakSelf updateTopView];
                                                [weakSelf.container updateData:weakSelf.dic_Info];
                                            }
                                            
//                                            //test용 코드
//                                            [weakSelf buyLesson];

                                        }
                                    }];
}


#pragma mark - IBAction
- (IBAction)goKakao:(id)sender
{
    
}

- (void)onReqStudy:(UIButton *)btn
{
    //수강신청
    __weak __typeof(&*self)weakSelf = self;
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"learn/degree/%@/enroll", self.str_Id]
                                        param:nil
                                   withMethod:@"POST"
                                    withBlock:^(id resulte, NSError *error) {
                                        
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
                                                [weakSelf updateLearning];
                                            }
                                        }
                                    }];
}

- (void)onCancelStudy:(UIButton *)btn
{
    __weak __typeof(&*self)weakSelf = self;
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"learn/degree/%@/enroll", self.str_Id]
                                        param:nil
                                   withMethod:@"DELETE"
                                    withBlock:^(id resulte, NSError *error) {
                                        
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
                                                [weakSelf updateLearning];
                                            }
                                        }
                                    }];
}

- (void)onStartStudy:(UIButton *)btn
{
    //start api 호출, 이건 학습하기 버튼을 누를때 한번만 호출
    __weak __typeof(&*self)weakSelf = self;
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"learn/learning/%@/start", self.str_Id]
                                        param:nil
                                   withMethod:@"POST"
                                    withBlock:^(id resulte, NSError *error) {
                                        
                                        [weakSelf updateLearning];
                                    }];
}

- (void)callWindowApi
{
    __weak __typeof(&*self)weakSelf = self;
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"learn/learning/%@/window", self.str_Id]
                                        param:nil
                                   withMethod:@"POST"
                                    withBlock:^(id resulte, NSError *error) {
                                        
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
                                                //                                                [weakSelf updateLearning];
                                            }
                                        }
                                    }];
}

//- (IBAction)goStudy:(id)sender
//{
////    NSArray *ar_Action = [self.dic_Info objectForKey:@"actions"];
////    if( ar_Action.count > 0 )
////    {
////        NSString *str_Status = [ar_Action firstObject];
////        if( [str_Status isEqualToString:@"REGIST"] )
////        {
////            //학습하기 버튼 노출
////            //REGIST: 수강신청 행동 가능
////            self.lc_LessonHeight.constant = 48.f;
////            [self.btn_Study setTitle:@"학습 신청하기" forState:0];
////        }
////        else if( [str_Status isEqualToString:@"REGIST_CANCEL"] )
////        {
////            //학습하기 버튼 숨김
////            //REGIST_CANCEL: 수강 신청 취소 행동 가능
////            self.lc_LessonHeight.constant = 78.f;
////            [self.btn_Study setTitle:@"학습 하기" forState:0];
////        }
////        else if( [str_Status isEqualToString:@"LEARNING"] )
////        {
////            //LEARNING: 학습하기 행동 가능
////            self.lc_LessonHeight.constant = 0.f;
////        }
////        else if( [str_Status isEqualToString:@"REVIEW"] )
////        {
////            //REVIEW: 복습하기 행동 가능
////            self.lc_LessonHeight.constant = 48.f;
////            [self.btn_Study setTitle:@"다시 공부하기" forState:0];
////        }
////    }
//    
//    
//    __weak __typeof(&*self)weakSelf = self;
//    
//    [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"learn/degree/%@/enroll", self.str_Id]
//                                        param:nil
//                                   withMethod:@"POST"
//                                    withBlock:^(id resulte, NSError *error) {
//                                        
//                                        if( resulte )
//                                        {
//                                            NSDictionary *dic_Data = [resulte objectForKey:@"data"];
//                                            id dic_Meta = [resulte objectForKey:@"meta"];
//                                            if( [dic_Meta isKindOfClass:[NSNull class]] )
//                                            {
//                                                dic_Meta = nil;
//                                            }
//                                            
//                                            NSInteger nCode = [[dic_Meta objectForKey_YM:@"errCode"] integerValue];
//                                            if( nCode == 0 )
//                                            {
//                                                [weakSelf updateLearning];
//                                            }
//                                        }
//                                    }];
//
//    
//    
//}
//
//- (IBAction)goStudyCancel:(id)sender
//{
//    __weak __typeof(&*self)weakSelf = self;
//    
//    [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"learn/degree/%@/enroll", self.str_Id]
//                                        param:nil
//                                   withMethod:@"DELETE"
//                                    withBlock:^(id resulte, NSError *error) {
//                                        
//                                        if( resulte )
//                                        {
//                                            NSDictionary *dic_Data = [resulte objectForKey:@"data"];
//                                            id dic_Meta = [resulte objectForKey:@"meta"];
//                                            if( [dic_Meta isKindOfClass:[NSNull class]] )
//                                            {
//                                                dic_Meta = nil;
//                                            }
//                                            
//                                            NSInteger nCode = [[dic_Meta objectForKey_YM:@"errCode"] integerValue];
//                                            if( nCode == 0 )
//                                            {
//                                                [weakSelf updateLearning];
//                                            }
//                                        }
//                                    }];
//}

- (IBAction)goList:(id)sender
{
    if( self.btn_List.selected )    return;
    
    self.btn_List.selected = YES;
    self.btn_More.selected = NO;
    
    [self.container addViewWithIdx:0];
    [self.container updateData:self.dic_Info];
}

- (IBAction)goMore:(id)sender
{
    if( self.btn_More.selected )    return;
    
    self.btn_List.selected = NO;
    self.btn_More.selected = YES;
    
    [self.container addViewWithIdx:1];
    [self.container updateData:self.dic_Info];
}

- (void)buyLesson
{
    __weak __typeof(&*self)weakSelf = self;

    [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"sales/goods/%@/billing", self.str_Id]
                                        param:nil
                                   withMethod:@"POST"
                                    withBlock:^(id resulte, NSError *error) {
                                        
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
                                                NSString *str_BillingId = [NSString stringWithFormat:@"%@", [dic_Data objectForKey:@"id"]];
                                                [weakSelf buyLesson2:str_BillingId];
                                            }
                                        }
                                    }];
    
}

- (void)buyLesson2:(NSString *)aBillingId
{
    [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"sales/billing/%@/purchase", aBillingId]
                                        param:nil
                                   withMethod:@"POST"
                                    withBlock:^(id resulte, NSError *error) {
                                        
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

                                            }
                                        }
                                    }];

    
}

@end
