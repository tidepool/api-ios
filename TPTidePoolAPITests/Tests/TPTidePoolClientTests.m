//
//  TPTidePoolClientTests.m
//  TPTidePoolAPITests
//
//  Created by Kerem Karatal on 8/12/13.
//
//

#import "TPTidePoolClientTests.h"

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
  
  expect([[session apiServerURL] absoluteString]).to.equal(@"http://api-server.dev/api/v1");
}

@end
