//
//  TwunchesViewController.m
//  twunch
//
//  Created by Jelle Vandebeeck on 14/06/13.
//  Copyright (c) 2013 fousa. All rights reserved.
//

#import <Accounts/Accounts.h>
#import <MapKit/MapKit.h>

#import "TwunchesViewController.h"
#import "TwunchViewController.h"
#import "TwunchesMapViewController.h"

#import "TwunchAPI.h"

#import "Twunch.h"

#import "NSString+Parsing.h"
#import "NSDate+Formatting.h"

#import "PinAnnotationView.h"
#import "PointAnnotation.h"

#import "UIView+CBFrameHelpers.h"

@interface TwunchesViewController ()
@end

@implementation TwunchesViewController {
    NSDictionary *_twunches;
    NSArray *_twunchesList;
    
    UIActivityIndicatorView *_activityIndicator;
    UIRefreshControl *_refreshControl;
    
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet MKMapView *_mapView;
    
    __weak IBOutlet UISegmentedControl *_segementControl;
    
    MKMapRect _regionRect;
    
    BOOL _secondLoad;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Twunches", @"Twunches");
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = _tableView;
    _refreshControl = [UIRefreshControl new];
    [_refreshControl addTarget:self action:@selector(willRefresh:) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = _refreshControl;
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.frame = (CGRect) { (_tableView.bounds.size.width - _activityIndicator.frame.size.width) / 2, (self.view.bounds.size.height - _activityIndicator.frame.size.height) / 2, _activityIndicator.frame.size };
    _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [_tableView addSubview:_activityIndicator];
    
    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_secondLoad) {
        _secondLoad = YES;
        [_mapView outsideRightEdgeBy:0.0f];
        
        if (twunchapp.account == nil) {
            [_activityIndicator startAnimating];
            
            ACAccountStore *store = [[ACAccountStore alloc] init];
            ACAccountType *twitterType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            [store requestAccessToAccountsWithType:twitterType options:nil completion:^(BOOL granted, NSError *error) {
                if (granted) {
                    ACAccountType *twitterType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
                    NSArray *twitterAccounts = [store accountsWithAccountType:twitterType];
                    if (twitterAccounts.count > 0) {
                        twunchapp.account = twitterAccounts.firstObject;
                    }
                    [self willRefresh:_refreshControl];
                }
            }];
        }
    }
    
    [self refreshMap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_segementControl.selectedSegmentIndex == 0) {
        [_tableView insideLeftEdgeBy:0.0f];
        [_mapView outsideRightEdgeBy:0.0f];
    } else {
        [_tableView outsideLeftEdgeBy:0.0f];
        [_mapView insideLeftEdgeBy:0.0f];
    }
}

#pragma mark - Map

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    PinAnnotationView *annotationView = (PinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Callout"];
    if(!annotationView) {
        annotationView = [[PinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Callout"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        button.tintColor = [UIColor colorWithRed:0.788 green:0.400 blue:0.404 alpha:1.000];
        annotationView.rightCalloutAccessoryView = button;
    }
    annotationView.tintColor = [UIColor colorWithRed:0.788 green:0.400 blue:0.404 alpha:1.000];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.twunch = ((PointAnnotation *)annotation).twunch;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:@"Detail" sender:((PinAnnotationView *)view).twunch];
}

#pragma mark - Actions

- (IBAction)didChangeSegment:(id)sender {
    UISegmentedControl *segement = sender;
    if (segement.selectedSegmentIndex == 0) {
        [UIView animateWithDuration:0.15f animations:^{
            [_tableView insideLeftEdgeBy:0.0f];
            [_mapView outsideRightEdgeBy:0.0f];
        }];
    } else {
        [UIView animateWithDuration:0.15f animations:^{
            [_tableView outsideLeftEdgeBy:0.0f];
            [_mapView insideLeftEdgeBy:0.0f];
        }];
    }
}

- (IBAction)didPressMap:(id)sender {
    [self performSegueWithIdentifier:@"Map" sender:nil];
}

#pragma mark - Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self months].count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[self months][section] dateFromMonth] fullMonthFormat];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self twunchesForSection:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TwunchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Twunch *twunch = [self twunchForIndexPath:indexPath];
    cell.textLabel.text = twunch.name;
    cell.detailTextLabel.text = [twunch.date fullFormat];
    
    return cell;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Detail"]) {
        TwunchViewController *twunchController = segue.destinationViewController;
        twunchController.twunch = [self twunchForIndexPath:[_tableView indexPathForCell:sender]];
    } else if ([segue.identifier isEqualToString:@"Map"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        TwunchesMapViewController *mapController = (TwunchesMapViewController *)navigationController.topViewController;
        mapController.twunches = [_twunches.allValues valueForKeyPath:@"@unionOfArrays.self"];
    }
}

#pragma mark - Data

- (NSArray *)months {
    return [_twunches.allKeys sortedArrayUsingSelector:@selector(compare:)];
}

- (NSArray *)twunchesForSection:(NSInteger)section {
    return _twunches[[self months][section]];
}

- (Twunch *)twunchForIndexPath:(NSIndexPath *)indexPath {
    return [self twunchesForSection:indexPath.section][indexPath.row];
}

#pragma mark - Refresh

- (IBAction)willRefresh:(id)sender {
    [TwunchAPI fetchWithCompletion:^(BOOL success) {
        _twunches = twunchapp.twunches;
        [_refreshControl endRefreshing];
        [_activityIndicator stopAnimating];
        [_tableView reloadData];
        
        _twunchesList = [_twunches.allValues valueForKeyPath:@"@unionOfArrays.self"];
        [self refreshMap];
    }];
}

- (void)refreshMap {
    _regionRect = MKMapRectNull;
    for (Twunch *twunch in _twunchesList) {
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
    
    [_mapView setVisibleMapRect:_regionRect edgePadding:(UIEdgeInsets) { 15, 15, 15, 15 } animated:YES];
}

@end
