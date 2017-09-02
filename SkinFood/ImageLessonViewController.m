//
//  ImageLessonViewController.m
//  SkinFood
//
//  Created by macpro15 on 2017. 8. 12..
//  Copyright © 2017년 macpro15. All rights reserved.
//

#import "ImageLessonViewController.h"

@interface ImageCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView *iv_Contents;
@end

@implementation ImageCell
- (void)awakeFromNib
{
    [super awakeFromNib];
}
@end

@interface ImageLessonViewController ()
@property (nonatomic, strong) NSMutableArray *arM_List;
@property (nonatomic, weak) IBOutlet UICollectionView *cv_Contents;
@property (nonatomic, weak) IBOutlet UIView *v_CountBg;
@property (nonatomic, weak) IBOutlet UILabel *lb_Count;
@end

@implementation ImageLessonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.v_CountBg.layer.cornerRadius = 8.f;
    self.v_CountBg.clipsToBounds = YES;
    
    self.arM_List = [NSMutableArray array];
    [self.arM_List addObject:@"999999"];
    [self.arM_List addObject:@"888888"];
    [self.arM_List addObject:@"777777"];
    [self.arM_List addObject:@"666666"];
    [self.arM_List addObject:@"555555"];
    [self.arM_List addObject:@"444444"];
    [self.arM_List addObject:@"333333"];
    [self.arM_List addObject:@"222222"];
    [self.arM_List addObject:@"111111"];
    [self.arM_List addObject:@"000000"];
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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.view setNeedsLayout];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    UICollectionViewFlowLayout *flowLayout = (id)self.cv_Contents.collectionViewLayout;
    flowLayout.itemSize = self.cv_Contents.frame.size;
    [flowLayout invalidateLayout];
    
    flowLayout = (id)self.cv_Contents.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(self.cv_Contents.frame.size.width, flowLayout.itemSize.height);
    [flowLayout invalidateLayout];
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationLandscapeLeft];
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    //    return UIInterfaceOrientationMaskLandscapeLeft;
    return UIInterfaceOrientationMaskLandscape;
}




#pragma mark - CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arM_List.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ImageCell";
    
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    [cell.iv_Contents setBackgroundColor:[UIColor colorWithHexString:[self.arM_List objectAtIndex:indexPath.row]]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}


@end
