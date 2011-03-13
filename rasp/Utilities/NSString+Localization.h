//
//  NSString+Localization.h
//  NoGov
//
//  Created by Jelle Vandebeeck on 03/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

@interface NSString (Localization)

- (BOOL)empty;

+ (NSString *)stringWithKey:(NSString *)key;

@end
