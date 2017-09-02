//
//  PDFLessonViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 12..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "PDFLessonViewController.h"

@interface PDFLessonViewController () <UIWebViewDelegate>
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end

@implementation PDFLessonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.webView.delegate = self;

    NSString *str_Url = [NSString stringWithFormat:@"%@/%@", kBaseWebUrl, self.str_Url];
    NSLog(@"webview url : %@", str_Url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:str_Url]];
    [self.webView loadRequest:request];

//    [self updateProcess];
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

//- (void)updateProcess
//{
//    __weak __typeof(&*self)weakSelf = self;
//    
//    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionary];
//    NSString *str_Langueage = [NSString stringWithFormat:@"%@", [self.dic_Info objectForKey:@"languageId"]];
//    NSString *str_Total = [NSString stringWithFormat:@"%@", [self.dic_Info objectForKey:@"contentQuantity"]];
//    
//    [dicM_Params setObject:str_Langueage forKey:@"languageId"];
//    [dicM_Params setObject:@"100" forKey:@"current"];
//    [dicM_Params setObject:str_Total forKey:@"total"];
//    
//    [[WebAPI sharedData] callAsyncWebAPIBlock:[NSString stringWithFormat:@"learn/learning/%@/progression/%@", self.str_DegreeId, self.str_LessonId]
//                                        param:nil
//                                   withMethod:@"PUT"
//                                    withBlock:^(id resulte, NSError *error) {
//                                        
//                                        if( resulte )
//                                        {
//
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
            NSError *error = nil;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:self.dic_Info options:0 error:&error];
            NSString * str_Json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSString *str_SecretKey = [[NSUserDefaults standardUserDefaults] objectForKey:kAuthToken];
            NSString *scriptString = [NSString stringWithFormat:@"setToken('%@',%@);", str_SecretKey, str_Json];
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
        
        range = [jsString rangeOfString:@"UPLOAD_IMAGES"];
        if (range.location != NSNotFound)
        {
            //	5	UPLOAD_IMAGES	uploadImages	count(number)		최대 선택 가능한 이미지 갯수	갤러리에서 선택한 이미지들을 서버에 업로드하고 response 를 웹뷰에 전달한다.
        }
        
        NSLog(@"%@", jsString);
        
    }
    
    return YES;
}

@end
