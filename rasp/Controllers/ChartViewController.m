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
- (void)configureView;
@end

@implementation ChartViewController

@synthesize element=_element;

#pragma mark - Detail element

- (void)setElement:(NSDictionary *)anElement {
    if (_element != anElement) {
        [_element release];
        _element = [anElement retain];
        
        [self configureView];
    }      
}

- (NSDictionary *)chartsFor:(NSString *)period {
    NSString *name           = (NSString *)[_element objectForKey:@"name"];
	BOOL multipleCharts = [((NSNumber *)[_element objectForKey:@"animated"]) boolValue];
    
	NSMutableArray *charts = [[NSMutableArray alloc] init];
	NSMutableArray *timeStamps = [[NSMutableArray alloc] init];
	NSString *path = (NSString *)[_element objectForKey:period];
	if (multipleCharts) {
		int timeStamp = 830;
		for (int i = 0; i < 22; i++) {
            [charts addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:path, timeStamp]]]];
			[timeStamps addObject:[NSString stringWithFormat:@"%04d", timeStamp]];
			timeStamp += timeStamp % 100 == 0 ? 30 : 70;
		}
	} else {
        [charts addObject:[MWPhoto photoWithURL:[NSURL URLWithString:path]]];
		[timeStamps addObject:name];
	}
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:timeStamps, charts, nil] forKeys:[NSArray arrayWithObjects:@"timeStamps", @"charts", nil]];
    [charts release];
    [timeStamps release];
    
    return dict;
}

- (void)configureView {
    NSDictionary *yesterdayDict = [self chartsFor:@"yesterday"];
    MWPhotoBrowser *yesterday = [[MWPhotoBrowser alloc] initWithPhotos:[yesterdayDict objectForKey:@"charts"] andTimeStamps:[yesterdayDict objectForKey:@"timeStamps"] andTabTitle:[NSString stringWithKey:@"title.yesterday"]];
	[yesterday setInitialPageIndex:7];
    yesterday.delegate = self;
    
    NSDictionary *todayDict = [self chartsFor:@"today"];
    MWPhotoBrowser *today = [[MWPhotoBrowser alloc] initWithPhotos:[todayDict objectForKey:@"charts"] andTimeStamps:[todayDict objectForKey:@"timeStamps"] andTabTitle:[NSString stringWithKey:@"title.today"]];
	[today setInitialPageIndex:7];
    today.delegate = self;
    
    NSDictionary *tomorrowDict = [self chartsFor:@"tomorrow"];
    MWPhotoBrowser *tomorrow = [[MWPhotoBrowser alloc] initWithPhotos:[tomorrowDict objectForKey:@"charts"] andTimeStamps:[tomorrowDict objectForKey:@"timeStamps"] andTabTitle:[NSString stringWithKey:@"title.tomorrow"]];
	[tomorrow setInitialPageIndex:7];
    tomorrow.delegate = self;
    
    NSDictionary *inTwoDaysDict = [self chartsFor:@"in_two_days"];
    MWPhotoBrowser *inTwoDays = [[MWPhotoBrowser alloc] initWithPhotos:[inTwoDaysDict objectForKey:@"charts"] andTimeStamps:[inTwoDaysDict objectForKey:@"timeStamps"] andTabTitle:[NSString stringWithKey:@"title.intwodays"]];
	[inTwoDays setInitialPageIndex:7];
    inTwoDays.delegate = self;
    
    [self setViewControllers:[NSArray arrayWithObjects:yesterday, today, tomorrow, inTwoDays, nil]];
    self.selectedIndex = 1;
    
    yesterday.tabBarItem.image = [UIImage imageNamed:@"calendar.png"];
    yesterday.tabBarItem.title = [NSString stringWithKey:@"title.yesterday"];
    today.tabBarItem.image = [UIImage imageNamed:@"calendar.png"];
    today.tabBarItem.title = [NSString stringWithKey:@"title.today"];
    tomorrow.tabBarItem.image = [UIImage imageNamed:@"calendar.png"];
    tomorrow.tabBarItem.title = [NSString stringWithKey:@"title.tomorrow"];
    inTwoDays.tabBarItem.image = [UIImage imageNamed:@"calendar.png"];
    inTwoDays.tabBarItem.title = [NSString stringWithKey:@"title.intwodays"];
    
    [yesterday release];
    [today release];
    [tomorrow release];
    [inTwoDays release];
}

- (void)updateTitle:(NSString *)aTitle andTabTitle:(NSString *)aTabTitle onBrowser:(MWPhotoBrowser *)browser {
    self.title = aTitle;
    browser.tabBarItem.title = aTabTitle;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)dealloc {
    [photos release], photos = nil;
    [_element release];
    [super dealloc];
}

@end
