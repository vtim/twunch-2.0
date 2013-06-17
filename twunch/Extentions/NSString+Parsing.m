//
//  NSString+Parsing.m
//  valet-service-ios
//
//  Created by Jelle Vandebeeck on 31/07/12.
//  Copyright (c) 2012 10to1. All rights reserved.
//

#import "NSString+Parsing.h"

@implementation NSString (Parsing)

- (NSDate *)date {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyyMMdd'T'HHmmss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    });
    
    return [dateFormatter dateFromString:self];
}

@end
