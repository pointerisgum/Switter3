//
//  FoodCafeSearchViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 31..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "FoodCafeSearchViewController.h"
#import "SearchBarCodeViewController.h"
#import "SearchKeyboardAccView.h"
#import "LessonSearchResultViewController.h"
#import "SnsCategoryViewController.h"
#import "HomeNotiCell.h"
#import "StudyStoryDetailViewController.h"

@interface FoodCafeSearchViewController () <UITextFieldDelegate>
@property (nonatomic, strong) NSDictionary *dic_SelectedCategory;
@property (nonatomic, strong) NSMutableArray *arM_List;
@property (nonatomic, weak) IBOutlet UITextField *tf_Category;
@property (nonatomic, weak) IBOutlet UITextField *tf_Lesson;
@property (nonatomic, weak) IBOutlet UICollectionView *cv_List;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_ResultHeight;
@property (nonatomic, weak) IBOutlet UILabel *lb_TotlaSearchCount;
@end

@implementation FoodCafeSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"SearchKeyboardAccView" owner:self options:nil];
    SearchKeyboardAccView *v_Acc = [topLevelObjects objectAtIndex:0];
    [v_Acc.btn_Button setTitle:@"검색" forState:UIControlStateNormal];
    [v_Acc.btn_Button addTarget:self action:@selector(goSearch:) forControlEvents:UIControlEventTouchUpInside];
    self.tf_Lesson.inputAccessoryView = v_Acc;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
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

- (void)updateList
{
    __weak __typeof(&*self)weakSelf = self;
    
    if( self.dic_SelectedCategory == nil )
    {
        [UIAlertController showAlertInViewController:self
                                           withTitle:@""
                                             message:@"카테고리를 선택해 주세요"
                                   cancelButtonTitle:nil
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@[@"확인"]
                                            tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex){
                                                
                                                [weakSelf showCategory];
                                            }];
    }
    
    NSString *str_Path = @"";
    if( self.dic_SelectedCategory )
    {
        NSString *str_CateIdenti = [self.dic_SelectedCategory objectForKey_YM:@"identifier"];
        str_Path = [NSString stringWithFormat:@"board/%@/article", str_CateIdenti];
    }

    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionary];
    if( self.tf_Lesson.text )
    {
        [dicM_Params setObject:self.tf_Lesson.text forKey:@"name"];
    }

    [dicM_Params setObject:@"1000" forKey:@"size"];

    [[WebAPI sharedData] callAsyncWebAPIBlock:str_Path
                                        param:dicM_Params
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
                                                NSDictionary *dic_Data = [resulte objectForKey:@"data"];
                                                weakSelf.arM_List = [NSMutableArray arrayWithArray:[dic_Data objectForKey:@"content"]];
                                                [weakSelf.cv_List reloadData];
                                            }
                                            
                                            if( weakSelf.arM_List == nil || weakSelf.arM_List.count <= 0 )
                                            {
                                                weakSelf.lc_ResultHeight.constant = 0.f;
                                                
                                                [UIAlertController showAlertInViewController:self
                                                                                   withTitle:@""
                                                                                     message:@"검색 결과가 없습니다"
                                                                           cancelButtonTitle:nil
                                                                      destructiveButtonTitle:nil
                                                                           otherButtonTitles:@[@"확인"]
                                                                                    tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex){
                                                                                        
                                                                                    }];
                                            }
                                            else
                                            {
                                                weakSelf.lb_TotlaSearchCount.text = [NSString stringWithFormat:@"%ld", weakSelf.arM_List.count];
                                                weakSelf.lc_ResultHeight.constant = 30.f;
                                            }
                                        }
                                    }];
    
}

#pragma mark - CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arM_List.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic_Main = self.arM_List[indexPath.row];

    StudyStoryDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudyStoryDetailViewController"];
    vc.str_Id = [NSString stringWithFormat:@"%@", [dic_Main objectForKey:@"id"]];
    vc.isFoodMode = YES;
    vc.str_Title = [self.dic_SelectedCategory objectForKey_YM:@"name"];
    vc.str_FoodIdenti = [self.dic_SelectedCategory objectForKey_YM:@"identifier"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
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
    return [(UICollectionViewFlowLayout*)collectionViewLayout minimumInteritemSpacing];
}




- (void)showCategory
{
    __weak __typeof(&*self)weakSelf = self;
    
    SnsCategoryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SnsCategoryViewController"];
    vc.isFoodCafeMode = YES;
    vc.dic_CateInfo = self.dic_SelectedCategory;
    vc.str_Title = @"카테고리 선택";
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [vc setCompletionCategoryBlock:^(id completeResult) {
        
        weakSelf.dic_SelectedCategory = completeResult;
        weakSelf.tf_Category.text = [weakSelf.dic_SelectedCategory objectForKey:@"name"];
    }];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if( textField == self.tf_Category )
    {
        [self showCategory];

        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if( textField == self.tf_Lesson )
    {
        if( textField.text.length > 0 )
        {
            [self.view endEditing:YES];
            [self updateList];
        }
    }
    
    return YES;
}


- (IBAction)goCategory:(id)sender
{
    [self showCategory];
}

- (IBAction)goSearch:(id)sender
{
    [self.view endEditing:YES];
    [self updateList];
}

@end
