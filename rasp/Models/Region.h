//
//  Region.h
//  rasp
//
//  Created by Jelle Vandebeeck on 29/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Region : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *countries;

- (id)initWithCountries:(NSArray *)someCountries;

@end
