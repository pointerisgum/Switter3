//
//  MoreMainViewController.m
//  Switter
//
//  Created by macpro15 on 2017. 8. 4..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "MoreMainViewController.h"
#import "StudyStoryDetailViewController.h"
#import "SnsListViewController.h"
#import "SnsMainViewController.h"
#import "MyPageViewController.h"

@interface MoreListCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *iv_Icon;
@property (nonatomic, weak) IBOutlet UILabel *lb_Title;
@property (nonatomic, weak) IBOutlet UIImageView *iv_UnderLine;
@end

@implementation MoreListCell

@end


@interface MoreMainViewController ()
@property (nonatomic, strong) NSArray *ar_List;
@property (nonatomic, weak) IBOutlet UIImageView *iv_User;
@property (nonatomic, weak) IBOutlet UILabel *lb_Store;
@property (nonatomic, weak) IBOutlet UILabel *lb_Name;
@property (nonatomic, weak) IBOutlet UIView *v_TopList;
@property (nonatomic, weak) IBOutlet UITableView *tbv_List;
@end

@implementation MoreMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.v_TopList.layer.cornerRadius = 4.f;
    
    self.iv_User.layer.cornerRadius = self.iv_User.frame.size.width / 2;
    self.iv_User.layer.borderWidth = 1.0f;
    self.iv_User.layer.borderColor = [UIColor whiteColor].CGColor;

    self.ar_List = @[@{@"icon":BundleImage(@"main_more_list01_icon.png"), @"title":@"직원 관리"},
                     @{@"icon":BundleImage(@"main_more_list02_icon.png"), @"title":@"매장 관리"},
                     @{@"icon":BundleImage(@"main_more_list03_icon.png"), @"title":@"정보지킴이 관리"}];
    
    [self updateMyInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    if( [segue.identifier isEqualToString:@"StudyStory"] )
//    {
//        UIViewController *vc = [segue destinationViewController];
//        vc.hidesBottomBarWhenPushed = YES;
//    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
//    UITableViewCell *cell = (UITableViewCell *)sender;
//    NSDictionary *dic = self.arM_List[cell.tag];
//    
//    //미응시(응시기간종료)
//    if( [[dic objectForKey_YM:@"rankingBoxType"] isEqualToString:@"R4"] )
//    {
//        return NO;
//    }
//    
//    //응시한 후 성적조회기간을 기다리는 시험
//    if( [[dic objectForKey_YM:@"ExaminedYN"] isEqualToString:@"Y"] )
//    {
//        if( [[dic objectForKey_YM:@"FeedbackReturnYN"] isEqualToString:@"Y"] )
//        {
//            return NO;
//        }
//    }

    return YES;
}


- (void)updateMyInfo
{
    __weak __typeof(&*self)weakSelf = self;
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:@"membership/member"
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
                                                id dic_Profile = [dic_Data objectForKey:@"profile"];
                                                if( [dic_Profile isKindOfClass:[NSNull class]] == NO )
                                                {
                                                    NSString *str_MyImageUrl = [dic_Profile objectForKey_YM:@"resourceUri"];
                                                    [weakSelf.iv_User sd_setImageWithURL:[NSURL URLWithString:str_MyImageUrl] placeholderImage:BundleImage(@"no_image_white.png")];
                                                }
                                                else
                                                {
                                                    [weakSelf.iv_User setImage:BundleImage(@"no_image_white.png")];
                                                }
                                                
                                                weakSelf.lb_Store.text = [dic_Data objectForKey_YM:@"storeName"];
                                                weakSelf.lb_Name.text = [NSString stringWithFormat:@"%@ %@",
                                                                         [dic_Data objectForKey_YM:@"name"],
                                                                         [dic_Data objectForKey_YM:@"dutyName"]];
                                            }
                                            else
                                            {
                                                [weakSelf.iv_User setImage:BundleImage(@"no_image_white.png")];
                                            }
                                        }
                                    }];
}

#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ar_List.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MoreListCell";
    MoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *dic = self.ar_List[indexPath.row];
    
    cell.iv_Icon.image = [dic objectForKey:@"icon"];
    cell.lb_Title.text = [dic objectForKey:@"title"];
    
    if( indexPath.row == self.ar_List.count - 1 )
    {
        //마지막은 언더라인을 빼준다
        cell.iv_UnderLine.hidden = YES;
    }
    else
    {
        cell.iv_UnderLine.hidden = NO;
    }
        
    return cell;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ALERT_NOT_AT;
}

- (IBAction)goStudyStory:(id)sender
{
    ALERT_NOT_AT;
}

- (IBAction)goStoryBox:(id)sender
{
    ALERT_NOT_AT;
}

- (IBAction)goBookMark:(id)sender
{
    SnsMainViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SnsMainViewController"];
    vc.isBookMarkMode = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goSurvey:(id)sender
{
    ALERT_NOT_AT;
}

- (IBAction)goFoodTag:(id)sender
{
    ALERT_NOT_AT;
}

- (IBAction)goMyPage:(id)sender
{
    MyPageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyPageViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
