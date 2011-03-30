//
//  raspAppDelegate-iPad.m
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "raspAppDelegate-iPad.h"

#import "RaspController.h"

@implementation raspAppDelegate_iPad

@synthesize splitViewController=_splitViewController;
@synthesize countryViewController=_countryViewController;
@synthesize detailViewController=_detailViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if ([[RaspController instance].regions count] == 0) [super showAlert];
    
    self.window.rootViewController = self.splitViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc {
    [_splitViewController release];
    [_countryViewController release];
    [_detailViewController release];
    [super dealloc];
}

@end
