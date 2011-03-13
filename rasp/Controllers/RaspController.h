//
//  RaspController.h
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RaspController : NSObject
@property (nonatomic, readonly) NSArray *menu;

+ (RaspController *)instance;
@end