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
@property (nonatomic, retain) NSString *yesterdayURL;
@property (nonatomic, retain) NSString *todayURL;
@property (nonatomic, retain) NSString *tomorrowURL;
@property (nonatomic, retain) NSString *theDayAfterURL;

@property (nonatomic, retain) Country *country;

@end
