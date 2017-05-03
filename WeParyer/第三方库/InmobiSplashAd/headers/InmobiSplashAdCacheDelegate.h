//
//  InmobiSplashAdCacheDelegate.h
//  InmobiSplashAdCache
//
//  Created by Subhash Nottath on 2/12/16.
//  Copyright © 2016 Inmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InmobiSplashAd.h"

// Publisher has to implement this protocol, inmobi ad cache will call the functions present here whenever needed.
@protocol InmobiSplashAdCacheDelegate <NSObject>

// Called by inmobi ad cache in response to fetchAdForResponse call from publisher in case of a fill with in given time
- (void) onFill : (InmobiSplashAd*) inmobiSplashAd;

// Called by inmobi ad cache in response to fetchAdForResponse call from publisher in case of a no fill with in given time
- (void) onNoFill;

@end
