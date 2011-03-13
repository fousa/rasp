//
//  NSString+Localization.m
//  NoGov
//
//  Created by Jelle Vandebeeck on 03/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "NSString+Localization.h"

@implementation NSString (Localization)

#pragma mark -
#pragma mark Utility

- (BOOL)empty {
	return ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0);
}

#pragma mark -
#pragma mark Translations

+ (NSString *)stringWithKey:(NSString *)key {
	NSString *translationKey = [NSString stringWithFormat:@"%@.%@", current_language, key];
	return NSLocalizedString(translationKey, @"Retrieve the string");
}

@end
