//
//  Country.h
//  rasp
//
//  Created by Jelle Vandebeeck on 29/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Country : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *charts;
@property (nonatomic, retain) NSArray *periods;
@property (nonatomic, assign) BOOL onlyHours;

@end
