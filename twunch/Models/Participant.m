//
//  Participant.m
//  twunch
//
//  Created by Jelle Vandebeeck on 17/06/13.
//  Copyright (c) 2013 fousa. All rights reserved.
//

#import "Participant.h"

@implementation Participant

- (NSString *)URL {
    return [NSString stringWithFormat:@"http://twitter.com/%@", _twitterHandle];
}

@end
