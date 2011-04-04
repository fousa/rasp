//
//  RootViewiPhoneController.h
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "Country.h"

#import "DetailViewController.h"

@interface MenuViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>
@property (nonatomic, retain) Country *country;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@end
