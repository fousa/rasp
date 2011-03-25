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

@implementation MenuViewController

@synthesize country=_country;
@synthesize charts=_charts;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = [NSString stringWithKey:[NSString stringWithFormat:@"title.country.%@", [self.country objectForKey:@"name"]]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_charts count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[_charts objectAtIndex:section] objectAtIndex:0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [((NSArray *) [((NSArray *) [_charts objectAtIndex:section]) objectAtIndex:1]) count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    static NSString *CellIdentifier = @"MenuCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary *element = [[[_charts objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row];
    cell.textLabel.text = [element objectForKey:@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.numberOfLines = 2;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	NSDictionary *element = [[[_charts objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row];
    
    ChartViewController *chartController = [[ChartViewController alloc] initWithNibName:@"ChartViewController" bundle:[NSBundle mainBundle]];
    chartController.element = element;
    chartController.country = self.country;
    [chartController configureView];
    [self.navigationController pushViewController:chartController animated:YES];
}

- (void)dealloc {
    [_charts release], _charts = nil;
    [super dealloc];
}

@end
