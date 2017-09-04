//
//  FootCafeWriteViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 9. 1..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "FootCafeWriteViewController.h"
#import "UIPlaceHolderTextView.h"
#import "SnsCategoryViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "BSImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "BSImagePickerController.h"

static NSInteger const kLimitText = 2000;
static const NSInteger kMaxImageCnt = 3;

@interface FootCafeWriteViewController () <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSDictionary *dic_Category;
@property (nonatomic, strong) NSDictionary *dic_Header;
@property (nonatomic, strong) BSImagePickerController *imagePicker;
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, strong) NSMutableArray *arM_VideoData;
@property (nonatomic, strong) NSMutableArray *arM_Photo;

@property (nonatomic, weak) IBOutlet UILabel *lb_MainTitle;
@property (nonatomic, weak) IBOutlet UITextField *tf_Category;
@property (nonatomic, weak) IBOutlet UITextField *tf_Header;
@property (nonatomic, weak) IBOutlet UIButton *btn_Secret;
@property (nonatomic, weak) IBOutlet UITextField *tf_Title;
@property (nonatomic, weak) IBOutlet UIPlaceHolderTextView *tv_Contents;
@property (nonatomic, weak) IBOutlet UIButton *btn_Category;
@property (nonatomic, weak) IBOutlet UIButton *btn_Header;
@property (nonatomic, weak) IBOutlet UIButton *btn_Send;

@property (nonatomic, weak) IBOutlet UIView *v_BottomMenu;
@property (nonatomic, weak) IBOutlet UIView *v_Picture;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_MenuBottom;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_PictureHeight;

@end

@implementation FootCafeWriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btn_Category.layer.borderColor = [UIColor colorWithHexString:@"c8c8c8"].CGColor;
    self.btn_Category.layer.borderWidth = 0.5f;
    
    self.btn_Header.layer.borderColor = [UIColor colorWithHexString:@"c8c8c8"].CGColor;
    self.btn_Header.layer.borderWidth = 0.5f;

    self.tv_Contents.placeholder = @"내용을 입력해 주세요.";

    self.arM_Photo = [NSMutableArray array];
    self.arM_VideoData = [NSMutableArray array];

    self.lc_PictureHeight.constant = 0.f;

    self.dic_Category = self.dic_SelectCategory;
    self.tf_Category.text = [self.dic_Category objectForKey:@"name"];
    self.tf_Category.userInteractionEnabled = self.btn_Category.userInteractionEnabled = NO;
    
    
    if( self.isModifyMode )
    {
        self.lb_MainTitle.text = @"수정하기";

        [self updateCategory];
        
        NSDictionary *dic_Contents = [self.dic_Info objectForKey:@"contents"];
        self.tf_Title.text = [dic_Contents objectForKey_YM:@"subject"];
        
        self.dic_Header = [self.dic_Info objectForKey:@"category"];
        self.tf_Header.text = [self.dic_Header objectForKey:@"text"];
        
        self.tv_Contents.text = [dic_Contents objectForKey:@"body"];
        
        self.btn_Secret.selected = [[self.dic_Info objectForKey:@"secret"] boolValue];
        
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
        
        if( [str_Type isEqualToString:@"IMAGE"] )
        {
            NSArray *ar_Images = [dic_Contents objectForKey:@"images"];
            for( NSInteger i = 0; i < ar_Images.count; i++ )
            {
                NSDictionary *dic_ImageInfo = ar_Images[i];
                NSString *str_ImageUrl = [dic_ImageInfo objectForKey:@"resourceUri"];
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str_ImageUrl]];
                [self.arM_Photo addObject:imageData];
            }
            
            [self updateImageThumbnail];
        }
        else if( [str_Type isEqualToString:@"VIDEO"] )
        {
            NSDictionary *dic_VideoInfo = [dic_Contents objectForKey:@"video"];
            self.videoUrl = [NSURL URLWithString:[dic_VideoInfo objectForKey:@"resourceUri"]];
            
            if( self.videoUrl )
            {
                NSData *videoData = [NSData dataWithContentsOfURL:self.videoUrl];
                [self.arM_VideoData addObject:videoData];
                [self updateVideoThumbnail];
            }
        }
        else
        {
            
        }
        
    }
    else
    {
        self.lb_MainTitle.text = @"글쓰기";
        NSString *str_CateName = [self.dic_Category objectForKey_YM:@"name"];
        if( [[self.dic_Category objectForKey_YM:@"name"] isEqualToString:@"물류문의"] )
        {
            self.tv_Contents.text = @"매장명 : \n주문일자(출고일자) : \n물류코드 : \n제품명 : \n내용 : \n송장번호(선택) : \n";
        }
        else if( [[self.dic_Category objectForKey_YM:@"name"] isEqualToString:@"궁금해요"] )
        {
            self.tv_Contents.placeholder = @"· 제품문의 : 제품 효능, 특징, 성분, 출시요청 등\n· 생산일정/물류 : 품절, 입고 일정 등\n· 디자인 : 용기디자인, 유니폼, 연출물, POP 등\n· 고객관리/CRM : 멤버십, 등급쿠폰, 회원정보 등\n· 광고홍보 : 매거진, 방송, 모델, 홍보 등\n· POS/전산 : POS, 영업정보시스템 전산 등\n· 프로모션/행사 : 멤버십데이, 빅세일, 프로모션 행사, 사은품 등";
        }
        else if( [str_CateName rangeOfString:@"엔젤"].location != NSNotFound )
        {
            if( [UIScreen mainScreen].bounds.size.height > 568.0f )
            {
                self.tv_Contents.placeholder = @"유관부서의 답변이 필요한 질문은 '궁금해요' 게시판을 이용해 주세요";
            }
            else
            {
                self.tv_Contents.placeholder = @"유관부서의 답변이 필요한 질문은 '궁금해요' 게시판을\n이용해 주세요";
            }
            
        }
//        else if( [[self.dic_Category objectForKey_YM:@"name"] isEqualToString:@"푸드엔젤지식In"] )
//        {
//            self.tv_Contents.placeholder = @"유관부서의 답변이 필요한 질문은 '궁금해요' 게시판을 이용해 주세요.";
//        }
    }
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
                                                NSArray *ar = [NSMutableArray arrayWithArray:[resulte objectForKey:@"data"]];
                                                for( NSInteger i = 0; i < ar.count; i++ )
                                                {
                                                    NSDictionary *dic = ar[i];
                                                    if( [[dic objectForKey_YM:@"identifier"] isEqualToString:self.str_ModifyTitle] )
                                                    {
                                                        weakSelf.dic_Category = dic;
                                                        weakSelf.tf_Category.text = [weakSelf.dic_Category objectForKey:@"name"];
                                                        break;
                                                    }
                                                }
                                                
                                            }
                                        }
                                        
                                        [weakSelf.view updateConstraintsIfNeeded];
                                        [weakSelf.view layoutIfNeeded];
                                    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAnimate:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAnimate:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
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
            self.lc_MenuBottom.constant = keyboardBounds.size.height;
            [self.tv_Contents setNeedsDisplay];
        }
        else if([notification name] == UIKeyboardWillHideNotification)
        {
            self.lc_MenuBottom.constant = 0.f;
            [self.tv_Contents setNeedsDisplay];
        }
    }completion:^(BOOL finished) {
        
    }];
}



- (void)updateImageThumbnail
{
//    [self initBottomSeleteMode];
    
    if( self.arM_Photo.count > 0 )
    {
        self.v_Picture.hidden = NO;
//        self.btn_Image.selected = YES;
        
        [self.arM_VideoData removeAllObjects];
        
        self.lc_PictureHeight.constant = 90.f;
        [self.tv_Contents setNeedsDisplay];
    }
    else
    {
        self.lc_PictureHeight.constant = 0.f;
        [self.tv_Contents setNeedsDisplay];
    }
    
    for( UIView *subView in self.v_Picture.subviews )
    {
        if( subView.tag > 0 )
        {
            subView.hidden = YES;
        }
    }
    
    for( NSInteger i = 0; i < self.arM_Photo.count; i++ )
    {
        NSData *imageData = self.arM_Photo[i];
        UIImage *image = [UIImage imageWithData:imageData];
        
        UIView *view = [self.v_Picture viewWithTag:i + 1];
        view.hidden = NO;
        for( id pictureSubView in view.subviews )
        {
            if( [pictureSubView isKindOfClass:[UIImageView class]] )
            {
                UIImageView *iv = (UIImageView *)pictureSubView;
                iv.image = image;
            }
            
            if( [pictureSubView isKindOfClass:[UIButton class]] )
            {
                UIButton *btn = (UIButton *)pictureSubView;
                if( btn.tag == 100 )
                {
                    btn.hidden = YES;
                }
                else
                {
                    btn.tag = i;
                    [btn addTarget:self action:@selector(onDeleteImage:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
    }
}

- (void)updateVideoThumbnail
{
//    [self initBottomSeleteMode];
    
    if( self.arM_VideoData.count > 0 )
    {
        self.v_Picture.hidden = NO;
//        self.btn_Video.selected = YES;
        
        [self.arM_Photo removeAllObjects];
        
        self.lc_PictureHeight.constant = 90.f;
        [self.tv_Contents setNeedsDisplay];
    }
    else
    {
        self.lc_PictureHeight.constant = 0.f;
        [self.tv_Contents setNeedsDisplay];
    }
    
    [self.tv_Contents layoutIfNeeded];
    
    for( UIView *subView in self.v_Picture.subviews )
    {
        if( subView.tag > 0 )
        {
            subView.hidden = YES;
        }
    }
    
    for( NSInteger i = 0; i < self.arM_VideoData.count; i++ )
    {
        NSData *imageData = self.arM_VideoData[i];
        __block UIImage *image = [UIImage imageWithData:imageData];
        
        if( image == nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.videoUrl options:nil];
                AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                NSError *error = NULL;
                CMTime time = CMTimeMake(1, 1);
                CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
                NSLog(@"error==%@, Refimage==%@", error, refImg);
                
                UIImage *FrameImage= [[UIImage alloc] initWithCGImage:refImg];
                image = FrameImage;
                
                UIView *view = [self.v_Picture viewWithTag:i + 1];
                view.hidden = NO;
                for( id pictureSubView in view.subviews )
                {
                    if( [pictureSubView isKindOfClass:[UIImageView class]] )
                    {
                        UIImageView *iv = (UIImageView *)pictureSubView;
                        iv.image = image;
                    }
                    
                    if( [pictureSubView isKindOfClass:[UIButton class]] )
                    {
                        UIButton *btn = (UIButton *)pictureSubView;
                        if( btn.tag == 100 )
                        {
                            btn.hidden = NO;
                            btn.userInteractionEnabled = NO;
                        }
                        else
                        {
                            btn.tag = i;
                            [btn addTarget:self action:@selector(onDeleteVideo:) forControlEvents:UIControlEventTouchUpInside];
                        }
                    }
                }
            });
        }
        else
        {
            UIView *view = [self.v_Picture viewWithTag:i + 1];
            view.hidden = NO;
            for( id pictureSubView in view.subviews )
            {
                if( [pictureSubView isKindOfClass:[UIImageView class]] )
                {
                    UIImageView *iv = (UIImageView *)pictureSubView;
                    iv.image = image;
                }
                
                if( [pictureSubView isKindOfClass:[UIButton class]] )
                {
                    UIButton *btn = (UIButton *)pictureSubView;
                    if( btn.tag == 100 )
                    {
                        btn.hidden = NO;
                        btn.userInteractionEnabled = NO;
                    }
                    else
                    {
                        btn.tag = i;
                        [btn addTarget:self action:@selector(onDeleteVideo:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
            }
        }
    }
}

- (void)onDeleteImage:(UIButton *)btn
{
    [self.arM_Photo removeObjectAtIndex:btn.tag];
    [self updateImageThumbnail];
}

- (void)onDeleteVideo:(UIButton *)btn
{
    [self.arM_VideoData removeAllObjects];
    [self updateVideoThumbnail];
}


#pragma mark - ImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.movie"])
    {
        self.videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.videoUrl options:nil];
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        gen.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMakeWithSeconds(0.0, 600);
        NSError *error = nil;
        CMTime actualTime;
        
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
        NSData *imageData = UIImageJPEGRepresentation(thumb, 0.5);
        CGImageRelease(image);
        
        [self.arM_VideoData removeAllObjects];
        [self.arM_VideoData addObject:imageData];
        [self updateVideoThumbnail];
        
        [self dismissViewControllerAnimated:YES
                                 completion:^{
                                     
                                 }];
        
    }
    else
    {
        UIImage* outputImage = [info objectForKey:UIImagePickerControllerEditedImage] ? [info objectForKey:UIImagePickerControllerEditedImage] : [info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSData *imageData = UIImageJPEGRepresentation(outputImage, 0.5);
        [self.arM_Photo addObject:imageData];
        [self updateImageThumbnail];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



#pragma mark - IBAction
- (IBAction)goShowCategory:(id)sender
{
    __weak __typeof(&*self)weakSelf = self;
    
    SnsCategoryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SnsCategoryViewController"];
    vc.str_Title = @"카테고리 선택";
    vc.isFoodCafeMode = YES;
    vc.dic_CateInfo = self.dic_Category;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [vc setCompletionCategoryBlock:^(id completeResult) {
        
        if( [weakSelf.dic_Category isEqual:completeResult] == NO )
        {
            weakSelf.dic_Category = completeResult;
            weakSelf.tf_Category.text = [weakSelf.dic_Category objectForKey:@"name"];
            
            weakSelf.tf_Header.text = @"";
            weakSelf.dic_Header = nil;
        }
    }];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (IBAction)goShowHeader:(id)sender
{
    __weak __typeof(&*self)weakSelf = self;

    if( self.dic_Category == nil )
    {
        [UIAlertController showAlertInViewController:self
                                           withTitle:@""
                                             message:@"카테고리를 선택해 주세요"
                                   cancelButtonTitle:nil
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@[@"확인"]
                                            tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex){
                                                
                                                [weakSelf goShowCategory:nil];
                                            }];
        
        return;
    }
    
    SnsCategoryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SnsCategoryViewController"];
    vc.str_Title = @"말머리 선택";
    vc.dic_CateInfo = self.dic_Category;
    vc.dic_Header = self.dic_Header;
    vc.isFoodCafeHeaderMode = YES;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [vc setCompletionCategoryBlock:^(id completeResult) {
        
        weakSelf.dic_Header = completeResult;
        weakSelf.tf_Header.text = [weakSelf.dic_Header objectForKey:@"text"];
    }];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (IBAction)goCamera:(id)sender
{
    if( kMaxImageCnt <= self.arM_Photo.count )
    {
        NSString *str_Msg = [NSString stringWithFormat:@"최대 %ld장의 이미지 등록이 가능합니다", kMaxImageCnt];
        ALERT_ONE(str_Msg);
        return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    
    if(IS_IOS8_OR_ABOVE)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];
    }
    else
    {
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (IBAction)goAlbum:(id)sender
{
    if( kMaxImageCnt <= self.arM_Photo.count )
    {
        NSString *str_Msg = [NSString stringWithFormat:@"최대 %ld장의 이미지 등록이 가능합니다", kMaxImageCnt];
        ALERT_ONE(str_Msg);
        return;
    }
    
    self.imagePicker = [[BSImagePickerController alloc] init];
    self.imagePicker.maximumNumberOfImages = kMaxImageCnt - self.arM_Photo.count;
    self.imagePicker.editing = YES;
    
    [self presentImagePickerController:self.imagePicker
                              animated:YES
                            completion:nil
                                toggle:^(ALAsset *asset, BOOL select) {
                                    if(select)
                                    {
                                        NSLog(@"Image selected");
                                    }
                                    else
                                    {
                                        NSLog(@"Image deselected");
                                    }
                                }
                                cancel:^(NSArray *assets) {
                                    NSLog(@"User canceled...!");
                                    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
                                }
                                finish:^(NSArray *assets) {
                                    NSLog(@"User finished :)!");
                                    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
                                    
                                    for( NSInteger i = 0; i < assets.count; i++ )
                                    {
                                        ALAsset *asset = assets[i];
                                        
                                        ALAssetRepresentation *rep = [asset defaultRepresentation];
                                        CGImageRef iref = [rep fullScreenImage];
                                        if (iref)
                                        {
                                            UIImage *image = [UIImage imageWithCGImage:iref];
                                            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                                            [self.arM_Photo addObject:imageData];
                                            [self updateImageThumbnail];
                                        }
                                    }
                                }];
}

- (IBAction)goSend:(id)sender
{
    [self.view endEditing:YES];
    
    if( self.dic_Category == nil )
    {
        [Util showToast:@"카테고리를 선택해 주세요"];
        return;
    }

    if( self.dic_Header == nil )
    {
        [Util showToast:@"말머리를 선택해 주세요"];
        return;
    }
    
    if( self.tf_Title.text.length <= 0 )
    {
        [Util showToast:@"제목을 입력해 주세요"];
        return;
    }

    if( self.tv_Contents.text.length <= 0 )
    {
        [Util showToast:@"내용을 입력해 주세요"];
        return;
    }
    
    if( self.arM_Photo.count > 0 )
    {
        [self sendImageContents];
    }
    else if( self.arM_VideoData.count > 0 )
    {
        [self sendVideoContents];
    }
    else
    {
        NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionary];
        [dicM_Params setObject:@{@"value":@"TEXT"} forKey:@"type"];
        
        NSMutableDictionary *dicM_Contents = [NSMutableDictionary dictionary];
        NSMutableDictionary *dicM_Type = [NSMutableDictionary dictionary];
        [dicM_Type setObject:@"텍스트" forKey:@"text"];
        [dicM_Type setObject:@"TEXT" forKey:@"value"];
        [dicM_Contents setObject:dicM_Type forKey:@"type"];
        [dicM_Params setObject:dicM_Contents forKey:@"contents"];
        
        [self sendTextContents:dicM_Params];
    }
}

- (void)sendTextContents:(NSDictionary *)dic
{
    __weak __typeof(&*self)weakSelf = self;
    
    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionaryWithDictionary:dic];
    
//    [dicM_Params setObject:@{@"value":[NSString stringWithFormat:@"%@", [self.dic_Category objectForKey:@"id"]]} forKey:@"category"];
    
    if( self.dic_Header && self.tf_Header.text.length > 0 && [self.tf_Header.text isEqualToString:@"전체"] == NO )
    {
        [dicM_Params setObject:@{@"value":[NSString stringWithFormat:@"%@", [self.dic_Header objectForKey:@"value"]]} forKey:@"category"];
    }
    
    NSMutableDictionary *dicM_Contents = [NSMutableDictionary dictionaryWithDictionary:[dicM_Params objectForKey:@"contents"]];
    [dicM_Contents setObject:self.tf_Title.text forKey:@"subject"];
    [dicM_Contents setObject:self.tv_Contents.text forKey:@"body"];
    [dicM_Contents setObject:self.btn_Secret.selected ? @"1" : @"0" forKey:@"secret"];
    
    [dicM_Params setObject:dicM_Contents forKey:@"contents"];
    
    
    NSMutableDictionary *dicM_Type = [dicM_Contents objectForKey:@"type"];
    if( dicM_Type == nil )
    {
        dicM_Contents = [NSMutableDictionary dictionary];
        [dicM_Type setObject:@"텍스트" forKey:@"text"];
        [dicM_Type setObject:@"TEXT" forKey:@"value"];
        
        [dicM_Contents setObject:dicM_Type forKey:@"type"];
    }
    
    
    NSString *str_Path = @"";
    if( self.isModifyMode )
    {
        NSString *str_Id = [NSString stringWithFormat:@"%@", [self.dic_Info objectForKey:@"id"]];
        NSString *str_CateIdenti = [self.dic_Category objectForKey_YM:@"identifier"];
        str_Path = [NSString stringWithFormat:@"board/%@/article/%@", str_CateIdenti, str_Id];
    }
    else
    {
        NSString *str_CateIdenti = [self.dic_Category objectForKey_YM:@"identifier"];
        str_Path = [NSString stringWithFormat:@"board/%@/article", str_CateIdenti];
    }
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:str_Path
                                        param:dicM_Params
                                   withMethod:self.isModifyMode ? @"PUT" : @"POST"
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
                                                NSDictionary *dic_Data = [NSDictionary dictionaryWithDictionary:[resulte objectForKey:@"data"]];
                                                if( weakSelf.completionAddBlock )
                                                {
                                                    weakSelf.completionAddBlock(dic_Data);
                                                }
                                                [weakSelf dismissViewControllerAnimated:YES completion:^{
                                                    
                                                }];
                                            }
                                        }
                                    }];
}

- (void)sendImageContents
{
    __weak __typeof(&*self)weakSelf = self;
    
    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionary];
    
    [dicM_Params setObject:@"IMAGE" forKey:@"type"];
    
    NSMutableDictionary *dicM_Image = [NSMutableDictionary dictionaryWithCapacity:self.arM_Photo.count];
    for( NSInteger i = 0; i < self.arM_Photo.count; i++ )
    {
        NSData *imageData = self.arM_Photo[i];
        NSString *str_Key = [NSString stringWithFormat:@"attachFiles%ld", i + 1];
        [dicM_Image setObject:imageData forKey:str_Key];
    }
    
    self.view.userInteractionEnabled = NO;
    
    [[WebAPI sharedData] imageUpload:@"common/attachment"
                               param:nil
                          withImages:dicM_Image
                           withBlock:^(id resulte, NSError *error) {
                               
                               [GMDCircleLoader hide];
                               
                               if( resulte )
                               {
                                   NSArray *ar = [resulte objectForKey:@"data"];
                                   if( ar.count > 0 )
                                   {
                                       //NSMutableDictionary *dicM_Contents = [NSMutableDictionary dictionaryWithDictionary:[dicM_Params objectForKey:@"contents"]];
                                       NSMutableDictionary *dicM_Contents = [NSMutableDictionary dictionary];
                                       [dicM_Contents setObject:ar forKey:@"images"];
                                       
                                       NSMutableDictionary *dicM_Type = [NSMutableDictionary dictionary];
                                       [dicM_Type setObject:@"이미지" forKey:@"text"];
                                       [dicM_Type setObject:@"IMAGE" forKey:@"value"];
                                       [dicM_Contents setObject:dicM_Type forKey:@"type"];
                                       
                                       [dicM_Params setObject:dicM_Contents forKey:@"contents"];
                                       [weakSelf sendTextContents:dicM_Params];
                                   }
                               }
                               
                               weakSelf.view.userInteractionEnabled = YES;
                           }];
}

- (void)sendVideoContents
{
    __weak __typeof(&*self)weakSelf = self;
    
    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionary];
    [dicM_Params setObject:@{@"value":@"VIDEO"} forKey:@"type"];
    
    self.view.userInteractionEnabled = NO;
    
    [GMDCircleLoader show];
    
    NSMutableDictionary *dicM_Video = [NSMutableDictionary dictionary];
    NSData *videoData = nil;
    if( self.videoUrl )
    {
        videoData = [NSData dataWithContentsOfURL:self.videoUrl];
        [dicM_Video setObject:videoData forKey:@"videoFile"];
    }
    
    [[WebAPI sharedData] imageUpload:@"common/attachment"
                               param:nil
                          withImages:dicM_Video
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
                                       NSArray *ar = [resulte objectForKey:@"data"];
                                       if( ar.count > 0 )
                                       {
                                           NSMutableDictionary *dicM_Contents = [NSMutableDictionary dictionary];
                                           [dicM_Contents setObject:[ar firstObject] forKey:@"video"];
                                           
                                           NSMutableDictionary *dicM_Type = [NSMutableDictionary dictionary];
                                           [dicM_Type setObject:@"비디오" forKey:@"text"];
                                           [dicM_Type setObject:@"VIDEO" forKey:@"value"];
                                           [dicM_Contents setObject:dicM_Type forKey:@"type"];
                                           
                                           [dicM_Params setObject:dicM_Contents forKey:@"contents"];
                                           [weakSelf sendTextContents:dicM_Params];
                                       }
                                   }
                               }
                               
                               weakSelf.view.userInteractionEnabled = YES;
                           }];
}

- (IBAction)goSecrt:(id)sender
{
    self.btn_Secret.selected = !self.btn_Secret.selected;
}

@end
