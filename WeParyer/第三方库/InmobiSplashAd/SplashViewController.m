//
//  ViewController.m
//
//  Created by Subhash Nottath on 3/7/16.
//  Copyright © 2016 Inmobi. All rights reserved.
//

#import "SplashViewController.h"

double fetchTime;
Boolean isSplashAdLoaded;

@interface SplashViewController () <InmobiSplashAdCacheDelegate>

@property (nonatomic,strong) InmobiSplashAdCache *InmobiSplashAdCache;
@property (nonatomic,strong) InMobiRequestHandler *InMobiRequestHandler;
@property (nonatomic,strong) SplashScreenDataClass *splashData;
@property (nonatomic,strong) UIView *splashView;
@property (nonatomic,strong) UIButton *skipBtn;
@property (nonatomic,assign) int secondsCountDown;
@property (nonatomic,assign) int adTime;
@property (nonatomic,assign) NSTimer* countDownTimer;
@property (nonatomic,assign) NSString* ipAddress;
@property (nonatomic,assign) BOOL isRequestAd;
@end

@implementation SplashViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initADView];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(jumpAd) userInfo:NULL repeats:NO];
    
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil)
    {
        _ipAddress = @"";
        _isRequestAd = false;
        isSplashAdLoaded = false;
        self.InMobiRequestHandler = [[InMobiRequestHandler alloc] init];
        self.splashData = [[SplashScreenDataClass alloc] init];
        self.splashView = [[UIView alloc] init];
        [self GetUserIPAddress];
//        [self continueRequestAdData];
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(continueRequestAdData) userInfo:NULL repeats:NO];
        return self;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {

    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)continueRequestAdData{
    if(_isRequestAd == false){
        [InmobiSplashAdCache setInitParamsWithCacheSize:10 timeout:1500 delegate:self.InMobiRequestHandler logLevel:0];
        self.InmobiSplashAdCache = [InmobiSplashAdCache getSharedInstance];
        [self getSplashAd];
        _isRequestAd = true;
    }
}

- (void)GetUserIPAddress{
    NSURL* ipUrl = [NSURL URLWithString:@"http://pv.sohu.com/cityjson"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:ipUrl];
    [request setHTTPMethod:@"POST"];
    
//    NSString* requestBody = [[NSString alloc] initWithUTF8String:"ie=utf-8"];
//    NSData* parm = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:parm];
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
    NSLog(@"begin GetUserIPAddress %llu\n",recordTime);
    NSURLSession *session = [NSURLSession sharedSession];
//    __block typeof(self)bself = self;
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error)
      {
          NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          NSLog(@"IPIPIPIPresponseStringresponseStringresponseStringresponseString =%@",responseString);
          if(responseString)
          {
              NSArray *aArray = [responseString componentsSeparatedByString:@"\""];
              if(aArray.count > 3)
              {
//                  [self.InMobiRequestHandler SetIpAddress:aArray[3]];
                  UInt64 recordTime2 = [[NSDate date] timeIntervalSince1970]*1000;
                  NSLog(@"end GetUserIPAddress %llu\n",recordTime2);//1471665529317----1471665527
//                  [bself continueRequestAdData];
              }
          }

      }
      ]resume];
}


- (void) getSplashAd {
    fetchTime = [[NSDate date] timeIntervalSince1970] * 1000;
    [self.InmobiSplashAdCache getAdFromInmobiSplashAdCache:self];
}

-(void)onFill:(InmobiSplashAd *)inmobiSplashAd {
    
    NSData *adResponseData = [inmobiSplashAd.adResponse dataUsingEncoding:NSUTF8StringEncoding];
    id adResponseDictionary = [NSJSONSerialization JSONObjectWithData:adResponseData options:0 error:nil];
    
    self.splashData = [self extractInmobiSplashAdFromResponseFromAdDictionary:adResponseDictionary withadImageData:inmobiSplashAd.imageData];
    
    isSplashAdLoaded = true;

    [self RemoveLaunchImage];
    
    [self renderAd:self.splashData];
    
}

-(void)onNoFill {
    
    NSLog(@"Got no-fill from the inmobi ad cache");
    
    isSplashAdLoaded = false;
}


//Code to parse the Ad JSON

-(SplashScreenDataClass *) extractInmobiSplashAdFromResponseFromAdDictionary:(NSDictionary *)adDictionary withadImageData: (NSMutableDictionary *) adImageData {
    NSString* base64PubContent = adDictionary[@"pubContent"];
    NSError *error;
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64PubContent options:0];
    NSDictionary *pubContentJson = [NSJSONSerialization JSONObjectWithData:decodedData options:0 error:&error];
    if (error) {
        NSLog(@"The Pubcontent in Ad failed to Parse");
        return nil;
    }
    
    SplashScreenDataClass *splashData = [[SplashScreenDataClass alloc] init];
    
    splashData.main_image = pubContentJson[@"screenshots"];
    splashData.landingURL = pubContentJson[@"landingURL"];
    
    NSDictionary *splash_event_trackers = adDictionary[@"eventTracking"];
    splashData.click_trackers = splash_event_trackers[@"8"][@"urls"];
    splashData.render_trackers = splash_event_trackers[@"18"][@"urls"];
    
    NSString *splash_main_image_url = [splashData.main_image objectForKey:@"url"];
    splashData.mainImageData = [adImageData objectForKey:splash_main_image_url];
    
    return splashData;
}


-(void)initADView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    self.splashView.frame = screenRect;
    
    CGSize viewSize = [[UIScreen mainScreen] bounds].size;
    NSString *viewOrientation = @"Portrait";    //横屏请设置成 @"Landscape"
    NSString *launchImage = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
            break;
        }
    }

    
//    UILabel* adRecome = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth-200)/2.0, screenHeight*0.2, 200, 100)];
//    adRecome.font = [UIFont systemFontOfSize:30];
//    adRecome.text = @"今日推荐";
//    [self.splashView addSubview:adRecome];

    UIImageView* adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    adImageView.backgroundColor = [UIColor clearColor];
    adImageView.alpha = 0.0;
    adImageView.tag = 1010;
    
    UIView* adBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    adBottomView.tag = 1011;
    UIImageView* adBottomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
    adBottomView.backgroundColor = [UIColor whiteColor];
    [adBottomView addSubview:adBottomImage];
    
    [self.splashView addSubview:adBottomView];
    [self.splashView addSubview:adImageView];
    self.splashView.alpha = 0.99;
    
    UITapGestureRecognizer *splashAdClicked = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnSplashAdClicked)];
    splashAdClicked.numberOfTapsRequired = 1;
    [self.splashView setUserInteractionEnabled:YES];
    [self.splashView addGestureRecognizer:splashAdClicked];
    
    for (id render_tracking_url in self.splashData.render_trackers) {
        [self.InmobiSplashAdCache pingTracker:render_tracking_url];
    }
    
    [self.view addSubview:self.splashView];
}

-(void)RemoveLaunchImage{
    UIView* adBottomImage = [self.view viewWithTag:1011];
    if(adBottomImage)
    {
        [UIView animateWithDuration:0.5 animations:^{
            adBottomImage.alpha = 0;
        } completion:^(BOOL finished) {
            [adBottomImage removeFromSuperview];
        }];
    }
    
    UIView* adView = [self.view viewWithTag:1010];
    if(adView)
    {
        [UIView animateWithDuration:0.5 animations:^{
            adView.alpha = 1.0;
        } completion:^(BOOL finished) {
//            [adView removeFromSuperview];
        }];
    }
}

//Code to render the ad unit

-(void)renderAd:(SplashScreenDataClass *)splash_ad {
    
   if (splash_ad.mainImageData != nil) {
       
       if([self.splashView viewWithTag:1010])
       {
           UIImageView* adImageView = [self.splashView viewWithTag:1010];
           adImageView.image = [[UIImage alloc] initWithData:splash_ad.mainImageData];
           
           [self showProgressView];
       }

    }
    
}

-(void)showProgressView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    _skipBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-70, 20, 60, 30)];
    _skipBtn.backgroundColor = [UIColor lightGrayColor];
    _skipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_skipBtn addTarget:self action:@selector(toHidenState) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_skipBtn];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_skipBtn.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer= [[CAShapeLayer alloc] init];
    maskLayer.frame = _skipBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    _skipBtn.layer.mask = maskLayer;
    
    _skipBtn.hidden = YES;
    
    _secondsCountDown = 0;
    
    _adTime = 0;
    
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:NULL repeats:YES];
    
}

-(void)onTimer
{
    if(_adTime ==0)
    {
        _adTime = 3;
    }
    if(_secondsCountDown < _adTime)
    {
        _skipBtn.hidden = NO;
        NSString* title = [[NSString alloc] initWithFormat:@"Skip %d",_adTime-_secondsCountDown];
        [_skipBtn setTitle:title forState:UIControlStateNormal];
        _secondsCountDown++;
    }
    else{
        [_countDownTimer invalidate];
        _countDownTimer = NULL;
        [_skipBtn setTitle:@"Skip 0" forState:UIControlStateNormal];
        [self toHidenState];
    }
}

-(void)toHidenState
{
//    [UIView animateWithDuration:0.05 animations:^{
//        self.view.alpha = 0.0;
//    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AdViewWillDisAppear" object:NULL userInfo:NULL];
//    }];

//    [self dismissViewControllerAnimated:YES completion:NULL];
    
//    [UIView animateWithDuration:0.5 animations:^{
//        self.splashView.alpha = 1.0;
//    } completion:^(BOOL finished) {
////        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeKeyWindow" object:NULL userInfo:NULL];
//        [UIView animateWithDuration:0.3 animations:^{
//            self.splashView.alpha = 0.0;
//            [_skipBtn removeFromSuperview];
//            if(_countDownTimer)
//            {
//                [_countDownTimer invalidate];
//                _countDownTimer = NULL;
//            }
//        } completion:^(BOOL finished) {
//            [self dismissViewControllerAnimated:YES completion:NULL];
//        }];
//    }];
}

-(void)jumpAd{
    if (isSplashAdLoaded == false) {
        [self toHidenState];
    }
}

-(void)OnSplashAdClicked{
    
    NSLog(@"SplashAdClicked");
    if(isSplashAdLoaded)
    {
        for (id click_tracking_url in self.splashData.click_trackers) {
            [self.InmobiSplashAdCache pingTracker:click_tracking_url];
        }
        
        NSURL *landing_page_url = [NSURL URLWithString:self.splashData.landingURL];
        
//        id<SplashViewControllerDelegate> strongDelegate = self.delegate;
//        
//        Boolean is_clicked=true;
        
        if ([[UIApplication sharedApplication] canOpenURL:landing_page_url]) {
            [[UIApplication sharedApplication] openURL:landing_page_url];
        }
        
//        if ([strongDelegate respondsToSelector:@selector(SplashViewController:didSplashAdDismiss:)]) {
//            [strongDelegate SplashViewController:self didSplashAdDismiss:is_clicked];
//        }
    }
}

@end
