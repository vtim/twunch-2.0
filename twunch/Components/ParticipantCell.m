//
//  ParticipantCell.m
//  twunch
//
//  Created by Jelle Vandebeeck on 17/06/13.
//  Copyright (c) 2013 fousa. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ParticipantCell.h"

@implementation ParticipantCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.bounds = CGRectMake(0, 0, 37, 37);
    self.imageView.frame = CGRectMake(8.5, 8.5, 37, 37);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = CGRectGetMaxX(self.imageView.frame) + 5;
    self.textLabel.frame = tmpFrame;
    
    tmpFrame = self.detailTextLabel.frame;
    tmpFrame.origin.x = CGRectGetMaxX(self.imageView.frame) + 5;
    self.detailTextLabel.frame = tmpFrame;
    
    CALayer *layer = self.imageView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 18.5f;
}

@end
