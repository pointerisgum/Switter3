//
//  HomeMainViewController.m
//  Switter
//
//  Created by macpro15 on 2017. 8. 2..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "HomeMainViewController.h"
#import "HomeThumbCell.h"
#import "HomeNewLessonCell.h"
#import "HomeLearningProcessCell.h"
#import "HomeNotiCell.h"
#import "HomeSnsImageCell.h"
#import "HomeSnsTextCell.h"
#import "HomeComplimentCell.h"
#import "LessonDetailViewController.h"
#import "LessonMainViewController.h"
#import "StudyStoryDetailViewController.h"
#import "SnsWriteViewController.h"
#import "SnsMainViewController.h"
#import "FoodCafeMainViewController.h"

@interface HomeMainViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *arM_Thumbs;
@property (nonatomic, strong) NSMutableArray *arM_NewLesson;
@property (nonatomic, strong) NSMutableArray *arM_LearningProcess;
@property (nonatomic, strong) NSMutableArray *arM_Noti;
@property (nonatomic, strong) NSMutableArray *arM_SNS;
@property (nonatomic, strong) NSMutableArray *arM_Compliment;
@property (nonatomic, strong) NSMutableDictionary *dicM_Compliment;
@property (nonatomic, strong) NSArray *ar_Colors;
//@property (nonatomic, weak) IBOutlet UIScrollView *sv_Main;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_ContentsHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_NotiHeight;
@property (nonatomic, weak) IBOutlet UIImageView *iv_Banner;
@property (nonatomic, weak) IBOutlet UICollectionView *cv_Thumb;
@property (nonatomic, weak) IBOutlet UIPageControl *pg_Thumb;

@property (nonatomic, weak) IBOutlet UICollectionView *cv_NewLesson;

@property (nonatomic, weak) IBOutlet UICollectionView *cv_LearningProcess;
@property (nonatomic, weak) IBOutlet UICollectionView *cv_Noti;
@property (nonatomic, weak) IBOutlet UICollectionView *cv_SNS;
@property (nonatomic, weak) IBOutlet UICollectionView *cv_Compliment;

@property (nonatomic, weak) IBOutlet UIImageView *iv_SnsSampleUser;
@property (nonatomic, weak) IBOutlet UILabel *lb_SnsWriteFixText;

@end

@implementation HomeMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //앱 구동시 미리 로드할 탭 미리로드 viewwill 안타고 viewdidload만 탐
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *myViewControllers = appDelegate.main.viewControllers;
    for (UINavigationController *navViewController in myViewControllers)
    {
        UIViewController *ctrl = navViewController.topViewController;
        if( [ctrl isKindOfClass:[FoodCafeMainViewController class]] )
        {
            [ctrl.view setNeedsLayout];
            [ctrl.view layoutIfNeeded];
        }
    }

    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"SNS글쓰기"];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];

    self.lb_SnsWriteFixText.attributedText = attributeString;
    
    self.iv_SnsSampleUser.layer.cornerRadius = self.iv_SnsSampleUser.frame.size.width / 2;
    self.iv_SnsSampleUser.layer.borderWidth = 1.0f;
    self.iv_SnsSampleUser.layer.borderColor = [UIColor whiteColor].CGColor;

    self.ar_Colors = [Common getCategoryColors];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [ALToastView toastInView:[UIApplication sharedApplication].keyWindow withText:@"home"];

    [self updateBanner];            //배너
    [self updateNewLesson];         //신규강의
    [self updateLearningProcess];   //학습과정
    [self updateNotice];            //공지사항
    [self updateSns];               //SNS
    [self updateMyInfo];            //매장 이야기를 들려주세요에서 내 이미지
    [self updateCompliment];        //특급칭찬
    
    [self.view setNeedsLayout];
}

- (void)viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    
    UICollectionViewFlowLayout *flowLayout = (id)self.cv_Thumb.collectionViewLayout;
    flowLayout.itemSize = self.cv_Thumb.frame.size;
    [flowLayout invalidateLayout];

    flowLayout = (id)self.cv_Noti.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(self.cv_Noti.frame.size.width - 16, flowLayout.itemSize.height);
    [flowLayout invalidateLayout];

//    self.sv_Main.contentSize = CGSizeMake(self.sv_Main.frame.size.width, self.v_LastObj.frame.origin.y + self.v_LastObj.frame.size.height + 20);
//    self.lc_ContentsHeight.constant = self.sv_Main.contentSize.height;

    [self.view layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.view layoutIfNeeded];
}

- (void)viewDidLayoutSubviews
{
    self.sv_Main.contentSize = CGSizeMake(self.sv_Main.frame.size.width, self.v_LastObj.frame.origin.y + self.v_LastObj.frame.size.height + 20);
    self.lc_ContentsHeight.constant = self.sv_Main.contentSize.height;
    
    if( self.sv_Main.contentSize.height > 1100 )
    {
        //여기 들어오게 되면 안됨
        self.sv_Main.contentSize = CGSizeMake(self.sv_Main.frame.size.width, 1069);
    }
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

- (void)updateBanner
{
    __weak __typeof(&*self)weakSelf = self;
    
//    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                        @"1", @"page",
//                                        @"5", @"size",
//                                        @"LATELY_UPDATE", @"sorting",
//                                        @"CURRENT", @"type",
//                                        nil];
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:@"banner"
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
                                                id ar_Data = [resulte objectForKey:@"data"];
                                                if( [ar_Data isKindOfClass:[NSArray class]] )
                                                {
                                                    weakSelf.arM_Thumbs = [NSMutableArray arrayWithArray:ar_Data];
                                                    weakSelf.pg_Thumb.numberOfPages = weakSelf.arM_Thumbs.count <= 1 ? 0 : weakSelf.arM_Thumbs.count;
                                                    [weakSelf.cv_Thumb reloadData];
                                                    
                                                    [weakSelf.view updateConstraintsIfNeeded];
                                                    [weakSelf.view layoutIfNeeded];
                                                }
                                            }
                                        }
                                    }];
}
- (void)updateNewLesson
{
    __weak __typeof(&*self)weakSelf = self;
    
    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        @"1", @"page",
                                        @"5", @"size",
                                        @"LATELY_UPDATE", @"sorting",
                                        @"CURRENT", @"type",
                                        nil];

    [[WebAPI sharedData] callAsyncWebAPIBlock:@"learn/degree"
                                        param:dicM_Params
                                   withMethod:@"GET"
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
                                                weakSelf.arM_NewLesson = [NSMutableArray arrayWithArray:[dic_Data objectForKey:@"content"]];
                                                [weakSelf.cv_NewLesson reloadData];
                                                
                                                [weakSelf.view updateConstraintsIfNeeded];
                                                [weakSelf.view layoutIfNeeded];
                                            }
                                        }
                                    }];
}

- (void)updateLearningProcess
{
    __weak __typeof(&*self)weakSelf = self;
    
//    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                        @"1", @"page",
//                                        @"5", @"size",
//                                        @"LATELY_UPDATE", @"sorting",
//                                        @"CURRENT", @"type",
//                                        nil];
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:@"learn/degree/category"
                                        param:nil
                                   withMethod:@"GET"
                                    withBlock:^(id resulte, NSError *error) {
                                        
                                        if( resulte )
                                        {
//                                            NSDictionary *dic_Data = [resulte objectForKey:@"data"];
                                            id dic_Meta = [resulte objectForKey:@"meta"];
                                            if( [dic_Meta isKindOfClass:[NSNull class]] )
                                            {
                                                dic_Meta = nil;
                                            }
                                            
                                            NSInteger nCode = [[dic_Meta objectForKey_YM:@"errCode"] integerValue];
                                            if( nCode == 0 )
                                            {
                                                weakSelf.arM_LearningProcess = [NSMutableArray arrayWithArray:[resulte objectForKey:@"data"]];
                                                [weakSelf.arM_LearningProcess insertObject:@{@"id":@"0", @"name":@"전체"} atIndex:0];
                                                [weakSelf.cv_LearningProcess reloadData];
                                                
                                                [weakSelf.view updateConstraintsIfNeeded];
                                                [weakSelf.view layoutIfNeeded];
                                            }
                                        }
                                    }];
}

- (void)updateNotice
{
    __weak __typeof(&*self)weakSelf = self;
    
    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        @"1", @"page",
                                        @"3", @"size",
                                        nil];
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:@"board/NOTICE/article"
                                        param:dicM_Params
                                   withMethod:@"GET"
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
                                                weakSelf.arM_Noti = [NSMutableArray arrayWithArray:[dic_Data objectForKey:@"content"]];
                                                weakSelf.lc_NotiHeight.constant = 32.f + (weakSelf.arM_Noti.count * 68);
                                                [weakSelf.cv_Noti reloadData];
                                                
                                                //여기서 조절 했는데 왜 안먹히지..
                                                [weakSelf.view updateConstraintsIfNeeded];
                                                [weakSelf.view layoutIfNeeded];
                                            }
                                        }
                                    }];
}

- (void)updateSns
{
    __weak __typeof(&*self)weakSelf = self;
    
    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        @"1", @"page",
                                        @"5", @"size",
                                        @"id,desc", @"sort",
                                        @"ALL", @"type",
                                        nil];
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:@"board/SNS/article"
                                        param:dicM_Params
                                   withMethod:@"GET"
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
                                                weakSelf.arM_SNS = [NSMutableArray arrayWithArray:[dic_Data objectForKey:@"content"]];
                                                [weakSelf.cv_SNS reloadData];
                                                
                                                [weakSelf.view updateConstraintsIfNeeded];
                                                [weakSelf.view layoutIfNeeded];
                                            }
                                        }
                                    }];
}

- (void)updateMyInfo
{
    __weak __typeof(&*self)weakSelf = self;
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:@"membership/member"
                                        param:nil
                                   withMethod:@"GET"
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
                                                id dic_Profile = [dic_Data objectForKey:@"profile"];
                                                if( [dic_Profile isKindOfClass:[NSNull class]] == NO )
                                                {
                                                    NSString *str_MyImageUrl = [dic_Profile objectForKey_YM:@"resourceUri"];
                                                    [weakSelf.iv_SnsSampleUser sd_setImageWithURL:[NSURL URLWithString:str_MyImageUrl] placeholderImage:BundleImage(@"no_image_white.png")];
                                                }
                                                else
                                                {
                                                    [weakSelf.iv_SnsSampleUser setImage:BundleImage(@"no_image_white.png")];
                                                }
                                            }
                                            else
                                            {
                                                [weakSelf.iv_SnsSampleUser setImage:BundleImage(@"no_image_white.png")];
                                            }
                                        }
                                        
                                        [weakSelf.view updateConstraintsIfNeeded];
                                        [weakSelf.view layoutIfNeeded];
                                    }];
}

- (void)updateCompliment
{
    __weak __typeof(&*self)weakSelf = self;
    
//    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                        @"1", @"page",
//                                        @"5", @"size",
////                                        @"id,desc", @"sort",
////                                        @"ALL", @"type",
//                                        nil];
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:@"retail/popular"
                                        param:nil
                                   withMethod:@"GET"
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
                                                weakSelf.dicM_Compliment = [NSMutableDictionary dictionaryWithDictionary:[dic_Data objectForKey:@"stores"]];
//                                                weakSelf.arM_Compliment = [NSMutableArray arrayWithArray:[dic_Data objectForKey:@"stores"]];
                                                [weakSelf.cv_Compliment reloadData];
                                                
                                                [weakSelf.view updateConstraintsIfNeeded];
                                                [weakSelf.view layoutIfNeeded];
                                            }
                                        }
                                    }];
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger nPage = scrollView.contentOffset.x / scrollView.frame.size.width;

    if( scrollView == self.cv_Thumb )
    {
        self.pg_Thumb.currentPage = nPage;
    }
}



#pragma mark - CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if( collectionView == self.cv_Thumb )
    {
        return self.arM_Thumbs.count;
    }
    else if( collectionView == self.cv_NewLesson )
    {
        return self.arM_NewLesson.count;
    }
    else if( collectionView == self.cv_LearningProcess )
    {
        return self.arM_LearningProcess.count;
    }
    else if( collectionView == self.cv_Noti )
    {
        return self.arM_Noti.count;
    }
    else if( collectionView == self.cv_SNS )
    {
        return self.arM_SNS.count;
    }
    else if( collectionView == self.cv_Compliment )
    {
        return self.dicM_Compliment.allKeys.count;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if( collectionView == self.cv_Thumb )
    {
        static NSString *identifier = @"HomeThumbCell";
        
        HomeThumbCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        NSDictionary *dic = self.arM_Thumbs[indexPath.row];
        
        NSString *str_ImageUrl = [dic objectForKey_YM:@"resourceUri"];
        cell.iv_Thumb.contentMode = UIViewContentModeScaleAspectFill;
        [cell.iv_Thumb sd_setImageWithURL:[NSURL URLWithString:str_ImageUrl] placeholderImage:BundleImage(@"noimage2.png")];
        cell.lb_Title.text = [dic objectForKey_YM:@"title"];
        
        return cell;
    }
    else if( collectionView == self.cv_NewLesson )
    {
        static NSString *identifier = @"HomeNewLessonCell";
        
        HomeNewLessonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        NSDictionary *dic_Main = self.arM_NewLesson[indexPath.row];
        
//        NSMutableString *strM_Level = [NSMutableString string];
//        NSArray *ar_Levels = [dic_Main objectForKey:@"levels"];
//        for( NSInteger i = 0; i < ar_Levels.count; i++ )
//        {
//            NSDictionary *dic = [ar_Levels objectAtIndex:i];
//            [strM_Level appendString:[dic objectForKey:@"text"]];
//            [strM_Level appendString:@" | "];
//        }
//        if( [strM_Level hasSuffix:@" | "] )
//        {
//            [strM_Level deleteCharactersInRange:NSMakeRange([strM_Level length]-1, 1)];
//        }
//
//        cell.lb_Tag.text = strM_Level;

        NSDictionary *dic_Category = [dic_Main objectForKey:@"category"];
        cell.lb_Tag.text = [dic_Category objectForKey_YM:@"text"];

        cell.lb_Title.text = [dic_Main objectForKey_YM:@"name"];
        
        id thumbnail = [dic_Main objectForKey:@"thumbnail"];
        if( [thumbnail isKindOfClass:[NSNull class]] == NO )
        {
            NSDictionary *dic_Thumb = [dic_Main objectForKey:@"thumbnail"];
            NSString *str_ImageUrl = [dic_Thumb objectForKey_YM:@"resourceUri"];
            [cell.iv_Thumb sd_setImageWithURL:[NSURL URLWithString:str_ImageUrl]];
        }
        
//        cell.iv_Thumb.image = BundleImage(@"main_banner_thumnail.png");
//        cell.lb_Title.text = @"title";
        
        //학습기간
        NSDictionary *dic_PeriodPolicy = [dic_Main objectForKey:@"periodPolicy"];
        NSDictionary *dic_Learning = [dic_PeriodPolicy objectForKey:@"learning"];
        BOOL isUnLimited = [[dic_Learning objectForKey:@"unlimited"] boolValue];
        TimeStruct *startTime =  [Util makeTimeWithTimeStamp:[[dic_Learning objectForKey:@"start"] doubleValue]];
        if( isUnLimited )
        {
            //무제한 학습
            cell.lb_Date.text = [NSString stringWithFormat:@"%04ld.%02ld.%02ld~무제한",
                                 startTime.nYear, startTime.nMonth, startTime.nDay];
        }
        else
        {
            TimeStruct *endTime =  [Util makeTimeWithTimeStamp:[[dic_Learning objectForKey:@"end"] doubleValue]];
            cell.lb_Date.text = [NSString stringWithFormat:@"%04ld.%02ld.%02ld~%04ld.%02ld.%02ld",
                                 startTime.nYear, startTime.nMonth, startTime.nDay,
                                 endTime.nYear, endTime.nMonth, endTime.nDay];
        }
        
        return cell;
    }
    else if( collectionView == self.cv_LearningProcess )
    {
        //학습과정
        static NSString *identifier = @"HomeLearningProcessCell";
        
        HomeLearningProcessCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        /*
         children =     (
         );
         id = 2;
         name = "\Uc5fc\Uc0c9";
         */
        NSDictionary *dic_Main = self.arM_LearningProcess[indexPath.row];
        
        [cell.btn_Item setTitle:[dic_Main objectForKey_YM:@"name"] forState:UIControlStateNormal];
        
        NSString *str_ColorHex = [self.ar_Colors objectAtIndex:indexPath.row % self.ar_Colors.count];
        [cell.btn_Item setBackgroundColor:[UIColor colorWithHexString:str_ColorHex]];
        
        return cell;
    }
    else if( collectionView == self.cv_Noti )
    {
        static NSString *identifier = @"HomeNotiCell";
        
        HomeNotiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        NSDictionary *dic_Main = self.arM_Noti[indexPath.row];
        NSDictionary *dic_Modifier = [dic_Main objectForKey:@"modifierInfo"];
        NSDictionary *dic_Register = [dic_Modifier objectForKey:@"register"];
        NSString *str_RegisterName = [dic_Register objectForKey_YM:@"name"];
        TimeStruct *time = [Util makeTimeWithTimeStamp:[[dic_Register objectForKey_YM:@"time"] doubleValue]];
        cell.lb_Date.text = [NSString stringWithFormat:@"%@ | %04ld.%02ld.%02ld", str_RegisterName, time.nYear, time.nMonth, time.nDay];
        
        NSDictionary *dic_Contents = [dic_Main objectForKey:@"contents"];
        cell.lb_Title.text = [dic_Contents objectForKey_YM:@"subject"];
        
        [cell.btn_CommentCnt setTitle:[NSString stringWithFormat:@"%@", [dic_Main objectForKey_YM:@"commentCount"]] forState:UIControlStateNormal];
        
        NSArray *ar_Thumbs = [dic_Contents objectForKey:@"images"];
        if( ar_Thumbs.count > 0 )
        {
            cell.lc_ImageWidth.constant = 60.f;
            
            NSDictionary *dic_ImageInfo = [ar_Thumbs firstObject];
            NSString *str_ImageUrl = [dic_ImageInfo objectForKey_YM:@"resourceUri"];
            [cell.iv_Thumb sd_setImageWithURL:[NSURL URLWithString:str_ImageUrl]];
        }
        else
        {
            cell.lc_ImageWidth.constant = 0.f;
        }
        
        
        return cell;
    }
    else if( collectionView == self.cv_SNS )
    {
        NSDictionary *dic_Main = self.arM_SNS[indexPath.row];
        NSDictionary *dic_Contents = [dic_Main objectForKey:@"contents"];
        NSArray *ar_Images = [dic_Contents objectForKey:@"images"];
        if( ar_Images.count > 0 )
        {
            //이미지가 있을 경우 이미지 표현
            static NSString *identifier = @"HomeSnsImageCell";
            HomeSnsImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            NSDictionary *dic_ImageInfo = [ar_Images firstObject];
            NSString *str_ImageUrl = [dic_ImageInfo objectForKey_YM:@"resourceUri"];
            [cell.iv_Thumb sd_setImageWithURL:[NSURL URLWithString:str_ImageUrl] placeholderImage:BundleImage(@"")];
            
            NSDictionary *dic_Modifier = [dic_Main objectForKey:@"modifierInfo"];
            NSDictionary *dic_Register = [dic_Modifier objectForKey:@"register"];
            NSDictionary *dic_Profile = [dic_Register objectForKey:@"profile"];
            id profile = [dic_Register objectForKey:@"profile"];
            if( [profile isKindOfClass:[NSNull class]] == NO )
            {
                NSString *str_UserImageUrl = [dic_Profile objectForKey_YM:@"resourceUri"];
                [cell.iv_User sd_setImageWithURL:[NSURL URLWithString:str_UserImageUrl] placeholderImage:BundleImage(@"no_image_white.png")];
                cell.lb_SubTitle1.text = [dic_Register objectForKey_YM:@"brandName"];
                cell.lb_SubTitle2.text = [NSString stringWithFormat:@"%@ %@", [dic_Register objectForKey_YM:@"name"], [dic_Register objectForKey_YM:@"dutyName"]];
            }
            
            return cell;
        }
        else
        {
            //이미지가 없을 경우 내용 표현
            static NSString *identifier = @"HomeSnsTextCell";
            HomeSnsTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            cell.lb_Title.text = [dic_Contents objectForKey_YM:@"body"];
            
            NSDictionary *dic_Modifier = [dic_Main objectForKey:@"modifierInfo"];
            NSDictionary *dic_Register = [dic_Modifier objectForKey:@"register"];
            id profile = [dic_Register objectForKey:@"profile"];
            if( [profile isKindOfClass:[NSNull class]] == NO )
            {
                NSDictionary *dic_Profile = [dic_Register objectForKey:@"profile"];
                NSString *str_UserImageUrl = [dic_Profile objectForKey_YM:@"resourceUri"];
                [cell.iv_User sd_setImageWithURL:[NSURL URLWithString:str_UserImageUrl] placeholderImage:BundleImage(@"no_image_white.png")];
                cell.lb_SubTitle1.text = [dic_Register objectForKey_YM:@"brandName"];
                cell.lb_SubTitle2.text = [NSString stringWithFormat:@"%@ %@", [dic_Register objectForKey_YM:@"name"], [dic_Register objectForKey_YM:@"dutyName"]];
            }

            return cell;
        }
        
        return nil;
    }
    else if( collectionView == self.cv_Compliment )
    {
        static NSString *identifier = @"HomeComplimentCell";
        
        HomeComplimentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        NSString *str_Key = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
        NSDictionary *dic = [self.dicM_Compliment objectForKey:str_Key];
        cell.lb_Area.text = [dic objectForKey:@"areaName"];
        cell.lb_StoreName.text = [dic objectForKey:@"name"];
        
        NSInteger nIconIdx = [str_Key integerValue];
        if( nIconIdx > 4 )
        {
            nIconIdx = 4;
        }
        
        NSString *str_IconName = [NSString stringWithFormat:@"main_store_icon_%ld.png", nIconIdx];
        cell.iv_Icon.image = BundleImage(str_IconName);
        
        return cell;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if( collectionView == self.cv_Thumb )
    {

    }
    else if( collectionView == self.cv_NewLesson )
    {
        NSDictionary *dic_Main = self.arM_NewLesson[indexPath.row];
        LessonDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LessonDetailViewController"];
        vc.str_Id = [NSString stringWithFormat:@"%@", [dic_Main objectForKey:@"id"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if( collectionView == self.cv_LearningProcess )
    {
        NSDictionary *dic_Main = self.arM_LearningProcess[indexPath.row];
        
        UINavigationController *navi = [self.tabBarController.viewControllers objectAtIndex:1];
        LessonMainViewController *vc = [navi.viewControllers firstObject];
        vc.isMainJump = YES;
        if( indexPath.row == 0 )
        {
            vc.dic_NonPassSelectedCategory = nil;
            vc.dic_PassSelectedCategory = nil;
        }
        else
        {
            vc.dic_NonPassSelectedCategory = dic_Main;
            vc.dic_PassSelectedCategory = dic_Main;
        }
        
        self.tabBarController.selectedIndex = 1;
    }
    else if( collectionView == self.cv_Noti )
    {
        NSDictionary *dic_Main = self.arM_Noti[indexPath.row];
        
    }
    else if( collectionView == self.cv_SNS )
    {
        NSDictionary *dic_Main = self.arM_SNS[indexPath.row];
        
        StudyStoryDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudyStoryDetailViewController"];
        vc.str_Id = [NSString stringWithFormat:@"%@", [dic_Main objectForKey:@"id"]];
        vc.isSnsMode = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if( collectionView == self.cv_Compliment )
    {
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if( collectionView == self.cv_LearningProcess )
    {
        CGSize defaultSize = [(UICollectionViewFlowLayout*)collectionViewLayout itemSize];
        
        NSDictionary *dic_Main = self.arM_LearningProcess[indexPath.row];
        NSString *str_Title = [NSString stringWithFormat:@"%@", [dic_Main objectForKey_YM:@"name"]];
        CGSize size = [(NSString*)str_Title sizeWithAttributes:NULL];
        return CGSizeMake(size.width + 40, defaultSize.height);
    }
    
    CGSize defaultSize = [(UICollectionViewFlowLayout*)collectionViewLayout itemSize];
    return defaultSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    //푸터 패딩
    CGSize defaultSize = [(UICollectionViewFlowLayout*)collectionViewLayout itemSize];
    return CGSizeMake(8.f, defaultSize.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if( collectionView == self.cv_LearningProcess )
    {
        return 8;
    }
    
    return [(UICollectionViewFlowLayout*)collectionViewLayout minimumInteritemSpacing];
}


#pragma mark - IBAction
- (IBAction)goBanner:(id)sender
{
    
}

- (IBAction)goSnsWrite:(id)sender
{
    UINavigationController *navi = [self.storyboard instantiateViewControllerWithIdentifier:@"SnsWriteNavi"];
    SnsWriteViewController *vc = [navi.viewControllers firstObject];
    [vc setCompletionAddBlock:^(id completeResult) {
        
        UINavigationController *navi = [self.tabBarController.viewControllers objectAtIndex:3];
        SnsMainViewController *vc = [navi.viewControllers firstObject];
        [vc refreshData];
    }];

    [self presentViewController:navi animated:YES completion:^{
        
    }];
}

- (IBAction)goComplimentMore:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.main.selectedIndex = 2;
    
    UINavigationController *navi = [appDelegate.main.viewControllers objectAtIndex:2];
    [navi popToRootViewControllerAnimated:NO];
    FoodCafeMainViewController *vc = [navi.viewControllers firstObject];
    [vc moveToCategory:@"칭찬릴레이"];

}

@end
