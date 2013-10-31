//
//  TPGameTests.m
//  TPTidePoolAPITests
//
//  Created by Kerem Karatal on 8/26/13.
//
//

#import "TPGameTests.h"
#import "TPTestUtils.h"
#import "TPGame.h"
#import <SSKeychain/SSKeychain.h>

@implementation TPGameTests

- (void)setUp {
  [super setUp];
  
  TPTidePoolClient *client = [TPTidePoolClient sharedInstance];
  [SSKeychain setPassword:client.testAccessToken forService:client.keychainServiceName account:client.keychainServiceName];
  [client checkAccessToken];
  [Expecta setAsynchronousTestTimeout:5];
}

- (void)tearDown {
    // Tear-down code here.
  
  [super tearDown];
}

- (void)testStartingBaselineGame {
  __block NSString *name = nil;
  [TPGame startGame:@"baseline"
            success:^(TPGame *game) {
              name = game.name;
            }
            failure:^(NSError *error) {
              NSLog(@"%@", [error description]);
            }
   
   ];
  expect(name).will.equal(@"baseline");
}

- (void) testSendingUserEvents {
  [TPGame startGame:@"snoozer"
            success:^(TPGame *game){
              
            }
            failure:^(NSError *error) {
              
            }];
}



@end
