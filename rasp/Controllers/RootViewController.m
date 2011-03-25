//
//  RootViewController.m
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "RootViewController.h"

#import "DetailViewController.h"
#import "RaspController.h"

@interface RootViewController () {
    NSArray *_charts;
}
@end

@implementation RootViewController
		
@synthesize detailViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
    
//    _charts = [[RaspController instance].charts retain];
}

		
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = [NSString stringWithKey:@"title.charts"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
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
    
    self.detailViewController.element = element;
}

- (void)dealloc {
    [_charts release], _charts = nil;
    [detailViewController release], detailViewController = nil;
    
    [super dealloc];
}

@end
