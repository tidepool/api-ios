//
//  TPGame.m
//  
//
//  Created by Kerem Karatal on 8/18/13.
//
//

#import "TPGame.h"

NSString *const kTPGameUrlRoot = @"api/v1/users/-/games";

@interface TPGame()
-(id) initWithUrlRoot:(NSString *) urlRoot name:(NSString *)name;
-(void) setStages:(NSDictionary *) stages;
@end

@implementation TPGame

+(void) startGame:(NSString *) name
          success:(void (^)(TPGame *game))success
          failure:(void (^)(NSError *error))failure {
  
  TPGame *game = [[TPGame alloc] initWithUrlRoot:kTPGameUrlRoot];
  NSDictionary *params = @{@"def_id": name};
  [game createWithParams:params
                 success:^(id object) {
                   
                   success(game);
                 }
                 failure:failure];
}

-(id) initWithUrlRoot:(NSString *) urlRoot name:(NSString *)name {
  self = [super initWithUrlRoot:urlRoot];
  if (self != nil) {
    _name = name;
  }
  return self; 
}


@end
