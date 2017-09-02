//
//  SnsCategoryViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 17..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "SnsCategoryViewController.h"

@interface CategoryCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIButton *btn_Radio;
@end

@implementation CategoryCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.btn_Radio.userInteractionEnabled = NO;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end

@interface SnsCategoryViewController ()
@property (nonatomic, strong) NSMutableArray *arM_List;
@property (nonatomic, weak) IBOutlet UITableView *tbv_List;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_TbvHeight;
@property (nonatomic, weak) IBOutlet UIButton *btn_Close;
@property (nonatomic, weak) IBOutlet UILabel *lb_MainTitle;
@end

@implementation SnsCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.lb_MainTitle.text = self.str_Title;
    self.btn_Close.layer.cornerRadius = self.btn_Close.frame.size.width / 2;
    
    [self updateList];
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
    __weak __typeof(&*self)weakSelf = self;
    
    NSString *str_Path = @"board/SNS/category/combo";
    if( self.isFoodCafeMode )
    {
        str_Path = @"board/list";
    }
    else if( self.isFoodCafeHeaderMode )
    {
        NSString *str_Board = [self.dic_CateInfo objectForKey_YM:@"identifier"];
        str_Path = [NSString stringWithFormat:@"board/%@/category/combo", str_Board];
    }
    
    [[WebAPI sharedData] callAsyncWebAPIBlock:str_Path
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
                                                weakSelf.arM_List = [NSMutableArray arrayWithArray:[resulte objectForKey:@"data"]];
                                                [weakSelf.tbv_List reloadData];
                                                
                                                NSInteger nCount = weakSelf.arM_List.count;
                                                if( weakSelf.arM_List.count > 7 )
                                                {
                                                    nCount = 7;
                                                }
                                                
                                                weakSelf.lc_TbvHeight.constant = 70.f + (nCount * 44);
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
    return self.arM_List.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryCell";
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = self.arM_List[indexPath.row];
    
    if( self.isFoodCafeMode )
    {
        [cell.btn_Radio setTitle:[dic objectForKey_YM:@"name"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.btn_Radio setTitle:[dic objectForKey_YM:@"text"] forState:UIControlStateNormal];
    }
    
    cell.btn_Radio.selected = NO;
    
    if( self.dic_CateInfo )
    {
        if( self.isFoodCafeMode )
        {
            NSInteger nSelectedIdx = [[self.dic_CateInfo objectForKey:@"id"] integerValue];
            NSInteger nCurrentIdx = [[dic objectForKey:@"id"] integerValue];
            if( nSelectedIdx == nCurrentIdx )
            {
                cell.btn_Radio.selected = YES;
            }
        }
        else
        {
            NSInteger nSelectedIdx = [[self.dic_CateInfo objectForKey:@"value"] integerValue];
            NSInteger nCurrentIdx = [[dic objectForKey:@"value"] integerValue];
            if( nSelectedIdx == nCurrentIdx )
            {
                cell.btn_Radio.selected = YES;
            }
        }
    }
    
    return cell;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.dic_CateInfo = self.arM_List[indexPath.row];
    [self.tbv_List reloadData];
    if( self.completionCategoryBlock )
    {
        self.completionCategoryBlock(self.dic_CateInfo);
    }

    //그냥 호출하면 가끔 먹통이 되다가 한참후에 먹어서 처리함. 원인은 몰것음....
    [self performSelector:@selector(onDismiss) withObject:nil afterDelay:0.1f];
}

- (void)onDismiss
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
