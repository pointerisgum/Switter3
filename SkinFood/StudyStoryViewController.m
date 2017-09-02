//
//  StudyStoryViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 7..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "StudyStoryViewController.h"
#import "StudyStoryCell.h"
#import "StudyStoryDetailViewController.h"
#import "SnsWriteViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@interface StudyStoryViewController ()
{
    BOOL isLoading;
    NSInteger nPage;
    NSInteger nTotalCount;
}
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lc_ContentsWidth;
@property (nonatomic, weak) IBOutlet UIButton *btn_Tab1;
@property (nonatomic, weak) IBOutlet UIImageView *iv_Tab1UnderLine;
@property (nonatomic, weak) IBOutlet UIButton *btn_Tab2;
@property (nonatomic, weak) IBOutlet UIImageView *iv_Tab2UnderLine;
@end

@implementation StudyStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.screenName = @"교육 스토리";
    
    nPage = 1;

    [self updateList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.sv_Main.contentSize = CGSizeMake(self.sv_Main.frame.size.width * 2, self.sv_Main.frame.size.height);
    self.lc_ContentsWidth.constant = self.view.frame.size.width * 2;
    
    if( self.btn_Tab1.selected )
    {
        self.sv_Main.contentOffset = CGPointZero;
    }
    else
    {
        self.sv_Main.contentOffset = CGPointMake(self.sv_Main.frame.size.width, 0);
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if( [segue.identifier isEqualToString:@"AlramDetail"] )
    {
        StudyStoryDetailViewController *vc = (StudyStoryDetailViewController *)[segue destinationViewController];
        vc.isComunnytiMode = NO;
    }
    else if( [segue.identifier isEqualToString:@"CommunityDetail"] )
    {
        StudyStoryDetailViewController *vc = (StudyStoryDetailViewController *)[segue destinationViewController];
        vc.isComunnytiMode = YES;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    return YES;
}

- (void)updateList
{
    __weak __typeof(&*self)weakSelf = self;
    
    if( nTotalCount > 0 && self.arM_List.count >= nTotalCount )
    {
        isLoading = NO;
        return;
    }
    
    if( isLoading )
    {
        return;
    }
    
    NSMutableDictionary *dicM_Params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSString stringWithFormat:@"%ld", nPage], @"page",
                                        @"0", @"size",
                                        @"id,desc", @"sort",
//                                        @"ALL", @"type",
                                        nil];
    
    isLoading = YES;
    
    //board/COMMUTICATION/article
    [[WebAPI sharedData] callAsyncWebAPIBlock:@"board/event"
                                        param:dicM_Params
                                   withMethod:@"GET"
                                    withBlock:^(id resulte, NSError *error) {
                                        
                                        isLoading = NO;
                                        
                                        nPage++;
                                        
                                        [weakSelf.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
                                        
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
                                                nTotalCount = [[dic_Data objectForKey:@"totalElements"] integerValue];
                                                
                                                if( weakSelf.arM_List && weakSelf.arM_List.count > 0 )
                                                {
                                                    //더보기시
                                                    [weakSelf.arM_List addObjectsFromArray:[dic_Data objectForKey:@"content"]];
                                                    [weakSelf.tbv_List reloadData];
                                                }
                                                else
                                                {
                                                    //최초 로딩시
                                                    weakSelf.arM_List = [NSMutableArray arrayWithArray:[dic_Data objectForKey:@"content"]];
                                                    [weakSelf.tbv_List reloadData];
                                                }
                                            }
                                        }
                                    }];
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
    NSDictionary *dic_Profile = [dic_Register objectForKey:@"profile"];
    NSString *str_UserImageUrl = [dic_Profile objectForKey_YM:@"resourceUri"];
    [cell.iv_User sd_setImageWithURL:[NSURL URLWithString:str_UserImageUrl] placeholderImage:BundleImage(@"no_image_white.png")];
    
    //성신여대점 | 2017.03.17
    NSString *str_StoreName = [dic_Register objectForKey_YM:@"storeName"];
    TimeStruct *time = [Util makeTimeWithTimeStamp:[[dic_Register objectForKey_YM:@"time"] doubleValue]];
    cell.lb_StoreAndDate.text = [NSString stringWithFormat:@"%@ | %04ld.%02ld.%02ld", str_StoreName, time.nYear, time.nMonth, time.nDay];
    
    //이은숙 점주
    NSString *str_RegisterName = [dic_Register objectForKey_YM:@"name"];
    NSString *str_DutyName = [dic_Register objectForKey_YM:@"dutyName"];
    cell.lb_UserName.text = [NSString stringWithFormat:@"%@ %@", str_RegisterName, str_DutyName];
    
    //[주목!주목]
    NSDictionary *dic_Category = [dic_Main objectForKey:@"category"];
    [cell.btn_Tag setTitle:[NSString stringWithFormat:@"[%@]", [dic_Category objectForKey:@"text"]] forState:0];
    
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
        [self updateList];
    }
}


#pragma mark - IBAction
- (IBAction)goTab1:(id)sender
{
    if( self.btn_Tab1.selected ) return;
    
    self.btn_Tab1.selected = YES;
    self.iv_Tab1UnderLine.hidden = NO;
    
    self.btn_Tab2.selected = NO;
    self.iv_Tab2UnderLine.hidden = YES;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.sv_Main.contentOffset = CGPointZero;
    }];
}

- (IBAction)goTab2:(id)sender
{
    if( self.btn_Tab2.selected ) return;
    
    self.btn_Tab1.selected = NO;
    self.iv_Tab1UnderLine.hidden = YES;
    
    self.btn_Tab2.selected = YES;
    self.iv_Tab2UnderLine.hidden = NO;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.sv_Main.contentOffset = CGPointMake(self.sv_Main.frame.size.width, 0);
    }];
}

- (IBAction)goWrite:(id)sender
{
    
}

@end
