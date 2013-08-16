//
//  TPTidePoolClient.m
//  
//
//  Created by Kerem Karatal on 8/12/13.
//
//

#import "TPTidePoolClient.h"
#import "AFJSONRequestOperation.h"

@interface TPTidePoolClient()
- (void) loadSettings;
- (void) configureClient;
@end


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
      _clientId = [settings valueForKey:@"clientId"];
      _clientSecret = [settings valueForKey:@"clientSecret"];
      
//      NSURL *baseURL = [NSURL URLWithString:[settings valueForKey:@"apiServerURL"]];
//      _apiServerURL = [NSURL URLWithString:[settings valueForKey:@"apiEndpoint"] relativeToURL:baseURL];
//      _authorizeEndpointURL = [NSURL URLWithString:[settings valueForKey:@"authorizeEndpoint"] relativeToURL:baseURL];
    }

    [self configureClient];
  }
  return self;
}

- (BOOL) isLoggedIn {
  return _accessToken != nil;
}



- (void) configureClient {
  [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
	[self setDefaultHeader:@"Content-type" value:@"application/json"];
  [self setParameterEncoding:AFJSONParameterEncoding];
}

- (void) loginWithEmail:(NSString *) email
               password:(NSString *) password
                success:(void (^)(TPUser *user))success
                failure:(void (^)(NSError *error))failure
{
  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"password", @"grant_type",
                                @"password", @"response_type",
                                email, @"email",
                                password, @"password",
                                _clientId, @"client_id",
                                _clientSecret, @"client_secret", nil];
  
}

- (void) registerWithEmail:(NSString *) email
                  password:(NSString *) password
      passwordConfirmation:(NSString *) passwordConfirmation
                   success:(void (^)(TPUser *user))success
                   failure:(void (^)(NSError *error))failure
{
  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"password", @"grant_type",
                          @"password", @"response_type",
                          email, @"email",
                          password, @"password",
                          _clientId, @"client_id",
                          _clientSecret, @"client_secret", nil];
  
}


- (void) loginWithAuthHash:(NSDictionary *) authHash
                   success:(void (^)(TPUser *user))success
                   failure:(void (^)(NSError *error))failure {
  

}


- (void) loginOrRegister:(NSDictionary *) params
                 success:(void (^)(TPUser *user))success
                 failure:(void (^)(NSError *error))failure {
  

  [self postPath:@"oauth/authorize"
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
           NSLog(@"success");
           TPUser *user = [self retrieveUserFromResponse:responseObject];
           success(user);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"failure");
           NSLog([error description]);
           failure(error);
         }];
  
}

- (TPUser *) retrieveUserFromResponse:(id) responseObject {
  
  return nil;
}

@end
