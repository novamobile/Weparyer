//
//  getInMobiAd.h
//  ToDoListApp
//
//  Created by Ankit Mittal on 3/15/16.
//  Copyright © 2016 Inmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "InmobiAdCacheRequestDelegate.h"
#import "InmobiSplashAdCache.h"

#import <AdSupport/ASIdentifierManager.h> 

@interface InMobiRequestHandler : NSObject <InmobiAdCacheRequestDelegate>

- (void) fetchAdsFromInmobiServer : (InmobiSplashAdCache*) cache;

- (void) SetIpAddress:(NSString* )ip;

@end


