//
//  Constants.h
//  NotifiiCMT
//
//  Created by Logictree on 06/05/16.
//  Copyright © 2016 Logictree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

//#define API_URL @"http://staging.notifii.com/api/cmt/"

 #define API_URL @"http://183.82.106.91:8010/api/cmt/"

// get sceen size and phonetype
#define SOME_VALUE (7)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

// community manager AccountID
//#define ACCOUNT_ID @"30001"
#define ACCOUNT_ID @"52477"

// display alertview message
#define Alert  @"Notice!"

// Theam Color settings
#define SEGMETEDCONTROL_SELECTIONINDICATER_COLOR ([UIColor colorWithRed:225.0/255.0 green:195.0/255.0 blue:45.0/255.0 alpha:1.0])
#define BUTTON_BAGROUND_COLOR ([UIColor colorWithRed:225.0/255.0 green:195.0/255.0 blue:45.0/255.0 alpha:1.0])
#define UPCOMMING_EVENT_DATELABEL_COLOR ([UIColor colorWithRed:225.0/255.0 green:195.0/255.0 blue:45.0/255.0 alpha:1.0])
#define CURRENT_EVENT_DATELABEL_COLOR ([UIColor colorWithRed:162.0/255.0 green:167.0/255.0 blue:174.0/255.0 alpha:1.0])


//text color

#define HEADER_TEXT_COLOR ([UIColor colorWithRed:60.0/255.0 green:82.0/255.0 blue:102.0/255.0 alpha:1.0])
#define DETAIL_TEXTCOLOR ([UIColor colorWithRed:162.0/255.0 green:167.0/255.0 blue:174.0/255.0 alpha:1.0])

//messages read Or Unread color

#define MESSAGE_READ_COLOR ([UIColor colorWithRed:78.0/255.0 green:165.0/255.0 blue:254.0/255.0 alpha:1.0])
#define MESSAGE_IMPORTANT_COLOR ([UIColor colorWithRed:246.0/255.0 green:48.0/255.0 blue:52.0/255.0 alpha:1.0])


#define MESSAGE_APPROVED_COLOR ([UIColor colorWithRed:145.0/255.0 green:221.0/255.0 blue:60.0/255.0 alpha:1.0])
#define MESSAGE_PENDING_COLOR ([UIColor colorWithRed:240.0/255.0 green:227.0/255.0 blue:21.0/255.0 alpha:1.0])
#define MESSAGE_REJECTED_COLOR ([UIColor colorWithRed:246.0/255.0 green:48.0/255.0 blue:52.0/255.0 alpha:1.0])


#define TEXTFIELD_BUTTON_BORDER_COLOR ([ UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0])



//Font Size and Type
#define DETAIL_FONT_TYPE @"Avenir"
#define SUBJECT_FONT_TYPE @"Avenir-Heavy"

#define SUBJECT_FONT_SIZE @"16";
#define DETAIL_FONT_SIZE  ((int)16);

// logo Image

#define LOGO_IMAGE ([UIImage imageNamed:@"Logo.png"]);


@interface Constants : NSObject

+(NSString*)convertToUserTimeZone:(NSString*)actualTime;
+(UIImage *) getImageFromDataBaseWithImageURL:(NSString *)imageURL;
+(void) saveImagesInDataBase:(NSDictionary *)dataDict;
+(NSString*)displyTimeForComments:(NSString *)acutalDate;
+(NSString *)getIPAddress;

@end
