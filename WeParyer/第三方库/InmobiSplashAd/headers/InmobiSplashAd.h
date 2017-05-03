//
//  InmobiSplashAd.h
//  InmobiSplashAdCache
//
//  Created by Subhash Nottath on 2/12/16.
//  Copyright © 2016 Inmobi. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface InmobiSplashAd : NSObject

// Inmobi Ad string. It contain pubContent, landingPage and eventTracking
// { "pubContent" : "...", "landingPage" : "...", "eventTracking" : "..."}
@property (nonatomic, strong) NSString* adResponse;
// Contains url to image data map(NSString* -> NSData*) of screenshot url and icon url (if present) which is in the pubContent.
@property (nonatomic, strong) NSMutableDictionary* imageData;

@end
