//
//  TPBase.h
//  
//
//  Created by Kerem Karatal on 8/18/13.
//
//

#import <Foundation/Foundation.h>
#import "TPTidePoolClient.h"

@interface TPBase : NSObject {
  TPTidePoolClient *_apiClient;
}

@property(nonatomic, readonly) NSString *urlRoot;

- (id) initWithUrlRoot:(NSString *) url;

-(void) saveSuccess:(void (^)(id object))success
            failure:(void (^)(NSError *error))failure;
-(void) createWithParams:(NSDictionary *) params
                 success:(void (^)(id object))success
                 failure:(void (^)(NSError *error))failure;
-(void) deleteSuccess:(void (^)(id object))success
              failure:(void (^)(NSError *error))failure;

@end
