//
//  AppDelegate.m
//  twunch
//
//  Created by Jelle Vandebeeck on 12/06/13.
//  Copyright (c) 2013 fousa. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self uncache];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18.0] }];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0] } forState:UIControlStateNormal];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.588 green:0.396 blue:0.075 alpha:1.000]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.510 green:0.557 blue:0.063 alpha:1.000]];
    
    return YES;
}

#pragma mark - Avatar

- (void)uncache {
    NSString *path = [[self directoryPath] stringByAppendingPathComponent:@"avatars.plist"];
    twunchapp.avatars = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    if (twunchapp.avatars == nil) twunchapp.avatars = [NSMutableDictionary new];
}

- (void)cache {
    NSString *path = [[self directoryPath] stringByAppendingPathComponent:@"avatars.plist"];
    [twunchapp.avatars writeToFile:path atomically:YES];
}

- (NSString *)directoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    return paths.firstObject;
}

@end
