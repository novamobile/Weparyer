//
//  getInMobiAd.m
//  ToDoListApp
//
//  Created by Ankit Mittal on 3/15/16.
//  Copyright © 2016 Inmobi. All rights reserved.

// <This is the server side code>

#import "InMobiRequestHandler.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "IPAdress.h"
#import "Weparyer-Swift.h"

@interface InMobiRequestHandler ()

@property(nonatomic,strong) NSString *serverURLstring;
@property(nonatomic,strong) NSString *ifa;
@property(nonatomic,strong) NSString *client_ip;
@property(nonatomic,strong) NSString *request_body;
@property(nonatomic,strong) NSURL *serverURL;
@property(nonatomic,strong) NSData *postData;

@end

@implementation InMobiRequestHandler


-(id) init {
    self=[super init];
    if (self) {
        
        self.serverURLstring = @"http://146.0.229.49:9000/community/inMobi/obtain";
        self.client_ip = @"46.18.167.255";
        self.ifa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        self.request_body=[[NSString alloc] initWithUTF8String: "device="];
        self.request_body = [self.request_body stringByAppendingString:self.ifa];
        if([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled])
        {
            NSLog(@"init->>>>>222222");
        }
        self.request_body = [self.request_body stringByAppendingString:@"&ip="];
        self.request_body = [self.request_body stringByAppendingString:_client_ip];
        NSLog(@"init->>>>>%@",self.request_body);
    }
    return self;
}

- (void) SetIpAddress:(NSString* )ip{
    if(ip)
    {
        if([ip isEqual:@""] == NO)
        {
            _client_ip = ip;
            NSLog(@"SetIpAddress->>>>>%@",_client_ip);
            [SwiftNotice noticeOnSatusBar:_client_ip autoClear:true autoClearTime:10];
//            [SwiftNotice showText:_client_ip autoClear:true autoClearTime:2];
        }
    }
}

- (void) fetchAdsFromInmobiServer : (InmobiSplashAdCache*) cache {
    self.serverURL = [NSURL URLWithString:self.serverURLstring];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.serverURL];
    [request setHTTPMethod:@"POST"];
    
    self.postData = [self.request_body dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:self.postData];
    NSLog(@"fetchAdsFromInmobiServer->>>>%@",self.request_body);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error)
                    {
                    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"responseStringresponseStringresponseStringresponseString =%@",responseString);
                    if (responseString) {
                        [cache populateSplashAdCacheWithResponse:responseString];
                    }
                }
    ]resume];

}

- (void)getIPAddress {
//    InitAddresses();
//    GetIPAddresses();
//    GetHWAddresses();
//    return [NSString stringWithFormat:@"%s", ip_names[1]];
}

@end
