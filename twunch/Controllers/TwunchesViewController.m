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

@interface TwunchesViewController ()
@end

@implementation TwunchesViewController {
    NSArray *_twunches;
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
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"April";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _twunches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TwunchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Twunch *aTwunch = _twunches[indexPath.row];
    cell.textLabel.text = aTwunch.name;
    
    return cell;
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
