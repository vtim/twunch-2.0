
//  MapViewController.m
//  twunch
//
//  Created by Jelle Vandebeeck on 17/06/13.
//  Copyright (c) 2013 fousa. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "MapViewController.h"

@interface MapViewController ()
@end

@implementation MapViewController {
    __weak IBOutlet MKMapView *_mapView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    MKCoordinateRegion region;
	MKCoordinateSpan span = MKCoordinateSpanMake(0.004, 0.004);
	region.span = span;
	region.center = [_twunch location];
	[_mapView setRegion:region animated:YES];
	[_mapView regionThatFits:region];
    
    MKPointAnnotation *pin = [MKPointAnnotation new];
    pin.coordinate = [_twunch location];
    pin.title = _twunch.name;
    pin.subtitle = _twunch.address;
    [_mapView addAnnotation:pin];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = NSLocalizedString(@"Location", @"Location");
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Directions", @"Directions") style:UIBarButtonItemStylePlain target:self action:@selector(didPressDirections:)];
}

#pragma mark - Actions

- (IBAction)didPressDirections:(id)sender {
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:[_twunch location] addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem openInMapsWithLaunchOptions:[NSDictionary dictionaryWithObjectsAndKeys:MKLaunchOptionsDirectionsModeWalking, MKLaunchOptionsDirectionsModeKey, nil]];
}

@end
