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

- (void)dealloc {
    [_window release];
    [super dealloc];
}

@end
