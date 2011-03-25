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
- (NSDictionary *)chartsFor:(NSString *)period;
@end

@implementation ChartViewController

@synthesize element=_element;
@synthesize country=_country;

#pragma mark - Detail element

- (NSDictionary *)chartsFor:(NSString *)period {
    NSString *name           = (NSString *)[_element objectForKey:@"name"];
	BOOL multipleCharts = [((NSNumber *)[_element objectForKey:@"animated"]) boolValue];
    
	NSMutableArray *charts = [[NSMutableArray alloc] init];
	NSMutableArray *timeStamps = [[NSMutableArray alloc] init];
	NSString *path = (NSString *)[_element objectForKey:period];
	if (multipleCharts) {
        for (NSString *period in ((NSArray *)[self.country objectForKey:@"periods"])) {
            [charts addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:path, [period intValue]]]]];
			[timeStamps addObject:[NSString stringWithFormat:@"%04d", [period intValue]]];
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
    NSArray *days = (NSArray *)[self.country objectForKey:@"days"];
    NSMutableArray *controllers = [NSMutableArray array];
    
    for (NSString *day in days) {
        NSDictionary *dict = [self chartsFor:day];
        MWPhotoBrowser *controller = [[MWPhotoBrowser alloc] initWithPhotos:[dict objectForKey:@"charts"] andTimeStamps:[dict objectForKey:@"timeStamps"] andTabTitle:[NSString stringWithKey:[NSString stringWithFormat:@"title.%@", day]]];
        controller.day = day;
        [controller setInitialPageIndex:7];
        controller.delegate = self;
        [controllers addObject:controller];
        [controller release];
    }
    
    [self setViewControllers:controllers];
    for (int i = 0; i < [controllers count]; i++) {
        MWPhotoBrowser *browser = ((MWPhotoBrowser *)[controllers objectAtIndex:i]);
        browser.tabBarItem.image = [UIImage imageNamed:@"calendar.png"];
        browser.tabBarItem.title = [NSString stringWithKey:[NSString stringWithFormat:@"title.%@", browser.day]];
    }
    self.selectedIndex = 1;
}

- (void)updateTitle:(NSString *)aTitle andTabTitle:(NSString *)aTabTitle onBrowser:(MWPhotoBrowser *)browser {
    self.title = aTitle;
    browser.tabBarItem.title = [NSString stringWithKey:[NSString stringWithFormat:@"title.%@", browser.day]];
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
