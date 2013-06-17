//
//  TwunchAPI.h
//  twunch
//
//  Created by Jelle Vandebeeck on 17/06/13.
//  Copyright (c) 2013 fousa. All rights reserved.
//

@interface TwunchAPI : NSObject
+ (void)fetchWithCompletion:(void(^)(BOOL success))completionHandler;
@end
