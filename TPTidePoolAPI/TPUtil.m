//
//  TPUtil.m
//  
//
//  Created by Kerem Karatal on 10/31/13.
//
//

#import "TPUtil.h"
#import <objc/runtime.h>

@implementation TPUtil

+ (NSDictionary *) propertiesToParamsForClass: (Class) cls  {
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  
  unsigned int count, i;
  objc_property_t *properties = class_copyPropertyList(cls, &count);
  for (NSInteger i = 0; i < count; i++) {
    objc_property_t property = properties[i];
    NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)];
    id propertyValue = [self valueForKey:(NSString *)propertyName];
    if (propertyValue && propertyName != @"urlRoot") {
      [params setObject:propertyValue forKey:propertyName];
    }
  }
  free(properties);
  
  return params;
}

@end
