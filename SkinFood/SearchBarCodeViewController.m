//
//  SearchBarCodeViewController.m
//  SkinFood
//
//  Created by KimYoung-Min on 2015. 1. 25..
//  Copyright (c) 2015년 woody.kim. All rights reserved.
//

#import "SearchBarCodeViewController.h"
#import "LessonSearchResultViewController.h"

@interface SearchBarCodeViewController ()
@property (nonatomic, strong) NSString *str_BarCode;
@property (nonatomic, weak) IBOutlet RMScannerView *scannerView;
@end

@implementation SearchBarCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set verbose logging to YES so we can see exactly what's going on
    [_scannerView setVerboseLogging:YES];
    
    // Set animations to YES for some nice effects
    [_scannerView setAnimateScanner:NO];
    
    // Set code outline to YES for a box around the scanned code
    [_scannerView setDisplayCodeOutline:YES];
    
    // Start the capture session when the view loads - this will also start a scan session
    [_scannerView startCaptureSession];
    
    // Set the title of the toggle button
//    self.sessionToggleButton.title = @"Stop";
    
    

    
    
//    [self.tf_BarCode setLeftViewMode:UITextFieldViewModeAlways];
//    self.tf_BarCode.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, self.tf_BarCode.frame.size.height)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    [self.scannerView setPrevSize:self.scannerView.frame.size];
    
    
//    [self.view layoutSubviews];
//    [self.view layoutIfNeeded];

    
    
    
    
//    NSLog(@"%@", self.scannerView);
//    
//    [self.view layoutSubviews];
//    [self.view layoutIfNeeded];
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



#pragma mark - BarCode
- (void)didScanCode:(NSString *)scannedCode onCodeType:(NSString *)codeType
{
    self.str_BarCode = scannedCode;
    
    //검색 결과 화면으로 이동
    [self dismissViewControllerAnimated:YES completion:^{
    
        LessonSearchResultViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LessonSearchResultViewController"];
        vc.str_SearchWord = self.str_BarCode;
        [self.mainNavi pushViewController:vc animated:YES];
    }];
    
    
    
//    [self.scannerView makeToast:self.str_BarCode withPosition:kPositionBottom];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Scanned %@", [_scannerView humanReadableCodeTypeForCode:codeType]] message:scannedCode delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:@"New Session", nil];
//    [alert show];
}

- (void)errorGeneratingCaptureSession:(NSError *)error
{
    NSDictionary *dic = error.userInfo;

    [_scannerView stopCaptureSession];
    
    /*
     //카메라 허용 안함 했을때의 에러 메세지
     AVErrorDeviceKey = "<AVCaptureFigVideoDevice: 0x15ce6fa30 [Back Camera][com.apple.avfoundation.avcapturedevice.built-in_video:0]>";
     NSLocalizedDescription = "Cannot use Back Camera";
     NSLocalizedFailureReason = "This app is not authorized to use Back Camera.";
     */
    
    /*
     //카메라가 없는 단말기에서의 에러 메세지
     NSLocalizedDescription = "Cannot Record";
     NSLocalizedRecoverySuggestion = "Try recording again.";
     */
    
    if( [[dic objectForKey_YM:@"NSLocalizedDescription"] isEqualToString:@"Cannot use Back Camera"] )
    {
        //설정에서 카메라 허용 안했을때
        ALERT(@"", @"설정 > 스위터 > 카메라 허용 후\n사용해 주세요", nil, @"확인", nil);

        //아래는 iOS5.1부터 막힘 ㅅㅂ
//        NSURL*url=[NSURL URLWithString:@"prefs:root=WIFI"];
//        [[UIApplication sharedApplication] openURL:url];

    }
    else if( [[dic objectForKey_YM:@"NSLocalizedDescription"] isEqualToString:@"Cannot Record"] )
    {
        //카메라가 없을때
        ALERT(@"", @"카메라가 지원되지 않는 디바이스 입니다.", nil, @"확인", nil);
    }
    
    
//    _statusText.text = @"Unsupported Device";
//    self.sessionToggleButton.title = @"Error";
}

- (void)errorAcquiringDeviceHardwareLock:(NSError *)error
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Focus Unavailable" message:@"Tap to focus is currently unavailable. Try again in a little while." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
//    [alert show];
}

- (BOOL)shouldEndSessionAfterFirstSuccessfulScan
{
    // Return YES to only scan one barcode, and then finish - return NO to continually scan.
    // If you plan to test the return NO functionality, it is recommended that you remove the alert view from the "didScanCode:" delegate method implementation
    // The Display Code Outline only works if this method returns NO
    return YES;
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"New Session"])
//    {
//        [_scannerView startScanSession];
////        self.sessionToggleButton.title = @"Stop";
//    }
//    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Okay"])
//    {
////        self.sessionToggleButton.title = @"Start";
//    }
//}

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}


#pragma mark - IBAction
//- (IBAction)startNewScannerSession:(id)sender
//{
//    if ([_scannerView isScanSessionInProgress])
//    {
//        [_scannerView stopScanSession];
////        self.sessionToggleButton.title = @"Start";
//    }
//    else
//    {
//        [_scannerView startScanSession];
////        self.sessionToggleButton.title = @"Stop";
//    }
//}

//- (IBAction)goInputCode:(id)sender
//{
//    [self.view addSubview:self.v_InputBarCode];
//    
//    [self.tf_BarCode becomeFirstResponder];
//}
//
//- (void)onKeyboardDown:(id)sender
//{
//    [self.view endEditing:YES];
//}
//
//- (IBAction)goSearch:(id)sender
//{
//    self.str_BarCode = self.tf_BarCode.text;
//    [self searchConfirmNoti];
//}

@end
