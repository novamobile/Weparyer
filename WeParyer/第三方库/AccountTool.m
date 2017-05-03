//
//  AccountTool.m
//  Weibo_Storyboard
//
//  Created by Frost on 14-5-13.
//  Copyright (c) 2014年 林億. All rights reserved.
//

#define kFileName @"accounts.data"
#define kCurrentAccount @"currentAccount.data"

#define kFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:kFileName]
#define kCurrentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:kCurrentAccount]

#import "AccountTool.h"

@interface AccountTool ()
@property (nonatomic, strong) NSMutableArray *accounts;
@end

@implementation AccountTool
singleton_implementation(AccountTool)

- (instancetype)init {
    if (self = [super init]) {
        //从文件里面读取账户信息
        _accounts = [NSKeyedUnarchiver unarchiveObjectWithFile:kFilePath];
        _currentAccount = [NSKeyedUnarchiver unarchiveObjectWithFile:kCurrentPath];
        //如果没有账户信息
        if (_accounts == nil) {
            _accounts = [NSMutableArray array];
        }
    }
    return self;
}

- (void)addAccount:(Account *)account {
    //存取对象
    [self.accounts addObject:account];
    _currentAccount = account;
    
//    //归档
//    [NSKeyedArchiver archiveRootObject:_currentAccount toFile:kCurrentPath];
//    [NSKeyedArchiver archiveRootObject:self.accounts toFile:kFilePath];
}

- (void)updateAccount:(Account *)account
{
    [NSKeyedArchiver archiveRootObject:_currentAccount toFile:kCurrentPath];
    [NSKeyedArchiver archiveRootObject:self.accounts toFile:kFilePath];
}

-(void)removeCurrentAccount{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *delelteFilePath1 = [documentsDirectory stringByAppendingPathComponent:kFileName];
    NSString *delelteFilePath2 = [documentsDirectory stringByAppendingPathComponent:kCurrentAccount];
    
    if([fileManager isDeletableFileAtPath:delelteFilePath1])
    {
        NSError *error;
        if ([fileManager removeItemAtPath:delelteFilePath1 error:&error] != YES)
            NSLog(@"Unable to delete file1: %@", [error localizedDescription]);
        
    }
    if([fileManager isDeletableFileAtPath:delelteFilePath2])
    {
        NSError *error;
        if ([fileManager removeItemAtPath:delelteFilePath2 error:&error] != YES)
            NSLog(@"Unable to delete file2: %@", [error localizedDescription]);
    }
    _currentAccount = nil;
    [self.accounts removeAllObjects];
}

@end
