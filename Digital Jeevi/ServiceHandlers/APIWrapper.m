//
//  APIWrapper.m
//  Kuku
//
//  Created by Sandeep on 13/04/16.
//  Copyright © 2016 com.sandeep. All rights reserved.
//

#import "APIWrapper.h"
#import "AFHTTPSessionManager.h"
#import "Constants.h"

static NSString *const kBaseUrlStr = API_URL;
static APIWrapper *sharedObject = nil;
@implementation APIWrapper

+ (APIWrapper *)sharedHttpClient;
{
    static APIWrapper *sharedPortfolioHttpClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sharedPortfolioHttpClient = [[APIWrapper alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrlStr] sessionConfiguration:configuration];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
  
    });
    
    return sharedPortfolioHttpClient;
}
+(APIWrapper*)shareHolder
{
    if(sharedObject == nil)
    {
        sharedObject = [[APIWrapper alloc] init];
    }
    return sharedObject;
}

- (id)init
{
    if( self = [super init] )
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netUpdatedWithStatus:) name:kReachabilityChangedNotification object:nil];
        
        internetReachability = [Reachability reachabilityForInternetConnection];
        [internetReachability startNotifier];
        
        activityBgView = [[UIView alloc] initWithFrame:[[(AppDelegate*)[[UIApplication sharedApplication] delegate] window] frame]];
        [activityBgView setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,70,70)];
       // UIImage *pattern = [UIImage imageNamed:@"button_middle_normal.png"];
        bg.backgroundColor = BUTTON_BAGROUND_COLOR;
       // [bg setImage:pattern];
        [activityBgView addSubview:bg];
        
        bg.layer.cornerRadius = 10;
        bg.layer.masksToBounds = YES;
        
       // bg.layer.borderColor = [UIColor lightGrayColor].CGColor;
       // bg.layer.borderWidth = 1.5f;
        
        
        actIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:1];
        [actIndicator setFrame:[[(AppDelegate*)[[UIApplication sharedApplication] delegate] window] frame]];
        activityBgView.center =[[(AppDelegate*)[[UIApplication sharedApplication] delegate] window] center];
        actIndicator.center = activityBgView.center;
        bg.center = activityBgView.center;
        
        [activityBgView addSubview:actIndicator];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] window] addSubview:activityBgView];
        [actIndicator setHidden:YES];
    }
    
    return( self );
}

-(BOOL)isNetConnected
{
    NetworkStatus internetStatus = [internetReachability currentReachabilityStatus];
    if(internetStatus == NotReachable)
    {
        return NO;
    }
    return YES;
}

-(void)showNetDisConnectedPopUp
{
    [self stopActivityIndicator];
    [noNetAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    noNetAlert = [[UIAlertView alloc] initWithTitle:Alert message:@"You are not connected to the Internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [noNetAlert setTag:100];
    [noNetAlert show];
    
}

-(void)netConnected
{
    [netConnectedAlert dismissWithClickedButtonIndex:0 animated:YES];
    netConnectedAlert = [[UIAlertView alloc] initWithTitle:Alert message:@"You are now connected to the Internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [netConnectedAlert setTag:101];
    [netConnectedAlert show];
    
}

-(void)netUpdatedWithStatus:(NSNotification*)notification
{
    NetworkStatus internetStatus = [internetReachability currentReachabilityStatus];
    
    switch (internetStatus)
    {
        case NotReachable:
        {
            [self showNetDisConnectedPopUp];
            break;
        }
        case ReachableViaWiFi:
        {
            [self netConnected];
            break;
        }
        case ReachableViaWWAN:
        {
            [self netConnected];
            break;
        }
    }
}

-(void)startActivityIndicator
{
    [activityBgView setHidden:NO];
    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] window] bringSubviewToFront:activityBgView];
    [actIndicator startAnimating];
}

-(void)stopActivityIndicator
{
    [actIndicator stopAnimating];
    [activityBgView setHidden:YES];
}

// - - - - - - - - - - - - - - - - - - Namaste User - - - - - - - - - - - - - - - - - -

//User Login
- (void)userLogin:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    [self POST:@"recipient_validate.php" parameters:parameters progress:nil
       success:^(NSURLSessionDataTask *task, id responseObject) {

        success(responseObject);
      
    }
       failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         
         failure(task, error);
     }];
    
}



-(void)recipientMessagesFromCommunityManager:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure{
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [self POST:@"recipient_messages_from_community_manager.php" parameters:parameters progress:nil
       success:^(NSURLSessionDataTask *task, id responseObject) {
           
           success(responseObject);
           
       }
       failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"error %@",[error localizedDescription]);
         
         failure(task, error);
     }];
    
    
}


-(void)messageDetailScreen:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [self POST:@"post_message_details.php" parameters:parameters progress:nil
       success:^(NSURLSessionDataTask *task, id responseObject) {
           
           
           success(responseObject);
           
       }
       failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"error %@",[error localizedDescription]);
         
         failure(task, error);
     }];

}

-(void)appSettingsToRecipients:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [self POST:@"cmt_settings_to_recipients.php" parameters:parameters progress:nil
       success:^(NSURLSessionDataTask *task, id responseObject) {
                success(responseObject);
       }
       failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"error %@",[error localizedDescription]);
         
         failure(task, error);
     }];

        
}

-(void)recipientVerification:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure{
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [self POST:@"recipient_verification.php" parameters:parameters progress:nil
       success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
           
       }
       failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"error %@",[error localizedDescription]);
         
         failure(task, error);
     }];

}

-(void)recipientEvents:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
  
    [self POST:@"recipient_past_upcoming_events.php" parameters:parameters progress:nil
       success:^(NSURLSessionDataTask *task, id responseObject) {
           success(responseObject);
           
       }
       failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"error %@",[error localizedDescription]);
         
         failure(task, error);
     }];

    
}





// serviceForAllMethods By Passing URL As String

-(void)serviceCalling:(NSDictionary *)parameters urlExtention:(NSString *)urlExtention  success:(void(^)(id responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [self POST:urlExtention parameters:parameters progress:nil
       success:^(NSURLSessionDataTask *task, id responseObject) {
    success(responseObject);
           
       }
       failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"error %@",[error localizedDescription]);
         
         failure(task, error);
     }];
    
    
}

-(void)recipientdetailScreen:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure{
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [self POST:@"recipient_events.php" parameters:parameters progress:nil
       success:^(NSURLSessionDataTask *task, id responseObject) {
           success(responseObject);
           
       }
       failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"error %@",[error localizedDescription]);
         
         failure(task, error);
     }];

}

@end
