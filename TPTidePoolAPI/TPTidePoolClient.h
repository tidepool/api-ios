//
//  TPTidePoolClient.h
//  
//
//  Created by Kerem Karatal on 8/12/13.
//
//
#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


@class TPUser;

@interface TPTidePoolClient : AFHTTPSessionManager

+ (id)sharedInstance;

@property(nonatomic, readonly) NSString *clientId;
@property(nonatomic, readonly) NSString *clientSecret;
@property(nonatomic, readonly) NSString *accessToken;
@property(nonatomic, readonly) NSString *testAccessToken;
@property(nonatomic, readonly) NSString *apiServerURL;
@property(nonatomic, readonly) NSString *keychainServiceName;

- (id) initWithBaseURL:(NSURL *) baseURL
  sessionConfiguration:(NSURLSessionConfiguration *) configuration
              settings:(NSDictionary *) settings;

- (BOOL) isLoggedIn;
- (void) checkAccessToken;

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
