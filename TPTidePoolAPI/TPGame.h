//
//  TPGame.h
//  
//
//  Created by Kerem Karatal on 8/18/13.
//
//

#import <Foundation/Foundation.h>

@interface TPGame : NSObject

@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSArray *stages;
@property(nonatomic, retain) NSString *status;
@property(nonatomic, retain) NSDate *dateTaken;

+(void) startGame:(NSString *) name
          success:(void (^)(TPGame *game))success
          failure:(void (^)(NSError *error))failure;

-(void) addUserEvent:(NSDictionary *) userEvent stage:(NSUInteger) stageNo;
-(void) sendEventsSuccess:(void (^)(TPGame *game))success
                  failure:(void (^)(NSError *error))failure;

-(void) calculateResultsSuccess:(void (^)(NSArray *results))success
                        failure:(void (^)(NSError *error))failure;

@end
