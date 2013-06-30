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
#import "AvatarDownloader.h"

#import "ParticipantsViewController.h"

@interface ParticipantsViewController ()
@end

@implementation ParticipantsViewController {
    NSArray *_participants;
    NSMutableDictionary *_imageDownloadsInProgress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _participants = _twunch.participants;
    _imageDownloadsInProgress = [NSMutableDictionary dictionary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSArray *allDownloads = [_imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancel)];
    
    [_imageDownloadsInProgress removeAllObjects];
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
    
    if (!participant.icon) {
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
            [self startIconDownload:participant forIndexPath:indexPath];
        }
//        cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
    } else {
        cell.imageView.image = participant.icon;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Participant *participant = _participants[indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:participant.URL]];
}

#pragma mark - Table cell image

- (void)startIconDownload:(Participant *)participant forIndexPath:(NSIndexPath *)indexPath {
    AvatarDownloader *iconDownloader = [_imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) {
        iconDownloader = [AvatarDownloader new];
        iconDownloader.participant = participant;
        [iconDownloader setCompletionHandler:^{
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.imageView.image = participant.icon;
            [_imageDownloadsInProgress removeObjectForKey:indexPath];
        }];
        [_imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader start];
    }
}

- (void)loadImagesForOnscreenRows {
    if ([_participants count] > 0) {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) {
            Participant *participant = [_participants objectAtIndex:indexPath.row];
            if (!participant.icon) {
                [self startIconDownload:participant forIndexPath:indexPath];
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForOnscreenRows];
}

@end
