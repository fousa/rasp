//
//  RaspController.m
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "RaspController.h"

#import "ASIHTTPRequest.h"
#import "JSON.h"

static RaspController *singletonRaspController = nil;

@interface RaspController () {
	NSMutableArray *_menu;
}
@end

@interface RaspController (Loading)
- (void)loadMenu;
@end

@implementation RaspController

#pragma mark -
#pragma mark Singleton

+ (RaspController *)instance {
	@synchronized(self) {
		if (!singletonRaspController) {
			singletonRaspController = [[RaspController alloc] init];
			[singletonRaspController loadMenu];
		}
	}
	return singletonRaspController;
}

#pragma mark -
#pragma mark Getters

- (NSArray *)menu {
    return _menu;
}

#pragma mark -
#pragma mark Loading

- (void)loadMenu {
	NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingString:@"menu"]];
	
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setTimeOutSeconds:25];
    [request setDidFinishSelector:@selector(requestSuccess:)];
    [request setUseKeychainPersistence:YES];
    [request startSynchronous];
}

- (void)requestSuccess:(ASIHTTPRequest *)aRequest {
    _menu = [[[aRequest responseString] JSONValue] retain];
	if ([_menu count] == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"An error occured trying to connect to the server." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

@end
