//
//  CountryViewController.h
//  rasp
//
//  Created by Jelle Vandebeeck on 25/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "Country.h"

@class MenuViewController;
@class DetailViewController;

@interface CountryViewController : UITableViewController
@property (nonatomic, retain) Country *country;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@end

