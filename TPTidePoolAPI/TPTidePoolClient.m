//
//  TPTidePoolClient.m
//  
//
//  Created by Kerem Karatal on 8/12/13.
//
//

#import "TPTidePoolClient.h"
#import <SSKeychain/SSKeychain.h>
#import "TPUser.h"
#import "TPSettings.h"

@interface TPTidePoolClient()
- (void) configureClient;
@end

NSString *const kTPTidePoolErrorDomain = @"com.tidepool.TPTidePoolAPI";

@implementation TPTidePoolClient

+ (id)sharedInstance {
  static dispatch_once_t once;
  static id sharedInstance;
  dispatch_once(&once, ^{
    NSDictionary *settings = [TPSettings loadSettings];
    NSURL *baseURL = nil;
    if (settings) {
      baseURL = [NSURL URLWithString:[settings valueForKey:@"apiServerURL"]];
    }
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sharedInstance = [[self alloc] initWithBaseURL:baseURL sessionConfiguration:configuration settings:settings];
  });
  return sharedInstance;
  
}

- (id) initWithBaseURL:(NSURL *) baseURL
  sessionConfiguration:(NSURLSessionConfiguration *) configuration
              settings:(NSDictionary *) settings {
    // Initialize from plist file which contains the API Secret.
    // Do not checkin the API secrets to Github
  
  self = [super initWithBaseURL:baseURL sessionConfiguration: configuration];
	if (self != nil) {
    _accessToken = nil;
    if (settings) {
      _clientId = [settings valueForKey:@"clientID"];
      _clientSecret = [settings valueForKey:@"clientSecret"];
      _apiServerURL = [settings valueForKey:@"apiServerURL"];
      _keychainServiceName = [settings valueForKey:@"keychainServiceName"];
      _accessToken = nil;
//      _accessToken = [settings valueForKey:@"testUserToken"];
      _testAccessToken = [settings valueForKey:@"testUserToken"];
    }
    [self checkAccessToken];
    [self configureClient];
  }
  return self;
}

- (BOOL) isLoggedIn {
  return _accessToken != nil;
}

- (void) checkAccessToken {
  _accessToken = [SSKeychain passwordForService:_keychainServiceName account:_keychainServiceName];
  if (_accessToken) {
    [self setAuthorizationHTTPField:_accessToken];
  }
}

- (void) configureClient {
  AFHTTPRequestSerializer *requestSerializer = self.requestSerializer;
  
  [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
  [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
  if (_accessToken) {
    [self setAuthorizationHTTPField:_accessToken];
  }
}

- (void) setAuthorizationHTTPField:(NSString *)accessToken {
  [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", accessToken] forHTTPHeaderField:@"Authorization"];
}

- (void) loginWithEmail:(NSString *) email
               password:(NSString *) password
                success:(void (^)(TPUser *user))success
                failure:(void (^)(NSError *error))failure {

  NSDictionary *params = @{@"email": email,
                           @"password": password
                           };

  [self loginOrRegister:params success:success failure:failure];
  
}

- (void) registerWithEmail:(NSString *) email
                  password:(NSString *) password
      passwordConfirmation:(NSString *) passwordConfirmation
                   success:(void (^)(TPUser *user))success
                   failure:(void (^)(NSError *error))failure {

  NSDictionary *params = @{@"email": email,
                           @"password": password,
                           @"password_confirmation": passwordConfirmation
                           };
  [self loginOrRegister:params success:success failure:failure];
  
}


- (void) loginOrRegisterWithAuthHash:(NSDictionary *) authHash
                             success:(void (^)(TPUser *user))success
                             failure:(void (^)(NSError *error))failure {
  
  [self loginOrRegister:authHash success:success failure:failure];
}


- (void) loginOrRegister:(NSDictionary *) params
                 success:(void (^)(TPUser *user))success
                 failure:(void (^)(NSError *error))failure {
  
  NSDictionary *baseParams = @{@"grant_type": @"password",
                                   @"response_type": @"password",
                                   @"client_id": self.clientId,
                                   @"client_secret": self.clientSecret
                                   };
  NSMutableDictionary *fullParams = [NSMutableDictionary dictionaryWithDictionary:baseParams];
  [fullParams addEntriesFromDictionary:params];
  
  [self POST:@"oauth/authorize" parameters:fullParams
     success:^(NSURLSessionDataTask *task, id responseObject) {
       NSLog(@"Success");
       TPUser *user = nil;
       _accessToken = [responseObject valueForKey:@"access_token"];
       if (_accessToken) {
         [SSKeychain setPassword:_accessToken forService:_keychainServiceName account:_keychainServiceName];
         [self.requestSerializer setAuthorizationHeaderFieldWithToken:[NSString stringWithFormat:@"Bearer %@", _accessToken]];
         user = [self retrieveUserFromResponse:responseObject];
         success(user);
       }
       else {
         NSString *desc = NSLocalizedString(@"Unable to retrieve access token", @"");
         NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
         
         NSError *error = [NSError errorWithDomain:kTPTidePoolErrorDomain code:-101 userInfo:userInfo];
         failure(error);
       }
     }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failure");
        NSLog([error description]);
        failure(error);
      }];
}

- (TPUser *) retrieveUserFromResponse:(id) responseObject {
  NSDictionary *userHash = [responseObject valueForKey:@"user"];
  TPUser *user = [[TPUser alloc] initWithUserHash:userHash];
  
  return user;
}

@end
