//
//  raspAppDelegate-iPad.m
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "raspAppDelegate-iPad.h"

#import "RootViewController.h"
#import "RaspController.h"

@implementation raspAppDelegate_iPad

@synthesize splitViewController=_splitViewController;
@synthesize rootViewController=_rootViewController;
@synthesize detailViewController=_detailViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [RaspController instance];
    
    self.window.rootViewController = self.splitViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc {
    [_splitViewController release];
    [_rootViewController release];
    [_detailViewController release];
    [super dealloc];
}

@end
