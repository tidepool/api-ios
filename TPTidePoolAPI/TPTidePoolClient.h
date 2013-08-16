//
//  TPTidePoolClient.h
//  
//
//  Created by Kerem Karatal on 8/12/13.
//
//

#import "AFHTTPClient.h"
#import "TPUser.h"

@interface TPTidePoolClient : AFHTTPClient

+ (id)sharedInstance;

@property(nonatomic, readonly) NSString *clientId;
@property(nonatomic, readonly) NSString *clientSecret;
@property(nonatomic, readonly) NSString *accessToken;
@property(nonatomic, readonly) NSURL *apiServerURL;
@property(nonatomic, readonly) NSURL *authorizeEndpointURL;

- (BOOL) isLoggedIn;
- (TPUser *) loginWithEmail:(NSString *) email andPassword:(NSString *) password;
- (TPUser *) loginWithAuthHash:(NSDictionary *) authHash;

@end
