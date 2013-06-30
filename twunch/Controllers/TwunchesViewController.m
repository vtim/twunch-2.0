//
//  TwunchesViewController.m
//  twunch
//
//  Created by Jelle Vandebeeck on 14/06/13.
//  Copyright (c) 2013 fousa. All rights reserved.
//

#import <Accounts/Accounts.h>

#import "TwunchesViewController.h"
#import "TwunchViewController.h"
#import "TwunchesMapViewController.h"

#import "TwunchAPI.h"

#import "Twunch.h"

#import "NSString+Parsing.h"
#import "NSDate+Formatting.h"

@interface TwunchesViewController ()
@end

@implementation TwunchesViewController {
    NSDictionary *_twunches;
    
    UIActivityIndicatorView *_activityIndicator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Twunches", @"Twunches");
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(willRefresh:) forControlEvents:UIControlEventValueChanged];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.frame = (CGRect) { (self.tableView.bounds.size.width - _activityIndicator.frame.size.width) / 2, (self.view.bounds.size.height - _activityIndicator.frame.size.height) / 2, _activityIndicator.frame.size };
    _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.tableView addSubview:_activityIndicator];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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
                [self willRefresh:self.refreshControl];
            }
        }];
    }
}

#pragma mark - Actions

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
        twunchController.twunch = [self twunchForIndexPath:[self.tableView indexPathForCell:sender]];
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
        [self.refreshControl endRefreshing];
        [_activityIndicator stopAnimating];
        [self.tableView reloadData];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Map", @"Map") style:UIBarButtonItemStylePlain target:self action:@selector(didPressMap:)];
    }];
}

@end
