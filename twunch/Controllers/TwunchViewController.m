//
//  TwunchViewController.m
//  twunch
//
//  Created by Jelle Vandebeeck on 14/06/13.
//  Copyright (c) 2013 fousa. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Social/Social.h>

#import "TwunchViewController.h"
#import "MapViewController.h"

#import "NSDate+Formatting.h"

@interface TwunchViewController ()
@end

@implementation TwunchViewController {
    IBOutlet UITableViewCell *_nameCell;
    IBOutlet UITableViewCell *_dateCell;
    IBOutlet UITableViewCell *_participantsCell;
    IBOutlet UITableViewCell *_addressCell;
    IBOutlet MKMapView *_mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Register", @"Register") style:UIBarButtonItemStylePlain target:self action:@selector(didPressRegister:)];
    
    _nameCell.textLabel.text = _twunch.name;
    _dateCell.textLabel.text = [_twunch.date fullFormat];
    _participantsCell.textLabel.text = [NSString stringWithFormat:@"%i %@", _twunch.participants.count , NSLocalizedString(@"participants", @"participants")];
    _addressCell.textLabel.text = _twunch.address;
    
    MKCoordinateRegion region;
	MKCoordinateSpan span = MKCoordinateSpanMake(0.004, 0.004);
	region.span = span;
	region.center = [_twunch location];
	[_mapView setRegion:region animated:YES];
	[_mapView regionThatFits:region];
    
    MKPointAnnotation *pin = [MKPointAnnotation new];
    pin.coordinate = [_twunch location];
    [_mapView addAnnotation:pin];
}

#pragma mark - Actions

- (IBAction)didPressRegister:(id)sender {
    __weak SLComposeViewController *composer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [composer setInitialText:[NSString stringWithFormat:@"(%@) @twunch I'll be there!", _twunch.name]];
    [composer addURL:[NSURL URLWithString:_twunch.URL]];
    [composer setCompletionHandler:^(SLComposeViewControllerResult result) {
        [composer dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:composer animated:YES completion:nil];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue.destinationViewController performSelector:@selector(setTwunch:) withObject:_twunch];
}

@end
