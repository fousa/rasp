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

#import "Region.h"
#import "ChartGroup.h"
#import "Chart.h"

static RaspController *singletonRaspController = nil;

@interface RaspController () {
    NSMutableArray *_regions;
}
@end

@interface RaspController (Loading)
- (void)loadChartsForCountry:(NSString *)country;
- (void)loadCountries;
@end

@implementation RaspController

@synthesize delegate=_delegate;

#pragma mark -
#pragma mark Singleton

+ (RaspController *)instance {
	@synchronized(self) {
		if (!singletonRaspController) {
			singletonRaspController = [[RaspController alloc] init];
            [singletonRaspController loadCountries];
		}
	}
	return singletonRaspController;
}

#pragma mark -
#pragma mark Getters

- (NSArray *)regions {
    return _regions;
}

#pragma - Countries

- (void)loadCountries {
	NSDictionary *parts = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"]];
    
    NSMutableArray *filteredRegions = [NSMutableArray array];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(compare:)];
    NSArray* sortedParts = [[parts allKeys] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    for (NSString *part in sortedParts) {
        NSArray *countries = ((NSArray *)[parts objectForKey:part]);
        NSMutableArray *newCountries = [NSMutableArray array];
        NSArray* sortedCountries = [countries sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        for (NSString *country in sortedCountries) {
            if ([defaults objectForKey:country] == nil || [defaults boolForKey:country]) {
                [newCountries addObject:country];
            }
        }
        if ([newCountries count] > 0) {
            Region *region = [[Region alloc] initWithCountries:newCountries];
            region.name = part;
            [filteredRegions addObject:region];
            [region release];
        }
    }
    _regions = filteredRegions;
}

#pragma mark - Charts

- (NSArray *)convertCharts:(NSDictionary *)dictionary forCountry:(Country *)country {
    NSMutableArray *groups = [NSMutableArray array];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(compare:)];
    NSArray* sortedGroups = [[dictionary allKeys] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    for (NSString *groupName in sortedGroups) {
        if ([groupName compare:@"config"] == NSOrderedSame) {
            country.periods = [[dictionary objectForKey:groupName]objectForKey:@"periods"];
            country.onlyHours = [[[dictionary objectForKey:groupName]objectForKey:@"only_hours"] boolValue];
        } else {
            ChartGroup *group = [ChartGroup new];
            group.name = groupName;
            group.charts = [NSMutableArray array];
            NSArray* sortedCharts = [[[dictionary objectForKey:groupName] allKeys] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            for (NSString *chartName in sortedCharts) {
                Chart *chart = [Chart new];
                chart.name = chartName;
                chart.country = country;
                chart.hasPeriods = [[[[dictionary objectForKey:groupName] objectForKey:chartName] objectForKey:@"has_periods"] boolValue];
                
                chart.yesterdayURLs = nil;
                if ([[[dictionary objectForKey:groupName] objectForKey:chartName] objectForKey:@"yesterday"] != nil) {
                    chart.yesterdayURLs = [NSMutableArray array];
                    for (NSString *URL in [[[dictionary objectForKey:groupName] objectForKey:chartName] objectForKey:@"yesterday"]) {
                        [chart.yesterdayURLs addObject:URL];
                    }
                }
                chart.todayURLs = nil;
                if ([[[dictionary objectForKey:groupName] objectForKey:chartName] objectForKey:@"today"] != nil) {
                    chart.todayURLs = [NSMutableArray array];
                    for (NSString *URL in [[[dictionary objectForKey:groupName] objectForKey:chartName] objectForKey:@"today"]) {
                        [chart.todayURLs addObject:URL];
                    }
                }
                chart.tomorrowURLs = nil;
                if ([[[dictionary objectForKey:groupName] objectForKey:chartName] objectForKey:@"tomorrow"] != nil) {
                    chart.tomorrowURLs = [NSMutableArray array];
                    for (NSString *URL in [[[dictionary objectForKey:groupName] objectForKey:chartName] objectForKey:@"tomorrow"]) {
                        [chart.tomorrowURLs addObject:URL];
                    }
                }
                chart.theDayAfterURLs = nil;
                if ([[[dictionary objectForKey:groupName] objectForKey:chartName] objectForKey:@"the_day_after"] != nil) {
                    chart.theDayAfterURLs = [NSMutableArray array];
                    for (NSString *URL in [[[dictionary objectForKey:groupName] objectForKey:chartName] objectForKey:@"the_day_after"]) {
                        [chart.theDayAfterURLs addObject:URL];
                    }
                }
                
                [group.charts addObject:chart];
                [chart release];
            }
            [groups addObject:group];
            [group release];
        }
    }
    return groups;
}

- (void)loadChartsForCountry:(Country *)country {
	NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingFormat:@"countries/%@/charts", country.name]];
	
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self.delegate];
    [request setTimeOutSeconds:25];
    [request setDidFinishSelector:@selector(requestSuccess:)];
    [request startAsynchronous];
}

#pragma mark -
#pragma mark Memory

- (void)dealloc {
    [_regions release], _regions = nil;
    self.delegate = nil;
    [super dealloc];
}

@end
