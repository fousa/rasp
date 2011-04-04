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
- (MWPhotoBrowser *)browserForURL:(NSArray *)URLs withName:(NSString *)aName;
@end

@implementation ChartViewController

@synthesize chart=_chart;
@synthesize country=_country;

#pragma mark - Detail element

- (void)configureView {
    NSMutableArray *browsers = [NSMutableArray array];
    int selectedBrowser = 0;
    if (self.chart.yesterdayURLs != nil) {
        MWPhotoBrowser *browser = [self browserForURL:self.chart.yesterdayURLs withName:@"yesterday"];
        [browsers addObject:browser];
        selectedBrowser++;
        browser.tabBarItem.image = [UIImage imageNamed:@"calendar-yesterday.png"];
        browser.tabBarItem.title = [NSString stringWithKey:@"title.yesterday"];
    }
    if (self.chart.todayURLs != nil) {
        MWPhotoBrowser *browser = [self browserForURL:self.chart.todayURLs withName:@"today"];
        [browsers addObject:browser];
        browser.tabBarItem.image = [UIImage imageNamed:@"calendar-today.png"];
        browser.tabBarItem.title = [NSString stringWithKey:@"title.today"];
    }
    if (self.chart.tomorrowURLs != nil) {
        MWPhotoBrowser *browser = [self browserForURL:self.chart.tomorrowURLs withName:@"tomorrow"];
        [browsers addObject:browser];
        browser.tabBarItem.image = [UIImage imageNamed:@"calendar-tomorrow.png"];
        browser.tabBarItem.title = [NSString stringWithKey:@"title.tomorrow"];
    }
    if (self.chart.theDayAfterURLs != nil) {
        MWPhotoBrowser *browser = [self browserForURL:self.chart.theDayAfterURLs withName:@"the_day_after"];
        [browsers addObject:browser];
        browser.tabBarItem.image = [UIImage imageNamed:@"calendar-the_day_after.png"];
        browser.tabBarItem.title = [NSString stringWithKey:@"title.the_day_after"];
    }
    
    [self setViewControllers:browsers];
    self.selectedIndex = selectedBrowser;
}

- (NSArray *)chartsFor:(NSArray *)URLs {
    NSMutableArray *charts = [NSMutableArray array];
    for (NSString *URLString in URLs) {
        [charts addObject:[MWPhoto photoWithURL:[NSURL URLWithString:URLString]]];
    }
    
    return [NSArray arrayWithArray:charts];
}

- (MWPhotoBrowser *)browserForURL:(NSArray *)URLs withName:(NSString *)aName {
    NSMutableArray *_periods;
    NSArray *_photos = [self chartsFor:URLs];
    int selectedPeriod = 0;
    BOOL stopCounting = NO;
    if (self.chart.hasPeriods) {
        _periods = [NSMutableArray array];
        NSArray *chartPeriods = [self.chart.country periodsForDay:aName];
        NSLog(@"name: %@", aName);
        for (NSNumber *period in chartPeriods) {
            NSString *periodString = [NSString stringWithFormat:@"%04d", [period intValue]];
            if (!stopCounting && [periodString compare:@"1200"] != NSOrderedSame) {
                selectedPeriod++;
            } else {
                stopCounting = YES;
            }
            [_periods addObject:periodString];
        }
    } else {
        _periods = [NSArray arrayWithObject:self.chart.name];
    }
    NSLog(@"periods: %d", [_periods count]);
    MWPhotoBrowser *browser = [[[MWPhotoBrowser alloc] initWithPhotos:_photos andTimeStamps:_periods andTabTitle:[NSString stringWithKey:[NSString stringWithFormat:@"title.%@", aName]]] autorelease];
    browser.day = aName;
    [browser setInitialPageIndex:selectedPeriod];
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
