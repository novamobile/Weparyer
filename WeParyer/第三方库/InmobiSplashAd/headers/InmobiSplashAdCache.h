//
//  InmobiSplashAdCache.h
//  InmobiSplashAdCache
//
//  Created by Subhash Nottath on 2/12/16.
//  Copyright © 2016 Inmobi. All rights reserved.
//

#import "InmobiSplashAdCacheDelegate.h"
#import "InmobiAdCacheRequestDelegate.h"
#import <AdSupport/ASIdentifierManager.h>

@interface InmobiSplashAdCache : NSObject

/**
 * Set initialization parameters of inmobi ad cache.
 * This has no effect if called after function getSharedInstance to get the cache's shared instance.
 * @param cacheSize Approximate max size in MB used by inmobi ad cache on the disk.
 * @param timeout Approximate timeout value in millisecond.
 * @param delegate This is used by inmobi ad cache to request for an ad through publisher when ad cache is empty.
 * @param logLevel of the library (default value 0). 0 = off, 1 = error, 2 = warn, 3 = debug
 */
+ (bool) setInitParamsWithCacheSize : (int) cacheSize timeout: (int) timeout delegate: (id<InmobiAdCacheRequestDelegate>) delegate logLevel : (int) logLevel;

/**
 * Returns the shared instance of inmobi ad cache, function setInitParams has to be called before this to initialize the cache correctly.
 */
+ (instancetype) getSharedInstance;
- (instancetype) __unavailable init;

/**
 * Populate inmobi ad cache with ads present in the inmobi splash ad response.
 * This function is called by implementation of InmobiAdCacheRequestDelegate with the response obtained from inmobi server. 
 * @param inmobiSplashAdResponse ad response obtained from inmobi ad server, response can contain multiple ads.
 */
- (void) populateSplashAdCacheWithResponse : (NSString*) inmobiSplashAdResponse;
/**
 * Use this function to get an InmobiSplashAd from ad cache.
 * @param delegate Callback that will be executed as the result of this function call.
 */
- (void) getAdFromInmobiSplashAdCache : (id<InmobiSplashAdCacheDelegate>) delegate;

/**
 * Use this function to ping the tracker url. 
 * This function do timestamp macro($TS) replacement and retries on failure.
 * @param url Url string that needs to be pinged.
 */
- (void) pingTracker : (NSString*) url;

@end
