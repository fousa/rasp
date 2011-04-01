//
//  Chart.h
//  rasp
//
//  Created by Jelle Vandebeeck on 29/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Country.h"

@interface Chart : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) BOOL hasPeriods;
@property (nonatomic, retain) NSMutableArray *yesterdayURLs;
@property (nonatomic, retain) NSMutableArray *todayURLs;
@property (nonatomic, retain) NSMutableArray *tomorrowURLs;
@property (nonatomic, retain) NSMutableArray *theDayAfterURLs;

@property (nonatomic, retain) Country *country;

@end
