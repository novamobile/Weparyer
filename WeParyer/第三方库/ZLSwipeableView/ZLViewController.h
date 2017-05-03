//
//  ZLViewController.h
//  仿陌陌点点切换
//
//  Created by zjwang on 16/3/28.
//  Copyright © 2016年 Xsummerybc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLSwipeableView.h"
#import "IMNative.h"
typedef NS_ENUM(NSInteger, HandleDirectionType) {
    HandleDirectionLeft        = 0,
    HandleDirectionRight       = 1,
};
@interface ZLViewController: UIViewController <ZLSwipeableViewDelegate, ZLSwipeableViewDataSource, NSURLConnectionDelegate, NSURLConnectionDataDelegate, IMNativeDelegate>

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic) NSUInteger colorIndex;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) ZLSwipeableView *swipeableView;
@property (nonatomic, strong) NSURLConnection* connection;
@property (nonatomic, strong) UIActivityIndicatorView* activityIndicator;
@property (nonatomic, strong) UILabel* statusLabel;
@property (nonatomic, strong) NSMutableData* responseData;
@property NSUInteger requstStatusCode;
@property (nonatomic, strong) IMNative* native;
@property (nonatomic, strong) NSString* nativeContent;
@property (nonatomic, strong) NSMutableArray* items;
@property (nonatomic, strong) NSMutableArray* alltitles;
- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView;

-(void)loadNativeAd; // should be implemented by sublcasses. Load the native ad and add the content to nativeContent so that its available.
-(NSString*)serverUrl; // should be implemented by subclasses
-(NSArray*)itemsFromJsonDict:(NSDictionary*)jsonDict; // should be implemented by subclasses
-(NSDictionary*)dictFromNativeContent;  // should be implemented by subclasses
-(void)presentADView;

@end

