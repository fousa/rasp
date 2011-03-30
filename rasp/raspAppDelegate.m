//
//  raspAppDelegate.m
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "raspAppDelegate.h"

#import "RaspController.h"

@implementation raspAppDelegate

@synthesize window=_window;

- (void)showAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithKey:@"alert.title"] message:[NSString stringWithKey:@"alert.message"] delegate:nil cancelButtonTitle:[NSString stringWithKey:@"alert.cancel"] otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)dealloc {
    [_window release];
    [super dealloc];
}

@end
