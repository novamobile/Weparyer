//
//  SplashScreenDataClass.h
//  ToDoListApp
//
//  Created by Ankit Mittal on 3/15/16.
//  Copyright © 2016 Inmobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SplashScreenDataClass : NSObject

@property NSMutableDictionary *main_image;
@property NSString *landingURL;
@property NSMutableArray *click_trackers;
@property NSMutableArray *render_trackers;
@property (nonatomic,strong) NSData *mainImageData;


@end
