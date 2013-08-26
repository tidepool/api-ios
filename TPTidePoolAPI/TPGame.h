//
//  TPGame.h
//  
//
//  Created by Kerem Karatal on 8/18/13.
//
//

#import <Foundation/Foundation.h>
#import "TPBase.h"

@interface TPGame : TPBase

@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSDictionary *stages;

+(void) startGame:(NSString *) name
          success:(void (^)(TPGame *game))success
          failure:(void (^)(NSError *error))failure;

-(void) addUserEvent:(NSDictionary *) userEvent;
-(void) sendEventsSuccess:(void (^)(TPGame *game))success
                  failure:(void (^)(NSError *error))failure;

-(void) calculateResultsSuccess:(void (^)(NSArray *results))success
                        failure:(void (^)(NSError *error))failure;

@end
