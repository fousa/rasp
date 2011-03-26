//
//  CountryViewController.m
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "CountryViewController.h"

#import "RaspController.h"
#import "MenuViewController.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"

#import "Region.h"

#define CELL_LOADING_TAG 999;

@interface CountryViewController () {
    NSArray *_regions;
    BOOL _loading;
}
@end

@implementation CountryViewController

@synthesize country=_country;
@synthesize detailViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
    
    _regions = [[RaspController instance].regions retain];
    _loading = NO;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = [NSString stringWithKey:@"title.countries"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_regions count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithKey:[NSString stringWithFormat:@"title.part.%@", ((Region *)[_regions objectAtIndex:section]).name]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [((Region *)[_regions objectAtIndex:section]).countries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    static NSString *CellIdentifier = @"CountryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Country *country = (Country *)[((Region *)[_regions objectAtIndex:indexPath.section]).countries objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithKey:[NSString stringWithFormat:@"title.country.%@", country.name]];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.numberOfLines = 2;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!_loading) {
        _loading = YES;
        self.country = (Country *)[((Region *)[_regions objectAtIndex:indexPath.section]).countries objectAtIndex:indexPath.row];

        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activity startAnimating];
        cell.tag = CELL_LOADING_TAG;
        cell.accessoryView = activity;
        [RaspController instance].delegate = self;
        [[RaspController instance] loadChartsForCountry:self.country];
    }
}

#pragma mark - Chart loading

- (void)requestSuccess:(ASIHTTPRequest *)aRequest {
    NSDictionary *charts = [[aRequest responseString] JSONValue];
    UITableViewCell *cell = ((UITableViewCell *)[self.tableView viewWithTag:999]);
	if ([[charts allKeys] count] == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"An error occured trying to connect to the server." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else {
        MenuViewController *menuController = [[MenuViewController alloc] init];
        self.country.charts = [[RaspController instance] convertCharts:charts forCountry:self.country];
        menuController.country = self.country;
        menuController.detailViewController = self.detailViewController;
        [menuController.tableView reloadData];
        [self.navigationController pushViewController:menuController animated:YES];
        [menuController release];
    }
    cell.accessoryView = nil;
    cell.tag = 0;
    _loading = NO;
}

- (void)dealloc {
    [_regions release], _regions = nil;
    self.country = nil;
    [super dealloc];
}

@end
