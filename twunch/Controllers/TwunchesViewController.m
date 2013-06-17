//
//  TwunchesViewController.m
//  twunch
//
//  Created by Jelle Vandebeeck on 14/06/13.
//  Copyright (c) 2013 fousa. All rights reserved.
//

#import "TwunchesViewController.h"

#import "TwunchAPI.h"

#import "Twunch.h"

#import "NSString+Parsing.h"
#import "NSDate+Formatting.h"

@interface TwunchesViewController ()
@end

@implementation TwunchesViewController {
    NSDictionary *_twunches;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Twunches", @"Twunches");
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(willRefresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self willRefresh:self.refreshControl];
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
    
    Twunch *aTwunch = [self twunchForIndexPath:indexPath];
    cell.textLabel.text = aTwunch.name;
    cell.detailTextLabel.text = [aTwunch.date fullFormat];
    
    return cell;
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
        _twunches = twunch.twunches;
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
}

@end
