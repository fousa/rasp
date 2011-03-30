//
//  Country.m
//  rasp
//
//  Created by Jelle Vandebeeck on 29/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "Country.h"


@implementation Country

@synthesize name, charts, periods, onlyHours;

- (void)dealloc {
    self.name = nil;
    self.charts = nil;
    self.periods = nil;
    
    [super dealloc];
}

@end
