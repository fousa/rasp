//
//  ChartGroup.m
//  rasp
//
//  Created by Jelle Vandebeeck on 29/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "ChartGroup.h"


@implementation ChartGroup

@synthesize name, charts;

- (void)dealloc {
    self.name = nil;
    self.charts = nil;
    
    [super dealloc];
}


@end
