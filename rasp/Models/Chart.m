//
//  Chart.m
//  rasp
//
//  Created by Jelle Vandebeeck on 29/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "Chart.h"

@implementation Chart
@synthesize name, hasPeriods, yesterdayURL, todayURL, tomorrowURL, theDayAfterURL, country;

- (void)dealloc {
    self.name = nil;
    self.yesterdayURL = nil;
    self.todayURL = nil;
    self.tomorrowURL = nil;
    self.theDayAfterURL = nil;
    self.country = nil;
    
    [super dealloc];
}

@end
