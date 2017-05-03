//
//  MMLocationManager.m
//  DemoBackgroundLocationUpdate
//
//  Created by Ralph Li on 7/20/15.
//  Copyright (c) 2015 LJC. All rights reserved.
//

#import "WPLocationManager.h"
//#import ""
#import "PrayTime.h"


@interface WPLocationManager()<CLLocationManagerDelegate>

//@property (nonatomic, assign) UIBackgroundTaskIdentifier taskIdentifier;

@end

@implementation WPLocationManager

+ (instancetype)sharedManager
{
    static WPLocationManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WPLocationManager alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        self.minSpeed = 3;
        self.minFilter = 50;
        self.minInteval = 10;
//        [self startMonitoringSignificantLocationChanges];
        self.delegate = self;
        self.distanceFilter  = self.minFilter;
        self.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations[0];
    
    NSLog(@"%@",location);
    
    [self adjustDistanceFilter:location];
    [self uploadLocation:location];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{}

//-(void)stopMonitoringSignificantLocationChanges{
//    [self stopMonitoringSignificantLocationChanges];
//}

/**
 *  规则: 如果速度小于minSpeed m/s 则把触发范围设定为50m
 *  否则将触发范围设定为minSpeed*minInteval
 *  此时若速度变化超过10% 则更新当前的触发范围(这里限制是因为不能不停的设置distanceFilter,
 *  否则uploadLocation会不停被触发)
 
 

 
 */
- (void)adjustDistanceFilter:(CLLocation*)location
{
//    NSLog(@"adjust:%f",location.speed);
    
    if ( location.speed < self.minSpeed )
    {
        if ( fabs(self.distanceFilter-self.minFilter) > 0.1f )
        {
            self.distanceFilter = self.minFilter;
        }
    }
    else
    {
        CGFloat lastSpeed = self.distanceFilter/self.minInteval;
        
        if ( (fabs(lastSpeed-location.speed)/lastSpeed > 0.1f) || (lastSpeed < 0) )
        {
            CGFloat newSpeed  = (int)(location.speed+0.5f);
            CGFloat newFilter = newSpeed*self.minInteval;
            
            self.distanceFilter = newFilter;
        }
    }
}


//这里仅用本地数据库模拟上传操作
- (void)uploadLocation:(CLLocation*)location
{
    
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"caches:%@",caches);
    NSDate*currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss SS"];
    NSString *dateStr = [dateFormatter stringFromDate:currentDate];
    
    NSLog(@"纬度=========%f 经度===========%f",location.coordinate.latitude,location.coordinate.longitude);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [userDefaults objectForKey:@"UserDefaultLocation"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:location.coordinate.latitude],@"latitude",[NSNumber numberWithDouble:location.coordinate.longitude],@"longitude",dateStr,@"time", nil];
    
    
    arr = [NSArray arrayWithObject:dic];
    NSLog(@"%@",arr);
    [userDefaults setObject:arr forKey:@"UserDefaultLocation"];
    [userDefaults synchronize];
    //去除所有通知
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    [self setUserDefaultNotificationsWithLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
//    [self setNotification];
}

//设置通知
-(void)setUserDefaultNotificationsWithLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude{
    
    PrayTime *time = [[PrayTime alloc]init];
    NSDate *date = [NSDate date];
    
    NSInteger num = [[NSUserDefaults standardUserDefaults]integerForKey:@"calcTimeMethod"];
    
    NSInteger addTimeZone = [[NSUserDefaults standardUserDefaults]integerForKey:@"daylight"];
    int add = 0;
    if (addTimeZone == 0) {
        add = 1;
    }else if(addTimeZone == 2){
        add = -1;
    }
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSInteger offset = [timeZone secondsFromGMTForDate:date];
    
   NSArray *times = [time prayerTimes:0 andLatitude:latitude andLongitude:longitude andtimeZone:(int)add calcMethod:(int)num];
     NSLog(@"times = %@",times);

    for (NSString *timeStr in times) {
        UILocalNotification *notification = [[UILocalNotification alloc]init];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"YYYY-MM-dd";
        NSString *UTCTime = [dateFormatter stringFromDate:date];
        NSString *notTime = [NSString stringWithFormat:@"%@ %@",UTCTime,timeStr];
        dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm";
        NSLog(@"%@",notTime);
        //通知时间
        NSLog(@"%zd",offset);
        notification.fireDate = [[dateFormatter dateFromString:notTime]dateByAddingTimeInterval:offset];
//        notification.fireDate = [dateFormatter dateFromString:notTime];
        //通知名称
        notification.soundName = @"礼拜时间到";
        //解锁图案
        notification.alertAction = @"解锁";
        //图标文字
        notification.applicationIconBadgeNumber = 1;
        //通知名称
        notification.userInfo = @{@"key":@"到点通知"};
        notification.repeatInterval = NSCalendarUnitDay;
        [[UIApplication sharedApplication]scheduleLocalNotification:notification];
    }
    
    
    /*
     UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil];
     
     [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
     
     
     
     
     
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
     NSString *timeStr = @"";
     dateFormatter.dateFormat = @"YYYY-MM-dd";
     NSString *noticeTime1 = [NSString stringWithFormat:@"%@%@",[dateFormatter stringFromDate:[NSDate date]],timeStr];
     dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm";
     
     
     NSDate *noticeDate0 = [dateFormatter dateFromString:noticeTime1];
     
     double willAddParyerTime = 0.0;
     double lastAddTime = 0.0;
     NSTimeInterval newNoticeTime = noticeDate0.timeIntervalSince1970 + (willAddParyerTime+lastAddTime)*60.0;
     
     NSDate *d = [NSDate dateWithTimeIntervalSince1970:newNoticeTime];
     NSString *time = [dateFormatter stringFromDate:d];
     NSDate *date = [NSDate date];
     NSString *prefixDate = [dateFormatter stringFromDate:date];
     NSString *noticeTime = [NSString stringWithFormat:@"%@%@",prefixDate,time];
     NSString *noticeDate = [dateFormatter dateFromString:noticeTime];
     notification.fireDate = noticeDate;
     
     
     */
}

-(void)setNotification{
    
    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil];
    
    [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
    
    
    UILocalNotification *localNote = [[UILocalNotification alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm";
    
    //通知时间
    localNote.fireDate = [dateFormatter dateFromString:@"2017-05-03 04:05"];
    //通知名称
    localNote.soundName = @"Abdelmajid";
    //解锁图案
    localNote.alertAction = @"解锁";
    //图标文字
    localNote.applicationIconBadgeNumber = 10;
//    localNote.repeatInterval
    localNote.userInfo = @{@"name":@"到点通知"};
    [[UIApplication sharedApplication]scheduleLocalNotification:localNote];
    
}


//- (void)beingBackgroundUpdateTask
//{
//    self.taskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//        [self endBackgroundUpdateTask];
//    }];
//}
//
//- (void)endBackgroundUpdateTask
//{
//    if ( self.taskIdentifier != UIBackgroundTaskInvalid )
//    {
//        [[UIApplication sharedApplication] endBackgroundTask: self.taskIdentifier];
//        self.taskIdentifier = UIBackgroundTaskInvalid;
//    }
//}

@end
