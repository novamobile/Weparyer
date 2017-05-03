//
//  SplashScreenDataClass.m
//  ToDoListApp
//
//  Created by Ankit Mittal on 3/15/16.
//  Copyright © 2016 Inmobi. All rights reserved.
//

#import "SplashScreenDataClass.h"

@implementation SplashScreenDataClass

-(id)init{
    self = [super init];
    if (self) {
        
        self.main_image  = [[NSMutableDictionary alloc] init];
        self.landingURL  = [[NSString alloc] init];
        
        self.click_trackers = [[NSMutableArray alloc] init];
        self.render_trackers = [[NSMutableArray alloc] init];
        self.mainImageData = [[NSData alloc] init];
        
    }
    return self;
}

@end
