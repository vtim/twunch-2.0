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
    self.window.tintColor = [UIColor colorWithRed:0.600 green:0.400 blue:0.000 alpha:1.000];
    
    [self uncache];
    
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
