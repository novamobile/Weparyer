//
//  ZLViewController.m
//  仿陌陌点点切换
//
//  Created by zjwang on 16/3/28.
//  Copyright © 2016年 Xsummerybc. All rights reserved.
//

#import "ZLViewController.h"
#import "ZLSwipeableView.h"
//#import "UIColor+FlatColors.h"
//#import "CardView.h"
#import "WeParyer-Swift.h"
#import "UDNavigationController.h"

@implementation ZLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view, typically from a nib.

//    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
//    self.navigationController.navigationBar.alpha = 0.15;
    
    UDNavigationController *nav = (UDNavigationController *)self.navigationController;
    [nav setAlph:0];
    
    //左边按钮
//    UIButton *buttonLeft = [UIButton buttonWithType:UIButtonTypeCustom];
//    [buttonLeft setFrame:CGRectMake(-10, 0, 50, 40)];
//    [buttonLeft setTitle:@"" forState:0];
//    [buttonLeft setTitleColor:[UIColor lightGrayColor] forState:0];
//    [buttonLeft.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
//    [buttonLeft addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(closeBtnClick)];
//    self.navigationItem.leftBarButtonItem = leftBarItem;
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    
//    self.title = @"翻牌子";
//    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    t.font = [UIFont systemFontOfSize:17];
//    t.textColor = [UIColor lightGrayColor];
//    t.backgroundColor = [UIColor clearColor];
//    t.textAlignment = NSTextAlignmentCenter;
//    t.text = @"翻牌子";
//    self.navigationItem.titleView = t;
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AdBackGround"]];
    imageView.frame = self.view.frame;
    [self.view addSubview:imageView];
    
    [self insertBlurView:imageView style:UIBlurEffectStyleDark];
    
    [self.view addSubview:self.swipeableView];
    ZLSwipeableView *swipeableView = _swipeableView;
    // Required Data Source
    self.swipeableView.dataSource = self;
    
    // Optional Delegate
    self.swipeableView.delegate = self;
    
    self.swipeableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *metrics = @{};
    
    // Adding constraints
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"|-20-[swipeableView]-20-|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:metrics
                               views:NSDictionaryOfVariableBindings(
                                                                    swipeableView)]];
    
    double offesty = 0.0;
    if([UIScreen mainScreen].bounds.size.height == 480.0)
    {
        offesty = 40.0;
        [self.view addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"V:|-80-[swipeableView]-80-|"
                                   options:0
                                   metrics:metrics
                                   views:NSDictionaryOfVariableBindings(
                                                                        swipeableView)]];
    }
    else
    {
        [self.view addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"V:|-120-[swipeableView]-120-|"
                                   options:0
                                   metrics:metrics
                                   views:NSDictionaryOfVariableBindings(
                                                                        swipeableView)]];
    }
    

    
    
    // `1` `2` `3` `4`

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:button];
        button.frame = CGRectMake(self.view.frame.size.width/2-25, self.view.frame.size.height - 90+offesty/2, 50, 50);
//        [button setTitle:items[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"clickAd"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handle:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:1];
        
    
    
    self.statusLabel = [[UILabel alloc] initWithFrame:self.view.frame];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.frame = self.view.frame;
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator stopAnimating];
    
    NSString* serverUrl = [self serverUrl];
    if (serverUrl.length) {
        
        self.items = [[NSMutableArray alloc] init];
        
        [self.activityIndicator startAnimating];
        
        NSURL* url = [NSURL URLWithString:serverUrl];
        NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
        
        self.responseData = [[NSMutableData alloc] init];
        
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [self.connection start];
    }
    else {
        [self loadNativeAd];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)closeBtnClick
{
    UDNavigationController *nav = (UDNavigationController *)self.navigationController;
    [nav setAlph:1.0];
    [self.navigationController popViewControllerAnimated:true];
}

- (void) insertBlurView:(UIView*) view style:(UIBlurEffectStyle)style
{
    view.backgroundColor = [UIColor clearColor];
    UIVisualEffectView* blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:style]];
    blurEffectView.frame = view.frame;
    [view insertSubview:blurEffectView atIndex:0];
}

// up down left right
- (void)handle:(UIButton *)sender
{
    [self presentADView];
//    HandleDirectionType type = sender.tag;
//    switch (type) {
//        case HandleDirectionLeft:
//            [self loadNativeAd];
//            [self.swipeableView swipeTopViewToLeft];
//            break;
//        case HandleDirectionRight:
//            [self presentADView];
////            [self.swipeableView swipeTopViewToRight];
//            break;
//        default:
//            break;
//    }
}
- (ZLSwipeableView *)swipeableView
{
    if (_swipeableView == nil) {
        _swipeableView = [[ZLSwipeableView alloc] initWithFrame:CGRectZero];
    }
    return _swipeableView;
}
- (void)viewDidLayoutSubviews {
    [self.swipeableView loadViewsIfNeeded];
}

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    NSLog(@"did swipe in direction: %zd", direction);
    if(direction == ZLSwipeableViewDirectionHorizontal)
    {
        [self loadNativeAd];
    }
    else
    {
        [self loadNativeAd];
    }
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didCancelSwipe:(UIView *)view {
    NSLog(@"did cancel swipe");
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did start swiping at location: x %f, y %f", location.x, location.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation {
    NSLog(@"swiping at location: x %f, y %f, translation: x %f, y %f", location.x, location.y,
          translation.x, translation.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did end swiping at location: x %f, y %f", location.x, location.y);
}

#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    ADCellView *view = [[ADCellView alloc] initWithFrame:swipeableView.bounds];
    view.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0  blue:250.0/255.0  alpha:1.0];
    [view setNative1:self.native];
    return view;
}

#pragma mark - () - color

//- (UIColor *)colorForName:(NSString *)name {
//    NSString *sanitizedName = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSString *selectorString = [NSString stringWithFormat:@"flat%@Color", sanitizedName];
//    Class colorClass = [UIColor class];
//    return [colorClass performSelector:NSSelectorFromString(selectorString)];
//}

#pragma mark - () - IMNative
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.requstStatusCode = ((NSHTTPURLResponse*)response).statusCode;
    self.responseData.length = 0;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.statusLabel.text = @"Couldnt connect to server";
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //stop activity indicator
    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
    
    NSError* errror = nil;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&errror];
    
    if (json==nil) {
        [self.view addSubview:self.statusLabel];
        self.statusLabel.text = @"Got improper response from the server";
        return;
    }
    
    if (errror!=nil) {
        [self.view addSubview:self.statusLabel];
        self.statusLabel.text = [NSString stringWithFormat:@"Got error from server , %@", errror];
        return;
    }
    
    NSArray* itemsFromDict = [self itemsFromJsonDict:json];
    if (itemsFromDict != nil) {
        [self.items addObjectsFromArray:itemsFromDict];
        [self loadNativeAd];
        
    }
}

-(NSString*)serverUrl {
    return nil; //Should be implemented by subclasses
}

-(void)loadNativeAd {
    // IMPLEMENT THIS IN SUBCLASSES
}

-(NSArray*)itemsFromJsonDict:(NSDictionary*)jsonDict {
    return nil; // IMPLEMENT THIS IN SUBCLASSES
}

-(NSDictionary*)dictFromNativeContent {
    return nil; //Implement this in subclasses
}

-(void)presentADView {
    //Implement this in subclasses
}

#pragma mark - IMNative Delegate

/**
 * The native ad has finished loading
 */
-(void)nativeDidFinishLoading:(IMNative*)native {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.nativeContent = native.adContent;
    
    NSLog(@"JSON content is %@", self.nativeContent);
    
}
/**
 * The native ad has failed to load with error.
 */
-(void)native:(IMNative*)native didFailToLoadWithError:(IMRequestStatus*)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"Native ad failed to load with error %@", error);
}
/**
 * The native ad would be presenting a full screen content.
 */
-(void)nativeWillPresentScreen:(IMNative*)native {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The native ad has presented a full screen content.
 */
-(void)nativeDidPresentScreen:(IMNative*)native {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The native ad would be dismissing the presented full screen content.
 */
-(void)nativeWillDismissScreen:(IMNative*)native {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The native ad has dismissed the presented full screen content.
 */
-(void)nativeDidDismissScreen:(IMNative*)native {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The user will be taken outside the application context.
 */
-(void)userWillLeaveApplicationFromNative:(IMNative*)native {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
