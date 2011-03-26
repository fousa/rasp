//
//  RaspController.h
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "Country.h"

@interface RaspController : NSObject
@property (nonatomic, readonly) NSArray *regions;
@property (nonatomic, retain) id delegate;

+ (RaspController *)instance;

- (void)loadChartsForCountry:(Country *)country;
- (NSArray *)convertCharts:(NSDictionary *)dictionary forCountry:(Country *)country;
@end