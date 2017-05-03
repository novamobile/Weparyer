//
//  InmobiADViewController.m
//  WeParyer
//
//  Created by Jeccy on 16/7/8.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

#import "InmobiADViewController.h"
#import "IMStrandTableViewAdapter.h"
#import "IMStrandPosition.h"
#import "IMNativeStrands.h"

#define kIMAdInsertionPosition 0
@interface InmobiADViewController () <UITableViewDelegate,UITableViewDataSource,IMNativeStrandsDelegate>
@property (nonatomic, strong) IMStrandPosition *positions;
@property (nonatomic, strong) IMStrandTableViewAdapter *strandAdapter;
@property (nonatomic, strong) IMNativeStrands *nativeStrands;
@property (nonatomic) BOOL nativeStrandsLoaded,nativeStrandsRendered,nativeStrandsInserted;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray *tableData;
@end

@implementation InmobiADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController setNavigationBarHidden:NO];
    
    self.title = @"正在播放：宵礼";
    self.tableData = [[NSMutableArray alloc] init];
    [self loadTableView];

    self.nativeStrands = [[IMNativeStrands alloc] initWithPlacementId:1466905009032];
    self.nativeStrands.delegate = self;
    [self.nativeStrands load];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    self.navigationItem.rightBarButtonItem = backBtn;
}

- (void)loadTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView addObserver:self
                     forKeyPath:@"contentOffset"
                        options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                        context:nil];
    _tableView.scrollEnabled = NO;
}

-(void)backBtnClick{
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if ([self isAdAtIndexPath:indexPath]) {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"adIdentifier"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"adIdentifier"];
        }
        IMNativeStrands *strands = [self.tableData objectAtIndex:indexPath.row];
        [cell addSubview:[strands strandsView]];
        return cell;
        
    }
    else
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
        //NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        //cell = [nib objectAtIndex:0];
    }
    
    
    // [cell sizeToFit];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _tableData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:_tableView] && [keyPath isEqualToString:@"contentOffset"]) {
        [self updateTableData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isAdAtIndexPath:indexPath]) {
        printf("........%f",[self.nativeStrands strandsViewSize].height);
        return [self.nativeStrands strandsViewSize].height;
    }
    CGFloat height= 10;
//    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
//        height = 502;
//    }
    return height;
}

- (void)updateTableData {
    if (!self.nativeStrandsLoaded || self.nativeStrandsInserted) {
        return;
    }
    self.nativeStrandsInserted = YES;
    [self.tableData insertObject:self.nativeStrands atIndex:kIMAdInsertionPosition];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView.indexPathsForVisibleRows indexOfObject:indexPath] == NSNotFound && [self isAdAtIndexPath:indexPath]) {
        [self.nativeStrands recycleView];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)isAdAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.tableData objectAtIndex:indexPath.row] isKindOfClass:[IMNativeStrands class]];
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
    [self updateTableData];
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
