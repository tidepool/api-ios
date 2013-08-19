//
//  TPTestUtils.m
//  TPTidePoolAPITests
//
//  Created by Kerem Karatal on 8/18/13.
//
//

#import "TPTestUtils.h"

@implementation TPTestUtils

+ (NSString *) getUUID
{
  CFUUIDRef theUUID = CFUUIDCreate(NULL);
  CFStringRef string = CFUUIDCreateString(NULL, theUUID);
  CFRelease(theUUID);
  return (__bridge NSString *)string;
}

@end
