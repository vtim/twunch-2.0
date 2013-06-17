//
//  TwunchViewController.m
//  twunch
//
//  Created by Jelle Vandebeeck on 14/06/13.
//  Copyright (c) 2013 fousa. All rights reserved.
//

#import "TwunchViewController.h"

@interface TwunchViewController ()
@end

@implementation TwunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Register", @"Register") style:UIBarButtonItemStylePlain target:self action:@selector(didPressRegister:)];
}

- (IBAction)didPressRegister:(id)sender {
    
}

@end
