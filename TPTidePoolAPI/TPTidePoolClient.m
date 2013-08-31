//
//  TPTidePoolClient.m
//  
//
//  Created by Kerem Karatal on 8/12/13.
//
//

#import "TPTidePoolClient.h"
#import "AFJSONRequestOperation.h"
#import <SSKeychain/SSKeychain.h>
#import "TPUser.h"

@interface TPTidePoolClient()
- (void) loadSettings;
- (void) configureClient;
@end

NSString *const kTPTidePoolErrorDomain = @"com.tidepool.TPTidePoolAPI";

@implementation TPTidePoolClient

+ (id)sharedInstance {
  static dispatch_once_t once;
  static id sharedInstance;
  dispatch_once(&once, ^{
    NSDictionary *settings = [TPTidePoolClient loadSettings];
    NSURL *baseURL = nil;
    if (settings) {
      baseURL = [NSURL URLWithString:[settings valueForKey:@"apiServerURL"]];
    }
    sharedInstance = [[self alloc] initWithBaseURL:baseURL andSettings:settings];
  });
  return sharedInstance;
  
}

+ (NSDictionary *) loadSettings {
  NSString *filePath = [[NSBundle bundleForClass: [TPTidePoolClient class]] pathForResource:@"Settings" ofType:@"plist"];
  NSData *pListData = [NSData dataWithContentsOfFile:filePath];
  NSPropertyListFormat format;
  NSString *error;
  NSDictionary *settings = (NSDictionary *) [NSPropertyListSerialization propertyListFromData:pListData
                                                                             mutabilityOption:NSPropertyListImmutable
                                                                                       format:&format
                                                                             errorDescription:&error];

  return settings;
}


- (id) initWithBaseURL:baseURL andSettings:settings {
    // Initialize from plist file which contains the API Secret.
    // Do not checkin the API secrets to Github
  
  self = [super initWithBaseURL:baseURL];
	if (self != nil) {
    _accessToken = nil;
    if (settings) {
      _clientId = [settings valueForKey:@"clientID"];
      _clientSecret = [settings valueForKey:@"clientSecret"];
      _apiServerURL = [settings valueForKey:@"apiServerURL"];
      _keychainServiceName = [settings valueForKey:@"keychainServiceName"];
      _accessToken = [settings valueForKey:@"testUserToken"];
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
}

- (void) configureClient {
  [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
	[self setDefaultHeader:@"Content-type" value:@"application/json"];
  if (_accessToken) {
    [self setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", _accessToken]];
  }
  [self setParameterEncoding:AFJSONParameterEncoding];
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
  
  [self postPath:@"oauth/authorize"
      parameters:fullParams
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
           NSLog(@"Success");
           TPUser *user = nil;
           _accessToken = [responseObject valueForKey:@"access_token"];
           if (_accessToken) {
             [SSKeychain setPassword:_accessToken forService:_keychainServiceName account:_keychainServiceName];
             [self setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", _accessToken]];
             user = [self retrieveUserFromResponse:responseObject];
             success(user);
           }
           else {
             NSString *desc = NSLocalizedString(@"Unable to retrieve access token", @"");
             NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
             
             NSError *error = [NSError errorWithDomain:kTPTidePoolErrorDomain
                                                  code:-101
                                              userInfo:userInfo];
             failure(error);
           }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
