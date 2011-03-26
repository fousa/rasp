//
//  DetailViewController.h
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "MWPhotoBrowser.h"

#import "Chart.h"

@interface DetailViewController : UITabBarController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, MWPhotoBrowserDelegate>
@property (nonatomic, retain) Chart *chart;
@end
