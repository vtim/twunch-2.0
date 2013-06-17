//
//  AppDelegate.h
//  twunch
//
//  Created by Jelle Vandebeeck on 12/06/13.
//  Copyright (c) 2013 fousa. All rights reserved.
//

#import <Accounts/Accounts.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ACAccount *account;

@property (strong, nonatomic) NSDictionary *twunches;
@property (strong, nonatomic) NSMutableDictionary *avatars;

- (void)cache;
@end
