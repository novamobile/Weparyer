//
//  MBProgressHUD+Show.m
//  Weibo_Storyboard
//
//  Created by Frost on 14-5-14.
//  Copyright (c) 2014年 林億. All rights reserved.
//

#import "MBProgressHUD+Show.h"

@implementation MBProgressHUD (Show)

+ (void)showText:(NSString *)text name:(NSString *)name {

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    
    name = [NSString stringWithFormat:@"MBProgressHUD.bundle/%@",name];
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    hud.labelText = text;
    
    //隐藏的时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    //1秒后自动隐藏
    [hud hide:YES afterDelay:1];
}

+ (void)showErrorWithText:(NSString *)text {
    [self showText:text name:@"error.png"];
}

+ (void)showSuccessWithText:(NSString *)text {
    [self showText:text name:@"success.png"];
}

@end
