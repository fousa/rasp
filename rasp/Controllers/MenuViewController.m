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

@implementation MenuViewController

@synthesize country=_country;
@synthesize detailViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = [NSString stringWithKey:[NSString stringWithFormat:@"title.country.%@", self.country.name]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.country.charts count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return ((ChartGroup *) [self.country.charts objectAtIndex:section]).name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [((ChartGroup *)[self.country.charts objectAtIndex:section]).charts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    static NSString *CellIdentifier = @"MenuCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Chart *chart = (Chart *)[((ChartGroup *)[self.country.charts objectAtIndex:indexPath.section]).charts objectAtIndex:indexPath.row];
    cell.textLabel.text = chart.name;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.numberOfLines = 2;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
    Chart *chart = (Chart *)[((ChartGroup *)[self.country.charts objectAtIndex:indexPath.section]).charts objectAtIndex:indexPath.row];
    
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
    [super dealloc];
}

@end
