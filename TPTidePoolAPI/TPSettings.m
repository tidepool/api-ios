//
//  TPSettings.m
//  
//
//  Created by Kerem Karatal on 10/30/13.
//
//

#import "TPSettings.h"

@implementation TPSettings

+ (NSDictionary *) loadSettings {
  NSString *filePath = [[NSBundle bundleForClass: [TPSettings class]] pathForResource:@"Settings" ofType:@"plist"];
  NSData *pListData = [NSData dataWithContentsOfFile:filePath];
  NSPropertyListFormat format;
  NSString *error;
  NSDictionary *settings = (NSDictionary *) [NSPropertyListSerialization propertyListFromData:pListData
                                                                             mutabilityOption:NSPropertyListImmutable
                                                                                       format:&format
                                                                             errorDescription:&error];
  
  return settings;
}

@end
