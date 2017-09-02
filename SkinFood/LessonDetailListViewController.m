//
//  LessonDetailListViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 6..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "LessonDetailListViewController.h"
#import "LessonDetailListTextCell.h"
#import "LessonDetailListCollectionCell.h"
#import "ImageLessonViewController.h"
#import "MoviePlayerViewController.h"
#import "PDFLessonViewController.h"
#import "TotalWebViewController.h"
#import "ImagePlayerViewController.h"

@interface LessonDetailListHeaderCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *lb_Title;
@end

@implementation LessonDetailListHeaderCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    self.contentView.frame = self.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
}
@end

@interface LessonDetailListViewController ()
@property (nonatomic, strong) NSDictionary *dic_Info;
//@property (nonatomic, strong) NSDictionary *dic_Window;
//@property (nonatomic, strong) NSMutableArray *arM_TotalList;
@property (nonatomic, strong) NSMutableDictionary *dicM_Section;
@property (nonatomic, strong) NSMutableArray *arM_Section;
@property (nonatomic, strong) NSMutableArray *arM_Lesson;
@property (nonatomic, strong) NSMutableArray *arM_Exam;
@property (nonatomic, strong) NSMutableArray *arM_Survey;
@property (nonatomic, weak) IBOutlet UITableView *tbv_List;
@end

@implementation LessonDetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tbv_List.hidden = YES;
    
//    NSArray *ar_Lesson = self.dic_Info
}

- (void)viewDidLayoutSubviews
{
    NSLog(@"self frame : %@", NSStringFromCGRect(self.view.frame));
    //    LessonDetailContainerViewController *vc = (SearchContainerViewController *)self.parentViewController;
    //    self.view.frame = CGRectMake(0, 0, vc.view.frame.size.width, vc.view.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [self updateView:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

    self.tbv_List.hidden = NO;
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

- (void)updateView:(NSDictionary *)dic
{
    if( dic )
    {
        self.dic_Info = dic;
    }
    
    if( self.dic_Info )
    {
        NSDictionary *dic_LearnerType = [self.dic_Info objectForKey_YM:@"learnerType"];
        NSString *str_LearnerType = [dic_LearnerType objectForKey_YM:@"value"];
        if( [str_LearnerType isEqualToString:@"LEARNER"] || [str_LearnerType isEqualToString:@"REVIEW"] || [str_LearnerType isEqualToString:@"LEARNING"] )
        {
            //학습중이거나 복습일 경우 window api를 호출해서 학습할 내용을 가져온다
            [self updateWindowApi];
        }
        
        [self updateStatus];
    }
}

- (void)updateStatus
{
    self.arM_Section = [NSMutableArray array];
    self.arM_Lesson = [NSMutableArray array];
    self.arM_Exam = [NSMutableArray array];
    self.arM_Survey = [NSMutableArray array];

    //학습
    NSArray *ar_Lesson = [self.dic_Info objectForKey:@"lessons"];
    if( ar_Lesson.count > 0 )
    {
        [self.arM_Section addObject:@"lessons"];
        self.arM_Lesson = [NSMutableArray arrayWithArray:ar_Lesson];
    }
    
    //시험
    id exams = [self.dic_Info objectForKey:@"exams"];
    if( [exams isKindOfClass:[NSNull class]] == NO )
    {
        NSArray *ar_Exam = [self.dic_Info objectForKey:@"exams"];   //시험
        if( ar_Exam.count > 0 )
        {
            [self.arM_Section addObject:@"exams"];
            self.arM_Exam = [NSMutableArray arrayWithArray:ar_Exam];
        }
    }
    
    //만족도
    id survey = [self.dic_Info objectForKey:@"survey"];
    if( [survey isKindOfClass:[NSNull class]] == NO )
    {
//        NSArray *ar_Survey = [self.dic_Info objectForKey:@"survey"];    //만족도
        if( survey )
        {
            [self.arM_Section addObject:@"survey"];
            [self.arM_Survey addObject:survey];
        }
    }
    
    [self.tbv_List reloadData];
}

- (void)updateWindowApi
{
    __weak __typeof(&*self)weakSelf = self;
    
    NSString *str_Id = [NSString stringWithFormat:@"%@", [self.dic_Info objectForKey:@"id"]];
    [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"learn/learning/%@/window", str_Id]
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
                                                weakSelf.dic_Info = [NSDictionary dictionaryWithDictionary:dic_Data];
                                                [weakSelf updateStatus];
                                            }
                                        }
                                    }];
}



#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arM_Section.count;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *str_Type = [self.arM_Section objectAtIndex:section];
    if( [str_Type isEqualToString:@"lessons"] )
    {
        return self.arM_Lesson.count;
    }
    else if( [str_Type isEqualToString:@"exams"] )
    {
        return self.arM_Exam.count;
    }
    else if( [str_Type isEqualToString:@"survey"] )
    {
        return self.arM_Survey.count;
    }
    
    return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LessonDetailListTextCell";
    LessonDetailListTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    id obj = nil;
    NSString *str_Type = [self.arM_Section objectAtIndex:indexPath.section];
    if( [str_Type isEqualToString:@"lessons"] )
    {
        obj = self.arM_Lesson[indexPath.row];
        
        NSDictionary *dic = obj;
        NSDictionary *dic_ContentType = [dic objectForKey:@"contentType"];
        NSString *str_ContentType = [dic_ContentType objectForKey:@"value"];
        
        BOOL isIconOn = NO;
        NSDictionary *dic_Status = [dic objectForKey:@"status"];
        if( dic_Status != nil )
        {
            NSString *str_Status = [dic_Status objectForKey:@"value"];
            if( [str_Status isEqualToString:@"WAITING"] == NO )
            {
                isIconOn = YES;
            }
        }
        
        if( isIconOn )
        {
            if( [str_ContentType isEqualToString:@"SLIDE"] )
            {
                [cell.iv_Icon setImage:BundleImage(@"study_detail_list_image_icon.png")];
            }
            else if( [str_ContentType isEqualToString:@"VIDEO"] )
            {
                [cell.iv_Icon setImage:BundleImage(@"study_detail_list_video_icon.png")];
            }
            else if( [str_ContentType isEqualToString:@"PDF"] )
            {
                [cell.iv_Icon setImage:BundleImage(@"study_detail_list_pdf_icon.png")];
            }
            else if( [str_ContentType isEqualToString:@"EXAM_PAPER"] )
            {
                [cell.iv_Icon setImage:BundleImage(@"study_detail_list_test_icon.png")];
            }
        }
        else
        {
            if( [str_ContentType isEqualToString:@"SLIDE"] )
            {
                [cell.iv_Icon setImage:BundleImage(@"study_detail_list_image_icon_n.png")];
            }
            else if( [str_ContentType isEqualToString:@"VIDEO"] )
            {
                [cell.iv_Icon setImage:BundleImage(@"study_detail_list_video_icon_n.png")];
            }
            else if( [str_ContentType isEqualToString:@"PDF"] )
            {
                [cell.iv_Icon setImage:BundleImage(@"study_detail_list_pdf_icon_n.png")];
            }
            else if( [str_ContentType isEqualToString:@"EXAM_PAPER"] )
            {
                [cell.iv_Icon setImage:BundleImage(@"study_detail_list_test_icon_n.png")];
            }
        }
        
        cell.lb_Title.text = [dic objectForKey:@"name"];
    }
    else if( [str_Type isEqualToString:@"exams"] )
    {
        obj = self.arM_Exam[indexPath.row];
        
        if( [obj isKindOfClass:[NSDictionary class]] )
        {
            NSDictionary *dic_Tmp = obj;
            cell.lb_Title.text = [dic_Tmp objectForKey:@"name"];
            
            BOOL isIconOn = NO;
            NSDictionary *dic_Status = [dic_Tmp objectForKey:@"status"];
            if( dic_Status != nil )
            {
                NSString *str_Status = [dic_Status objectForKey:@"value"];
                if( [str_Status isEqualToString:@"WAITING"] == NO )
                {
                    isIconOn = YES;
                }
            }
            
            if( isIconOn )
            {
                [cell.iv_Icon setImage:BundleImage(@"study_detail_list_test_icon.png")];
            }
            else
            {
                [cell.iv_Icon setImage:BundleImage(@"study_detail_list_test_icon_n.png")];
            }
        }
        else
        {
            cell.lb_Title.text = [obj objectForKey:@"name"];
            [cell.iv_Icon setImage:BundleImage(@"study_detail_list_test_icon_n.png")];
        }
    }
    else if( [str_Type isEqualToString:@"survey"] )
    {
        obj = self.arM_Survey[indexPath.row];

        if( [obj isKindOfClass:[NSDictionary class]] )
        {
            NSDictionary *dic_Tmp = obj;
            cell.lb_Title.text = [dic_Tmp objectForKey:@"name"];
            
            BOOL isIconOn = NO;
            NSDictionary *dic_Status = [dic_Tmp objectForKey:@"status"];
            if( dic_Status != nil )
            {
                NSString *str_Status = [dic_Status objectForKey:@"value"];
                if( [str_Status isEqualToString:@"WAITING"] == NO )
                {
                    isIconOn = YES;
                }
            }
            
            if( isIconOn )
            {
                [cell.iv_Icon setImage:BundleImage(@"study_detail_list_level_icon.png")];
            }
            else
            {
                [cell.iv_Icon setImage:BundleImage(@"study_detail_list_level_icon_n.png")];
            }
        }
        else
        {
            cell.lb_Title.text = [obj objectForKey:@"name"];
            [cell.iv_Icon setImage:BundleImage(@"study_detail_list_level_icon_n.png")];
        }
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *CellIdentifier = @"LessonDetailListHeaderCell";
    LessonDetailListHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *str_Type = [self.arM_Section objectAtIndex:section];
    if( [str_Type isEqualToString:@"lessons"] )
    {
        cell.lb_Title.text = @"학습";
    }
    else if( [str_Type isEqualToString:@"exams"] )
    {
        cell.lb_Title.text = @"시험";
    }
    else if( [str_Type isEqualToString:@"survey"] )
    {
        cell.lb_Title.text = @"만족도";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic_LearnerType = [self.dic_Info objectForKey_YM:@"learnerType"];
    __block NSString *str_LearnerType = [dic_LearnerType objectForKey_YM:@"value"];
    
    
    NSString *str_Type = [self.arM_Section objectAtIndex:indexPath.section];
    if( [str_Type isEqualToString:@"lessons"] )
    {
        NSDictionary *dic = self.arM_Lesson[indexPath.row];

        BOOL isIconOn = NO;
        NSDictionary *dic_Status = [dic objectForKey:@"status"];
        __block NSString *str_Status = @"";
        if( dic_Status != nil )
        {
            str_Status = [dic_Status objectForKey:@"value"];
            if( [str_Status isEqualToString:@"WAITING"] == NO )
            {
                isIconOn = YES;
            }
        }
        
        if( isIconOn == NO )
        {
            //아직 시작하지 않음
            return;
        }
        
        if( [str_LearnerType isEqualToString:@"LEARNER"] || [str_LearnerType isEqualToString:@"REVIEW"] || [str_LearnerType isEqualToString:@"LEARNING"] )
        {
            //학습중이거나 복습일 경우에만 학습가능
            NSDictionary *dic_ContentType = [dic objectForKey:@"contentType"];
            NSString *str_ContentType = [dic_ContentType objectForKey:@"value"];
            if( [str_ContentType isEqualToString:@"SLIDE"] )
            {
                __weak __typeof(&*self)weakSelf = self;
                
                NSString *str_DegreeId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"degreeId"]];
                NSString *str_LessonId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"id"]];
                NSArray *ar_Language = [NSArray arrayWithArray:[dic objectForKey:@"languages"]];
                NSString *str_LangId = @"";
                if( ar_Language.count > 0 )
                {
                    NSDictionary *dic_Language = [ar_Language firstObject];
                    str_LangId = [dic_Language objectForKey_YM:@"id"];
                }
                [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"learn/learning/%@/lesson/%@/language/%@",
                                                           str_DegreeId, str_LessonId, str_LangId]
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
                                                            NSDictionary *dic_Images = [dic_Data objectForKey:@"file"];
                                                            NSArray *ar_ContentsList = [dic_Images objectForKey:@"subFileResourceUri"];
                                                            if( ar_ContentsList.count <= 0 )
                                                            {
                                                                [Util showToast:@"이미지가 없습니다"];
                                                                return ;
                                                            }
                                                            
                                                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                            ImagePlayerViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ImagePlayerViewController"];
                                                            vc.dic_Info = [NSDictionary dictionaryWithDictionary:dic_Data];
//                                                            vc.str_Idx = str_LessonId;
                                                            vc.ar_List = ar_ContentsList;
                                                            vc.str_DegreeId = str_DegreeId;
                                                            vc.str_LessonId = str_LessonId;
                                                            vc.str_LangId = str_LangId;
                                                            vc.isStudyMode = ![str_Status isEqualToString:@"COMPLETION"];
                                                            vc.nStartPage = [[dic_Data objectForKey_YM:@"recent"] integerValue];
                                                            
                                                            [weakSelf presentViewController:vc animated:YES completion:^{
                                                                
                                                            }];

                                                        }
                                                    }
                                                }];

                
            }
            else if( [str_ContentType isEqualToString:@"VIDEO"] )
            {
                __weak __typeof(&*self)weakSelf = self;
                
                NSString *str_DegreeId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"degreeId"]];
                NSString *str_LessonId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"id"]];
                NSArray *ar_Language = [NSArray arrayWithArray:[dic objectForKey:@"languages"]];
                NSString *str_LangId = @"";
                if( ar_Language.count > 0 )
                {
                    NSDictionary *dic_Language = [ar_Language firstObject];
                    str_LangId = [dic_Language objectForKey_YM:@"id"];
                }
                [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"learn/learning/%@/lesson/%@/language/%@",
                                                           str_DegreeId, str_LessonId, str_LangId]
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
                                                            NSDictionary *dic_Mp4 = [dic_Data objectForKey:@"mp4"];
                                                            MoviePlayerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MoviePlayerViewController"];
                                                            vc.dic_Info = [NSDictionary dictionaryWithDictionary:dic_Data];
                                                            vc.str_Url = [dic_Mp4 objectForKey_YM:@"resourceUri"];
                                                            vc.str_DegreeId = str_DegreeId;
                                                            vc.str_LessonId = str_LessonId;
                                                            vc.str_LangId = str_LangId;
                                                            vc.isStudyMode = ![str_Status isEqualToString:@"COMPLETION"];
                                                            vc.fStartTime = [[dic_Data objectForKey_YM:@"recent"] floatValue] * 0.001;
                                                            vc.fTotalTime = [[dic_Data objectForKey_YM:@"total"] floatValue] * 0.001;
                                                            
                                                            [self presentViewController:vc
                                                                               animated:YES
                                                                             completion:^{
                                                                                 
                                                                             }];
                                                        }
                                                    }
                                                }];
            }
            else if( [str_ContentType isEqualToString:@"PDF"] )
            {
                TotalWebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TotalWebViewController"];
                vc.str_Title = @"PDF 학습";
                vc.str_Url = @"pdf_lesson.html";
                vc.str_DegreeId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"degreeId"]];
                vc.str_LessonId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"id"]];
                vc.dic_Info = dic;
                [self presentViewController:vc
                                   animated:YES
                                 completion:^{
                                     
                                 }];
            }
            else if( [str_ContentType isEqualToString:@"EXAM_PAPER"] )
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                TotalWebViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TotalWebViewController"];
                vc.str_Title = @"형성평가";
                vc.str_Url = @"exam_lesson.html";
                vc.str_DegreeId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"degreeId"]];
                vc.str_LessonId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"id"]];
                vc.dic_Info = dic;
                [self presentViewController:vc
                                   animated:YES
                                 completion:^{
                                     
                                 }];
            }
        }
    }
    else if( [str_Type isEqualToString:@"exams"] )
    {
        NSDictionary *dic = self.arM_Exam[indexPath.row];
        
        BOOL isIconOn = NO;
        NSDictionary *dic_Status = [dic objectForKey:@"status"];
        if( dic_Status != nil )
        {
            NSString *str_Status = [dic_Status objectForKey:@"value"];
            if( [str_Status isEqualToString:@"WAITING"] == NO )
            {
                isIconOn = YES;
            }
        }
        
        if( isIconOn == NO )
        {
            //아직 시작하지 않음
            return;
        }
        
        if( [str_LearnerType isEqualToString:@"LEARNER"] || [str_LearnerType isEqualToString:@"REVIEW"] || [str_LearnerType isEqualToString:@"LEARNING"] )
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TotalWebViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TotalWebViewController"];
            vc.str_Title = @"시험";
            vc.str_Url = @"exam_degree.html";
            vc.str_DegreeId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"degreeId"]];
            vc.str_LessonId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"id"]];
            vc.dic_Info = dic;
            vc.str_TokenId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"examineeId"]];
            vc.webViewType = kExam;
            [self presentViewController:vc
                               animated:YES
                             completion:^{
                                 
                             }];
        }
    }
    else if( [str_Type isEqualToString:@"survey"] )
    {
        NSDictionary *dic = self.arM_Survey[indexPath.row];
        
        BOOL isIconOn = NO;
        NSDictionary *dic_Status = [dic objectForKey:@"status"];
        if( dic_Status != nil )
        {
            NSString *str_Status = [dic_Status objectForKey:@"value"];
            if( [str_Status isEqualToString:@"WAITING"] == NO )
            {
                isIconOn = YES;
            }
        }
        
        if( isIconOn == NO )
        {
            //아직 시작하지 않음
            return;
        }
        
        if( [str_LearnerType isEqualToString:@"LEARNER"] || [str_LearnerType isEqualToString:@"REVIEW"] || [str_LearnerType isEqualToString:@"LEARNING"] )
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TotalWebViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TotalWebViewController"];
            vc.str_Title = @"만족도";
            vc.str_Url = @"survey_degree.html";
            vc.str_DegreeId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"degreeId"]];
            vc.str_LessonId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"id"]];
            vc.dic_Info = dic;
            vc.str_TokenId = [NSString stringWithFormat:@"%@", [dic objectForKey_YM:@"respondentId"]];
            vc.webViewType = kSurvey;
            [self presentViewController:vc
                               animated:YES
                             completion:^{
                                 
                             }];
        }
    }
    
}

@end

