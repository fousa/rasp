//
//  Country.m
//  rasp
//
//  Created by Jelle Vandebeeck on 29/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "Country.h"


@implementation Country

@synthesize name, URL, charts, periods, onlyHours, theDayAfterPeriods, yesterdayPeriods, todayPeriods, tomorrowPeriods;

- (NSArray *)periodsForDay:(NSString *)day {
    if ([day compare:@"yesterday"] == NSOrderedSame && self.yesterdayPeriods != nil) return self.yesterdayPeriods;
    if ([day compare:@"today"] == NSOrderedSame && self.todayPeriods != nil) return self.todayPeriods;
    if ([day compare:@"tomorrow"] == NSOrderedSame && self.tomorrowPeriods != nil) return self.tomorrowPeriods;
    if ([day compare:@"the_day_after"] == NSOrderedSame && self.theDayAfterPeriods != nil) return self.theDayAfterPeriods;
    
    return self.periods;
}

- (void)dealloc {
    self.name = nil;
    self.URL = nil;
    self.charts = nil;
    self.yesterdayPeriods = nil;
    self.todayPeriods = nil;
    self.tomorrowPeriods = nil;
    self.theDayAfterPeriods = nil;
    self.periods = nil;
    
    [super dealloc];
}

@end
