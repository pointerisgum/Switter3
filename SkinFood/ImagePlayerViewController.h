//
//  ImagePlayerViewController.h
//  SMBA_EN
//
//  Created by KimYoung-Min on 2016. 5. 22..
//  Copyright © 2016년 youngmin.kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePlayerViewController : YmBaseViewController
//@property (nonatomic, strong) NSString *str_Idx;
@property (nonatomic, strong) NSDictionary *dic_Info;
@property (nonatomic, strong) NSArray *ar_List;

@property (nonatomic, assign) BOOL isStudyMode;
@property (nonatomic, strong) NSString *str_DegreeId;
@property (nonatomic, strong) NSString *str_LessonId;
@property (nonatomic, strong) NSString *str_LangId;
//@property (nonatomic, strong) NSString *str_Url;
@property (nonatomic, assign) NSInteger nStartPage;
//@property (nonatomic, assign) CGFloat fTotalPage;

@end
