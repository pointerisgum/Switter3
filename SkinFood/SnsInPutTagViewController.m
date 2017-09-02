//
//  SnsInPutTagViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 19..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "SnsInPutTagViewController.h"

@interface SnsTagCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *lb_Title;
@end

@implementation SnsTagCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
@end

@interface SnsMyTag : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UILabel *lb_Tag;
@property (nonatomic, weak) IBOutlet UIButton *btn_Delete;
@end

@implementation SnsMyTag
- (void)awakeFromNib
{
    [super awakeFromNib];
}
@end


@interface SnsInPutTagViewController () <UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *arM_List;
@property (nonatomic, weak) IBOutlet UITextField *tf_Tag;
@property (nonatomic, weak) IBOutlet UITableView *tbv_List;
@property (nonatomic, weak) IBOutlet UILabel *lb_Tag;
@property (nonatomic, weak) IBOutlet UICollectionView *cv_TagList;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_TagBottom;
@end

@implementation SnsInPutTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tf_Tag.delegate = self;
    self.tf_Tag.layer.cornerRadius = 2.f;
    self.tf_Tag.layer.borderWidth = 0.5f;
    self.tf_Tag.layer.borderColor = [UIColor colorWithRed:200.f/255.f green:200.f/255.f blue:200.f/255.f alpha:1].CGColor;
    self.tf_Tag.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.tf_Tag.frame.size.height)];
    self.tf_Tag.leftViewMode = UITextFieldViewModeAlways;

    if( self.arM_SelectedTag == nil )
    {
        self.arM_SelectedTag = [NSMutableArray array];
    }
    else
    {
        [self.cv_TagList reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAnimate:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAnimate:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
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

#pragma mark - Notification
- (void)keyboardWillAnimate:(NSNotification *)notification
{
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        [UIView setAnimationCurve:[curve intValue]];
        if([notification name] == UIKeyboardWillShowNotification)
        {
            self.lc_TagBottom.constant = keyboardBounds.size.height;
        }
        else if([notification name] == UIKeyboardWillHideNotification)
        {
            self.lc_TagBottom.constant = 0.f;
        }
    }completion:^(BOOL finished) {
        
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
    static NSString *CellIdentifier = @"SnsTagCell";
    SnsTagCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = self.arM_List[indexPath.row];
    cell.lb_Title.text = [NSString stringWithFormat:@"#%@", [dic objectForKey_YM:@"name"]];
    
    return cell;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    [self.view endEditing:YES];
    NSDictionary *dic_Target = self.arM_List[indexPath.row];
    NSInteger nTargetId = [[dic_Target objectForKey:@"id"] integerValue];
    BOOL isHave = NO;
    for( NSInteger i = 0; i < self.arM_SelectedTag.count; i++ )
    {
        NSDictionary *dic_Current = self.arM_SelectedTag[i];
        NSInteger nCurrentId = [[dic_Current objectForKey:@"id"] integerValue];
        if( nTargetId == nCurrentId )
        {
            isHave = YES;
            break;
        }
    }
    
    if( isHave == NO )
    {
        [self.arM_SelectedTag addObject:self.arM_List[indexPath.row]];
        [self.cv_TagList reloadData];
    }
}



#pragma mark - CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arM_SelectedTag.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SnsMyTag";
    SnsMyTag *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.btn_Delete.tag = indexPath.row;

    NSDictionary *dic = self.arM_SelectedTag[indexPath.row];
    cell.lb_Tag.text = [NSString stringWithFormat:@"#%@", [dic objectForKey_YM:@"name"]];
    [cell.btn_Delete addTarget:self action:@selector(onDeleteTag:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.arM_SelectedTag[indexPath.row];
    NSString *str_Tag = [NSString stringWithFormat:@"#%@", [dic objectForKey_YM:@"name"]];

    CGSize size = [(NSString*)str_Tag sizeWithAttributes:NULL];
    return CGSizeMake(size.width + 26, 45.f);
}

- (void)onDeleteTag:(UIButton *)btn
{
    [self.arM_SelectedTag removeObjectAtIndex:btn.tag];
    [self.cv_TagList reloadData];
}



#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self goSearch:nil];
    
    return YES;
}



#pragma mark - IBAction
- (IBAction)goSearch:(id)sender
{
    if( self.tf_Tag.text.length <= 0 )
    {
//        return;
    }
    
    __weak __typeof(&*self)weakSelf = self;
    
    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionary];
    [dicM_Params setObject:self.tf_Tag.text forKey:@"name"];
    
    NSMutableString *strM_SelectedTagIds = [NSMutableString string];
    for( NSInteger i = 0; i < self.arM_SelectedTag.count; i++ )
    {
        NSDictionary *dic = self.arM_SelectedTag[i];
        [strM_SelectedTagIds appendString:[NSString stringWithFormat:@"%@", [dic objectForKey_YM:@"id"]]];
        [strM_SelectedTagIds appendString:@","];
    }
    
    if( [strM_SelectedTagIds hasSuffix:@","] )
    {
        [strM_SelectedTagIds deleteCharactersInRange:NSMakeRange([strM_SelectedTagIds length] - 1, 1)];
    }

    [dicM_Params setObject:strM_SelectedTagIds forKey:@"exclude"];

    [[WebAPI sharedData] callAsyncWebAPIBlock:@"common/tag/search"
                                        param:dicM_Params
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
                                            }
                                            
                                            if( weakSelf.arM_List.count <= 0 )
                                            {
                                                [Util showToast:@"검색 결과가 없습니다"];
                                            }
                                        }
                                    }];

}

- (IBAction)goDone:(id)sender
{
    if( self.completionTagBlock )
    {
        self.completionTagBlock(self.arM_SelectedTag);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
