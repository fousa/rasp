//
//  raspAppDelegate.m
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "raspAppDelegate.h"

#import "RootViewController.h"
#import "RaspController.h"

@implementation raspAppDelegate

@synthesize window=_window;
@synthesize splitViewController=_splitViewController;
@synthesize rootViewController=_rootViewController;
@synthesize detailViewController=_detailViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [RaspController instance];
    
    self.window.rootViewController = self.splitViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

+ (raspAppDelegate *)sharedAppDelegate {
    return (raspAppDelegate *) [UIApplication sharedApplication].delegate;
}

#pragma mark - Language

- (NSString *)selectedLanguage {
	NSString *storedSelectedLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:kSelectedLanguageKey];	
	if ([storedSelectedLanguage empty] || !storedSelectedLanguage) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
		NSString *currentLanguage = [languages objectAtIndex:0];
		if([currentLanguage isEqualToString:@"nl"]) {
			[[NSUserDefaults standardUserDefaults] setObject:currentLanguage forKey:kSelectedLanguageKey];
		} else {
			[[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:kSelectedLanguageKey];
		}
		storedSelectedLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:kSelectedLanguageKey];
	}
	return storedSelectedLanguage;
}

- (void)dealloc {
    [_window release];
    [_splitViewController release];
    [_rootViewController release];
    [_detailViewController release];
    [super dealloc];
}

@end
