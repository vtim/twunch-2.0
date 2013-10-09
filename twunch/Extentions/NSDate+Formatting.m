//
//  NSDate+Formatting.m
//  valet-service-ios
//
//  Created by Jelle Vandebeeck on 31/07/12.
//  Copyright (c) 2012 10to1. All rights reserved.
//

#import "NSDate+Formatting.h"

@implementation NSDate (Formatting)

- (NSString *)fullFormat {
    static NSDateFormatter *fullFormatter = nil;
    static dispatch_once_t onceFullToken;
    dispatch_once(&onceFullToken, ^{
        fullFormatter = [NSDateFormatter new];
        [fullFormatter setDateStyle:NSDateFormatterMediumStyle];
        [fullFormatter setTimeStyle:NSDateFormatterShortStyle];
    });
    return [fullFormatter stringFromDate:self];
}

- (NSString *)dateKeyFormat {
    static NSDateFormatter *monthFormatter = nil;
    static dispatch_once_t onceMonthToken;
    dispatch_once(&onceMonthToken, ^{
        monthFormatter = [NSDateFormatter new];
        [monthFormatter setDateFormat:@"YYYYMM"];
    });
    return [monthFormatter stringFromDate:self];
}

- (NSString *)fullMonthFormat {
    static NSDateFormatter *fullMonthFormatter = nil;
    static dispatch_once_t onceFullMonthToken;
    dispatch_once(&onceFullMonthToken, ^{
        fullMonthFormatter = [NSDateFormatter new];
        [fullMonthFormatter setDateFormat:@"MMMM"];
    });
    return [fullMonthFormatter stringFromDate:self];
}

@end
