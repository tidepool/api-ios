  //
  //  NSString+InflectionSupport.h
  //
  //
  //  Created by Ryan Daigle on 7/31/08.
  //  Copyright 2008 yFactorial, LLC. All rights reserved.
  //
#import <Foundation/Foundation.h>

@interface NSString (InflectionSupport)

- (NSString *)deCamelizeWith:(NSString *)delimiter;

/**
 * Return the dashed form af this camelCase string:
 *
 *   [@"camelCase" dasherize] //> @"camel-case"
 */
- (NSString *)dasherize;

/**
 * Return the underscored form af this camelCase string:
 *
 *   [@"camelCase" underscore] //> @"camel_case"
 */
- (NSString *)underscore;

/**
 * Return the camelCase form af this dashed/underscored string:
 *
 *   [@"camel-case_string" camelize] //> @"camelCaseString"
 */
- (NSString*)camelize;
- (NSString*)camelizeCached;

/**
 * Return a copy of the string suitable for displaying in a title. Each word is downcased, with the first letter upcased.
 */
- (NSString *)titleize;

- (NSString *)decapitalize;

/**
 * Return a copy of the string with the first letter capitalized.
 */
- (NSString *)toClassName;

- (NSString *)singularize;

- (NSString *)pluralize;

@end