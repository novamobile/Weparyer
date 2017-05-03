//
//  IMUtilities.h
//  Ads Demo
//
//  Copyright (c) 2015 inmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMGlobalImageCache.h"

#define URL_LOADED_NOTIFICATION @"UrlLoaded"

@interface IMUtilities : NSObject

+(NSDictionary*)dictFromNativeContent:(NSString*)nativeContent;

+(NSArray*)newsItemsFromJsonDict:(NSDictionary*)jsonDict;

+(NSArray*)boardItemsFromJsonDict:(NSDictionary*)jsonDict;

+(NSArray*)feedItemsFromJsonDict:(NSDictionary*)jsonDict;

+(NSURL*)getImageURLFromNewsDict:(NSDictionary*)dict;

+(NSURL*)getImageURLFromBoardDict:(NSDictionary*)dict;

+(NSDictionary*)dictFromJSONData:(NSData*)jsonData;

@end
