//
//  ParticipantsViewController.m
//  twunch
//
//  Created by Jelle Vandebeeck on 14/06/13.
//  Copyright (c) 2013 fousa. All rights reserved.
//

#import <Social/Social.h>
#import <Accounts/Accounts.h>

#import "Participant.h"

#import "UIImageView+AFNetworking.h"

#import "ParticipantsViewController.h"

@interface ParticipantsViewController ()
@end

@implementation ParticipantsViewController {
    NSArray *_participants;
    NSMutableDictionary *_images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _participants = _twunch.participants;
    _images = [NSMutableDictionary new];
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
    
    if (_images[indexPath] == nil && twunchapp.avatars[participant.twitterHandle] == nil) {
        NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1.1/users/show.json"];
        NSDictionary *params = [NSDictionary dictionaryWithObject:participant.twitterHandle forKey:@"screen_name"];
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
        [request setAccount:twunchapp.account];
        [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if (responseData) {
                NSDictionary *user = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:NULL];
                NSString *profileImageUrl = [user objectForKey:@"profile_image_url"];
                twunchapp.avatars[participant.twitterHandle] = profileImageUrl;
                [twunchapp cache];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSData *imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString:profileImageUrl]];
                    _images[indexPath] = [UIImage imageWithData:imageData];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    });
                });
            }
            
        }];
    } else if (_images[indexPath] == nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString:twunchapp.avatars[participant.twitterHandle]]];
            _images[indexPath] = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
        });
    } else {
        cell.imageView.image = _images[indexPath];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Participant *participant = _participants[indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:participant.URL]];
}

@end
