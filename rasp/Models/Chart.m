//
//  Chart.m
//  rasp
//
//  Created by Jelle Vandebeeck on 29/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "Chart.h"

@implementation Chart
@synthesize name, hasPeriods, yesterdayURLs, todayURLs, tomorrowURLs, theDayAfterURLs, country;

- (void)dealloc {
    self.name = nil;
    self.yesterdayURLs = nil;
    self.todayURLs = nil;
    self.tomorrowURLs = nil;
    self.theDayAfterURLs = nil;
    self.country = nil;
    
    [super dealloc];
}

@end
