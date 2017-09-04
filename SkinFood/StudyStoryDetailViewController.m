//
//  StudyStoryDetailViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 8..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "StudyStoryDetailViewController.h"
#import "StudyStoreDetailTopCell.h"
#import "StudyStoreDetailCommentCell.h"
#import "BABFrameObservingInputAccessoryView.h"
#import "FTPopOverMenu.h"
#import "MWPhotoBrowser.h"
#import "CommentKeyboardAccView.h"
#import <KakaoLink/KakaoLink.h>
#import <MediaPlayer/MediaPlayer.h>
#import "VideoPlayViewController.h"
#import "SnsWriteViewController.h"
#import "FootCafeWriteViewController.h"

@interface StudyStoryDetailViewController () <MWPhotoBrowserDelegate>
{
    MWPhotoBrowser *browser;
}
@property (nonatomic, strong) NSMutableArray *ar_Photo;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) NSDictionary *dic_Info;
@property (nonatomic, strong) NSMutableArray *arM_List;
@property (nonatomic, strong) StudyStoreDetailTopCell *c_StudyStoreDetailTopCell;
@property (nonatomic, strong) StudyStoreDetailCommentCell *c_StudyStoreDetailCommentCell;

@property (nonatomic, weak) IBOutlet UILabel *lb_MainTitle;
@property (nonatomic, weak) IBOutlet UITableView *tbv_List;
@property (nonatomic, weak) IBOutlet UIButton *btn_BookMark;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_InputCommentHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_InputCommentBottom;
@property (nonatomic, weak) IBOutlet UIView *v_Comment;
@property (nonatomic, weak) IBOutlet UITextField *tf_Comment;
@property (nonatomic, weak) IBOutlet CommentKeyboardAccView *v_CommentKeyboardAccView;

@property (nonatomic, weak) IBOutlet UIButton *btn_Kakao;
@end

@implementation StudyStoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self performSelector:@selector(onVideoPlay:) withObject:nil afterDelay:3.0f];
    
    self.btn_Kakao.hidden = self.btn_BookMark.hidden = YES;
    
    if( self.isSnsMode )
    {
        self.screenName = @"SNS 상세";
        self.lb_MainTitle.text = @"SNS FEED";
        
        self.btn_Kakao.hidden = self.btn_BookMark.hidden = NO;
    }
    else if( self.isFoodMode )
    {
        self.screenName = self.str_Title;
        self.lb_MainTitle.text = self.str_Title;
    }
    else
    {
        self.screenName = @"교육 스토리 상세";
        self.lb_MainTitle.text = @"교육 스토리";
    }
    
    self.ar_Photo = [NSMutableArray array];
    self.thumbs = [NSMutableArray array];


    
    //스크롤뷰 내릴때 키보드도 함께 내리기
    BABFrameObservingInputAccessoryView *inputView = [[BABFrameObservingInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    inputView.userInteractionEnabled = NO;
    
    
    self.v_CommentKeyboardAccView.tv_Contents.inputAccessoryView = inputView;
    
    __weak typeof(self)weakSelf = self;
    
    inputView.inputAcessoryViewFrameChangedBlock = ^(CGRect inputAccessoryViewFrame){
        
        CGFloat value = CGRectGetHeight(weakSelf.view.frame) - CGRectGetMinY(inputAccessoryViewFrame) - CGRectGetHeight(weakSelf.v_CommentKeyboardAccView.tv_Contents.inputAccessoryView.frame);
        
        weakSelf.v_CommentKeyboardAccView.lc_Bottom.constant = MAX(0, value);
        
        [weakSelf.view layoutIfNeeded];
        
    };
    ///////////////////////////////

    self.v_CommentKeyboardAccView.tv_Contents.placeholder = @"댓글 달기...";

}

- (void)viewWillLayoutSubviews
{
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if( self.isComunnytiMode || self.isSnsMode || self.isFoodMode )
    {
        if( self.isFoodMode )
        {
            if( self.isUnAbleWrite )
            {
                self.lc_InputCommentHeight.constant = 0.f;
            }
        }
        else
        {
            self.lc_InputCommentHeight.constant = 48.f;
        }
//        self.v_CommentKeyboardAccView.lc_TfWidth.constant = 45.f;
    }
    else
    {
        self.lc_InputCommentHeight.constant = 0.f;
//        self.v_CommentKeyboardAccView.lc_TfWidth.constant = 0.f;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
//    [self.view setNeedsDisplay];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAnimate:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAnimate:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self updateList:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if( self.completionUpdateBlock )
    {
        self.completionUpdateBlock(self.dic_Info);
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
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

#pragma mark - Notification
- (void)keyboardWillAnimate:(NSNotification *)notification
{
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        [UIView setAnimationCurve:[curve intValue]];
        if([notification name] == UIKeyboardWillShowNotification)
        {
            self.v_CommentKeyboardAccView.lc_Bottom.constant = keyboardBounds.size.height;
//            if (self.tbv_List.contentSize.height > self.tbv_List.frame.size.height)
//            {
//                CGPoint offset = CGPointMake(0, self.tbv_List.contentOffset.y + keyboardBounds.size.height);
//                [self.tbv_List setContentOffset:offset animated:NO];
//            }
        }
        else if([notification name] == UIKeyboardWillHideNotification)
        {
            self.v_CommentKeyboardAccView.lc_Bottom.constant = 0;
        }
    }completion:^(BOOL finished) {
        
        [self.v_CommentKeyboardAccView updateConstraints];
        [self.v_CommentKeyboardAccView layoutIfNeeded];
        [self.v_CommentKeyboardAccView setNeedsLayout];
        
    }];
}


- (void)updateList:(BOOL)isScrollDown
{
    [self updateTopList];
    [self updateCommentList:isScrollDown];
}

- (void)updateTopList
{
    __weak __typeof(&*self)weakSelf = self;
    
    if( self.isSnsMode )
    {
        [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"board/SNS/article/%@", self.str_Id]
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
                                                    
                                                    NSDictionary *dic_Contents = [weakSelf.dic_Info objectForKey:@"contents"];
//                                                    NSString *str_MainTitle = [dic_Contents objectForKey:@"subject"];
//                                                    weakSelf.lb_MainTitle.text = str_MainTitle;

                                                    [weakSelf.tbv_List reloadData];
                                                    
                                                    [weakSelf.thumbs removeAllObjects];
                                                    [weakSelf.ar_Photo removeAllObjects];
                                                    
                                                    NSArray *ar_Images = [dic_Contents objectForKey:@"images"];
                                                    for( NSInteger i = 0; i < ar_Images.count; i++ )
                                                    {
                                                        NSDictionary *dic_ImageInfo = ar_Images[i];
                                                        NSString *str_ImageUrl = [dic_ImageInfo objectForKey_YM:@"resourceUri"];
                                                        NSURL *url = [NSURL URLWithString:str_ImageUrl];
                                                        [weakSelf.thumbs addObject:[MWPhoto photoWithURL:url]];
                                                        [weakSelf.ar_Photo addObject:[MWPhoto photoWithURL:url]];
                                                    }
                                                }
                                            }
                                        }];
    }
    else if( self.isFoodMode )
    {
        [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"board/%@/article/%@", self.str_FoodIdenti, self.str_Id]
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
                                                    
                                                    NSDictionary *dic_Contents = [weakSelf.dic_Info objectForKey:@"contents"];
                                                    NSString *str_Title = [dic_Contents objectForKey:@"subject"];
                                                    weakSelf.lb_MainTitle.text = str_Title;
                                                    
                                                    [weakSelf.tbv_List reloadData];
                                                    
                                                    [weakSelf.thumbs removeAllObjects];
                                                    [weakSelf.ar_Photo removeAllObjects];
                                                    
                                                    NSArray *ar_Images = [dic_Contents objectForKey:@"images"];
                                                    for( NSInteger i = 0; i < ar_Images.count; i++ )
                                                    {
                                                        NSDictionary *dic_ImageInfo = ar_Images[i];
                                                        NSString *str_ImageUrl = [dic_ImageInfo objectForKey_YM:@"resourceUri"];
                                                        NSURL *url = [NSURL URLWithString:str_ImageUrl];
                                                        [weakSelf.thumbs addObject:[MWPhoto photoWithURL:url]];
                                                        [weakSelf.ar_Photo addObject:[MWPhoto photoWithURL:url]];
                                                    }
                                                }
                                            }
                                        }];
    }
}

- (void)updateCommentList:(BOOL)isScrollDown
{
    __weak __typeof(&*self)weakSelf = self;
    
    if( self.isSnsMode )
    {
        [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"board/SNS/article/%@/comment/list", self.str_Id]
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
                                                    weakSelf.arM_List = [NSMutableArray arrayWithArray:[resulte objectForKey:@"data"]];
                                                    [weakSelf.tbv_List reloadData];
                                                    
                                                    if( isScrollDown )
                                                    {
                                                        [weakSelf scrollToTheBottom:YES];
                                                    }
                                                }
                                            }
                                        }];
    }
    else if( self.isFoodMode )
    {
        [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"board/%@/article/%@/comment/list", self.str_FoodIdenti, self.str_Id]
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
                                                    weakSelf.arM_List = [NSMutableArray arrayWithArray:[resulte objectForKey:@"data"]];
                                                    [weakSelf.tbv_List reloadData];
                                                    
                                                    if( isScrollDown )
                                                    {
                                                        [weakSelf scrollToTheBottom:YES];
                                                    }
                                                }
                                            }
                                        }];
    }
}

- (void)imageTap:(UIGestureRecognizer *)gesture
{
    NSInteger nTag = gesture.view.tag;
    
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = YES;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;
    
    browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:nTag - 1];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
    
    // Release
    
    // Test reloading of data after delay
    double delayInSeconds = 3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    });
}

- (void)onVideoPlay:(UIButton *)btn
{
//    UINavigationController *navi = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoPlayNavi"];
//    VideoPlayViewController *vc = [navi.viewControllers firstObject];
    VideoPlayViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoPlayViewController"];
    NSDictionary *dic_Contents = [self.dic_Info objectForKey:@"contents"];
    NSDictionary *dic_Video = [dic_Contents objectForKey:@"video"];
    vc.str_Url = [dic_Video objectForKey_YM:@"resourceUri"];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}



#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return _ar_Photo.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < _ar_Photo.count)
        return [_ar_Photo objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    if (index < _thumbs.count)
    {
        return [_thumbs objectAtIndex:index];
    }
    return nil;
}




#pragma mark UITableViewDataSource
- (StudyStoreDetailTopCell *)c_StudyStoreDetailTopCell
{
    if (!_c_StudyStoreDetailTopCell)
    {
        _c_StudyStoreDetailTopCell = [self.tbv_List dequeueReusableCellWithIdentifier:NSStringFromClass([StudyStoreDetailTopCell class])];
    }
    
    return _c_StudyStoreDetailTopCell;
}

- (StudyStoreDetailCommentCell *)c_StudyStoreDetailCommentCell
{
    if (!_c_StudyStoreDetailCommentCell)
    {
        _c_StudyStoreDetailCommentCell = [self.tbv_List dequeueReusableCellWithIdentifier:NSStringFromClass([StudyStoreDetailCommentCell class])];
    }
    
    return _c_StudyStoreDetailCommentCell;
}

- (void)configureCell:(StudyStoreDetailTopCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( self.isComunnytiMode || self.isSnsMode || self.isFoodMode )
    {
        cell.lc_ParticipateHeight.constant = 0.f;
    }
    else
    {
        cell.lc_ParticipateHeight.constant = 46.f;
    }
    
    
    BOOL isClipping = [[self.dic_Info objectForKey:@"clipping"] boolValue];
    self.btn_BookMark.selected = isClipping;

    //유저 이미지
    NSDictionary *dic_Modifier = [self.dic_Info objectForKey:@"modifierInfo"];
    NSDictionary *dic_Register = [dic_Modifier objectForKey:@"register"];
    id profile = [dic_Register objectForKey:@"profile"];
    if( [profile isKindOfClass:[NSNull class]] == NO )
    {
        NSDictionary *dic_Profile = [dic_Register objectForKey:@"profile"];
        NSString *str_UserImageUrl = [dic_Profile objectForKey_YM:@"resourceUri"];
        [cell.iv_User sd_setImageWithURL:[NSURL URLWithString:str_UserImageUrl] placeholderImage:BundleImage(@"no_image_white.png")];
    }
    
    //성신여대점 | 2017.03.17
    NSString *str_StoreName = [dic_Register objectForKey_YM:@"storeName"];
    TimeStruct *time = [Util makeTimeWithTimeStamp:[[dic_Register objectForKey_YM:@"time"] doubleValue]];
    cell.lb_StoreAndDate.text = [NSString stringWithFormat:@"%@ | %04ld.%02ld.%02ld", str_StoreName, time.nYear, time.nMonth, time.nDay];
    
    //이은숙 점주
    NSString *str_RegisterName = [dic_Register objectForKey_YM:@"name"];
    NSString *str_DutyName = [dic_Register objectForKey_YM:@"responsibilityName"];
    cell.lb_Name.text = str_RegisterName;
    cell.lb_Position.text = str_DutyName;
    
    //[주목!주목]
    id category = [self.dic_Info objectForKey:@"category"];
    if( [category isKindOfClass:[NSNull class]] == NO )
    {
        NSDictionary *dic_Category = [self.dic_Info objectForKey:@"category"];
        [cell.btn_Category setTitle:[NSString stringWithFormat:@"[%@]", [dic_Category objectForKey:@"text"]] forState:0];
    }
    else
    {
        [cell.btn_Category setTitle:@"" forState:0];
    }

    //tag
    NSMutableString *strM_Tags = [NSMutableString string];
    NSArray *ar_Tags = [NSArray arrayWithArray:[self.dic_Info objectForKey:@"tags"]];
    for( NSInteger i = 0; i < ar_Tags.count; i++ )
    {
        NSDictionary *dic = ar_Tags[i];
        [strM_Tags appendString:@"#"];
        [strM_Tags appendString:[dic objectForKey_YM:@"name"]];
        [strM_Tags appendString:@" "];
    }
    cell.lb_Tag.text = strM_Tags;

    
    cell.lc_TotalImageHeight.constant = 0.f;
    
    //내용
    NSDictionary *dic_Contents = [self.dic_Info objectForKey:@"contents"];
    cell.lb_Contents.text = [dic_Contents objectForKey:@"body"];
    
    
    NSString *str_Type = @"";
    NSDictionary *dic_Type = [dic_Contents objectForKey_YM:@"type"];
    if( [dic_Type isKindOfClass:[NSDictionary class]] == NO )
    {
        str_Type = @"";
//        return;
    }
    else
    {
        str_Type = [dic_Type objectForKey_YM:@"value"];
    }

//    str_Type = @"VIDEO";
    
    if( [str_Type isEqualToString:@"IMAGE"] )
//    if( 1 )
    {
        //이미지
        NSArray *ar_Images = [dic_Contents objectForKey:@"images"];
        if( ar_Images == nil || ar_Images.count <= 0 )
        {
            //이미지가 없다면
            cell.lc_TotalImageHeight.constant = 0.f;
        }
        else if( ar_Images.count == 1 )
        {
            NSDictionary *dic_ImageInfo = [ar_Images firstObject];
            NSString *str_ImageUrl = [dic_ImageInfo objectForKey_YM:@"resourceUri"];
            
            CGFloat fWidth = [[dic_ImageInfo objectForKey:@"width"] floatValue];
            CGFloat fHeight = [[dic_ImageInfo objectForKey:@"height"] floatValue];
            CGFloat fScreenWidth = [UIScreen mainScreen].bounds.size.width - 20;
            
            CGFloat fScale = fScreenWidth / fWidth;
            fHeight *= fScale;
            
            UIImageView *iv_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, fScreenWidth, fHeight)];
            iv_1.contentMode = UIViewContentModeScaleAspectFit;
            iv_1.userInteractionEnabled = YES;
            iv_1.tag = 1;
            [iv_1 sd_setImageWithURL:[NSURL URLWithString:str_ImageUrl]];
            
            [cell.v_ImageBg addSubview:iv_1];
            
            UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
            [imageTap setNumberOfTapsRequired:1];
            [iv_1 addGestureRecognizer:imageTap];
            
            cell.lc_TotalImageHeight.constant = iv_1.frame.size.height;
        }
        else if( ar_Images.count == 2 )
        {
            NSDictionary *dic_ImageInfo = [ar_Images firstObject];
            NSString *str_ImageUrl = [dic_ImageInfo objectForKey_YM:@"resourceUri"];
            
            CGFloat fWidth = [[dic_ImageInfo objectForKey:@"width"] floatValue];
            CGFloat fHeight = [[dic_ImageInfo objectForKey:@"height"] floatValue];
            CGFloat fScreenWidth = [UIScreen mainScreen].bounds.size.width - 20;
            
            CGFloat fScale = fScreenWidth / fWidth;
            fHeight *= fScale;
            
            UIImageView *iv_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, fScreenWidth, fHeight)];
            iv_1.contentMode = UIViewContentModeScaleAspectFit;
            iv_1.userInteractionEnabled = YES;
            iv_1.tag = 1;
            [iv_1 sd_setImageWithURL:[NSURL URLWithString:str_ImageUrl]];
            
            [cell.v_ImageBg addSubview:iv_1];
            
            UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
            [imageTap setNumberOfTapsRequired:1];
            [iv_1 addGestureRecognizer:imageTap];
            
            cell.lc_TotalImageHeight.constant = iv_1.frame.size.height;
            
            
            dic_ImageInfo = [ar_Images objectAtIndex:1];
            str_ImageUrl = [dic_ImageInfo objectForKey_YM:@"resourceUri"];
            fWidth = [[dic_ImageInfo objectForKey:@"width"] floatValue];
            fHeight = [[dic_ImageInfo objectForKey:@"height"] floatValue];
            fScreenWidth = [UIScreen mainScreen].bounds.size.width - 20;
            
            fScale = fScreenWidth / fWidth;
            fHeight *= fScale;
            
            UIImageView *iv_2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, fHeight, fScreenWidth, fHeight)];
            iv_2.contentMode = UIViewContentModeScaleAspectFit;
            iv_2.userInteractionEnabled = YES;
            iv_2.tag = 2;
            [iv_2 sd_setImageWithURL:[NSURL URLWithString:str_ImageUrl]];
            
            [cell.v_ImageBg addSubview:iv_2];
            
            UITapGestureRecognizer *imageTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
            [imageTap2 setNumberOfTapsRequired:1];
            [iv_2 addGestureRecognizer:imageTap2];
            
            cell.lc_TotalImageHeight.constant = iv_1.frame.size.height + iv_2.frame.size.height;
        }
        else if( ar_Images.count >= 3 )
        {
            NSDictionary *dic_ImageInfo = [ar_Images firstObject];
            NSString *str_ImageUrl = [dic_ImageInfo objectForKey_YM:@"resourceUri"];
            
            CGFloat fWidth = [[dic_ImageInfo objectForKey:@"width"] floatValue];
            CGFloat fHeight = [[dic_ImageInfo objectForKey:@"height"] floatValue];
            CGFloat fScreenWidth = [UIScreen mainScreen].bounds.size.width - 20;
            
            CGFloat fScale = fScreenWidth / fWidth;
            fHeight *= fScale;
            
            if( isnan(fHeight) )
            {
                fHeight = fScreenWidth;
            }
            
            UIImageView *iv_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, fScreenWidth, fHeight)];
            iv_1.contentMode = UIViewContentModeScaleAspectFit;
            iv_1.userInteractionEnabled = YES;
            iv_1.tag = 1;
            [iv_1 sd_setImageWithURL:[NSURL URLWithString:str_ImageUrl]];
            
            [cell.v_ImageBg addSubview:iv_1];
            
            UITapGestureRecognizer *imageTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
            [imageTap1 setNumberOfTapsRequired:1];
            [iv_1 addGestureRecognizer:imageTap1];
            
            cell.lc_TotalImageHeight.constant = iv_1.frame.size.height;
            
            
            dic_ImageInfo = [ar_Images objectAtIndex:1];
            str_ImageUrl = [dic_ImageInfo objectForKey_YM:@"resourceUri"];
            fWidth = [[dic_ImageInfo objectForKey:@"width"] floatValue];
            fHeight = [[dic_ImageInfo objectForKey:@"height"] floatValue];
            fScreenWidth = [UIScreen mainScreen].bounds.size.width - 20;
            
            fScale = fScreenWidth / fWidth;
            fHeight *= fScale;
            
            if( isnan(fHeight) )
            {
                fHeight = fScreenWidth;
            }
            
            UIImageView *iv_2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.lc_TotalImageHeight.constant, fScreenWidth, fHeight)];
            iv_2.contentMode = UIViewContentModeScaleAspectFit;
            iv_2.userInteractionEnabled = YES;
            iv_2.tag = 2;
            [iv_2 sd_setImageWithURL:[NSURL URLWithString:str_ImageUrl]];
            
            [cell.v_ImageBg addSubview:iv_2];
            
            UITapGestureRecognizer *imageTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
            [imageTap2 setNumberOfTapsRequired:1];
            [iv_2 addGestureRecognizer:imageTap2];
            
            cell.lc_TotalImageHeight.constant = iv_1.frame.size.height + iv_2.frame.size.height;
            
            
            dic_ImageInfo = [ar_Images objectAtIndex:2];
            str_ImageUrl = [dic_ImageInfo objectForKey_YM:@"resourceUri"];
            fWidth = [[dic_ImageInfo objectForKey:@"width"] floatValue];
            fHeight = [[dic_ImageInfo objectForKey:@"height"] floatValue];
            fScreenWidth = [UIScreen mainScreen].bounds.size.width - 20;
            
            fScale = fScreenWidth / fWidth;
            fHeight *= fScale;
            
            if( isnan(fHeight) )
            {
                fHeight = fScreenWidth;
            }
            
            UIImageView *iv_3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.lc_TotalImageHeight.constant, fScreenWidth, fHeight)];
            iv_3.contentMode = UIViewContentModeScaleAspectFit;
            iv_3.userInteractionEnabled = YES;
            iv_3.tag = 3;
            [iv_3 sd_setImageWithURL:[NSURL URLWithString:str_ImageUrl]];
            
            [cell.v_ImageBg addSubview:iv_3];
            
            UITapGestureRecognizer *imageTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
            [imageTap3 setNumberOfTapsRequired:1];
            [iv_3 addGestureRecognizer:imageTap3];
            
            cell.lc_TotalImageHeight.constant = iv_1.frame.size.height + iv_2.frame.size.height + iv_3.frame.size.height;
        }
    }
    else if( [str_Type isEqualToString:@"VIDEO"] )
//    else if( 1 )
    {
        //비디오
        NSDictionary *dic_ImageInfo = [dic_Contents objectForKey:@"video"];

        NSString *str_ImageUrl = nil;
        NSArray *ar_Thumb = [dic_ImageInfo objectForKey:@"subFileResourceUri"];
        if( ar_Thumb.count > 0 )
        {
            str_ImageUrl = [ar_Thumb firstObject];
        }
        
        CGFloat fWidth = [UIScreen mainScreen].bounds.size.width - 20;
        CGFloat fHeight = 200.f;
        
        UIImageView *iv_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, fWidth, fHeight)];
        iv_1.clipsToBounds = YES;
        iv_1.contentMode = UIViewContentModeScaleAspectFill;
        iv_1.userInteractionEnabled = YES;
        iv_1.tag = 1;
        if( str_ImageUrl )
        {
            [iv_1 sd_setImageWithURL:[NSURL URLWithString:str_ImageUrl]];
        }
        else
        {
            [iv_1 setImage:BundleImage(@"noimage2.png")];
        }
        
        [cell.v_ImageBg addSubview:iv_1];
        
        UIImageView *iv_Bg = [[UIImageView alloc] initWithFrame:iv_1.frame];
        iv_Bg.backgroundColor = [UIColor blackColor];
        iv_Bg.alpha = 0.3f;
        [cell.v_ImageBg addSubview:iv_Bg];
        
        
        UIButton *btn_Play = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_Play.frame = iv_1.frame;
        [btn_Play setImage:BundleImage(@"btn_play.png") forState:UIControlStateNormal];
        [btn_Play addTarget:self action:@selector(onVideoPlay:) forControlEvents:UIControlEventTouchUpInside];
        [cell.v_ImageBg addSubview:btn_Play];

        cell.lc_TotalImageHeight.constant = iv_1.frame.size.height;
    }
    else if( [str_Type isEqualToString:@"LINK"] )
//    else if( 1 )
    {
        //링크
        NSString *str_LinkUrl = [dic_Contents objectForKey_YM:@"linkUrl"];
        if( str_LinkUrl.length > 0 )
        {
            cell.btn_Link.hidden = NO;
            [cell.btn_Link setTitle:str_LinkUrl forState:0];
            cell.lc_TotalImageHeight.constant = 30.f;
            [cell.btn_Link addTarget:self action:@selector(onLink:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            cell.btn_Link.hidden = YES;
            [cell.btn_Link setTitle:@"" forState:0];
            [cell.btn_Link removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        }
    }
    
    
    
    //댓글수
    [cell.btn_Comment setTitle:[NSString stringWithFormat:@"%@", [self.dic_Info objectForKey:@"commentCount"]] forState:0];
    
    //좋아요수
    [cell.btn_Like setTitle:[NSString stringWithFormat:@"%@", [self.dic_Info objectForKey:@"likesCount"]] forState:0];
    [cell.btn_Like addTarget:self action:@selector(onLike:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btn_Like.selected = [[self.dic_Info objectForKey_YM:@"like"] boolValue];
}

- (void)configureCommentCell:(StudyStoreDetailCommentCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic_Main = [self.arM_List objectAtIndex:indexPath.row - 1];
    
    //유저 이미지
    NSDictionary *dic_Modifier = [dic_Main objectForKey:@"modifierInfo"];
    NSDictionary *dic_Register = [dic_Modifier objectForKey:@"register"];
    NSDictionary *dic_Profile = [dic_Register objectForKey:@"profile"];
    NSString *str_UserImageUrl = [dic_Profile objectForKey_YM:@"resourceUri"];
    [cell.iv_User sd_setImageWithURL:[NSURL URLWithString:str_UserImageUrl] placeholderImage:BundleImage(@"no_image_white.png")];
    
    //성신여대점 | 2017.03.17
    NSString *str_StoreName = [dic_Register objectForKey_YM:@"storeName"];
    TimeStruct *time = [Util makeTimeWithTimeStamp:[[dic_Register objectForKey_YM:@"time"] doubleValue]];
    cell.lb_Store.text = str_StoreName;
    cell.lb_Date.text = [NSString stringWithFormat:@"%04ld.%02ld.%02ld", time.nYear, time.nMonth, time.nDay];

    //이은숙 점주
    NSString *str_RegisterName = [dic_Register objectForKey_YM:@"name"];
    NSString *str_DutyName = [dic_Register objectForKey_YM:@"responsibilityName"];
    cell.lb_Name.text = str_RegisterName;
    cell.lb_Position.text = str_DutyName;
    
    cell.lb_Contents.text = [dic_Main objectForKey_YM:@"contents"];
    
    cell.btn_Info.tag = indexPath.row - 1;
    [cell.btn_Info addTarget:self action:@selector(onInfo:) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arM_List.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.row == 0 )
    {
        StudyStoreDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([StudyStoreDetailTopCell class])];
        
        [self configureCell:cell forRowAtIndexPath:indexPath];
        
        return cell;
    }
    
    StudyStoreDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([StudyStoreDetailCommentCell class])];
    
    [self configureCommentCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.row == 0 )
    {
        [self configureCell:self.c_StudyStoreDetailTopCell forRowAtIndexPath:indexPath];
        
        [self.c_StudyStoreDetailTopCell updateConstraintsIfNeeded];
        [self.c_StudyStoreDetailTopCell layoutIfNeeded];
        
        return [self.c_StudyStoreDetailTopCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;        
    }
    
    if( self.isComunnytiMode || self.isSnsMode || self.isFoodMode )
    {
        //교육소통이거나 sns일 경우
        [self configureCommentCell:self.c_StudyStoreDetailCommentCell forRowAtIndexPath:indexPath];
        
        [self.c_StudyStoreDetailCommentCell updateConstraintsIfNeeded];
        [self.c_StudyStoreDetailCommentCell layoutIfNeeded];
        
        NSLog(@"heught : %f", [self.c_StudyStoreDetailCommentCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height);
        
        return [self.c_StudyStoreDetailCommentCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
    
    return 50;
}



#pragma mark - IBAction
- (IBAction)goAddComment:(id)sender
{
    if( self.v_CommentKeyboardAccView.tv_Contents.text.length > 0 )
    {
        __weak __typeof(&*self)weakSelf = self;
        
        if( self.isSnsMode )
        {
            NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionary];
            [dicM_Params setObject:self.v_CommentKeyboardAccView.tv_Contents.text forKey:@"contents"];
//            [dicM_Params setObject:[NSArray array] forKey:@"images"];
            
            [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"board/SNS/article/%@/comment", self.str_Id]
                                                param:dicM_Params
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
                                                        weakSelf.v_CommentKeyboardAccView.tv_Contents.text = @"";
                                                        [weakSelf.v_CommentKeyboardAccView.tv_Contents resignFirstResponder];
                                                        weakSelf.v_CommentKeyboardAccView.lc_TfWidth.constant = 45.f;

                                                        [weakSelf updateList:YES];
                                                    }
                                                }
                                            }];
        }
        else if( self.isFoodMode )
        {
            NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionary];
            [dicM_Params setObject:self.v_CommentKeyboardAccView.tv_Contents.text forKey:@"contents"];
            
            [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"board/%@/article/%@/comment", self.str_FoodIdenti, self.str_Id]
                                                param:dicM_Params
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
                                                        weakSelf.v_CommentKeyboardAccView.tv_Contents.text = @"";
                                                        [weakSelf.v_CommentKeyboardAccView.tv_Contents resignFirstResponder];
                                                        weakSelf.v_CommentKeyboardAccView.lc_TfWidth.constant = 45.f;
                                                        
                                                        [weakSelf updateList:YES];
                                                    }
                                                }
                                            }];
        }
    }
}

- (void)scrollToTheBottom:(BOOL)animated
{
    if( self.tbv_List.contentSize.height < self.tbv_List.frame.size.height )
    {
        return;
    }
    
    if( self.arM_List.count > 0 )
    {
        CGPoint offset = CGPointMake(0, self.tbv_List.contentSize.height - self.tbv_List.frame.size.height);
        [self.tbv_List setContentOffset:offset animated:animated];
    }
}

- (IBAction)goKakao:(id)sender
{
    NSDictionary *dic_Contents = [self.dic_Info objectForKey:@"contents"];
    NSString *str_Contents = [dic_Contents objectForKey:@"body"];
    NSArray *ar_Images = [dic_Contents objectForKey:@"images"];
    NSString *str_ImageUrl = @"https://switteruploadcontents.s3.amazonaws.com/switter_kakao.jpg";
    if( ar_Images.count > 0 )
    {
        NSDictionary *dic_ImageInfo = [ar_Images firstObject];
        str_ImageUrl = [dic_ImageInfo objectForKey_YM:@"resourceUri"];
    }
    
    NSString *str_Type = @"";
    NSDictionary *dic_Type = [dic_Contents objectForKey_YM:@"type"];
    if( [dic_Type isKindOfClass:[NSDictionary class]] == NO )
    {
        str_Type = @"";
    }
    else
    {
        str_Type = [dic_Type objectForKey_YM:@"value"];
    }

    if( [str_Type isEqualToString:@"VIDEO"] )
    {
        NSDictionary *dic_ImageInfo = [dic_Contents objectForKey:@"video"];
        NSArray *ar_Thumb = [dic_ImageInfo objectForKey:@"subFileResourceUri"];
        if( ar_Thumb.count > 0 )
        {
            str_ImageUrl = [ar_Thumb firstObject];
        }
    }
    
    NSString *str_Id = [NSString stringWithFormat:@"SNS;%@", [self.dic_Info objectForKey:@"id"]];
//    NSString *str_Id = [NSString stringWithFormat:@"LEARN;%@", [self.dic_Info objectForKey:@"id"]];   //학습
//    NSString *str_Id = [NSString stringWithFormat:@"STORY;%@", [self.dic_Info objectForKey:@"id"]];   //교육스토리

    KLKTemplate *template = [KLKFeedTemplate feedTemplateWithBuilderBlock:^(KLKFeedTemplateBuilder * _Nonnull feedTemplateBuilder) {
        
        feedTemplateBuilder.content = [KLKContentObject contentObjectWithBuilderBlock:^(KLKContentBuilder * _Nonnull contentBuilder) {
            contentBuilder.title = @"";
            contentBuilder.desc = str_Contents;
            contentBuilder.imageURL = [NSURL URLWithString:str_ImageUrl];
            contentBuilder.link = [KLKLinkObject linkObjectWithBuilderBlock:^(KLKLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.iosExecutionParams = str_Id;
                linkBuilder.androidExecutionParams = str_Id;
            }];
        }];
        
        [feedTemplateBuilder addButton:[KLKButtonObject buttonObjectWithBuilderBlock:^(KLKButtonBuilder * _Nonnull buttonBuilder) {
            buttonBuilder.title = @"앱으로 보기";
            buttonBuilder.link = [KLKLinkObject linkObjectWithBuilderBlock:^(KLKLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.iosExecutionParams = str_Id;
                linkBuilder.androidExecutionParams = str_Id;
            }];
        }]];
    }];
    
    [[KLKTalkLinkCenter sharedCenter] sendDefaultWithTemplate:template success:^(NSDictionary<NSString *,NSString *> * _Nullable warningMsg, NSDictionary<NSString *,NSString *> * _Nullable argumentMsg) {
        
        // 성공
        NSLog(@"warning message: %@", warningMsg);
        NSLog(@"argument message: %@", argumentMsg);
        
    } failure:^(NSError * _Nonnull error) {
        
        // 실패
        NSLog(@"error: %@", error);
        
    }];
}

- (IBAction)goBookMark:(id)sender
{
    __weak typeof(self)weakSelf = self;
    
    __block BOOL isClipping = [[self.dic_Info objectForKey:@"clipping"] boolValue];
    NSString *str_Method = @"";
    if( isClipping )
    {
        //이미 좋아요한건 취소
        str_Method = @"DELETE";
    }
    else
    {
        //좋아요
        str_Method = @"POST";
    }

    if( self.isSnsMode )
    {
        [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"board/SNS/article/%@/clipping", self.str_Id]
                                            param:nil
                                       withMethod:str_Method
                                        withBlock:^(id resulte, NSError *error) {
                                            
                                            [weakSelf updateList:NO];
                                        }];
    }
    else if( self.isFoodMode )
    {
        [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"board/%@/article/%@/clipping", self.str_FoodIdenti, self.str_Id]
                                            param:nil
                                       withMethod:str_Method
                                        withBlock:^(id resulte, NSError *error) {
                                            
                                            [weakSelf updateList:NO];
                                        }];
    }
}

- (IBAction)goMore:(id)sender
{
    //...기능들
    __weak typeof(self)weakSelf = self;

    NSArray *ar = nil;
    
    NSString *str_MyIdx = [[NSUserDefaults standardUserDefaults] objectForKey:kMyIdx];

    NSDictionary *dic_Modifier = [self.dic_Info objectForKey:@"modifierInfo"];
    NSDictionary *dic_Register = [dic_Modifier objectForKey:@"register"];
//    NSDictionary *dic_Profile = [dic_Register objectForKey:@"profile"];
    NSString *str_RegisterId = [NSString stringWithFormat:@"%@", [dic_Register objectForKey:@"id"]];
    if( [str_MyIdx isEqualToString:str_RegisterId] )
    {
        //내가 쓴 글이면
        ar = @[@"수정하기", @"삭제하기"];
        [FTPopOverMenu showForSender:sender
                       withMenuArray:ar
                          imageArray:nil
                           doneBlock:^(NSInteger selectedIndex) {
                               
                               NSLog(@"done block. do something. selectedIndex : %ld", (long)selectedIndex);
                               
                               if( selectedIndex == 0 )
                               {
                                   if( weakSelf.isSnsMode )
                                   {
                                       UINavigationController *navi = [self.storyboard instantiateViewControllerWithIdentifier:@"SnsWriteNavi"];
                                       SnsWriteViewController *vc = [navi.viewControllers firstObject];
                                       vc.isModifyMode = YES;
                                       vc.dic_Info = self.dic_Info;
                                       [vc setCompletionAddBlock:^(id completeResult) {
                                           
                                       }];
                                       [weakSelf presentViewController:navi animated:YES completion:^{
                                           
                                       }];
                                   }
                                   else if( self.isFoodMode )
                                   {
                                       FootCafeWriteViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FootCafeWriteViewController"];
                                       UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
                                       navi.navigationBarHidden = YES;
                                       vc.isModifyMode = YES;
                                       vc.str_ModifyTitle = weakSelf.str_FoodIdenti;
                                       vc.dic_Info = self.dic_Info;
                                       [vc setCompletionAddBlock:^(id completeResult) {
                                           
                                       }];
                                       [weakSelf presentViewController:navi animated:YES completion:^{
                                           
                                       }];
                                   }
                                   else if( self.isComunnytiMode )
                                   {
                                       
                                   }
                               }
                               else
                               {
                                   [UIAlertController showAlertInViewController:self
                                                                      withTitle:@""
                                                                        message:@"게시글을 삭제 하시겠습니까?"
                                                              cancelButtonTitle:@"취소"
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
                                                                               [weakSelf delete];
                                                                           }
                                                                       }];
                               }
                           } dismissBlock:^{
                               
                               NSLog(@"user canceled. do nothing.");
                               
                               //                           FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
                               //                           configuration.allowRoundedArrow = !configuration.allowRoundedArrow;
                               
                           }];
    }
    else
    {
        //신고여부
        
        __block BOOL isReport = [[self.dic_Info objectForKey:@"report"] boolValue];
        ar = @[@"게시물 신고하기"];
        
        [FTPopOverMenu showForSender:sender
                       withMenuArray:ar
                          imageArray:nil
                           doneBlock:^(NSInteger selectedIndex) {
                               
                               NSLog(@"done block. do something. selectedIndex : %ld", (long)selectedIndex);
                               
                               [UIAlertController showAlertInViewController:self
                                                                  withTitle:@""
                                                                    message:@"게시물을 신고하시겠습니까?"
                                                          cancelButtonTitle:@"취소"
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
                                                                           if( isReport )
                                                                           {
                                                                               [ALToastView toastInView:[UIApplication sharedApplication].keyWindow withText:@"이미 신고하셨습니다"];
                                                                           }
                                                                           else
                                                                           {
                                                                               [weakSelf report];
                                                                           }
                                                                       }
                                                                   }];
                           } dismissBlock:^{
                               
                               NSLog(@"user canceled. do nothing.");
                           }];
    }
}

- (void)delete
{
    __weak typeof(self)weakSelf = self;

    if( self.isSnsMode )
    {
        [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"board/SNS/article/%@", self.str_Id]
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
                                                    weakSelf.dic_Info = nil;
                                                    
                                                    if( weakSelf.completionDeleteBlock )
                                                    {
                                                        weakSelf.completionDeleteBlock(dic_Data);
                                                    }
                                                    
                                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                                }
                                            }
                                        }];
    }
    else if( self.isFoodMode )
    {
        [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"board/%@/article/%@", self.str_FoodIdenti, self.str_Id]
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
                                                    weakSelf.dic_Info = nil;
                                                    
                                                    if( weakSelf.completionDeleteBlock )
                                                    {
                                                        weakSelf.completionDeleteBlock(dic_Data);
                                                    }
                                                    
                                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                                }
                                            }
                                        }];
    }
}

- (void)reportCancel
{
    NSLog(@"신고취소");
}

- (void)report
{
    NSLog(@"신고");

    __weak typeof(self)weakSelf = self;
    
    if( self.isSnsMode )
    {
        [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"board/SNS/article/%@/report", self.str_Id]
                                            param:nil
                                       withMethod:@"PUT"
                                        withBlock:^(id resulte, NSError *error) {
                                            
                                            [weakSelf updateList:NO];
                                            [ALToastView toastInView:[UIApplication sharedApplication].keyWindow withText:@"신고하였습니다"];
                                        }];
    }
    else if( self.isFoodMode )
    {
        [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"board/%@/article/%@/report", self.str_FoodIdenti, self.str_Id]
                                            param:nil
                                       withMethod:@"PUT"
                                        withBlock:^(id resulte, NSError *error) {
                                            
                                            [weakSelf updateList:NO];
                                            [ALToastView toastInView:[UIApplication sharedApplication].keyWindow withText:@"신고하였습니다"];
                                        }];
    }
}

- (void)onLink:(UIButton *)btn
{
    NSDictionary *dic_Contents = [self.dic_Info objectForKey:@"contents"];
    NSString *str_LinkUrl = [dic_Contents objectForKey_YM:@"linkUrl"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str_LinkUrl]];
}

- (void)onLike:(UIButton *)btn
{
    __weak typeof(self)weakSelf = self;
    __block BOOL isLike = [[self.dic_Info objectForKey:@"like"] boolValue];
    NSString *str_Method = @"";
    if( isLike )
    {
        //이미 좋아요한건 취소
        str_Method = @"DELETE";
    }
    else
    {
        //좋아요
        str_Method = @"POST";
    }
    
    if( self.isSnsMode )
    {
        [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"board/SNS/article/%@/likes", self.str_Id]
                                            param:nil
                                       withMethod:str_Method
                                        withBlock:^(id resulte, NSError *error) {
                                            
                                            [weakSelf updateList:NO];
                                        }];
    }
    else if( self.isFoodMode )
    {
        [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"board/%@/article/%@/likes", self.str_FoodIdenti, self.str_Id]
                                            param:nil
                                       withMethod:str_Method
                                        withBlock:^(id resulte, NSError *error) {
                                            
                                            [weakSelf updateList:NO];
                                        }];
    }
}

- (IBAction)goBack:(id)sender
{
//    if( self.completionBackBlock )
//    {
//        self.completionBackBlock(self.dic_Info);
//    }
    
    [super goBack:sender];
}

- (void)onInfo:(UIButton *)btn
{
    NSString *str_MyIdx = [[NSUserDefaults standardUserDefaults] objectForKey:kMyIdx];
    
    __block NSDictionary *dic_Main = [self.arM_List objectAtIndex:btn.tag];
    NSDictionary *dic_Modifier = [dic_Main objectForKey:@"modifierInfo"];
    NSDictionary *dic_Register = [dic_Modifier objectForKey:@"register"];
    NSString *str_RegisterId = [NSString stringWithFormat:@"%@", [dic_Register objectForKey:@"id"]];
    if( [str_MyIdx isEqualToString:str_RegisterId] )
    {
        //내 글이면 삭제
        NSMutableArray *arM = [NSMutableArray array];
        [arM addObject:@"삭제하기"];
        
        [OHActionSheet showSheetInView:self.view
                                 title:nil
                     cancelButtonTitle:@"취소"
                destructiveButtonTitle:nil
                     otherButtonTitles:arM
                            completion:^(OHActionSheet* sheet, NSInteger buttonIndex)
         {
             if( buttonIndex == 0 )
             {
                 //삭제하기
                 __weak __typeof(&*self)weakSelf = self;
                 [UIAlertController showAlertInViewController:weakSelf
                                                    withTitle:@""
                                                      message:@"댓글을 삭제하시겠습니까?"
                                            cancelButtonTitle:@"취소"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@[@"확인"]
                                                     tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex){
                                                         
                                                         if (buttonIndex == controller.cancelButtonIndex)
                                                         {

                                                         }
                                                         else if (buttonIndex == controller.destructiveButtonIndex)
                                                         {

                                                         }
                                                         else if (buttonIndex >= controller.firstOtherButtonIndex)
                                                         {
                                                             NSString *str_CommentId = [NSString stringWithFormat:@"%@", [dic_Main objectForKey_YM:@"id"]];
                                                             
                                                             if( self.isSnsMode )
                                                             {
                                                                 [[WebAPI sharedData] callAsyncWebAPIBlock:
                                                                  [NSString stringWithFormat:@"board/SNS/article/%@/comment/%@", self.str_Id, str_CommentId]
                                                                                                     param:nil
                                                                                                withMethod:@"DELETE"
                                                                                                 withBlock:^(id resulte, NSError *error) {
                                                                                                     
                                                                                                     [weakSelf.arM_List removeObject:dic_Main];
                                                                                                     [weakSelf.tbv_List reloadData];
                                                                                                     
                                                                                                     [Util showToast:@"삭제 되었습니다"];
                                                                                                 }];
                                                             }
                                                             else if( self.isFoodMode )
                                                             {
                                                                 [[WebAPI sharedData] callAsyncWebAPIBlock:
                                                                  [NSString stringWithFormat:@"board/%@/article/%@/comment/%@", self.str_FoodIdenti, self.str_Id, str_CommentId]
                                                                                                     param:nil
                                                                                                withMethod:@"DELETE"
                                                                                                 withBlock:^(id resulte, NSError *error) {
                                                                                                     
                                                                                                     [weakSelf.arM_List removeObject:dic_Main];
                                                                                                     [weakSelf.tbv_List reloadData];
                                                                                                     
                                                                                                     [Util showToast:@"삭제 되었습니다"];
                                                                                                 }];
                                                             }
                                                         }
                                                     }];
             }
         }];
    }
    else
    {
        //남의 글이면 신고
        __block BOOL isReport = [[dic_Main objectForKey_YM:@"report"] boolValue];
        
        NSMutableArray *arM = [NSMutableArray array];
        [arM addObject:@"신고하기"];
        
        [OHActionSheet showSheetInView:self.view
                                 title:nil
                     cancelButtonTitle:@"취소"
                destructiveButtonTitle:nil
                     otherButtonTitles:arM
                            completion:^(OHActionSheet* sheet, NSInteger buttonIndex)
         {
             if( buttonIndex == 0 )
             {
                 //신고하기
                 if( isReport )
                 {
                     [Util showToast:@"이미 신고 하였습니다"];
                     return;
                 }
                 __weak __typeof(&*self)weakSelf = self;
                 [UIAlertController showAlertInViewController:weakSelf
                                                    withTitle:@""
                                                      message:@"댓글을 신고하시겠습니까?"
                                            cancelButtonTitle:@"취소"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@[@"확인"]
                                                     tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex){
                                                         
                                                         if (buttonIndex == controller.cancelButtonIndex)
                                                         {
                                                             
                                                         }
                                                         else if (buttonIndex == controller.destructiveButtonIndex)
                                                         {
                                                             
                                                         }
                                                         else if (buttonIndex >= controller.firstOtherButtonIndex)
                                                         {
                                                             NSString *str_CommentId = [NSString stringWithFormat:@"%@", [dic_Main objectForKey_YM:@"id"]];
                                                             if( self.isSnsMode )
                                                             {
                                                                 [[WebAPI sharedData] callAsyncWebAPIBlock:
                                                                  [NSString stringWithFormat:@"board/SNS/article/%@/comment/%@/report", self.str_Id, str_CommentId]
                                                                                                     param:nil
                                                                                                withMethod:@"PUT"
                                                                                                 withBlock:^(id resulte, NSError *error) {
                                                                                                     
                                                                                                     [weakSelf updateList:NO];
                                                                                                     
                                                                                                     [Util showToast:@"신고 되었습니다"];
                                                                                                 }];
                                                             }
                                                             else if( self.isFoodMode )
                                                             {
                                                                 [[WebAPI sharedData] callAsyncWebAPIBlock:
                                                                  [NSString stringWithFormat:@"board/%@/article/%@/comment/%@/report", self.str_FoodIdenti, self.str_Id, str_CommentId]
                                                                                                     param:nil
                                                                                                withMethod:@"PUT"
                                                                                                 withBlock:^(id resulte, NSError *error) {
                                                                                                     
                                                                                                     [weakSelf updateList:NO];
                                                                                                     
                                                                                                     [Util showToast:@"신고 되었습니다"];
                                                                                                 }];
                                                             }
                                                         }
                                                     }];
             }
         }];
    }
}

@end

