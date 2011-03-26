//
//  raspAppDelegate-iPad.h
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

@class CountryViewController;
@class DetailViewController;

@interface raspAppDelegate_iPad : raspAppDelegate
@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet CountryViewController *countryViewController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@end
