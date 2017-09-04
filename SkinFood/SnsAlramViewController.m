//
//  SnsAlramViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 13..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "SnsAlramViewController.h"
#import "NoDataView.h"
#import "StudyStoryDetailViewController.h"

@interface SnsAlramCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *lb_Date;
@property (nonatomic, weak) IBOutlet UILabel *lb_Title;
@end

@implementation SnsAlramCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//- (void)setBounds:(CGRect)bounds
//{
//    [super setBounds:bounds];
//    
//    self.contentView.frame = self.bounds;
//}
//
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    [self.contentView updateConstraintsIfNeeded];
//    [self.contentView layoutIfNeeded];
//}
@end


@interface SnsAlramViewController ()
@property (nonatomic, strong) NSMutableArray *arM_List;
@property (nonatomic, weak) IBOutlet UITableView *tbv_List;
@end

@implementation SnsAlramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.screenName = @"SNS 알림";
    
    self.tbv_List.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 10.f)];
    self.tbv_List.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 8.f)];

    [self updateList];
    [self updateSnsComment];
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

- (void)updateList
{
    UIView *v_Empty = [self.tbv_List viewWithTag:1982];
    [v_Empty removeFromSuperview];

    __weak __typeof(&*self)weakSelf = self;
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:@"board/SNS/comment/timeline"
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
                                                NSDictionary *dic_Data = [resulte objectForKey:@"data"];
                                                weakSelf.arM_List = [NSMutableArray arrayWithArray:[dic_Data objectForKey:@"content"]];
                                                [weakSelf.tbv_List reloadData];
                                            }
                                            
                                            if( weakSelf.arM_List == nil || weakSelf.arM_List.count <= 0 )
                                            {
                                                NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"NoDataView" owner:self options:nil];
                                                NoDataView *v_Empty = [topLevelObjects objectAtIndex:0];
                                                v_Empty.center = weakSelf.tbv_List.center;
                                                v_Empty.tag = 1982;
                                                v_Empty.lb_Title.text = @"알림 내역이 없습니다";
                                                v_Empty.iv_Icon.image = BundleImage(@"sns_notice_nodata_icon01.png");
                                                [weakSelf.tbv_List addSubview:v_Empty];
                                            }
                                        }
                                    }];
}

- (void)updateSnsComment
{
    //알림 화면이 보일때 호출
    [[WebAPI sharedData] callAsyncWebAPIBlock:@"record/board/SNS_COMMENT"
                                        param:nil
                                   withMethod:@"POST"
                                    withBlock:^(id resulte, NSError *error) {
                                        
                                        if( resulte )
                                        {

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
    return self.arM_List.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SnsAlramCell";
    SnsAlramCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic_Main = self.arM_List[indexPath.row];
    NSDictionary *dic_Member = [dic_Main objectForKey:@"member"];
    TimeStruct *time = [Util makeTimeWithTimeStamp:[[dic_Main objectForKey_YM:@"registration"] doubleValue]];
    cell.lb_Date.text = [NSString stringWithFormat:@"%04ld.%02ld.%02ld", time.nYear, time.nMonth, time.nDay];

    NSString *str_UserName = [NSString stringWithFormat:@"%@", [dic_Member objectForKey_YM:@"name"]];
    cell.lb_Title.text = [NSString stringWithFormat:@"%@님이 댓글을 등록하였습니다", str_UserName];
    
    return cell;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *dic_Main = self.arM_List[indexPath.row];

    StudyStoryDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudyStoryDetailViewController"];
    vc.str_Id = [NSString stringWithFormat:@"%@", [dic_Main objectForKey:@"articleId"]];
    vc.isSnsMode = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
