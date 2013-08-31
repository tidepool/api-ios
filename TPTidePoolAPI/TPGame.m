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
  
  TPGame *game = [[TPGame alloc] initWithUrlRoot:kTPGameUrlRoot name:name];
  NSDictionary *params = @{@"def_id": name};
  [game createWithParams:params
                 success:^(id object) {
                   NSDictionary *data = [object valueForKey:@"data"];
                   game.stages = [data valueForKey:@"stages"];
                   game.status = [data valueForKey:@"status"];
                   NSString *dateTakenStr = [data valueForKey:@"date_taken"];
                   
                   NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                   [dateFormatter setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss'.'sssZZZZZ"];
                   
                   game.dateTaken = [dateFormatter dateFromString:dateTakenStr];
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

-(void) setStages:(NSDictionary *)stages {
  _stages = stages;
}
@end
