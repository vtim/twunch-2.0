//
//  Participant.m
//  twunch
//
//  Created by Jelle Vandebeeck on 17/06/13.
//  Copyright (c) 2013 fousa. All rights reserved.
//

#import "Participant.h"

@implementation Participant

- (NSURL *)twitterWebURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/%@", _twitterHandle]];
}

- (NSURL *)twitterAppURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"twitter://user?screen_name=%@", _twitterHandle]];
}

- (NSURL *)tweetbotURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"tweetbot:///user_profile/%@", _twitterHandle]];
}

@end
