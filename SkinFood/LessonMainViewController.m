//
//  LessonMainViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 5..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "LessonMainViewController.h"
#import "LessonMainCell.h"
#import "HomeLearningProcessCell.h"
#import "NoDataView.h"
#import "LessonContainerViewController.h"

@interface LessonMainViewController ()
{
    BOOL isNonPassLoding;
    BOOL isPassLoding;
    
    NSInteger nNonPassTotalCount;
    NSInteger nPassTotalCount;
    
    NSInteger nNonPassPage;
    NSInteger nPassPage;
}
@property (nonatomic, strong) LessonContainerViewController *vc_NonPass;
@property (nonatomic, strong) LessonContainerViewController *vc_Pass;
@property (nonatomic, strong) NSArray *ar_Colors;
@property (nonatomic, strong) NSMutableArray *arM_NonPassCategory;
@property (nonatomic, strong) NSMutableArray *arM_PassCategory;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_ContentsWidth;

@property (nonatomic, weak) IBOutlet UIButton *btn_NonPass;
@property (nonatomic, weak) IBOutlet UIImageView *iv_NonPassUnderLine;
@property (nonatomic, weak) IBOutlet UICollectionView *cv_NonPassLearningProcess;
@property (nonatomic, weak) IBOutlet UIView *v_NonPassEmpty;

@property (nonatomic, weak) IBOutlet UIButton *btn_Pass;
@property (nonatomic, weak) IBOutlet UIImageView *iv_PassUnderLine;
@property (nonatomic, weak) IBOutlet UICollectionView *cv_PassLearningProcess;
@property (nonatomic, weak) IBOutlet UIView *v_PassEmpty;

@end

@implementation LessonMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ar_Colors = [Common getCategoryColors];

    nNonPassPage = nPassPage = 1;

    [self updateLearningProcess];
    [self updateNonPassLesson];
    [self updatePassLesson];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if( self.isMainJump )
    {
        self.isMainJump = NO;

        nNonPassPage = 1;
        [self.vc_NonPass.arM_List removeAllObjects];
        self.vc_NonPass.arM_List = nil;

        nPassPage = 1;
        [self.vc_Pass.arM_List removeAllObjects];
        self.vc_Pass.arM_List = nil;

        [self.vc_NonPass.tbv_List setContentOffset:CGPointZero];
        [self.vc_Pass.tbv_List setContentOffset:CGPointZero];
        
        [self updateNonPassLesson];
        [self updatePassLesson];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.sv_Main.contentSize = CGSizeMake(self.sv_Main.frame.size.width * 2, self.sv_Main.frame.size.height);
    self.lc_ContentsWidth.constant = self.view.frame.size.width * 2;
    
    if( self.btn_NonPass.selected )
    {
        self.sv_Main.contentOffset = CGPointZero;
    }
    else
    {
        self.sv_Main.contentOffset = CGPointMake(self.sv_Main.frame.size.width, 0);
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    __weak __typeof(&*self)weakSelf = self;

    if( [segue.identifier isEqualToString:@"NonPass"] )
    {
        self.vc_NonPass = [segue destinationViewController];
        [self.vc_NonPass setCompletionMoreBlock:^(id completeResult) {

            NSLog(@"미수료 모어");
            [weakSelf updateNonPassLesson];
        }];
    }
    else if( [segue.identifier isEqualToString:@"Pass"] )
    {
        self.vc_Pass = [segue destinationViewController];
        [self.vc_Pass setCompletionMoreBlock:^(id completeResult) {
            
            NSLog(@"수료 모어");
            [weakSelf updatePassLesson];
        }];
    }
}

- (void)updateLearningProcess
{
    __weak __typeof(&*self)weakSelf = self;
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:@"learn/degree/category"
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
                                                weakSelf.arM_NonPassCategory = [NSMutableArray arrayWithArray:[resulte objectForKey:@"data"]];
                                                [weakSelf.arM_NonPassCategory insertObject:@{@"id":@"0", @"name":@"전체"} atIndex:0];
                                                [weakSelf.cv_NonPassLearningProcess reloadData];

                                                weakSelf.arM_PassCategory = [NSMutableArray arrayWithArray:[resulte objectForKey:@"data"]];
                                                [weakSelf.arM_PassCategory insertObject:@{@"id":@"0", @"name":@"전체"} atIndex:0];
                                                [weakSelf.cv_PassLearningProcess reloadData];
                                            }
                                        }
                                    }];
}

- (void)updateNonPassLesson
{
    __weak __typeof(&*self)weakSelf = self;
    
    if( nNonPassTotalCount > 0 && self.vc_NonPass.arM_List.count >= nNonPassTotalCount )
    {
        isNonPassLoding = NO;
        return;
    }

    if( isNonPassLoding )
    {
//        [self updateNonPassLesson];
        return;
    }
    
    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSString stringWithFormat:@"%ld", nNonPassPage], @"page",
                                        @"0", @"size",
                                        @"LATELY_UPDATE", @"sorting",
                                        @"INCOMPLETE", @"type",
                                        nil];
    
    if( self.dic_NonPassSelectedCategory )
    {
        NSString *str_CateIdx = [NSString stringWithFormat:@"%@", [self.dic_NonPassSelectedCategory objectForKey:@"id"]];
        [dicM_Params setObject:str_CateIdx forKey:@"category"];
    }
    
    isNonPassLoding = YES;
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:@"learn/degree"
                                        param:dicM_Params
                                   withMethod:@"GET"
                                    withBlock:^(id resulte, NSError *error) {
                                        
                                        isNonPassLoding = NO;

                                        nNonPassPage++;
                                        
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
                                                nNonPassTotalCount = [[dic_Data objectForKey:@"totalElements"] integerValue];
                                                
                                                if( weakSelf.vc_NonPass.arM_List && weakSelf.vc_NonPass.arM_List.count > 0 )
                                                {
                                                    //더보기시
                                                    [weakSelf.vc_NonPass.arM_List addObjectsFromArray:[dic_Data objectForKey:@"content"]];
                                                    [weakSelf.vc_NonPass.tbv_List reloadData];
                                                }
                                                else
                                                {
                                                    //최초 로딩시
                                                    weakSelf.vc_NonPass.arM_List = [NSMutableArray arrayWithArray:[dic_Data objectForKey:@"content"]];
                                                    [weakSelf.vc_NonPass.tbv_List reloadData];
                                                    
                                                    if( nNonPassTotalCount <= 0 || weakSelf.vc_NonPass.arM_List == nil || weakSelf.vc_NonPass.arM_List.count <= 0 )
                                                    {
                                                        weakSelf.v_NonPassEmpty.hidden = NO;
                                                    }
                                                    else
                                                    {
                                                        weakSelf.v_NonPassEmpty.hidden = YES;
                                                    }
                                                }
                                            }
                                        }
                                    }];
}

- (void)updatePassLesson
{
    __weak __typeof(&*self)weakSelf = self;
    
    if( nPassTotalCount > 0 && self.vc_Pass.arM_List.count >= nPassTotalCount )
    {
        isPassLoding = NO;
        return;
    }
    
    if( isPassLoding )
    {
        return;
    }
    
    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSString stringWithFormat:@"%ld", nPassPage], @"page",
                                        @"0", @"size",
                                        @"LATELY_UPDATE", @"sorting",
                                        @"COMPLETE", @"type",
                                        nil];
    
    if( self.dic_PassSelectedCategory )
    {
        NSString *str_CateIdx = [NSString stringWithFormat:@"%@", [self.dic_PassSelectedCategory objectForKey:@"id"]];
        [dicM_Params setObject:str_CateIdx forKey:@"category"];
    }
    
    isPassLoding = YES;
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:@"learn/degree"
                                        param:dicM_Params
                                   withMethod:@"GET"
                                    withBlock:^(id resulte, NSError *error) {
                                        
                                        isPassLoding = NO;

                                        nPassPage++;

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
                                                nPassTotalCount = [[dic_Data objectForKey:@"totalElements"] integerValue];

                                                if( weakSelf.vc_Pass.arM_List && weakSelf.vc_Pass.arM_List.count > 0 )
                                                {
                                                    //더보기시
                                                    [weakSelf.vc_Pass.arM_List addObjectsFromArray:[dic_Data objectForKey:@"content"]];
                                                    [weakSelf.vc_Pass.tbv_List reloadData];
                                                }
                                                else
                                                {
                                                    //최초 로딩시
                                                    weakSelf.vc_Pass.arM_List = [NSMutableArray arrayWithArray:[dic_Data objectForKey:@"content"]];
                                                    [weakSelf.vc_Pass.tbv_List reloadData];
                                                    
                                                    if( weakSelf.vc_Pass.arM_List == nil || weakSelf.vc_Pass.arM_List.count <= 0 )
                                                    {
                                                        weakSelf.v_PassEmpty.hidden = NO;
                                                    }
                                                    else
                                                    {
                                                        weakSelf.v_PassEmpty.hidden = YES;
                                                    }
                                                }
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
    if( collectionView == self.cv_NonPassLearningProcess )
    {
        return self.arM_NonPassCategory.count;
    }
    
    return self.arM_PassCategory.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic_Main = nil;
    if( collectionView == self.cv_NonPassLearningProcess )
    {
        //미수료
        dic_Main = self.arM_NonPassCategory[indexPath.row];
    }
    else
    {
        dic_Main = self.arM_PassCategory[indexPath.row];
    }
    
    static NSString *identifier = @"HomeLearningProcessCell";
    
    HomeLearningProcessCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [Util makeShadow:cell];
    [Util makeShadow:cell.btn_Item];
    
    [cell.btn_Item setTitle:[dic_Main objectForKey_YM:@"name"] forState:UIControlStateNormal];
    
    NSString *str_ColorHex = [self.ar_Colors objectAtIndex:indexPath.row % self.ar_Colors.count];
    [cell.btn_Item setBackgroundColor:[UIColor colorWithHexString:str_ColorHex]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if( collectionView == self.cv_NonPassLearningProcess )
    {
        nNonPassPage = 1;
        
        NSDictionary *dic_Cate = self.arM_NonPassCategory[indexPath.row];
        NSString *str_CateName = [dic_Cate objectForKey:@"name"];
        if( [str_CateName isEqualToString:@"전체"] )
        {
            self.dic_NonPassSelectedCategory = nil;
        }
        else
        {
            self.dic_NonPassSelectedCategory = dic_Cate;
        }
        
        [self.vc_NonPass.arM_List removeAllObjects];
        self.vc_NonPass.arM_List = nil;
        [self updateNonPassLesson];
        
        [UIView animateWithDuration:0.3f animations:^{
        
            [self.vc_NonPass.tbv_List setContentOffset:CGPointZero];
        }];
    }
    else
    {
        nPassPage = 1;
        
        NSDictionary *dic_Cate = self.arM_PassCategory[indexPath.row];
        NSString *str_CateName = [dic_Cate objectForKey:@"name"];
        if( [str_CateName isEqualToString:@"전체"] )
        {
            self.dic_PassSelectedCategory = nil;
        }
        else
        {
            self.dic_PassSelectedCategory = dic_Cate;
        }
        
        [self.vc_Pass.arM_List removeAllObjects];
        self.vc_Pass.arM_List = nil;
        [self updatePassLesson];
        
        [UIView animateWithDuration:0.3f animations:^{
            
            [self.vc_Pass.tbv_List setContentOffset:CGPointZero];
        }];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize defaultSize = [(UICollectionViewFlowLayout*)collectionViewLayout itemSize];
    
    NSDictionary *dic_Cate = self.arM_NonPassCategory[indexPath.row];
    NSString *str_CateName = [dic_Cate objectForKey:@"name"];
    CGSize size = [(NSString*)str_CateName sizeWithAttributes:NULL];
    return CGSizeMake(size.width + 40, defaultSize.height);
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
    return 8.f;
}



#pragma mark - IBAction
- (IBAction)goNonPass:(id)sender
{
    if( self.btn_NonPass.selected ) return;
    
    self.btn_NonPass.selected = YES;
    self.iv_NonPassUnderLine.hidden = NO;
    
    self.btn_Pass.selected = NO;
    self.iv_PassUnderLine.hidden = YES;
    
    [UIView animateWithDuration:0.3f animations:^{
       
        self.sv_Main.contentOffset = CGPointZero;
    }];
}

- (IBAction)goPass:(id)sender
{
    if( self.btn_Pass.selected ) return;
    
    self.btn_NonPass.selected = NO;
    self.iv_NonPassUnderLine.hidden = YES;
    
    self.btn_Pass.selected = YES;
    self.iv_PassUnderLine.hidden = NO;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.sv_Main.contentOffset = CGPointMake(self.sv_Main.frame.size.width, 0);
    }];
}

@end
