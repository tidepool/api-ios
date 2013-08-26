//
//  TPTidePoolClientTests.m
//  TPTidePoolAPITests
//
//  Created by Kerem Karatal on 8/12/13.
//
//

#import "TPTidePoolClientTests.h"
#import "TPTestUtils.h"
#import "TPUser.h"

@implementation TPTidePoolClientTests
- (void)setUp {
  [super setUp];
  
    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.
  
  [super tearDown];
}

- (void)testLoadingSessionFromSettingsFile {
  TPTidePoolClient *session = [TPTidePoolClient sharedInstance];
  
  expect([session apiServerURL]).to.equal(@"http://api-server.dev/");
}

- (void)testLoggingInUsingEmailAndPassword {
  [Expecta setAsynchronousTestTimeout:5];
  
  TPTidePoolClient *session = [TPTidePoolClient sharedInstance];
  
  __block NSString *email;
  __block NSString *errorDesc;
  [session loginWithEmail:@"user@example.com" password:@"tidepool" success:^(TPUser *user) {
      email = user.email;
    }
    failure:^(NSError *error) {
      errorDesc = [error description];
    }];
  
  expect(email).will.equal(@"user@example.com");

}

- (void) testRegisterUsingEmailAndPassword {
  [Expecta setAsynchronousTestTimeout:5];
  
  TPTidePoolClient *session = [TPTidePoolClient sharedInstance];
  
  NSString *guid = [TPTestUtils getUUID];
  NSString *inputEmail = [NSString stringWithFormat:@"test_user_%@@example.com", guid ];
  __block NSString *email;
  __block NSString *errorDesc;
  [session registerWithEmail:inputEmail password:@"tidepool" passwordConfirmation:@"tidepool"  success:^(TPUser *user) {
      email = user.email;
    }
    failure:^(NSError *error) {
      errorDesc = [error description];
    }];
  
  expect(email).will.equal(inputEmail);
}

@end
