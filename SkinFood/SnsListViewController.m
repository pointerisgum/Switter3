//
//  SnsListViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 13..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "SnsListViewController.h"
#import "StudyStoryCell.h"
#import "StudyStoryDetailViewController.h"
#import "SnsWriteViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@interface SnsListViewController ()
{
    NSInteger nCurrentIdx;
}
@property (nonatomic, weak) IBOutlet UIButton *btn_Write;
@end

@implementation SnsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    nCurrentIdx = -1;
    
    self.tbv_List.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 10.f)];

    self.refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tbv_List];
    self.refreshControl.tintColor = kMainColor;
    [self.refreshControl addTarget:self action:@selector(updateList) forControlEvents:UIControlEventValueChanged];
    [self.tbv_List addSubview:self.refreshControl];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if( self.isBookMarkMode )
    {
        self.btn_Write.hidden = YES;
    }
    else
    {
        self.btn_Write.hidden = NO;
    }
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
    
    __weak __typeof(&*self)weakSelf = self;

    if( [segue.identifier isEqualToString:@"SnsDetail"] )
    {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSDictionary *dic = self.arM_List[cell.tag];
        
        nCurrentIdx = cell.tag;
        
        StudyStoryDetailViewController *vc = segue.destinationViewController;
        vc.str_Id = [NSString stringWithFormat:@"%@", [dic objectForKey:@"id"]];
        vc.isSnsMode = YES;
        [vc setCompletionUpdateBlock:^(id completeResult) {
            
            if( completeResult )
            {
                if( nCurrentIdx > -1 )
                {
                    [weakSelf.arM_List replaceObjectAtIndex:nCurrentIdx withObject:completeResult];
                }
                else
                {
                    NSInteger nTargetId = [[completeResult objectForKey_YM:@"id"] integerValue];
                    for( NSInteger i = 0; i < weakSelf.arM_List.count; i++ )
                    {
                        NSDictionary *dic = weakSelf.arM_List[i];
                        NSInteger nId = [[dic objectForKey_YM:@"id"] integerValue];
                        if( nTargetId == nId )
                        {
                            [weakSelf.arM_List replaceObjectAtIndex:i withObject:completeResult];
                            break;
                        }
                    }
                }
             
                if( weakSelf.isBookMarkMode )
                {
                    if( weakSelf.completionRefreshBlock )
                    {
                        weakSelf.completionRefreshBlock(nil);
                    }
                }
                else
                {
                    [weakSelf.tbv_List reloadData];
                }
            }
        }];
        [vc setCompletionDeleteBlock:^(id completeResult) {

            if( completeResult )
            {
                if( nCurrentIdx > -1 )
                {
                    [weakSelf.arM_List removeObjectAtIndex:nCurrentIdx];
                }
                else
                {
                    NSInteger nTargetId = [[completeResult objectForKey_YM:@"id"] integerValue];
                    for( NSInteger i = 0; i < weakSelf.arM_List.count; i++ )
                    {
                        NSDictionary *dic = weakSelf.arM_List[i];
                        NSInteger nId = [[dic objectForKey_YM:@"id"] integerValue];
                        if( nTargetId == nId )
                        {
                            [weakSelf.arM_List removeObjectAtIndex:i];
                            break;
                        }
                    }
                }
                
                [weakSelf.tbv_List reloadData];
            }
        }];
    }
    else if( [segue.identifier isEqualToString:@"WriteSegue"] )
    {
        UINavigationController *navi = segue.destinationViewController;
        SnsWriteViewController *vc = [navi.viewControllers firstObject];
        [vc setCompletionAddBlock:^(id completeResult) {
           
            [weakSelf.arM_List insertObject:completeResult atIndex:0];
            [weakSelf.tbv_List reloadData];
            [weakSelf.tbv_List setContentOffset:CGPointZero];
        }];
    }
}

- (void)moveToDetail:(NSString *)aIdx
{
    __weak __typeof(&*self)weakSelf = self;

    StudyStoryDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudyStoryDetailViewController"];
    vc.str_Id = aIdx;
    vc.isSnsMode = YES;
    [vc setCompletionUpdateBlock:^(id completeResult) {
        
        if( completeResult )
        {
            NSInteger nTargetId = [[completeResult objectForKey_YM:@"id"] integerValue];
            for( NSInteger i = 0; i < weakSelf.arM_List.count; i++ )
            {
                NSDictionary *dic = weakSelf.arM_List[i];
                NSInteger nId = [[dic objectForKey_YM:@"id"] integerValue];
                if( nTargetId == nId )
                {
                    [weakSelf.arM_List replaceObjectAtIndex:i withObject:completeResult];
                    [weakSelf.tbv_List reloadData];
                    break;
                }
            }
        }
    }];
    
    [vc setCompletionDeleteBlock:^(id completeResult) {
        
        if( completeResult )
        {
            NSInteger nTargetId = [[completeResult objectForKey_YM:@"id"] integerValue];
            for( NSInteger i = 0; i < weakSelf.arM_List.count; i++ )
            {
                NSDictionary *dic = weakSelf.arM_List[i];
                NSInteger nId = [[dic objectForKey_YM:@"id"] integerValue];
                if( nTargetId == nId )
                {
                    [weakSelf.arM_List removeObjectAtIndex:i];
                    [weakSelf.tbv_List reloadData];
                    break;
                }
            }
        }
    }];

    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if( [identifier isEqualToString:@"SnsDetail"] )
    {
//        self.navigationController.hidesBottomBarWhenPushed = YES;
    }
    
    return YES;
}


- (void)updateList
{
    if( self.completionRefreshBlock )
    {
        self.completionRefreshBlock(nil);
    }
}

#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arM_List.count;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StudyStoryCell";
    StudyStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    cell.tag = indexPath.section;
    cell.btn_Link.hidden = YES;
    [cell.btn_Link setTitle:@"" forState:0];
    
    NSDictionary *dic_Main = self.arM_List[indexPath.section];
    
    //유저 이미지
    NSDictionary *dic_Modifier = [dic_Main objectForKey:@"modifierInfo"];
    NSDictionary *dic_Register = [dic_Modifier objectForKey:@"register"];
    id profile = [dic_Register objectForKey:@"profile"];
    if( [profile isKindOfClass:[NSNull class]] == NO )
    {
        NSDictionary *dic_Profile = [dic_Register objectForKey:@"profile"];
        NSString *str_UserImageUrl = [dic_Profile objectForKey_YM:@"resourceUri"];
        [cell.iv_User sd_setImageWithURL:[NSURL URLWithString:str_UserImageUrl] placeholderImage:BundleImage(@"no_image_white.png")];
    }
    
    //성신여대점 | 2017.03.17
    NSString *str_StoreName = [dic_Register objectForKey_YM:@"storeName"];
    TimeStruct *time = [Util makeTimeWithTimeStamp:[[dic_Register objectForKey_YM:@"time"] doubleValue]];
    cell.lb_StoreAndDate.text = [NSString stringWithFormat:@"%@ | %04ld.%02ld.%02ld", str_StoreName, time.nYear, time.nMonth, time.nDay];

    //이은숙 점주
    NSString *str_RegisterName = [dic_Register objectForKey_YM:@"name"];
    NSString *str_DutyName = [dic_Register objectForKey_YM:@"responsibilityName"];
    cell.lb_UserName.text = str_RegisterName;
    cell.lb_Position.text = str_DutyName;
    
    //[주목!주목]
    id category = [dic_Main objectForKey:@"category"];
    if( [category isKindOfClass:[NSDictionary class]] )
    {
        NSDictionary *dic_Category = [dic_Main objectForKey:@"category"];
        [cell.btn_Tag setTitle:[NSString stringWithFormat:@"[%@]", [dic_Category objectForKey_YM:@"text"]] forState:0];
    }
    
    //tags
//    NSMutableString *strM_Tags = [NSMutableString string];
//    NSArray *ar_Tags = [NSArray arrayWithArray:[dic_Main objectForKey:@"tags"]];
//    for( NSInteger i = 0; i < ar_Tags.count; i++ )
//    {
//        NSDictionary *dic = ar_Tags[i];
//        [strM_Tags appendString:@"#"];
//        [strM_Tags appendString:[dic objectForKey_YM:@"name"]];
//        [strM_Tags appendString:@" "];
//    }
//    [cell.btn_Tag setTitle:strM_Tags forState:0];
    
    
    //내용
    NSDictionary *dic_Contents = [dic_Main objectForKey:@"contents"];
    cell.lb_Contents.text = [dic_Contents objectForKey:@"body"];
    
    cell.lc_ImageViewHeight.constant = 0.f;
    cell.v_VideoItem.hidden = cell.v_OneItem.hidden = cell.v_TwoItem.hidden = cell.v_ThreeItem.hidden = YES;
    [cell.btn_VideoPlay setImage:BundleImage(@"") forState:UIControlStateNormal];
    cell.btn_VideoPlay.userInteractionEnabled = NO;
    
    
    NSString *str_Type = @"";
    NSDictionary *dic_Type = [dic_Contents objectForKey_YM:@"type"];
    if( [dic_Type isKindOfClass:[NSDictionary class]] == NO )
    {
        str_Type = @"";
    }
    else
    {
        str_Type = [dic_Type objectForKey_YM:@"value"];
    }

//    str_Type = @"VIDEO";

    if( [str_Type isEqualToString:@"IMAGE"] )
//    if( 1 )
    {
        //이미지
        cell.lc_ImageViewHeight.constant = 180.f;
        
        NSArray *ar_Images = [dic_Contents objectForKey:@"images"];
        if( ar_Images == nil || ar_Images.count <= 0 )
        {
            //이미지가 없다면
        }
        else if( ar_Images.count == 1 )
        {
            NSDictionary *dic_ImageInfo = [ar_Images firstObject];
            NSString *str_ImageUrl = [dic_ImageInfo objectForKey_YM:@"resourceUri"];
            cell.v_OneItem.hidden = NO;
            [cell.iv_OneThumb sd_setImageWithURL:[NSURL URLWithString:str_ImageUrl]];
        }
        else if( ar_Images.count == 2 )
        {
            NSDictionary *dic_ImageInfo = [ar_Images firstObject];
            NSString *str_ImageUrl = [dic_ImageInfo objectForKey_YM:@"resourceUri"];
            cell.v_TwoItem.hidden = NO;
            [cell.iv_TwoThumb1 sd_setImageWithURL:[NSURL URLWithString:str_ImageUrl]];
            
            dic_ImageInfo = ar_Images[1];
            str_ImageUrl = [dic_ImageInfo objectForKey_YM:@"resourceUri"];
            [cell.iv_TwoThumb2 sd_setImageWithURL:[NSURL URLWithString:str_ImageUrl]];
            
        }
        else if( ar_Images.count >= 3 )
        {
            NSDictionary *dic_ImageInfo = [ar_Images firstObject];
            NSString *str_ImageUrl = [dic_ImageInfo objectForKey_YM:@"resourceUri"];
            cell.v_ThreeItem.hidden = NO;
            [cell.iv_ThreeThumb1 sd_setImageWithURL:[NSURL URLWithString:str_ImageUrl]];
            
            dic_ImageInfo = ar_Images[1];
            str_ImageUrl = [dic_ImageInfo objectForKey_YM:@"resourceUri"];
            [cell.iv_ThreeThumb2 sd_setImageWithURL:[NSURL URLWithString:str_ImageUrl]];
            
            dic_ImageInfo = ar_Images[2];
            str_ImageUrl = [dic_ImageInfo objectForKey_YM:@"resourceUri"];
            [cell.iv_ThreeThumb3 sd_setImageWithURL:[NSURL URLWithString:str_ImageUrl]];
            
            //        if( ar_Images.count > 3 )
            //        {
            //            //+이미지 넣기
            //            
            //        }
        }
    }
    else if( [str_Type isEqualToString:@"VIDEO"] )
//    else if( 1 )
    {
        //비디오
        cell.lc_ImageViewHeight.constant = 180.f;
        
        id video = [dic_Contents objectForKey:@"video"];
        if( [video isKindOfClass:[NSNull class]] == NO )
        {
            cell.v_VideoItem.hidden = NO;

            NSDictionary *dic_Video = [dic_Contents objectForKey:@"video"];
            NSString *str_VideoUrl = [dic_Video objectForKey_YM:@"resourceUri"];
            
            NSArray *ar_Thumb = [dic_Video objectForKey:@"subFileResourceUri"];
            if( ar_Thumb.count > 0 )
            {
                NSString *str_ThumbImageUrl = [ar_Thumb firstObject];
                [cell.iv_VideoItem sd_setImageWithURL:[NSURL URLWithString:str_ThumbImageUrl]];
            }
            else
            {
                [cell.iv_VideoItem setImage:BundleImage(@"noimage2.png")];
            }
            
            [cell.btn_VideoPlay setImage:BundleImage(@"btn_play.png") forState:UIControlStateNormal];
            
//            AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:[NSURL URLWithString:str_VideoUrl] options:nil];
//            AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//            generator.appliesPreferredTrackTransform = YES;
//            CMTime thumbTime = CMTimeMakeWithSeconds(1,2);
//            
//            AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime,
//                                                               CGImageRef im,
//                                                               CMTime actualTime,
//                                                               AVAssetImageGeneratorResult result,
//                                                               NSError *error){
//                NSLog(@"make sure generator is used in this block and it'll work %@", generator);
//                UIImage* image = [[UIImage alloc] initWithCGImage:im];
////                [cell.iv_VideoItem setImage:image];
//
//            };
//            
//            generator.maximumSize = CGSizeMake(320, 180);
//            [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];

            
            
            
            
            
            
            
            
            
//            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:str_VideoUrl] options:nil];
//            AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//            NSError *error = NULL;
//            CMTime time = CMTimeMake(1, 2);
//            CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
//            NSLog(@"error==%@, Refimage==%@", error, refImg);
//            
//            UIImage *FrameImage= [[UIImage alloc] initWithCGImage:refImg];
        }
    }
    else if( [str_Type isEqualToString:@"LINK"] )
    {
        //링크
        NSString *str_LinkUrl = [dic_Contents objectForKey_YM:@"linkUrl"];
        if( str_LinkUrl.length > 0 )
        {
            cell.btn_Link.hidden = NO;
            cell.lc_ImageViewHeight.constant = 40.f;
            [cell.btn_Link setTitle:str_LinkUrl forState:0];
        }
    }
    
    
    
    
    cell.btn_LikeCnt.selected = [[dic_Main objectForKey_YM:@"like"] boolValue];
    

    //댓글수
    [cell.btn_CommentCnt setTitle:[NSString stringWithFormat:@"%@", [dic_Main objectForKey:@"commentCount"]] forState:0];
    
    //좋아요수
    [cell.btn_LikeCnt setTitle:[NSString stringWithFormat:@"%@", [dic_Main objectForKey:@"likesCount"]] forState:0];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic_Main = self.arM_List[indexPath.section];
    NSDictionary *dic_Contents = [dic_Main objectForKey:@"contents"];
    NSDictionary *dic_Type = [dic_Contents objectForKey_YM:@"type"];
    if( [dic_Type isKindOfClass:[NSDictionary class]] == NO )   return 332.f - 180.f;
    
    NSString *str_Type = [dic_Type objectForKey:@"value"];
    
    if( [str_Type isEqualToString:@"IMAGE"] )
//    if( 1 )
    {
        NSArray *ar_Images = [dic_Contents objectForKey:@"images"];
        if( ar_Images.count > 0 )
        {
            return 332.f;
        }
        else
        {
            return 332.f - 180.f;
        }
    }
    else if( [str_Type isEqualToString:@"VIDEO"] )
//    else if( 1 )
    {
        return 332.f;
    }
    else if( [str_Type isEqualToString:@"LINK"] )
    {
        return 332.f - 140.f;
    }
    
    return 332.f - 180.f;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    [view setAlpha:0.0F];
    
    return view;
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


//#pragma mark - IBAction
//- (IBAction)goWrite:(id)sender
//{
//    
//}

@end
