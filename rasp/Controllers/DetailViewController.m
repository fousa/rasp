//
//  DetailViewController.m
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "DetailViewController.h"

#import "EmptyViewController.h"

#import "MWPhoto.h"

#define BAR_VIEW_TAG 101
#define DETAIL_VIEW_TAG 102

#define TINT_COLOR [UIColor colorWithRed:.209882 green:.459732 blue:.75887 alpha:1]

@interface DetailViewController () {
    UIBarButtonItem *_barButtonItem;
    BOOL initialLoad;
}
@property (nonatomic, retain) UIPopoverController *popoverController;
@end

@interface DetailViewController (View)
- (void)configureView;
- (NSArray *)chartsFor:(NSString *)path andTimestamps:(NSArray *)timestamps;
- (UINavigationController *)browserForURL:(NSString *)URLString withName:(NSString *)aName;
@end

@implementation DetailViewController

@synthesize chart=_chart;
@synthesize popoverController=_myPopoverController;

#pragma mark - Initialization

- (void)awakeFromNib {
    EmptyViewController *empty = [[EmptyViewController alloc] initWithNibName:@"EmptyViewController" bundle:[NSBundle mainBundle]];
    empty.title = [NSString stringWithKey:@"text.select"];
    UINavigationController *emptyNavigation = [[UINavigationController alloc] initWithRootViewController:empty];
    emptyNavigation.navigationBar.tintColor = TINT_COLOR;
    [empty release];
    
    [self setViewControllers:[NSArray arrayWithObjects:emptyNavigation, nil]];
    self.selectedViewController = emptyNavigation;
    emptyNavigation.tabBarItem.title = [NSString stringWithKey:@"title.empty"];
    [emptyNavigation release];
    
    for (UIView *v in self.view.subviews) {
        if ([v class] == [UITabBar class]) {
            v.hidden = YES;
            v.tag = BAR_VIEW_TAG;
        } else {
            CGRect rect = v.frame;
            rect.size.height += 49;
            v.frame = rect;
            v.tag = DETAIL_VIEW_TAG;
        }
    }
    initialLoad = YES;
}

#pragma mark - Detail element

- (void)setChart:(Chart *)aChart {
    if (_chart != aChart) {
        [_chart release];
        _chart = [aChart retain];
        
        if (initialLoad) {
            [self.view viewWithTag:BAR_VIEW_TAG].hidden = NO;
            UIView *v = [self.view viewWithTag:DETAIL_VIEW_TAG];
            CGRect rect = v.frame;
            rect.size.height -= 49;
            v.frame = rect;
            initialLoad = NO;
        }
        
        [self configureView];
    }

    if (self.popoverController != nil) {
        [self.popoverController dismissPopoverAnimated:YES];
    }        
}

- (NSArray *)chartsFor:(NSString *)path andTimestamps:(NSArray *)timestamps {
    NSMutableArray *charts = [NSMutableArray array];
    for (NSString *timestamp in timestamps) {
        [charts addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:path, [timestamp intValue]]]]];
    }
    
    return [NSArray arrayWithArray:charts];
}

- (UINavigationController *)browserForURL:(NSString *)URLString withName:(NSString *)aName {
    NSMutableArray *_periods;
    NSArray *_photos;
    if (self.chart.hasPeriods) {
        _photos = [self chartsFor:URLString andTimestamps:self.chart.country.periods];
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
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:browser];
    navigationController.navigationBar.tintColor = TINT_COLOR;
    [browser release];
    
    return navigationController;
}

- (void)configureView {
    NSMutableArray *browsers = [NSMutableArray array];
    if (self.chart.yesterdayURL != nil) {
        UINavigationController *browser = [self browserForURL:self.chart.yesterdayURL withName:@"yesterday"];
        [browsers addObject:browser];
        [browser release];
    }
    if (self.chart.yesterdayURL != nil) {
        UINavigationController *browser = [self browserForURL:self.chart.todayURL withName:@"today"];
        [browsers addObject:browser];
        [browser release];
    }
    if (self.chart.yesterdayURL != nil) {
        UINavigationController *browser = [self browserForURL:self.chart.tomorrowURL withName:@"tomorrow"];
        [browsers addObject:browser];
        [browser release];
    }
    if (self.chart.yesterdayURL != nil) {
        UINavigationController *browser = [self browserForURL:self.chart.theDayAfterURL withName:@"the_day_after"];
        [browsers addObject:browser];
        [browser release];
    }
    
    [self setViewControllers:browsers];
    for (int i = 0; i < [browsers count]; i++) {
        UINavigationController *browser = ((UINavigationController *)[browsers objectAtIndex:i]);
        browser.tabBarItem.image = [UIImage imageNamed:@"calendar.png"];
        browser.tabBarItem.title = [NSString stringWithKey:[NSString stringWithFormat:@"title.%@", ((MWPhotoBrowser *)browser.topViewController).day]];
    }
    self.selectedIndex = 1;
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        ((UINavigationController *)self.selectedViewController).topViewController.navigationItem.leftBarButtonItem = _barButtonItem;
    }
}

- (void)updateTitle:(NSString *)aTitle andTabTitle:(NSString *)aTabTitle onBrowser:(MWPhotoBrowser *)browser {
    browser.title = aTitle;
    browser.navigationController.tabBarItem.title = aTabTitle;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Split view support

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController: (UIPopoverController *)pc {
    barButtonItem.title = [NSString stringWithKey:@"title.charts"];
    _barButtonItem = barButtonItem;
    if (self.viewControllers.count > 0) {
        ((UINavigationController *)self.selectedViewController).topViewController.navigationItem.leftBarButtonItem = _barButtonItem;
    }
    self.popoverController = pc;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    _barButtonItem = barButtonItem;
    if (self.viewControllers.count > 0) {
        ((UINavigationController *)self.selectedViewController).topViewController.navigationItem.leftBarButtonItem = nil;
    }
    self.popoverController = nil;
}

- (void)viewDidUnload {
	[super viewDidUnload];

	self.popoverController = nil;
}

- (void)dealloc {
    [_myPopoverController release];
    [_chart release];
    [super dealloc];
}

@end
