//
//  TPBase.m
//  
//
//  Created by Kerem Karatal on 8/18/13.
//
//

#import "TPBase.h"

@implementation TPBase

- (id) initWithUrlRoot:(NSString *) url {
  self = [super init];
  if (self != nil) {
    _urlRoot = url;
    _apiClient = [TPTidePoolClient sharedInstance];
  }
  return self;
}

-(void) readWithParams:(NSDictionary *)params
               success:(void (^)(id *object))success
               failure:(void (^)(NSError *error))failure {
  
  [_apiClient putPath:_urlRoot
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Success");
                success(self);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Failure");
                NSLog([error description]);
                failure(error);
              }];
}

-(void) saveSuccess:(void (^)(id *object))success
            failure:(void (^)(NSError *error))failure {
  
  params = [self propertiesToParams]
  [_apiClient putPath:_urlRoot
     parameters:params
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"Success");
          success(self);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Failure");
          NSLog([error description]);
          failure(error);
        }];

}

-(void) createSuccess:(void (^)(id *object))success
              failure:(void (^)(NSError *error))failure {

  
  params = [self propertiesToParams]
  [_apiClient postPath:_urlRoot
     parameters:params
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"Success");
          success(self);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Failure");
          NSLog([error description]);
          failure(error);
        }];
}

-(void) deleteSuccess:(void (^)(id *object))success
              failure:(void (^)(NSError *error))failure {
  

}

- (NSDictionary *) propertiesToParams {
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  
  unsigned int count, i;
  objc_property_t *properties = class_copyPropertyList([self class], &count);
  for (NSInteger i = 0; i < count; i++) {
    objc_property_t property = properties[i];
    NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)];
    id propertyValue = [self valueForKey:(NSString *)propertyName];
    if (propertyValue && propertyName != @"urlRoot") {
      [params setObject:propertyValue forKey:propertyName];
    }
  }
  free(properties);
  
  return params;
}

@end
