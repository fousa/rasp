//
//  RootViewiPhoneController.m
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "MenuViewController.h"

#import "RaspController.h"
#import "ChartViewController.h"

#import "ChartGroup.h"
#import "Chart.h"

@interface MenuViewController ()
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *searchController;
@property (nonatomic, retain) NSArray *charts;
@end

@implementation MenuViewController

@synthesize country=_country;
@synthesize detailViewController, searchBar, searchController, charts;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
    
    // Create a search bar - you can add this in the viewDidLoad
	self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)] autorelease];
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
	self.searchBar.delegate = self;
    self.searchBar.tintColor = TINT_COLOR;
    self.searchBar.showsSearchResultsButton = NO;
	self.tableView.tableHeaderView = self.searchBar;
    
    self.tableView.contentOffset = CGPointMake(0, self.searchBar.frame.size.height);
    
    self.charts = self.country.charts;
    
    CGSize contentSize = self.contentSizeForViewInPopover;
    contentSize.height = 480;
    self.contentSizeForViewInPopover = contentSize;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = [NSString stringWithKey:[NSString stringWithFormat:@"title.country.%@", self.country.name]];
}

#pragma mark - Searching

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.charts = [[RaspController instance] convertCharts:self.country.charts search:searchText];
    [self.tableView reloadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.charts = self.country.charts;
    [self.tableView reloadData];
    
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    self.tableView.contentOffset = CGPointMake(0, self.searchBar.frame.size.height);
    
    [UIView commitAnimations];
    
    self.searchBar.text = @"";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.charts count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return ((ChartGroup *) [self.charts objectAtIndex:section]).name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [((ChartGroup *)[self.charts objectAtIndex:section]).charts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    static NSString *CellIdentifier = @"MenuCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Chart *chart = (Chart *)[((ChartGroup *)[self.charts objectAtIndex:indexPath.section]).charts objectAtIndex:indexPath.row];
    cell.textLabel.text = chart.name;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.numberOfLines = 2;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
    Chart *chart = (Chart *)[((ChartGroup *)[self.charts objectAtIndex:indexPath.section]).charts objectAtIndex:indexPath.row];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.detailViewController.chart = chart;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        ChartViewController *chartController = [[ChartViewController alloc] initWithNibName:@"ChartViewController" bundle:[NSBundle mainBundle]];
        chartController.chart = chart;
        chartController.country = self.country;
        [chartController configureView];
        [self.navigationController pushViewController:chartController animated:YES];
        [chartController release];
    }
}

- (void)dealloc {
    self.country = nil;
    self.charts = nil;
    self.searchController = nil;
    self.searchBar = nil;
    [super dealloc];
}

@end
