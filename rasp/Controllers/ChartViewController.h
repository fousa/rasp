//
//  ChartViewController.h
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "MWPhotoBrowser.h"

@interface ChartViewController : UITabBarController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, MWPhotoBrowserDelegate>
@property (nonatomic, retain) NSDictionary *element;

- (NSDictionary *)chartsFor:(NSString *)period;
@end
