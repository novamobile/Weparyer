//
//  InmobiTestViewController.m
//  WeParyer
//
//  Created by Jeccy on 16/7/9.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

#import "InmobiTestViewController.h"
#import "IMNativeStrands.h"

@interface InmobiTestViewController () <IMNativeStrandsDelegate>
@property (nonatomic, strong) IMNativeStrands *nativeStrands;
@property (nonatomic) BOOL nativeStrandsLoaded,nativeStrandsRendered,nativeStrandsInserted;
@property (nonatomic, strong) UIView* adView;
@property (nonatomic, strong) NSMutableArray *tableData;

@end

@implementation InmobiTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"正在播放：宵礼";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 420)];
    self.adView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.adView];
    
    self.nativeStrands = [[IMNativeStrands alloc] initWithPlacementId:1466905009032];
    self.nativeStrands.delegate = self;
    [self.nativeStrands load];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nativeStrands:(IMNativeStrands *)nativeStrands didFailToLoadWithError:(IMRequestStatus *)error {
    NSLog(@"Error : %@",error.description);
}
- (void)nativeStrandsAdClicked:(IMNativeStrands *)nativeStrands {
    NSLog(@"Native Strands Ad Clicked");
}
- (void)nativeStrandsAdImpressed:(IMNativeStrands *)nativeStrands {
    NSLog(@"Native Strands Ad Impression tracked");
}
- (void)nativeStrandsDidDismissScreen:(IMNativeStrands *)nativeStrands {
    NSLog(@"Native Strands will dismiss screen");
}
- (void)nativeStrandsDidFinishLoading:(IMNativeStrands *)nativeStrands {
    self.nativeStrandsLoaded = YES;
    [self.adView addSubview:[self.nativeStrands strandsView]];
    CGRect oldFrame = [self.nativeStrands strandsView].frame;
//    [[self.nativeStrands strandsView] setFrame:CGRectMake(-10, oldFrame.origin.y, oldFrame.size.width+10, oldFrame.size.height)];
    NSLog(@"Native Strands did finish load");
}
- (void)nativeStrandsDidPresentScreen:(IMNativeStrands *)nativeStrands {
    NSLog(@"Native Strands did present screen");
}
- (void)nativeStrandsWillDismissScreen:(IMNativeStrands *)nativeStrands {
    NSLog(@"Native Strands will dismiss screen");
}
- (void)nativeStrandsWillPresentScreen:(IMNativeStrands *)nativeStrands {
    NSLog(@"Native Strands will present screen");
}
- (void)userWillLeaveApplicationFromNativeStrands:(IMNativeStrands *)nativeStrands {
    NSLog(@"user will leave application from native strands");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
