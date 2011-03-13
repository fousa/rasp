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
#import "MWPhotoBrowser.h"

@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize toolbar=_toolbar;

@synthesize element=_element;

@synthesize detailDescriptionLabel=_detailDescriptionLabel;

@synthesize popoverController=_myPopoverController;

- (void)awakeFromNib {
    EmptyViewController *empty = [[EmptyViewController alloc] initWithNibName:@"EmptyViewController" bundle:[NSBundle mainBundle]];
    empty.title = @"Select a chart";
    UINavigationController *emptyNavigation = [[UINavigationController alloc] initWithRootViewController:empty];
    [empty release];
    
    [self setViewControllers:[NSArray arrayWithObjects:emptyNavigation, nil]];
    emptyNavigation.tabBarItem.image = [UIImage imageNamed:@"empty.png"];  
    emptyNavigation.tabBarItem.title = @"Empty";
    [emptyNavigation release];
}

#pragma mark - Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setElement:(NSDictionary *)anElement
{
    if (_element != anElement) {
        [_element release];
        _element = [anElement retain];
        
        // Update the view.
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

- (void)configureView
{
    NSDictionary *yesterdayDict = [self chartsFor:@"yesterday"];
    MWPhotoBrowser *yesterday = [[MWPhotoBrowser alloc] initWithPhotos:[yesterdayDict objectForKey:@"charts"] andTimeStamps:[yesterdayDict objectForKey:@"timeStamps"] andTabTitle:@"Yesterday"];
	[yesterday setInitialPageIndex:7];
    UINavigationController *yesterdayNavigation = [[UINavigationController alloc] initWithRootViewController:yesterday];
    [yesterday release];
    
    NSDictionary *todayDict = [self chartsFor:@"today"];
    MWPhotoBrowser *today = [[MWPhotoBrowser alloc] initWithPhotos:[todayDict objectForKey:@"charts"] andTimeStamps:[todayDict objectForKey:@"timeStamps"] andTabTitle:@"Today"];
	[today setInitialPageIndex:7];
    UINavigationController *todayNavigation = [[UINavigationController alloc] initWithRootViewController:today];
    [today release];
    
    NSDictionary *tomorrowDict = [self chartsFor:@"tomorrow"];
    MWPhotoBrowser *tomorrow = [[MWPhotoBrowser alloc] initWithPhotos:[tomorrowDict objectForKey:@"charts"] andTimeStamps:[tomorrowDict objectForKey:@"timeStamps"] andTabTitle:@"Tomorrow"];
	[tomorrow setInitialPageIndex:7];
    UINavigationController *tomorrowNavigation = [[UINavigationController alloc] initWithRootViewController:tomorrow];
    [tomorrow release];
    
    NSDictionary *inTwoDaysDict = [self chartsFor:@"in_two_days"];
    MWPhotoBrowser *inTwoDays = [[MWPhotoBrowser alloc] initWithPhotos:[inTwoDaysDict objectForKey:@"charts"] andTimeStamps:[inTwoDaysDict objectForKey:@"timeStamps"] andTabTitle:@"In 2 Days"];
	[inTwoDays setInitialPageIndex:7];
    UINavigationController *inTwoDaysNavigation = [[UINavigationController alloc] initWithRootViewController:inTwoDays];
    [inTwoDays release];
    
    [self setViewControllers:[NSArray arrayWithObjects:yesterdayNavigation, todayNavigation, tomorrowNavigation, inTwoDaysNavigation, nil]];
    yesterdayNavigation.tabBarItem.image = [UIImage imageNamed:@"yesterday.png"];
    yesterdayNavigation.tabBarItem.title = @"Yesterday";
    todayNavigation.tabBarItem.image = [UIImage imageNamed:@"today.png"];
    todayNavigation.tabBarItem.title = @"Today";
    tomorrowNavigation.tabBarItem.image = [UIImage imageNamed:@"tomorrow.png"];
    tomorrowNavigation.tabBarItem.title = @"Tomorrow";
    inTwoDaysNavigation.tabBarItem.image = [UIImage imageNamed:@"in-two-days.png"];
    inTwoDaysNavigation.tabBarItem.title = @"In 2 Days";
    
    [yesterdayNavigation release];
    [todayNavigation release];
    [tomorrowNavigation release];
    [inTwoDaysNavigation release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Split view support

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController: (UIPopoverController *)pc
{
    barButtonItem.title = @"Charts";
    if (self.viewControllers.count > 0) {
        ((UINavigationController *)[self.viewControllers objectAtIndex:0]).topViewController.navigationItem.leftBarButtonItem = barButtonItem;
    }
    self.popoverController = pc;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    if (self.viewControllers.count > 0) {
        ((UINavigationController *)[self.viewControllers objectAtIndex:0]).topViewController.navigationItem.leftBarButtonItem = nil;
    }
    self.popoverController = nil;
}

- (void)viewDidUnload
{
	[super viewDidUnload];

	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.popoverController = nil;
}

- (void)dealloc
{
    [_myPopoverController release];
    [_toolbar release];
    [_element release];
    [_detailDescriptionLabel release];
    [super dealloc];
}

@end
