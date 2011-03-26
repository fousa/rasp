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
    for (NSString *part in [parts allKeys]) {
        NSArray *countries = ((NSArray *)[parts objectForKey:part]);
        NSMutableArray *newCountries = [NSMutableArray array];
        for (NSString *country in countries) {
            if ([defaults boolForKey:country]) {
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
    for (NSString *groupName in [dictionary allKeys]) {
        if ([groupName compare:@"config"] == NSOrderedSame) {
            country.periods = [[dictionary objectForKey:groupName]objectForKey:@"periods"];
        } else {
            ChartGroup *group = [ChartGroup new];
            group.name = groupName;
            group.charts = [NSMutableArray array];
            for (NSString *chartName in [dictionary objectForKey:groupName]) {
                Chart *chart = [Chart new];
                chart.name = chartName;
                chart.country = country;
                chart.hasPeriods = [[[[dictionary objectForKey:groupName] objectForKey:chartName] objectForKey:@"has_periods"] boolValue];
                NSString *yesterdayURL = [[[dictionary objectForKey:groupName] objectForKey:chartName] objectForKey:@"yesterday"];
                if (yesterdayURL != nil) chart.yesterdayURL = yesterdayURL;

                NSString *todayURL = [[[dictionary objectForKey:groupName] objectForKey:chartName] objectForKey:@"today"];
                if (todayURL != nil) chart.todayURL = todayURL;
                
                NSString *tomorrowURL = [[[dictionary objectForKey:groupName] objectForKey:chartName] objectForKey:@"tomorrow"];
                if (tomorrowURL != nil) chart.tomorrowURL = tomorrowURL;
                
                NSString *theDayAfterURL = [[[dictionary objectForKey:groupName] objectForKey:chartName] objectForKey:@"the_day_after"];
                if (theDayAfterURL != nil) chart.theDayAfterURL = theDayAfterURL;
                
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
