//
//  TPUser.m
//  
//
//  Created by Kerem Karatal on 8/12/13.
//
//

#import "TPUser.h"

NSString *const kTPUserUrlRoot = @"api/v1/users/";

@implementation TPUser

-(id) initWithUserHash:(NSDictionary *) userHash {
  self = [super initWithUrlRoot:kTPUserUrlRoot];
  if (self != nil) {
    _userId = [userHash valueForKey:@"id"];
    _email = [userHash valueForKey:@"email"];
    _name = [userHash valueForKey:@"name"];
    _city = [userHash valueForKey:@"city"];
    _state = [userHash valueForKey:@"state"];
    _country = [userHash valueForKey:@"country"];
    _image = [userHash valueForKey:@"image"];
    _gender = [userHash valueForKey:@"gender"];
  }
  return self;
}

@end
