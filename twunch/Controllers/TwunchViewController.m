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
    __weak IBOutlet UITableViewCell *_nameCell;
    __weak IBOutlet UITableViewCell *_dateCell;
    __weak IBOutlet UITableViewCell *_participantsCell;
    __weak IBOutlet UITableViewCell *_addressCell;
    __weak IBOutlet UITableViewCell *_noteCell;
    __weak IBOutlet MKMapView *_mapView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = NSLocalizedString(@"", @"");
    
    _nameCell.textLabel.text = _twunch.name;
    _noteCell.textLabel.text = _twunch.note == nil || [_twunch.note isEqualToString:@""] ? NSLocalizedString(@"No note", @"No note") : _twunch.note;
    _dateCell.textLabel.text = [_twunch.date fullFormat];
    _participantsCell.textLabel.text = [NSString stringWithFormat:@"%i %@", _twunch.participants.count , [_twunch you] ? NSLocalizedString(@"participants including you", @"participants including you") : NSLocalizedString(@"participants", @"participants")];
    _addressCell.textLabel.text = _twunch.address;
    
    [self.tableView reloadData];
    
    if ([_twunch you]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Unregister", @"Unregister") style:UIBarButtonItemStylePlain target:self action:@selector(didPressUnregister:)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Register", @"Register") style:UIBarButtonItemStylePlain target:self action:@selector(didPressRegister:)];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    MKCoordinateRegion region;
	MKCoordinateSpan span = MKCoordinateSpanMake(0.004, 0.004);
	region.span = span;
	region.center = [_twunch location];
	[_mapView setRegion:region animated:YES];
	[_mapView regionThatFits:region];
    
    [_mapView removeAnnotations:_mapView.annotations];
    
    MKPointAnnotation *pin = [MKPointAnnotation new];
    pin.coordinate = [_twunch location];
    [_mapView addAnnotation:pin];
}

#pragma mark - Table

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: return [_nameCell.textLabel.text boundingRectWithSize:(CGSize) { 270, CGFLOAT_MAX } options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:_nameCell.textLabel.font } context:nil].size.height + 40;
        case 1: return [_dateCell.textLabel.text boundingRectWithSize:(CGSize) { 270, CGFLOAT_MAX } options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:_dateCell.textLabel.font } context:nil].size.height + 40;
        case 2: return [_participantsCell.textLabel.text boundingRectWithSize:(CGSize) { 270, CGFLOAT_MAX } options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:_participantsCell.textLabel.font } context:nil].size.height + 40;
        case 3: return [_noteCell.textLabel.text boundingRectWithSize:(CGSize) { 270, CGFLOAT_MAX } options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:_noteCell.textLabel.font } context:nil].size.height + 40;
        case 4: return [_addressCell
                        .textLabel.text boundingRectWithSize:(CGSize) { 270, CGFLOAT_MAX } options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:_addressCell.textLabel.font } context:nil].size.height + 40;
        case 5: return 210;
        default: return 0;
    }
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

- (IBAction)didPressUnregister:(id)sender {
    __weak SLComposeViewController *composer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [composer setInitialText:[NSString stringWithFormat:@"(%@) @twunch I won't be able to make it!", _twunch.name]];
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
