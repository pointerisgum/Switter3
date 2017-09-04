//
//  LessonContainerViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 6..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "LessonContainerViewController.h"
#import "LessonMainCell.h"
#import "LessonDetailViewController.h"

@interface LessonContainerViewController ()
@end

@implementation LessonContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.screenName = @"교육과정 리스트";
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
    
    if( [segue.identifier isEqualToString:@"Detail"] )
    {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSDictionary *dic = self.arM_List[cell.tag];
        
        LessonDetailViewController *vc = segue.destinationViewController;
        vc.str_Id = [NSString stringWithFormat:@"%@", [dic objectForKey:@"id"]];
    }
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
    //    return self.arM_NonPassList.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LessonMainCell";
    LessonMainCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    cell.tag = indexPath.row;
    
    NSDictionary *dic_Main = self.arM_List[indexPath.row];
    
    NSDictionary *dic_Category = [dic_Main objectForKey:@"category"];
    cell.lb_Tag.text = [dic_Category objectForKey_YM:@"text"];
    
    cell.lb_Title.text = [dic_Main objectForKey_YM:@"name"];
    
    id thumbnail = [dic_Main objectForKey:@"thumbnail"];
    if( [thumbnail isKindOfClass:[NSNull class]] == NO )
    {
        NSDictionary *dic_Thumb = [dic_Main objectForKey:@"thumbnail"];
        NSString *str_ImageUrl = [dic_Thumb objectForKey:@"resourceUri"];
        [cell.iv_Thumb sd_setImageWithURL:[NSURL URLWithString:str_ImageUrl]];
    }
    
    //수강신청가능기간
    NSDictionary *dic_PeriodPolicy = [dic_Main objectForKey:@"periodPolicy"];
    NSDictionary *dic_Register = [dic_PeriodPolicy objectForKey:@"register"];
    BOOL isUnLimited = [[dic_Register objectForKey:@"unlimited"] boolValue];
    TimeStruct *startTime =  [Util makeTimeWithTimeStamp:[[dic_Register objectForKey:@"start"] doubleValue]];
    if( isUnLimited )
    {
        //무제한 학습
        cell.lb_ReqDate.text = [NSString stringWithFormat:@"%04ld.%02ld.%02ld~무제한",
                             startTime.nYear, startTime.nMonth, startTime.nDay];
    }
    else
    {
        TimeStruct *endTime =  [Util makeTimeWithTimeStamp:[[dic_Register objectForKey:@"end"] doubleValue]];
        cell.lb_ReqDate.text = [NSString stringWithFormat:@"%04ld.%02ld.%02ld~%04ld.%02ld.%02ld",
                             startTime.nYear, startTime.nMonth, startTime.nDay,
                             endTime.nYear, endTime.nMonth, endTime.nDay];
    }

    //학습기간
    NSDictionary *dic_Learning = [dic_PeriodPolicy objectForKey:@"learning"];
    isUnLimited = [[dic_Learning objectForKey:@"unlimited"] boolValue];
    startTime = nil;
    startTime =  [Util makeTimeWithTimeStamp:[[dic_Learning objectForKey:@"start"] doubleValue]];
    if( isUnLimited )
    {
        //무제한 학습
        cell.lb_StudyDate.text = [NSString stringWithFormat:@"%04ld.%02ld.%02ld~무제한",
                                startTime.nYear, startTime.nMonth, startTime.nDay];
    }
    else
    {
        TimeStruct *endTime =  [Util makeTimeWithTimeStamp:[[dic_Learning objectForKey:@"end"] doubleValue]];
        cell.lb_StudyDate.text = [NSString stringWithFormat:@"%04ld.%02ld.%02ld~%04ld.%02ld.%02ld",
                                startTime.nYear, startTime.nMonth, startTime.nDay,
                                endTime.nYear, endTime.nMonth, endTime.nDay];
    }

    return cell;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if( scrollView == self.tbv_List && scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height - 20 )
    {
        if( self.completionMoreBlock )
        {
            self.completionMoreBlock(nil);
        }
    }
}

@end
