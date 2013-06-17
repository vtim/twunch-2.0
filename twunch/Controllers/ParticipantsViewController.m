//
//  ParticipantsViewController.m
//  twunch
//
//  Created by Jelle Vandebeeck on 14/06/13.
//  Copyright (c) 2013 fousa. All rights reserved.
//

#import "Participant.h"

#import "ParticipantsViewController.h"

@interface ParticipantsViewController ()
@end

@implementation ParticipantsViewController {
    NSArray *_participants;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _participants = _twunch.participants;
}

#pragma mark - Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _participants.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Participant *participant = _participants[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"@%@", participant.twitterHandle];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Participant *participant = _participants[indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:participant.URL]];
}

@end
