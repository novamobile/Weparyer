//
//  InmobiAdCacheRequestDelegate.h
//  InmobiSplashAdCache
//
//  Created by Subhash Nottath on 2/18/16.
//  Copyright © 2016 Inmobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InmobiSplashAdCache;

// Publisher has to implement this to provide fetchAds facility for inmobi ad cache
@protocol InmobiAdCacheRequestDelegate <NSObject>

// Called by inmobi ad cache when it needs to get ads from the inmobi server through publisher's ad request
- (void) fetchAdsFromInmobiServer : (InmobiSplashAdCache*) cache;

@end
