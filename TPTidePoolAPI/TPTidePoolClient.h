//
//  TPTidePoolClient.h
//  
//
//  Created by Kerem Karatal on 8/12/13.
//
//

#import "AFHTTPClient.h"

@class TPUser;

@interface TPTidePoolClient : AFHTTPClient

+ (id)sharedInstance;

@property(nonatomic, readonly) NSString *clientId;
@property(nonatomic, readonly) NSString *clientSecret;
@property(nonatomic, readonly) NSString *accessToken;
@property(nonatomic, readonly) NSString *apiServerURL;
@property(nonatomic, readonly) NSString *keychainServiceName;

- (BOOL) isLoggedIn;
- (void) loginWithEmail:(NSString *) email
               password:(NSString *) password
                success:(void (^)(TPUser *user))success
                failure:(void (^)(NSError *error))failure;

- (void) registerWithEmail:(NSString *) email
                  password:(NSString *) password
      passwordConfirmation:(NSString *) passwordConfirmation
                   success:(void (^)(TPUser *user))success
                   failure:(void (^)(NSError *error))failure;

- (void) loginOrRegisterWithAuthHash:(NSDictionary *) authHash
                             success:(void (^)(TPUser *user))success
                             failure:(void (^)(NSError *error))failure;

@end
