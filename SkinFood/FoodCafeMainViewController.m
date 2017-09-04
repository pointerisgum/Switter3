//
//  FoodCafeMainViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 31..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "FoodCafeMainViewController.h"
#import "FoodCateMainCategoryCell.h"
#import "HomeNotiCell.h"
#import "StudyStoryDetailViewController.h"
#import "FootCafeWriteViewController.h"

@interface FoodCafeMainViewController ()
{
    BOOL isLoading;
    NSInteger nPage;
    NSInteger nTotalCount;
    
    __block BOOL isMoveCategoty;
    NSString *str_MoveCategoryName;
}
@property (nonatomic, strong) NSMutableArray *arM_Category;
@property (nonatomic, strong) NSMutableArray *arM_List;
@property (nonatomic, strong) NSDictionary *dic_SelectedCategory;
@property (nonatomic, strong) NSDictionary *dic_SelectedSubCategory;
@property (nonatomic, weak) IBOutlet UICollectionView *cv_Category;
@property (nonatomic, weak) IBOutlet UICollectionView *cv_List;
@property (nonatomic, weak) IBOutlet UILabel *lb_SubCategory;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_SubCateHeight;
@property (nonatomic, weak) IBOutlet UIButton *btn_Write;
@property (nonatomic, weak) IBOutlet UILabel *lb_GuideText;
@end

@implementation FoodCafeMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.screenName = @"푸드카페";
    
    nPage = 1;

    self.btn_Write.hidden = YES;
    
    [self updateCategoryAndList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if( [segue.identifier isEqualToString:@"WriteSegue"] )
    {
        __weak __typeof(&*self)weakSelf = self;

        FootCafeWriteViewController *vc = segue.destinationViewController;
        vc.dic_SelectCategory = self.dic_SelectedCategory;
        [vc setCompletionAddBlock:^(id completeResult) {
            
            [weakSelf.arM_List insertObject:completeResult atIndex:0];
            [weakSelf.cv_List reloadData];
        }];
    }
}


- (void)moveToCategory:(NSString *)aMoveTitle
{
//    __weak __typeof(&*self)weakSelf = self;

    isMoveCategoty = YES;
    str_MoveCategoryName = aMoveTitle;
    
    for( NSInteger i = 0; i < self.arM_Category.count; i++ )
    {
        NSDictionary *dic = self.arM_Category[i];
        NSString *str_Text = [dic objectForKey_YM:@"name"];
        if( [str_Text isEqualToString:aMoveTitle] )
        {
            nPage = 1;
            [self.arM_List removeAllObjects];
            self.arM_List = nil;
            self.dic_SelectedCategory = dic;
            [self updateList];
            [self.cv_Category reloadData];
            self.cv_Category.contentOffset = CGPointMake(36 * i, 0);
            break;
        }
    }
}

- (void)updateCategoryAndList
{
    [self updateCategory];
}

- (void)updateCategory
{
    __weak __typeof(&*self)weakSelf = self;
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:@"board/list"
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
                                                weakSelf.arM_Category = [NSMutableArray arrayWithArray:[resulte objectForKey:@"data"]];
                                                [weakSelf.cv_Category reloadData];
                                                
//                                                if( isMoveCategoty )
//                                                {
//                                                    isMoveCategoty = NO;
//                                                    [weakSelf moveToCategory:str_MoveCategoryName];
//                                                    str_MoveCategoryName = @"";
//                                                    
////                                                    weakSelf.cv_Category.contentOffset =
////                                                    CGPointMake(weakSelf.cv_Category.contentSize.width - weakSelf.cv_Category.frame.size.width, 0);
//
//                                                }
                                            }
                                        }
                                        
                                        [weakSelf updateList];
                                    }];
}

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

    if( self.arM_Category == nil )  return; //이런 현상은 나오면 안됨 나온다면 서버오류
        
    if( self.dic_SelectedCategory == nil )
    {
        self.dic_SelectedCategory = [self.arM_Category firstObject];
    }
    
    self.btn_Write.hidden = ![[self.dic_SelectedCategory objectForKey:@"writeArticle"] boolValue];

    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionary];
    if( self.dic_SelectedSubCategory )
    {
        NSString *str_Id = [NSString stringWithFormat:@"%@", [self.dic_SelectedSubCategory objectForKey_YM:@"value"]];
        [dicM_Params setObject:str_Id forKey:@"category"];
    }
    //123
    //456
    //789
    //111
    //222
    [dicM_Params setObject:@"id,desc" forKey:@"sort"];
    [dicM_Params setObject:[NSString stringWithFormat:@"%ld", nPage] forKey:@"page"];
    [dicM_Params setObject:@"0" forKey:@"size"];

    isLoading = YES;

    NSString *str_CateIdenti = [self.dic_SelectedCategory objectForKey_YM:@"identifier"];
    [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"board/%@/article", str_CateIdenti]
                                        param:dicM_Params
                                   withMethod:@"GET"
                                    withBlock:^(id resulte, NSError *error) {
                                        
                                        isLoading = NO;
                                        
                                        nPage++;

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
                                                NSDictionary *dic_Data = [resulte objectForKey:@"data"];
                                                
                                                nTotalCount = [[dic_Data objectForKey:@"totalElements"] integerValue];

                                                if( weakSelf.cv_List && weakSelf.arM_List.count > 0 )
                                                {
                                                    //더보기시
                                                    [weakSelf.arM_List addObjectsFromArray:[dic_Data objectForKey:@"content"]];
                                                    [weakSelf.cv_List reloadData];
                                                }
                                                else
                                                {
                                                    //최초 로딩시
                                                    weakSelf.arM_List = [NSMutableArray arrayWithArray:[dic_Data objectForKey:@"content"]];
                                                }
                                                
                                                [weakSelf.cv_List reloadData];
                                            }
                                        }
                                    }];

}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if( scrollView == self.cv_List && scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height - 20 )
    {
        [self updateList];
    }
}



#pragma mark - CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if( collectionView == self.cv_Category )
    {
        return self.arM_Category.count;
    }
    
    return self.arM_List.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if( collectionView == self.cv_Category )
    {
        FoodCateMainCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FoodCateMainCategoryCell" forIndexPath:indexPath];
        
        NSDictionary *dic = self.arM_Category[indexPath.row];
        cell.lb_Title.text = [dic objectForKey_YM:@"name"];
        
        cell.iv_UnderLine.hidden = YES;
        [cell.lb_Title setFont:[UIFont fontWithName:@"Helvetica-bold" size:14.f]];
        cell.lb_Title.textColor = [UIColor colorWithRed:120.f/255.f green:120.f/255.f blue:120.f/255.f alpha:1];
        
        if( self.dic_SelectedCategory == nil )
        {
            if( indexPath.row == 0 )
            {
                cell.iv_UnderLine.hidden = NO;
                [cell.lb_Title setFont:[UIFont fontWithName:@"Helvetica-bold" size:14.f]];
                cell.lb_Title.textColor = [UIColor blackColor];
            }
        }
        else
        {
            if( [self.dic_SelectedCategory isEqual:dic] )
            {
                cell.iv_UnderLine.hidden = NO;
                [cell.lb_Title setFont:[UIFont fontWithName:@"Helvetica-bold" size:14.f]];
                cell.lb_Title.textColor = [UIColor blackColor];
            }
        }
        
        return cell;
    }
    
    HomeNotiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeNotiCell" forIndexPath:indexPath];
    
    NSDictionary *dic_Main = self.arM_List[indexPath.row];
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

- (void)updateGuideText:(NSString *)aMsg
{
    if( [aMsg rangeOfString:@"공지"].location != NSNotFound )
    {
        self.lb_GuideText.text = @"스위터 이벤트, 브랜드 소식,\n교육 관련 공지를 확인하는 공간입니다.";
    }
    else if( [aMsg rangeOfString:@"물류"].location != NSNotFound )
    {
        self.lb_GuideText.text = @"배송문의 (대한통운) 02-2657-2438, 7736\n매장 주문 문의 (PO팀) 02-597-4191 (ARS 2번-1번)\n연출물 문의 (디자인팀) 02-597-4191 (ARS 2번-2번)";
    }
    else if( [aMsg rangeOfString:@"엔젤"].location != NSNotFound )
    {
        self.lb_GuideText.text = @"제품 혹은 DP에 대한 궁금증을 매장의 푸드엔젤끼리 자유롭게 질문하고 답변하는 열린 공간입니다.";
    }
    else if( [aMsg rangeOfString:@"궁금"].location != NSNotFound )
    {
        self.lb_GuideText.text = @"질문, 건의 등을 공유하는 공간이며, 카테고리를 정확히 선택해 주셔야 유관 부서에 빠른 알림이 가능합니다.";
    }
    else if( [aMsg rangeOfString:@"칭찬"].location != NSNotFound )
    {
        self.lb_GuideText.text = @"매장의 칭찬 사례, 서비스 우수 매장 등을 공유하는 공간입니다.";
    }
    else if( [aMsg rangeOfString:@"학습자료"].location != NSNotFound )
    {
        self.lb_GuideText.text = @"제품, 성분 및 효능, 세일즈, 서비스 등의 학습자료를 확인하는 공간입니다.";
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if( collectionView == self.cv_Category )
    {
        nPage = 1;
        
        [self.arM_List removeAllObjects];
        self.arM_List = nil;

        self.dic_SelectedSubCategory = nil;
        self.lb_SubCategory.text = @"전체";
        
        NSDictionary *dic = self.arM_Category[indexPath.row];
        
        self.dic_SelectedCategory = dic;
        
        NSString *str_CateName = [self.dic_SelectedCategory objectForKey:@"name"];
        [self updateGuideText:str_CateName];
        
        [self.cv_Category reloadData];
        [self updateList];
    }
    else if( collectionView == self.cv_List )
    {
        __weak __typeof(&*self)weakSelf = self;

        NSDictionary *dic_Main = self.arM_List[indexPath.row];
        
        NSDictionary *dic_Contents = [dic_Main objectForKey:@"contents"];
        NSString *str_Subject = [dic_Contents objectForKey_YM:@"subject"];
        
        StudyStoryDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudyStoryDetailViewController"];
        vc.str_Id = [NSString stringWithFormat:@"%@", [dic_Main objectForKey:@"id"]];
        vc.isFoodMode = YES;
        vc.str_Title = str_Subject.length > 0 ? str_Subject : [self.dic_SelectedCategory objectForKey_YM:@"name"];
        vc.str_FoodIdenti = [self.dic_SelectedCategory objectForKey_YM:@"identifier"];
        vc.isUnAbleWrite = ![[self.dic_SelectedCategory objectForKey_YM:@"writeComment"] boolValue];
        [vc setCompletionUpdateBlock:^(id completeResult) {
            
            if( completeResult )
            {
                NSInteger nTargetId = [[completeResult objectForKey_YM:@"id"] integerValue];
                for( NSInteger i = 0; i < weakSelf.arM_List.count; i++ )
                {
                    NSDictionary *dic_Tmp = weakSelf.arM_List[i];
                    NSInteger nTmpId = [[dic_Tmp objectForKey_YM:@"id"] integerValue];
                    if( nTargetId == nTmpId )
                    {
                        [weakSelf.arM_List replaceObjectAtIndex:i withObject:completeResult];
                        [weakSelf.cv_List reloadData];
                        break;
                    }
                }
            }
        }];
        [vc setCompletionDeleteBlock:^(id completeResult) {
            
            if( completeResult )
            {
                NSInteger nTargetId = [[completeResult objectForKey_YM:@"id"] integerValue];
                for( NSInteger i = 0; i < weakSelf.arM_List.count; i++ )
                {
                    NSDictionary *dic_Tmp = weakSelf.arM_List[i];
                    NSInteger nTmpId = [[dic_Tmp objectForKey_YM:@"id"] integerValue];
                    if( nTargetId == nTmpId )
                    {
                        [weakSelf.arM_List removeObject:dic_Tmp];
                        [weakSelf.cv_List reloadData];
                        break;
                    }
                }
            }
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if( collectionView == self.cv_Category )
    {
        CGSize defaultSize = [(UICollectionViewFlowLayout*)collectionViewLayout itemSize];
        
        NSDictionary *dic_Cate = self.arM_Category[indexPath.row];
        NSString *str_CateName = [dic_Cate objectForKey:@"name"];
        CGSize size = [(NSString*)str_CateName sizeWithAttributes:NULL];
        return CGSizeMake(size.width + 36, defaultSize.height);
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
    //셀 사이 간격
    if( collectionView == self.cv_Category )
    {
        return 8;
    }
    
    return [(UICollectionViewFlowLayout*)collectionViewLayout minimumInteritemSpacing];
}



#pragma mark - IBAction
- (IBAction)goSearch:(id)sender
{
    
}

- (IBAction)goWrite:(id)sender
{
    
}

- (IBAction)goChooseSubCategory:(id)sender
{
    __weak __typeof(&*self)weakSelf = self;
    
    NSString *str_Board = [self.dic_SelectedCategory objectForKey_YM:@"identifier"];
    [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"board/%@/category/combo", str_Board]
                                        param:nil
                                   withMethod:@"GET"
                                    withBlock:^(id resulte, NSError *error) {
                                        
                                        [GMDCircleLoader hide];

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
                                                NSMutableArray *arM_Titles = [NSMutableArray array];
                                                [arM_Titles addObject:@"전체"];
                                                __block NSArray *ar = [NSMutableArray arrayWithArray:[resulte objectForKey:@"data"]];
                                                for( NSInteger i = 0; i < ar.count; i++ )
                                                {
                                                    NSDictionary *dic = ar[i];
                                                    [arM_Titles addObject:[dic objectForKey_YM:@"text"]];
                                                }

                                                [OHActionSheet showSheetInView:self.view
                                                                         title:nil
                                                             cancelButtonTitle:@"취소"
                                                        destructiveButtonTitle:nil
                                                             otherButtonTitles:arM_Titles
                                                                    completion:^(OHActionSheet* sheet, NSInteger buttonIndex)
                                                 {
                                                     if( buttonIndex == 0 )
                                                     {
                                                         nPage = 1;
                                                         [weakSelf.arM_List removeAllObjects];
                                                         weakSelf.arM_List = nil;

                                                         weakSelf.lb_SubCategory.text = @"전체";
                                                         weakSelf.dic_SelectedSubCategory = nil;
                                                     }
                                                     else
                                                     {
                                                         if( buttonIndex > ar.count )   return ;

                                                         nPage = 1;
                                                         [weakSelf.arM_List removeAllObjects];
                                                         weakSelf.arM_List = nil;

                                                         NSDictionary *dic = ar[buttonIndex - 1];
                                                         weakSelf.lb_SubCategory.text = [dic objectForKey_YM:@"text"];
                                                         weakSelf.dic_SelectedSubCategory = dic;
                                                     }
                                                     
                                                     [weakSelf updateList];
                                                 }];
                                            }
                                        }
                                    }];

}

@end
