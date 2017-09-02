//
//  SnsWriteViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 17..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "SnsWriteViewController.h"
#import "UIPlaceHolderTextView.h"
#import "SnsCategoryViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "BSImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "BSImagePickerController.h"
#import "SnsInPutTagViewController.h"

static NSInteger const kLimitText = 2000;
static const NSInteger kMaxImageCnt = 3;

@interface SnsWriteViewController () <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSDictionary *dic_Category;
@property (nonatomic, strong) BSImagePickerController *imagePicker;
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, strong) NSMutableArray *arM_VideoData;
@property (nonatomic, strong) NSMutableArray *arM_Photo;
@property (nonatomic, strong) NSMutableArray *arM_Tags;
@property (nonatomic, weak) IBOutlet UILabel *lb_MainTitle;
@property (nonatomic, weak) IBOutlet UIButton *btn_Category;
@property (nonatomic, weak) IBOutlet UIButton *btn_Send;
@property (nonatomic, weak) IBOutlet UILabel *lb_Category;
@property (nonatomic, weak) IBOutlet UIPlaceHolderTextView *tv_Contents;
@property (nonatomic, weak) IBOutlet UIView *v_BottomMenu;
@property (nonatomic, weak) IBOutlet UIView *v_Picture;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_MenuBottom;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_PictureHeight;
@property (nonatomic, weak) IBOutlet UIView *v_Link;
@property (nonatomic, weak) IBOutlet UIView *v_LinkBg;
@property (nonatomic, weak) IBOutlet UITextField *tf_Link;
@property (nonatomic, weak) IBOutlet UILabel *lb_Tags;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_TagHeight;
@property (nonatomic, weak) IBOutlet UIButton *btn_Image;
@property (nonatomic, weak) IBOutlet UIButton *btn_Video;
@property (nonatomic, weak) IBOutlet UIButton *btn_Link;
@end

@implementation SnsWriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //test code
//    self.tf_Link.text = @"https://www.naver.com";
    
    
    self.btn_Category.layer.borderColor = [UIColor colorWithHexString:@"c8c8c8"].CGColor;
    self.btn_Category.layer.borderWidth = 0.5f;
    self.tv_Contents.placeholder = @"내용을 입력해 주세요.";
    
    self.arM_Photo = [NSMutableArray array];
    self.arM_VideoData = [NSMutableArray array];
    
    self.v_LinkBg.layer.borderColor = [UIColor colorWithRed:200.f/255.f green:200.f/255.f blue:200.f/255.f alpha:1].CGColor;
    self.v_LinkBg.layer.borderWidth = 0.5f;
    
    self.lc_PictureHeight.constant = 0.f;
    
    
    if( self.isModifyMode )
    {
        self.lb_MainTitle.text = @"수정하기";
        
        self.dic_Category = [self.dic_Info objectForKey:@"category"];
        self.lb_Category.text = [self.dic_Category objectForKey:@"text"];
        NSDictionary *dic_Contents = [NSDictionary dictionaryWithDictionary:[self.dic_Info objectForKey:@"contents"]];
        self.tv_Contents.text = [dic_Contents objectForKey:@"body"];
        
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
        
        //태그
        self.arM_Tags = [NSMutableArray arrayWithArray:[self.dic_Info objectForKey:@"tags"]];
        [self updateTag];
        
        if( [str_Type isEqualToString:@"IMAGE"] )
//        if( 1 )
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
//        else if( 1 )
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
        else if( [str_Type isEqualToString:@"LINK"] )
        {
            self.tf_Link.text = [dic_Contents objectForKey:@"linkUrl"];
            [self goLink:nil];
        }
        else
        {
            
        }
        
    }
    else
    {
        self.lb_MainTitle.text = @"글쓰기";
    }

    
    
//    UITapGestureRecognizer *textViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewTap:)];
//    [textViewTap setNumberOfTapsRequired:1];
//    [self.tv_Contents addGestureRecognizer:textViewTap];

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    __weak __typeof(&*self)weakSelf = self;

    if( [segue.identifier isEqualToString:@"TagSegue"] )
    {
        SnsInPutTagViewController *vc = [segue destinationViewController];
        vc.arM_SelectedTag = [NSMutableArray arrayWithArray:self.arM_Tags];
        [vc setCompletionTagBlock:^(id completeResult) {
           
            NSLog(@"%@", completeResult);
            
            self.arM_Tags = [NSMutableArray arrayWithArray:completeResult];
            [weakSelf updateTag];
        }];
    }
    
    
}


//- (void)textViewTap:(UIGestureRecognizer *)gesture
//{
//    [self.view endEditing:YES];
//}


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

- (void)initBottomSeleteMode
{
    self.btn_Image.selected = NO;
    self.btn_Video.selected = NO;
    self.btn_Link.selected = NO;
}

- (void)updateImageThumbnail
{
    [self initBottomSeleteMode];
    
    if( self.arM_Photo.count > 0 )
    {
        self.v_Link.hidden = YES;
        self.v_Picture.hidden = NO;
        self.tf_Link.text = @"";
        self.btn_Image.selected = YES;
        
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
    [self initBottomSeleteMode];

    if( self.arM_VideoData.count > 0 )
    {
        self.v_Link.hidden = YES;
        self.v_Picture.hidden = NO;
        self.tf_Link.text = @"";
        self.btn_Video.selected = YES;

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

- (void)updateTag
{
    NSMutableString *strM_Tags = [NSMutableString string];
    for( NSInteger i = 0; i < self.arM_Tags.count; i++ )
    {
        NSDictionary *dic = self.arM_Tags[i];
        [strM_Tags appendString:[NSString stringWithFormat:@"#%@", [dic objectForKey_YM:@"name"]]];
        [strM_Tags appendString:@" "];
    }
    
    if( [strM_Tags hasSuffix:@" "] )
    {
        [strM_Tags deleteCharactersInRange:NSMakeRange([strM_Tags length] - 1, 1)];
    }
    
    self.lb_Tags.text = strM_Tags;
    
    if( self.arM_Tags.count > 0 )
    {
        self.lc_TagHeight.constant = 28.0f;
    }
    else
    {
        self.lc_TagHeight.constant = 0.f;
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
    vc.dic_CateInfo = self.dic_Category;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [vc setCompletionCategoryBlock:^(id completeResult) {
       
        weakSelf.dic_Category = completeResult;
        weakSelf.lb_Category.text = [weakSelf.dic_Category objectForKey:@"text"];
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
        //        [Util showToast:str_Msg];
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
//        [Util showToast:str_Msg];
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

//    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//    imagePickerController.delegate = self;
//    imagePickerController.allowsEditing = YES;
//    
//    if(IS_IOS8_OR_ABOVE)
//    {
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [self presentViewController:imagePickerController animated:YES completion:nil];
//        }];
//    }
//    else
//    {
//        [self presentViewController:imagePickerController animated:YES completion:nil];
//    }

}

- (IBAction)goVide:(id)sender
{
    __weak __typeof(&*self)weakSelf = self;

    [UIAlertController showActionSheetInViewController:self
                                             withTitle:nil
                                               message:nil
                                     cancelButtonTitle:@"취소"
                                destructiveButtonTitle:nil
                                     otherButtonTitles:@[@"동영상 촬영하기", @"앨범에서 가져오기"]
                    popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
                        
                    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                       
                        if( buttonIndex >= controller.firstOtherButtonIndex )
                        {
                            if( buttonIndex == controller.firstOtherButtonIndex )
                            {
                                NSLog(@"촬영");
                                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
                                imagePickerController.delegate = self;
                                imagePickerController.allowsEditing = YES;
                                
                                if(IS_IOS8_OR_ABOVE)
                                {
                                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                        [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
                                    }];
                                }
                                else
                                {
                                    [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
                                }
                            }
                            else if( buttonIndex == controller.firstOtherButtonIndex + 1 )
                            {
                                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
                                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
                                imagePickerController.delegate = self;
                                //             imagePickerController.allowsEditing = YES;
                                
                                if(IS_IOS8_OR_ABOVE)
                                {
                                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                        [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
                                    }];
                                }
                                else
                                {
                                    [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
                                }
                            }
                        }
                    }];

}

- (IBAction)goLink:(id)sender
{
    [self.arM_VideoData removeAllObjects];
    [self.arM_Photo removeAllObjects];
    self.lc_PictureHeight.constant = 80.f;
    [self.tv_Contents setNeedsDisplay];
    self.v_Link.hidden = NO;
    self.v_Picture.hidden = YES;
    
    [self initBottomSeleteMode];
    self.btn_Link.selected = YES;
}

- (IBAction)goTag:(id)sender
{
    
}

- (IBAction)goSend:(id)sender
{
    [self.view endEditing:YES];
    
    if( self.dic_Category == nil )
    {
        [Util showToast:@"카테고리를 선택해 주세요"];
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
    else if( self.tf_Link.text.length > 0 )
    {
        NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionary];
        [dicM_Params setObject:@{@"value":@"LINK"} forKey:@"type"];
//        NSMutableDictionary *dicM_Link = [NSMutableDictionary dictionary];
//        [dicM_Link setObject:self.tf_Link.text forKey:@"linkUrl"];
//        [dicM_Link setObject:@"" forKey:@"linkName"];
//        [dicM_Params setObject:dicM_Link forKey:@"contents"];

        NSMutableDictionary *dicM_Contents = [NSMutableDictionary dictionary];
        NSMutableDictionary *dicM_Type = [NSMutableDictionary dictionary];
        [dicM_Type setObject:@"링크" forKey:@"text"];
        [dicM_Type setObject:@"LINK" forKey:@"value"];
        [dicM_Contents setObject:dicM_Type forKey:@"type"];
        
        [dicM_Contents setObject:self.tf_Link.text forKey:@"linkUrl"];
        [dicM_Params setObject:dicM_Contents forKey:@"contents"];
        
        [self sendTextContents:dicM_Params];
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
    
//    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionary];
//    [dicM_Params setObject:@{@"value":[NSString stringWithFormat:@"%@", [self.dic_Category objectForKey:@"value"]]} forKey:@"category"];
//    [dicM_Params setObject:@{@"value":@"TEXT"} forKey:@"type"];
    
    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionaryWithDictionary:dic];

    [dicM_Params setObject:@{@"value":[NSString stringWithFormat:@"%@", [self.dic_Category objectForKey:@"value"]]} forKey:@"category"];

    NSMutableDictionary *dicM_Contents = [NSMutableDictionary dictionaryWithDictionary:[dicM_Params objectForKey:@"contents"]];
    [dicM_Contents setObject:@"" forKey:@"subject"];
    [dicM_Contents setObject:self.tv_Contents.text forKey:@"body"];
    
    [dicM_Params setObject:dicM_Contents forKey:@"contents"];
    
    NSMutableDictionary *dicM_Type = [dicM_Contents objectForKey:@"type"];
    if( dicM_Type == nil )
    {
        dicM_Contents = [NSMutableDictionary dictionary];
        [dicM_Type setObject:@"텍스트" forKey:@"text"];
        [dicM_Type setObject:@"TEXT" forKey:@"value"];
        
        [dicM_Contents setObject:dicM_Type forKey:@"type"];
    }
    
    
    
    if( self.arM_Tags.count > 0 )
    {
        [dicM_Params setObject:self.arM_Tags forKey:@"tags"];
    }

    NSString *str_Path = @"board/SNS/article";
    if( self.isModifyMode )
    {
        NSString *str_Id = [NSString stringWithFormat:@"%@", [self.dic_Info objectForKey:@"id"]];
        str_Path = [NSString stringWithFormat:@"board/SNS/article/%@", str_Id];
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

@end
