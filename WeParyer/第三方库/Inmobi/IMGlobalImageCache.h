//
//  IMGlobalImageCache.h
//  Ads Demo
//
//  Copyright (c) 2015 inmobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMGlobalImageCache : NSObject

+(IMGlobalImageCache*)sharedCache;

-(void)addImage:(UIImage*)image forKey:(NSString*)key;

-(void)removeImageForKey:(NSString*)key;

-(UIImage*)imageForKey:(NSString*)key;

@end
