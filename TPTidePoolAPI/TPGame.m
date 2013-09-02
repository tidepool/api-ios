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
-(void) setStages:(NSArray *) stages;

@property(nonatomic, retain) NSMutableArray *events;

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
                   [game setupEvents:game.stages.count];
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

-(void) setupEvents:(NSUInteger) count {
  self.events = [NSMutableArray arrayWithCapacity:count];
  for (NSUInteger i = 0; i < count) {
    NSMutableDictionary *userEvent = @{@"event_type", game
    [self.events insertObject:<#(id)#> atIndex:i];
  }
}

-(void) setStages:(NSArray *)stages {
  _stages = stages;
}

- (void) addUserEvent:(NSDictionary *)userEvent stage:(NSUInteger) stageNo {
  if (stageNo >= self.events.count){
    return;
  }
  [self.events insertObject:userEvent atIndex:stageNo];
}

-(void) sendEventsSuccess:(void (^)(TPGame *game))success
                  failure:(void (^)(NSError *error))failure {
  NSString *path = [NSString stringWithFormat:@"%@/event_log", self.urlRoot];
  [_apiClient putPath:path
           parameters:self.events
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Success");
                success(responseObject);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Failure");
                NSLog([error description]);
                failure(error);
              }];

}

-(void) calculateResultsSuccess:(void (^)(NSArray *results))success
                        failure:(void (^)(NSError *error))failure {
  
}
@end
