//
//  IMStrandsPlacerViewController.m
//  Ads Demo
//
//  Copyright © 2016 Inmobi. All rights reserved.
//

#import "IMStrandsPlacerViewController.h"
#import "IMStrandTableViewAdapter.h"
#import "IMStrandPosition.h"
@interface IMStrandsPlacerViewController() <IMStrandTableViewAdapterDelegate>
@property (nonatomic) CGFloat layoutHeight;
@property (nonatomic, strong) IMStrandPosition *positions;
@property (nonatomic, strong) IMStrandTableViewAdapter *strandAdapter;
@property (nonatomic,strong) NSMutableArray *tableData;
@end

@implementation IMStrandsPlacerViewController
- (void)viewDidLoad {
    [self setNavigationbar];
    _positions = [IMStrandPosition positioning];
    [_positions addFixedIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [_positions enableRepeatingPositionsWithStride:1];
    
    _strandAdapter = [IMStrandTableViewAdapter adapterWithTableView:self.tableView placementId:1466905009032 adPositioning:_positions tableViewCellClass:[UITableViewCell class]];
    
    [self Get_the_feed];
}

- (void)setNavigationbar
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 64)];
    navigationBar.tintColor = [UIColor grayColor];
    //创建UINavigationItem
    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"创建UINavigationBar"];
    [navigationBar pushNavigationItem: navigationBarTitle animated:YES];
    [self.view addSubview: navigationBar];
    //创建UIBarButton 可根据需要选择适合自己的样式
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(navigationBackButton)];
    //设置barbutton
    navigationBarTitle.leftBarButtonItem = item;
    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
    
}

-(void)Get_the_feed {
    [self.tableView reloadData];
    [_strandAdapter load];
    
    [self.refreshControl endRefreshing];
}

-(void)navigationBackButton
{
    
}

-(void)dellAD
{
//    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
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
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height= 428;
    return height;
}

/**
 * Notifies the delegate that the strandTableViewAdapter ad has finished loading
 */
-(void)strandTableViewAdapter:(IMStrandTableViewAdapter*)strandTableViewAdapter adDidFinishLoadingAtIndexPath:(NSIndexPath*)indexPath {
    
}
/**
 * Notifies the delegate that the strandTableViewAdapter ad has been removed
 */
-(void)strandTableViewAdapter:(IMStrandTableViewAdapter*)strandTableViewAdapter adsRemovedFromIndexPaths:(NSArray*)indexPaths {
    
}
/**
 * Notifies the delegate that the strandTableViewAdapter ad has failed to load with error.
 */
-(void)strandTableViewAdapter:(IMStrandTableViewAdapter*)strandTableViewAdapter adDidFailToLoadAtIndexPath:(NSIndexPath*)indexPath withError:(IMRequestStatus*)error {
    
}
/**
 * Notifies the delegate that the strandTableViewAdapter ad would be presenting a full screen content.
 */
-(void)strandTableViewAdapter:(IMStrandTableViewAdapter*)strandTableViewAdapter adAtIndexPathWillPresentScreen:(NSIndexPath*)indexPath {
    
}
/**
 * Notifies the delegate that the strandTableViewAdapter ad has presented a full screen content.
 */
-(void)strandTableViewAdapter:(IMStrandTableViewAdapter*)strandTableViewAdapter adAtIndexPathDidPresentScreen:(NSIndexPath*)indexPath {
    
}
/**
 * Notifies the delegate that the strandTableViewAdapter ad would be dismissing the presented full screen content.
 */
-(void)strandTableViewAdapter:(IMStrandTableViewAdapter*)strandTableViewAdapter adAtIndexPathWillDismissScreen:(NSIndexPath*)indexPath {
    
}
/**
 * Notifies the delegate that the strandTableViewAdapter ad has dismissed the presented full screen content.
 */
-(void)strandTableViewAdapter:(IMStrandTableViewAdapter*)strandTableViewAdapter adAtIndexPathDidDismissScreen:(NSIndexPath*)indexPath {
    
}
/**
 * Notifies the delegate that the user will be taken outside the application context.
 */
-(void)strandTableViewAdapter:(IMStrandTableViewAdapter*)strandTableViewAdapter userWillLeaveApplicationFromAdAtIndexPath:(NSIndexPath*)indexPath {
    
}
@end
