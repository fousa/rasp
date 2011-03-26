//
//  ChartViewController.m
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "ChartViewController.h"

#import "MWPhoto.h"

@interface ChartViewController () {
    NSArray *photos;
    UIBarButtonItem *_barButtonItem;
}
@end

@interface ChartViewController (View)
- (NSArray *)chartsFor:(NSString *)path andTimestamps:(NSArray *)timestamps;
- (MWPhotoBrowser *)browserForURL:(NSString *)URLString withName:(NSString *)aName;
@end

@implementation ChartViewController

@synthesize chart=_chart;
@synthesize country=_country;

#pragma mark - Detail element

- (NSArray *)chartsFor:(NSString *)path andTimestamps:(NSArray *)timestamps {
    NSMutableArray *charts = [NSMutableArray array];
    for (NSString *timestamp in timestamps) {
        [charts addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:path, [timestamp intValue]]]]];
    }
    
    return [NSArray arrayWithArray:charts];
}

- (void)configureView {
    NSMutableArray *browsers = [NSMutableArray array];
    if (self.chart.yesterdayURL != nil) {
        MWPhotoBrowser *browser = [self browserForURL:self.chart.yesterdayURL withName:@"yesterday"];
        [browsers addObject:browser];
        [browser release];
    }
    if (self.chart.yesterdayURL != nil) {
        MWPhotoBrowser *browser = [self browserForURL:self.chart.todayURL withName:@"today"];
        [browsers addObject:browser];
        [browser release];
    }
    if (self.chart.yesterdayURL != nil) {
        MWPhotoBrowser *browser = [self browserForURL:self.chart.tomorrowURL withName:@"tomorrow"];
        [browsers addObject:browser];
        [browser release];
    }
    if (self.chart.yesterdayURL != nil) {
        MWPhotoBrowser *browser = [self browserForURL:self.chart.theDayAfterURL withName:@"the_day_after"];
        [browsers addObject:browser];
        [browser release];
    }
    
    [self setViewControllers:browsers];
    for (int i = 0; i < [browsers count]; i++) {
        MWPhotoBrowser *browser = ((MWPhotoBrowser *)[browsers objectAtIndex:i]);
        browser.tabBarItem.image = [UIImage imageNamed:@"calendar.png"];
        browser.tabBarItem.title = [NSString stringWithKey:[NSString stringWithFormat:@"title.%@", browser.day]];
    }
    self.selectedIndex = 1;
}

- (MWPhotoBrowser *)browserForURL:(NSString *)URLString withName:(NSString *)aName {
    NSMutableArray *_periods;
    NSArray *_photos;
    if (self.chart.hasPeriods) {
        _photos = [self chartsFor:URLString andTimestamps:self.country.periods];
        _periods = [NSMutableArray array];
        for (NSNumber *period in self.chart.country.periods) {
            [_periods addObject:[NSString stringWithFormat:@"%@", period]];
        }
    } else {
        _photos = [NSArray arrayWithObject:[MWPhoto photoWithURL:[NSURL URLWithString:URLString]]];
        _periods = [NSArray arrayWithObject:self.chart.name];
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:_photos andTimeStamps:_periods andTabTitle:[NSString stringWithKey:[NSString stringWithFormat:@"title.%@", aName]]];
    browser.day = aName;
    [browser setInitialPageIndex:7];
    browser.delegate = self;
    return browser;
}

- (void)updateTitle:(NSString *)aTitle andTabTitle:(NSString *)aTabTitle onBrowser:(MWPhotoBrowser *)browser {
    self.title = aTitle;
    browser.tabBarItem.title = [NSString stringWithKey:[NSString stringWithFormat:@"title.%@", browser.day]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)viewDidDisappear:(BOOL)animated {
    [photos release], photos = nil;
    self.chart = nil;
    self.country = nil;
    self.viewControllers = nil;
}

- (void)dealloc {
    [photos release], photos = nil;
    self.chart = nil;
    self.country = nil;
    [super dealloc];
}

@end
