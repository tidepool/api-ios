//
//  TPGame.m
//  
//
//  Created by Kerem Karatal on 8/18/13.
//
//

#import "TPGame.h"
#import "TPUtil.h"
#import "TPTidePoolClient.h"

NSString *const kTPGameUrlRoot = @"api/v1/users/-/games";

@interface TPGame() {
  TPTidePoolClient *_apiClient;
}
-(id) initWithUrlRoot:(NSString *) urlRoot name:(NSString *)name;
-(void) setStages:(NSArray *) stages;
-(void) startGame:(NSString *) name
          success:(void (^)(TPGame *game))success
          failure:(void (^)(NSError *error))failure;

@property(nonatomic, retain) NSMutableArray *events;
@end

@implementation TPGame

+(void) startGame:(NSString *) name
          success:(void (^)(TPGame *game))success
          failure:(void (^)(NSError *error))failure {
  
  TPGame *game = [[TPGame alloc] initWithName:name];
  [game startGame:name success:success failure:failure];
}

-(id) initWithName:(NSString *)name {
  self = [super init];
  if (self != nil) {
    _name = name;
    _apiClient = [TPTidePoolClient sharedInstance];
  }
  return self; 
}

- (void) startGame:(NSString *) name
           success:(void (^)(TPGame *game))success
           failure:(void (^)(NSError *error))failure {
  
  NSDictionary *params = @{@"def_id": name};
  [_apiClient POST:kTPGameUrlRoot
        parameters:params
           success:^(NSURLSessionDataTask *task, id responseObject) {
             NSDictionary *data = [responseObject valueForKey:@"data"];
             [self initializeGameData:data];
             success(self);
           }
           failure:^(NSURLSessionDataTask *task, NSError *error) {
             failure(error);
           }
   ];
}

-(void) initializeGameData:(NSDictionary *)data {
  self.stages = [data valueForKey:@"stages"];
  [self initializeEvents:self.stages];
  self.status = [data valueForKey:@"status"];
  NSString *dateTakenStr = [data valueForKey:@"date_taken"];
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss'.'sssZZZZZ"];
  
  self.dateTaken = [dateFormatter dateFromString:dateTakenStr];
}


-(void) initializeEvents:(NSArray *) stages {
  self.events = [NSMutableArray arrayWithCapacity:[stages count]];
  NSInteger *timeZoneOffset = [[NSTimeZone localTimeZone] secondsFromGMT];
  
  NSUInteger *stageNo = 0;
  for (NSDictionary *stage in stages) {
    NSString *eventType = [[stage valueForKey:@"client_view_name"] lowercaseString];
    if (eventType == nil) {
      // For older games...
      eventType = [[stage valueForKey:@"view_name"] lowercaseString];
    }
      
    NSMutableDictionary *eventInfo = [NSMutableDictionary dictionary];
    [eventInfo setObject:eventType forKey:@"event_type"];
    [eventInfo setObject:[NSNumber numberWithInt:timeZoneOffset] forKey:@"timezone_offset"];
    [eventInfo setObject:[NSNumber numberWithInt:stageNo] forKey:@"stage"];
    [eventInfo setObject:[NSMutableArray array] forKey:@"events"];
    stageNo++;
  }
}

-(void) setStages:(NSArray *)stages {
  _stages = stages;
}

- (void) addUserEvent:(NSDictionary *)userEvent stage:(NSUInteger) stageNo {
  if (stageNo >= self.events.count){
    return;
  }
  NSDictionary *stageEvents = [self.events objectAtIndex:stageNo];
  NSMutableArray *userEvents = [stageEvents objectForKey:@"events"];
  
  [userEvents addObject:userEvent];
}

-(void) sendEventsSuccess:(void (^)(TPGame *game))success
                  failure:(void (^)(NSError *error))failure {
  NSString *path = [NSString stringWithFormat:@"%@/event_log", kTPGameUrlRoot];
  [_apiClient POST:path
           parameters:self.events
              success:^(NSURLSessionDataTask *task, id responseObject)  {
                NSLog(@"Success");
                success(self);
              }
              failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Failure");
                NSLog([error description]);
                failure(error);
              }];
}

-(void) calculateResultsSuccess:(void (^)(NSArray *results))success
                        failure:(void (^)(NSError *error))failure {
  
}
@end
