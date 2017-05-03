//
//  AccountTool.h
//  Weibo_Storyboard
//
//  Created by Frost on 14-5-13.
//  Copyright (c) 2014年 林億. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@class Account;

@interface AccountTool : NSObject
singleton_interface(AccountTool);

@property (nonatomic, strong) Account *currentAccount;

- (void)addAccount:(Account *)account;

- (void)updateAccount:(Account *)account;

- (void)removeCurrentAccount;

@end
