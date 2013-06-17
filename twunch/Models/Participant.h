//
//  Participant.h
//  twunch
//
//  Created by Jelle Vandebeeck on 17/06/13.
//  Copyright (c) 2013 fousa. All rights reserved.
//

@interface Participant : NSObject
@property (nonatomic, strong) NSString *twitterHandle;

- (NSString *)URL;
@end
