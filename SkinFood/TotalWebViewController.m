//
//  TotalWebViewController.m
//  SMBA_EN
//
//  Created by KimYoung-Min on 2016. 5. 16..
//  Copyright © 2016년 youngmin.kim. All rights reserved.
//

#import "TotalWebViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "MWPhotoBrowser.h"
#import "BSImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

static const NSInteger kMaxImageCnt = 1;

@interface TotalWebViewController () <UIWebViewDelegate, MWPhotoBrowserDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSInteger nTotalPage;   //pdf 전용
}
@property (nonatomic, assign) BOOL isImageMode;
@property (nonatomic, strong) NSMutableArray *ar_Photo;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) BSImagePickerController *imagePicker;
@property (nonatomic, strong) NSMutableArray *arM_Photo;
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UILabel *lb_MainTitle;
@end

@implementation TotalWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView.delegate = self;
    
//    [self initNavi];
    
    if( self.str_Title )
    {
        self.screenName = self.lb_MainTitle.text = self.str_Title;
    }
    else
    {
        self.screenName = @"WebView";
    }
    
    //http://ebt.mobileb2bacademy.com/front/board/wvNotice?userIdx=6420&userAuth=9
    NSString *str_Url = [NSString stringWithFormat:@"%@/%@", kBaseWebUrl, self.str_Url];
    NSLog(@"webview url : %@", str_Url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:str_Url]];
    [self.webView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    
//    if( self.isBackButton )
//    {
//        self.navigationController.navigationBarHidden = NO;
//    }

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

- (void)initNavi
{
    UILabel *lb_Title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, self.navigationController.navigationBar.frame.size.height)];
    lb_Title.tag = kNaviTitleTag;
    lb_Title.font = [UIFont fontWithName:@"Helvetica" size:18];
    lb_Title.textColor = kMainColor;
    lb_Title.text = self.str_Title;
    [Util getTextWith:lb_Title];
    lb_Title.textAlignment = NSTextAlignmentCenter;

    lb_Title.minimumScaleFactor = 0.5f;
    lb_Title.adjustsFontSizeToFitWidth = YES;

    CGRect frame = lb_Title.frame;
    frame.size.width = [Util getTextWith:lb_Title];
    lb_Title.frame = frame;
    
    
    if( frame.size.width > 280.0f )
    {
        frame = lb_Title.frame;
        frame.size.width = 280.f;
        lb_Title.frame = frame;
        
        lb_Title.minimumScaleFactor = 0.5f;
        lb_Title.adjustsFontSizeToFitWidth = YES;
    }
    
    self.navigationItem.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    self.navigationController.navigationBar.opaque = YES;
    [self.navigationItem.titleView addSubview:lb_Title];
    
    if( self.isBackButton )
    {
        self.navigationItem.leftBarButtonItem = [self leftBackMenuBarButtonItem];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = [self leftMenuBar];
    }
    
    [self.navigationController.navigationBar hideBottomHairline];
    
    
    
    /*
     self.navigationItem.leftBarButtonItem = [self leftBackMenuBarButtonItem];
     
     [self.navigationController.navigationBar hideBottomHairline];
     
     NSDictionary *titleBarAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:18],
     NSForegroundColorAttributeName:kMainColor
     };
     self.navigationController.navigationBar.titleTextAttributes = titleBarAttributes;
     
     self.navigationController.navigationItem.title = @"Terms of Use & Privacy Policy";
     */
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if( self.dic_Info && self.str_Idx )
//    {
//        [self updateList];
//    }
}

//- (void)updateList
//{
//    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                        [[NSUserDefaults standardUserDefaults] objectForKey:@"UserIdx"], @"userIdx",
//                                        [[NSUserDefaults standardUserDefaults] objectForKey:@"BrandIdx"], @"brandIdx",
//                                        self.str_Idx, @"integrationCourseIdx",
//                                        [NSString stringWithFormat:@"%ld", [[self.dic_Info objectForKey:@"ProcessIdx"] integerValue]], @"processIdx",
//                                        [NSString stringWithFormat:@"%ld", [[self.dic_Info objectForKey:@"SubProcessIdx"] integerValue]], @"subProcessIdx",
//                                        @"pdf", @"contentType",
//                                        nil];
//    //course/getSubProcessImageList
//    [[WebAPI sharedData] callAsyncWebAPIBlock:@"course/inLearningSubProcessInfo"
//                                        param:dicM_Params
//                                    withBlock:^(id resulte, NSError *error) {
//                                        
//                                        [GMDCircleLoader hide];
//                                        
//                                        if( resulte )
//                                        {
//                                            NSLog(@"%@", resulte);
//                                            
//                                            NSDictionary *dic_Data = [resulte objectForKey:@"Data"];
//                                            NSDictionary *dic_Meta = [resulte objectForKey:@"Meta"];
//                                            NSInteger nCode = [[dic_Meta objectForKey_YM:@"ResultCd"] integerValue];
//                                            if( nCode == 1 )
//                                            {
//                                                NSDictionary *dic_SubProcessInfoMap = [dic_Data objectForKey:@"SubProcessInfoMap"];
//                                                nTotalPage = [[dic_SubProcessInfoMap objectForKey:@"ContentQuantity"] integerValue];
//                                                
//                                                [self updateProgress];
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
//                                    }];
//}

//- (void)updateProgress
//{
//    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                        [[NSUserDefaults standardUserDefaults] objectForKey:@"UserIdx"], @"userIdx",
//                                        [[NSUserDefaults standardUserDefaults] objectForKey:@"BrandIdx"], @"brandIdx",
//                                        self.str_Idx, @"integrationCourseIdx",
//                                        [NSString stringWithFormat:@"%ld", [[self.dic_Info objectForKey:@"ProcessIdx"] integerValue]], @"processIdx",
//                                        [NSString stringWithFormat:@"%ld", [[self.dic_Info objectForKey:@"SubProcessIdx"] integerValue]], @"subProcessIdx",
//                                        @"583", @"contentType",
//                                        [NSString stringWithFormat:@"%ld", nTotalPage], @"frameProcessingCnt",
//                                        [NSString stringWithFormat:@"%ld", nTotalPage], @"frameTotalCnt",
//                                        nil];
//    
//    [[WebAPI sharedData] callAsyncWebAPIBlock:@"course/updateSubProcessProgressRateFrame"
//                                        param:dicM_Params
//                                     withType:@"POST"
//                                    withBlock:^(id resulte, NSError *error) {
//                                        
//                                        [GMDCircleLoader hide];
//                                        
//                                        if( resulte )
//                                        {
//                                            NSDictionary *dic_Meta = [resulte objectForKey:@"Meta"];
//                                            NSInteger nCode = [[dic_Meta objectForKey_YM:@"ResultCd"] integerValue];
//                                            if( nCode == 1 )
//                                            {
//                                                
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
//                                    }];
//}



#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if( [[[request URL] absoluteString] hasPrefix:@"toapp://"] )
    {
        NSString *jsData = [[request URL] absoluteString];
        NSArray *ar_Cert = [jsData componentsSeparatedByString:@"toapp://cmd?status=certi&"];
        if( ar_Cert.count > 1 )
        {
            NSString *str = [[ar_Cert objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSArray *ar_Sep = [str componentsSeparatedByString:@"&"];
            NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithCapacity:ar_Sep.count];
            for( NSString *str in ar_Sep )
            {
                NSArray *ar = [str componentsSeparatedByString:@"="];
                [dicM setValue:[ar objectAtIndex:1] forKey:[ar objectAtIndex:0]];
            }
        }
        
        
        NSArray *jsDataArray = [jsData componentsSeparatedByString:@"toapp://"];
        
        //        //1보다크면 무조건 팝!!
        //        if( [jsDataArray count] > 1 )
        //        {
        //            [self.navigationController popViewControllerAnimated:YES];
        //            return YES;
        //        }
        
        NSString *jsString = [jsDataArray objectAtIndex:1]; //jsString == @"call objective-c from javascript"
        
        NSRange range = [jsString rangeOfString:@"CLOSE"];
        if (range.location != NSNotFound)
        {
            if (self.presentingViewController != nil) {
                
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            return YES;
        }
        
        range = [jsString rangeOfString:@"LOAD_COMPLETE"];
        if (range.location != NSNotFound)
        {
            NSString *str_SecretKey = [[NSUserDefaults standardUserDefaults] objectForKey:kAuthToken];
            
            NSString *scriptString = @"";
            if( self.dic_Info )
            {
                NSError *error = nil;
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:self.dic_Info options:0 error:&error];
                NSString * str_Json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                scriptString = [NSString stringWithFormat:@"setToken('%@',%@);", str_SecretKey, str_Json];
            }
            else
            {
                if( self.webViewType == kExam || self.webViewType == kSurvey )
                {
                    scriptString = [NSString stringWithFormat:@"setToken('%@',%@);", str_SecretKey, self.str_TokenId];
                }
                else if( self.webViewType == kClanender ||
                        self.webViewType == kMyInfo ||
                        self.webViewType == kPoin ||
                        self.webViewType == kOneOnOne ||
                        self.webViewType == kPwChange )
                {
                    scriptString = [NSString stringWithFormat:@"setToken('%@');", str_SecretKey];
                }

            }
            
            [self.webView stringByEvaluatingJavaScriptFromString:scriptString];
        }
        
        range = [jsString rangeOfString:@"NO_AUTH"];
        if( range.location != NSNotFound )
        {
            [UIAlertController showAlertInViewController:self
                                               withTitle:@""
                                                 message:@"인증 제한시간이 경과하였거나 다른 기기에서 로그인 되어 인증정보가 유효하지 않습니다. 앱을 종료합니다"
                                       cancelButtonTitle:nil
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
                                                        [Common logOut:NO];
                                                    }
                                                }];
            
        }
        
        range = [jsString rangeOfString:@"DOWNLOAD"];
        if (range.location != NSNotFound)
        {
            //	4	DOWNLOAD	download	url(string)		다운로드 대상 URL(ex: http://example.com/asdf.pdf)	전달된 URL 의 파일을 다운로드 한다.
        }
        
        range = [jsString rangeOfString:@"UPLOAD_PROFILE"];
        if (range.location != NSNotFound)
        {
            //	5	UPLOAD_IMAGES	uploadImages	count(number)		최대 선택 가능한 이미지 갯수	갤러리에서 선택한 이미지들을 서버에 업로드하고 response 를 웹뷰에 전달한다.
            [self.view endEditing:YES];
            
            if( self.arM_Photo )
            {
                [self.arM_Photo removeAllObjects];
                self.arM_Photo = nil;
            }
            self.arM_Photo = [NSMutableArray array];
            
            self.imagePicker = [[BSImagePickerController alloc] init];
            self.imagePicker.maximumNumberOfImages = kMaxImageCnt;
            
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
                                                }
                                            }
                                            
                                            if( self.arM_Photo && self.arM_Photo.count > 0 )
                                            {
                                                [self uploadImage];
                                            }
                                        }];
            
            return YES;
        }
        
        
        range = [jsString rangeOfString:@"IMAGE"];
        if (range.location != NSNotFound)
        {
            jsString = [jsString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            jsString = [jsString stringByReplacingOccurrencesOfString:@"cmd?IMAGE<imgURL>" withString:@""];
            jsString = [jsString stringByReplacingOccurrencesOfString:@"</imgURL>" withString:@""];
            
            NSArray *ar_Tmp = [jsString componentsSeparatedByString:@";"];
            
            NSMutableArray *arM_ImageList = [NSMutableArray arrayWithCapacity:ar_Tmp.count];
            for( NSInteger i = 0; i < ar_Tmp.count; i++ )
            {
                [arM_ImageList addObject:ar_Tmp[i]];
            }
            
            
            
            
            
            NSInteger nImageCnt = ar_Tmp.count;
            self.thumbs = [NSMutableArray arrayWithCapacity:nImageCnt];
            self.ar_Photo = [NSMutableArray arrayWithCapacity:nImageCnt];
            
            for( NSInteger i = 0; i < nImageCnt; i++ )
            {
                NSString *str_Url = ar_Tmp[i];
                if( str_Url.length <= 0 || [str_Url hasPrefix:@"http"] == NO )
                {
                    continue;
                }
                [self.thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:str_Url]]];
                [self.ar_Photo addObject:[MWPhoto photoWithURL:[NSURL URLWithString:str_Url]]];
            }
            
            BOOL displayActionButton = NO;
            BOOL displaySelectionButtons = NO;
            BOOL displayNavArrows = YES;
            BOOL enableGrid = YES;
            BOOL startOnGrid = NO;
            
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
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
            
            self.isImageMode = YES;
            
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
            nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:nc animated:YES completion:nil];
            
        }
    
        range = [jsString rangeOfString:@"CallCamera"];
        if (range.location != NSNotFound)
        {
            [self.view endEditing:YES];
            
            if( self.arM_Photo )
            {
                [self.arM_Photo removeAllObjects];
                self.arM_Photo = nil;
            }
            self.arM_Photo = [NSMutableArray array];
            
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
            
            return YES;
        }
        
        range = [jsString rangeOfString:@"CallAlbum"];
        if (range.location != NSNotFound)
        {
        }

        NSLog(@"%@", jsString);
        
    }
    
    return YES;
}


- (void)uploadImage
{
    __weak __typeof(&*self)weakSelf = self;

//    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionary];
//    
//    [dicM_Params setObject:@"IMAGE" forKey:@"type"];
    
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
//                                       NSDictionary *dic = [ar firstObject];
                                       NSData * jsonData = [NSJSONSerialization dataWithJSONObject:ar options:0 error:&error];
                                       NSString * str_Json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                                       
                                       NSString *scriptString = [NSString stringWithFormat:@"changeProfile(%@);", str_Json];
                                       [self.webView stringByEvaluatingJavaScriptFromString:scriptString];
                                       
//                                       [self uploadProfile:str_Json];
                                   }
                               }
                               
                               weakSelf.view.userInteractionEnabled = YES;
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


@end
