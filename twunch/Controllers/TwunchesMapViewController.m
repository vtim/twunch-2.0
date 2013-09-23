//
//  TwunchesMapViewController.m
//  twunch
//
//  Created by Jelle Vandebeeck on 30/06/13.
//  Copyright (c) 2013 fousa. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "TwunchesMapViewController.h"
#import "TwunchViewController.h"

#import "Twunch.h"

#import "PinAnnotationView.h"
#import "PointAnnotation.h"

#import "NSDate+Formatting.h"

@interface TwunchesMapViewController ()
@end

@implementation TwunchesMapViewController {
    __weak IBOutlet MKMapView *_mapView;
    
    MKMapRect _regionRect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Map", @"Map");
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"List", @"List") style:UIBarButtonItemStylePlain target:self action:@selector(didPressList:)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _regionRect = MKMapRectNull;
    for (Twunch *twunch in _twunches) {
        if ([twunch location].latitude != 0 || [twunch location].longitude != 0) {
            PointAnnotation *pin = [PointAnnotation new];
            pin.coordinate = [twunch location];
            pin.title = twunch.name;
            pin.subtitle = [twunch.date fullFormat];
            pin.twunch = twunch;
            [_mapView addAnnotation:pin];
            
            MKMapPoint mapPoint = MKMapPointForCoordinate(pin.coordinate);
            MKMapRect pointRect = MKMapRectMake(mapPoint.x, mapPoint.y, 1.5, 1.5);
            _regionRect = MKMapRectUnion(_regionRect, pointRect);
        }
    }
    
    [_mapView setVisibleMapRect:_regionRect edgePadding:(UIEdgeInsets) { 5, 5, 5, 5 } animated:YES];
}

#pragma mark - Map

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    PinAnnotationView *annotationView = (PinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Callout"];
    if(!annotationView) {
        annotationView = [[PinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Callout"];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.twunch = ((PointAnnotation *)annotation).twunch;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:@"Detail" sender:((PinAnnotationView *)view).twunch];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Detail"]) {
        TwunchViewController *twunchController = segue.destinationViewController;
        twunchController.twunch = sender;
    }
}

#pragma mark - Actions

- (IBAction)didPressList:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end