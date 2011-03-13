//
//  raspAppDelegate-iPhone.m
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "raspAppDelegate-iPhone.h"

#import "RaspController.h"

@implementation raspAppDelegate_iPhone

@synthesize navigationController=_navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [RaspController instance];
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc {
    [_navigationController release];
    [super dealloc];
}

@end
