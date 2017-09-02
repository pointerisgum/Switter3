//
//  LessonDetailMoreViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 6..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "LessonDetailMoreViewController.h"

@interface LessonDetailMoreCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *lb_Title;
@property (nonatomic, weak) IBOutlet UILabel *lb_Discrip;
@end

@implementation LessonDetailMoreCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    self.contentView.frame = self.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    
    self.lb_Discrip.preferredMaxLayoutWidth = CGRectGetWidth(self.lb_Discrip.frame);
}
@end


@interface LessonDetailMoreViewController ()
@property (nonatomic, strong) NSMutableArray *arM_List;
@property (nonatomic, strong) NSDictionary *dic_Info;
@property (nonatomic, weak) IBOutlet UITableView *tbv_List;
@property (nonatomic, strong) LessonDetailMoreCell *c_LessonDetailMoreCell;
@end

@implementation LessonDetailMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.arM_List = [NSMutableArray array];
//    [self.arM_List addObject:@"ㅁ니ㅓㅇㄴ미ㅏㅓㅇ어마니머아넝만ㅁ이나"];
//    [self.arM_List addObject:@"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"];
    [self.tbv_List reloadData];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
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

- (void)updateView:(NSDictionary *)dic
{
    self.dic_Info = dic;
    NSArray *ar_Lesson = [self.dic_Info objectForKey:@"courses"];
    if( ar_Lesson && ar_Lesson.count > 0 )
    {
        NSDictionary *dic_Lesson = [ar_Lesson firstObject];
        self.arM_List = [dic_Lesson objectForKey:@"learnInfo"];
        if( self.arM_List && self.arM_List.count > 0 )
        {
            [self.tbv_List reloadData];
        }
    }
}


#pragma mark UITableViewDataSource
- (LessonDetailMoreCell *)c_LessonDetailMoreCell
{
    if (!_c_LessonDetailMoreCell)
    {
        _c_LessonDetailMoreCell = [self.tbv_List dequeueReusableCellWithIdentifier:NSStringFromClass([LessonDetailMoreCell class])];
    }
    
    return _c_LessonDetailMoreCell;
}

- (void)configureCell:(LessonDetailMoreCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic_LessonInfo = [self.arM_List firstObject];
    if( indexPath.row == 0 )
    {
        cell.lb_Title.text = @"학습 목표";
        cell.lb_Discrip.text = [dic_LessonInfo objectForKey:@"purpose"];
    }
    else if( indexPath.row == 1 )
    {
        cell.lb_Title.text = @"학습 개요";
        cell.lb_Discrip.text = [dic_LessonInfo objectForKey:@"summary"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.arM_List.count;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LessonDetailMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LessonDetailMoreCell class])];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self configureCell:self.c_LessonDetailMoreCell forRowAtIndexPath:indexPath];
    
    [self.c_LessonDetailMoreCell updateConstraintsIfNeeded];
    [self.c_LessonDetailMoreCell layoutIfNeeded];
    
    return [self.c_LessonDetailMoreCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

@end
