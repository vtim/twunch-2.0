//
//  Twunch.m
//  twunch
//
//  Created by Jelle Vandebeeck on 17/06/13.
//  Copyright (c) 2013 fousa. All rights reserved.
//

#import "Twunch.h"

@implementation Twunch

- (CLLocationCoordinate2D)location {
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

- (BOOL)you {
    return twunchapp.account && [self.participants containsObject:twunchapp.account.username];
}

@end
