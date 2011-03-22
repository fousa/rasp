//
//  DetailViewController.m
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "DetailViewController.h"

#import "RootViewController.h"
#import "EmptyViewController.h"

#import "MWPhoto.h"

#define BAR_VIEW_TAG 101
#define DETAIL_VIEW_TAG 102

#define TINT_COLOR [UIColor colorWithRed:.209882 green:.459732 blue:.75887 alpha:1]

@interface DetailViewController () {
    NSArray *photos;
    UIBarButtonItem *_barButtonItem;
    BOOL initialLoad;
}
@property (nonatomic, retain) UIPopoverController *popoverController;
@end

@interface DetailViewController (View)
- (void)configureView;
@end

@implementation DetailViewController

@synthesize element=_element;
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

- (void)setElement:(NSDictionary *)anElement {
    if (_element != anElement) {
        [_element release];
        _element = [anElement retain];
        
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
    yesterday.delegate = self;
    [yesterday setInitialPageIndex:7];
    UINavigationController *yesterdayNavigation = [[UINavigationController alloc] initWithRootViewController:yesterday];
    yesterdayNavigation.navigationBar.tintColor = TINT_COLOR;
    [yesterday release];
    
    NSDictionary *todayDict = [self chartsFor:@"today"];
    MWPhotoBrowser *today = [[MWPhotoBrowser alloc] initWithPhotos:[todayDict objectForKey:@"charts"] andTimeStamps:[todayDict objectForKey:@"timeStamps"] andTabTitle:[NSString stringWithKey:@"title.today"]];
	[today setInitialPageIndex:7];
    today.delegate = self;
    UINavigationController *todayNavigation = [[UINavigationController alloc] initWithRootViewController:today];
    todayNavigation.navigationBar.tintColor = TINT_COLOR;
    [today release];
    
    NSDictionary *tomorrowDict = [self chartsFor:@"tomorrow"];
    MWPhotoBrowser *tomorrow = [[MWPhotoBrowser alloc] initWithPhotos:[tomorrowDict objectForKey:@"charts"] andTimeStamps:[tomorrowDict objectForKey:@"timeStamps"] andTabTitle:[NSString stringWithKey:@"title.tomorrow"]];
	[tomorrow setInitialPageIndex:7];
    tomorrow.delegate = self;
    UINavigationController *tomorrowNavigation = [[UINavigationController alloc] initWithRootViewController:tomorrow];
    tomorrowNavigation.navigationBar.tintColor = TINT_COLOR;
    [tomorrow release];
    
    NSDictionary *inTwoDaysDict = [self chartsFor:@"in_two_days"];
    MWPhotoBrowser *inTwoDays = [[MWPhotoBrowser alloc] initWithPhotos:[inTwoDaysDict objectForKey:@"charts"] andTimeStamps:[inTwoDaysDict objectForKey:@"timeStamps"] andTabTitle:[NSString stringWithKey:@"title.intwodays"]];
	[inTwoDays setInitialPageIndex:7];
    inTwoDays.delegate = self;
    UINavigationController *inTwoDaysNavigation = [[UINavigationController alloc] initWithRootViewController:inTwoDays];
    inTwoDaysNavigation.navigationBar.tintColor = TINT_COLOR;
    [inTwoDays release];
    
    [self setViewControllers:[NSArray arrayWithObjects:yesterdayNavigation, todayNavigation, tomorrowNavigation, inTwoDaysNavigation, nil] animated:YES];
    self.selectedIndex = 1;
    yesterdayNavigation.tabBarItem.image = [UIImage imageNamed:@"calendar.png"];
    yesterdayNavigation.tabBarItem.title = [NSString stringWithKey:@"title.yesterday"];
    todayNavigation.tabBarItem.image = [UIImage imageNamed:@"calendar.png"];
    todayNavigation.tabBarItem.title = [NSString stringWithKey:@"title.today"];
    tomorrowNavigation.tabBarItem.image = [UIImage imageNamed:@"calendar.png"];
    tomorrowNavigation.tabBarItem.title = [NSString stringWithKey:@"title.tomorrow"];
    inTwoDaysNavigation.tabBarItem.image = [UIImage imageNamed:@"calendar.png"];
    inTwoDaysNavigation.tabBarItem.title = [NSString stringWithKey:@"title.intwodays"];
    
    [yesterdayNavigation release];
    [todayNavigation release];
    [tomorrowNavigation release];
    [inTwoDaysNavigation release];
    
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
    [photos release], photos = nil;
    [_myPopoverController release];
    [_element release];
    [super dealloc];
}

@end
