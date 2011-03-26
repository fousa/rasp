//
//  ChartViewController.h
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "MWPhotoBrowser.h"

#import "Chart.h"
#import "Country.h"

@interface ChartViewController : UITabBarController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, MWPhotoBrowserDelegate>
@property (nonatomic, retain) Chart *chart;
@property (nonatomic, retain) Country *country;

- (void)configureView;
@end
