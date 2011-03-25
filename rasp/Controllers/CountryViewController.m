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

#define CELL_LOADING_TAG 999;

@interface CountryViewController () {
    NSDictionary *_countries;
    BOOL _loading;
}
@end

@implementation CountryViewController

@synthesize country=_country;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
    
    _countries = [[RaspController instance].countries retain];
    _loading = NO;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = [NSString stringWithKey:@"title.countries"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_countries allKeys] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"title.world.%@", [[_countries allKeys] objectAtIndex:section]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_countries objectForKey:[[_countries allKeys] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    static NSString *CellIdentifier = @"CountryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary *element = [((NSArray *)[_countries objectForKey:[[_countries allKeys] objectAtIndex:indexPath.section]]) objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithKey:[NSString stringWithFormat:@"title.country.%@", [element objectForKey:@"name"]]];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.numberOfLines = 2;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!_loading) {
        _loading = YES;
        self.country = [((NSArray *)[_countries objectForKey:[[_countries allKeys] objectAtIndex:indexPath.section]]) objectAtIndex:indexPath.row];
    
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activity startAnimating];
        cell.tag = CELL_LOADING_TAG;
        cell.accessoryView = activity;
        [RaspController instance].delegate = self;
        [[RaspController instance] loadChartsForCountry:[self.country objectForKey:@"name"]];
    }
}

#pragma mark - Chart loading

- (void)requestSuccess:(ASIHTTPRequest *)aRequest {
    NSArray *charts = [[[aRequest responseString] JSONValue] retain];
    UITableViewCell *cell = ((UITableViewCell *)[self.tableView viewWithTag:999]);
	if ([charts count] == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"An error occured trying to connect to the server." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else {
        MenuViewController *menuController = [[MenuViewController alloc] init];
        menuController.charts = charts;
        menuController.country = self.country;
        [menuController.tableView reloadData];
        [self.navigationController pushViewController:menuController animated:YES];
    }
    cell.accessoryView = nil;
    cell.tag = 0;
    _loading = NO;
}

- (void)dealloc {
    [_countries release], _countries = nil;
    [super dealloc];
}

@end
