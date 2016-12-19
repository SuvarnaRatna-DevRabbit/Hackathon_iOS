//
//  APIWrapper.h
//  Kuku
//
//  Created by Sandeep on 13/04/16.
//  Copyright © 2016 com.sandeep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "Reachability.h"
#import "AppDelegate.h"

@interface APIWrapper : AFHTTPSessionManager
{
    Reachability *internetReachability;
    UIActivityIndicatorView *actIndicator;
    UIView *activityBgView;
    UIAlertView *noNetAlert,*netConnectedAlert;
}

+ (APIWrapper *)sharedHttpClient;
+(APIWrapper*)shareHolder;
- (id)init;
-(void)netUpdatedWithStatus:(NSNotification*)notification;
-(void)startActivityIndicator;
-(void)stopActivityIndicator;
-(void)netConnected;
-(void)showNetDisConnectedPopUp; 
-(BOOL)isNetConnected;

//user validation
- (void)userLogin:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

//installation
-(void)appSettingsToRecipients:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

//verification process
-(void)recipientVerification:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

//messages list
-(void)recipientMessagesFromCommunityManager:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;
//message DetailsScreen
-(void)messageDetailScreen:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

//events list
-(void)recipientEvents:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

// serviceCallingForAll
-(void)serviceCalling:(NSDictionary *)parameters urlExtention:(NSString *)urlExtention  success:(void(^)(id responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

-(void)recipientdetailScreen:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

@end
