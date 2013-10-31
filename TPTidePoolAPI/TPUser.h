//
//  TPUser.h
//  
//
//  Created by Kerem Karatal on 8/12/13.
//
//

#import <Foundation/Foundation.h>

@interface TPUser : NSObject

@property(nonatomic, retain) NSString *userId;
@property(nonatomic, retain) NSString *email;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *city;
@property(nonatomic, retain) NSString *state;
@property(nonatomic, retain) NSString *country;
@property(nonatomic, retain) NSString *image;
@property(nonatomic, retain) NSString *gender;

+(void) findById:(NSString *)user_id 
         success:(void (^)(TPUser *user))success
         failure:(void (^)(NSError *error))failure;

+(void) findByTokenSuccess:(void (^)(TPUser *user))success
                   failure:(void (^)(NSError *error))failure;

-(id) initWithUserHash:(NSDictionary *) userHash;

@end
