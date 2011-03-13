//
//  DetailViewController.h
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

@interface DetailViewController : UITabBarController <UIPopoverControllerDelegate, UISplitViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) NSDictionary *element;
@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;

- (NSDictionary *)chartsFor:(NSString *)period;
@end
