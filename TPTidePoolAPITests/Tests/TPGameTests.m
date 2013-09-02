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

@implementation TPGameTests

- (void)setUp {
  [super setUp];
  
    // Set-up code here.
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
              
            }
   
   ];
  expect(name).will.equal(@"baseline");
}

- (void) testSendingUserEvents {
  [TPGame startGame:@"snoozers"
            success:^(TPGame *game){
              [game addUserEvent:<#(NSDictionary *)#> stage:<#(NSUInteger)#>];
              
            }
            failure:^(NSError *error) {
              
            }];
}



@end
