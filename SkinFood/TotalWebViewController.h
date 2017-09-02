//
//  TotalWebViewController.h
//  SMBA_EN
//
//  Created by KimYoung-Min on 2016. 5. 16..
//  Copyright © 2016년 youngmin.kim. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kExam           = 1,
    kSurvey         = 2,
    kClanender      = 3,
    kAttendance     = 4,    //출석
    kMyInfo         = 5,
    kPwChange       = 6,
    kPoin           = 7,
    kOneOnOne       = 8,
} WebViewType;

@interface TotalWebViewController : YmBaseViewController
@property (nonatomic, assign) BOOL isBackButton;
@property (nonatomic, strong) NSString *str_Title;
@property (nonatomic, strong) NSString *str_Url;

@property (nonatomic, assign) WebViewType webViewType;
@property (nonatomic, strong) NSString *str_Idx;
@property (nonatomic, strong) NSDictionary *dic_Info;
@property (nonatomic, strong) NSString *str_DegreeId;
@property (nonatomic, strong) NSString *str_LessonId;
@property (nonatomic, strong) NSString *str_TokenId;

@end
