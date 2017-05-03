//
//  SplashViewController.h
//  ToDoListApp
//
//  Created by Ankit Mittal on 3/14/16.
//  Copyright © 2016 Inmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InmobiSplashAdCache.h"
#import "InmobiAdCacheRequestDelegate.h"
#import "InMobiRequestHandler.h"
#import "SplashScreenDataClass.h"

@protocol SplashViewControllerDelegate;

@interface SplashViewController : UIViewController

@property (nonatomic, weak) id<SplashViewControllerDelegate> delegate;


@end

//@protocol SplashViewControllerDelegate <NSObject>
//
//- (void)SplashViewController:(SplashViewController *)splashScreen didSplashAdLoad:(Boolean)isAdLoaded;
//
//- (void)SplashViewController:(SplashViewController *)splashScreen didSplashAdDismiss:(Boolean)didDismiss;

//@end