//
//  Twunch.h
//  twunch
//
//  Created by Jelle Vandebeeck on 17/06/13.
//  Copyright (c) 2013 fousa. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface Twunch : NSObject
@property (nonatomic, assign) BOOL closed;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *URL;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray *participants;

- (CLLocationCoordinate2D)location;
- (BOOL)you;
@end
