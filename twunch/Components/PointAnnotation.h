//
//  PointAnnotation.h
//  twunch
//
//  Created by Jelle Vandebeeck on 30/06/13.
//  Copyright (c) 2013 fousa. All rights reserved.
//

#import <MapKit/MapKit.h>

@class Twunch;

@interface PointAnnotation : MKPointAnnotation
@property (nonatomic, strong) Twunch *twunch;
@end
