//
//  RaspController.h
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

@interface RaspController : NSObject
@property (nonatomic, readonly) NSDictionary *countries;
@property (nonatomic, retain) id delegate;

+ (RaspController *)instance;

- (void)loadChartsForCountry:(NSString *)country;
@end