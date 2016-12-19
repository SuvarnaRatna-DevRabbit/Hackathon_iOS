//
//  Constants.m
//  NotifiiCMT
//
//  Created by Logictree on 06/05/16.
//  Copyright © 2016 Logictree. All rights reserved.
//

#import "Constants.h"
#import "Images.h"
@implementation Constants



#pragma mark TimeZone Converstion

+(NSString*)convertToUserTimeZone:(NSString*)actualTime

{
    NSString * userLoginTimeZone = [[NSUserDefaults standardUserDefaults] objectForKey:@"timezone"];
    NSString *userSourceTimeZone = [NSString stringWithFormat:@"%@",@""];
    if([userLoginTimeZone isEqualToString:@"America/Puerto_Rico"])
    {
        userSourceTimeZone = @"AST";
    }
    else if([userLoginTimeZone isEqualToString:@"America/New_York"])
    {
        userSourceTimeZone = @"EST";
    }
    else if([userLoginTimeZone isEqualToString:@"America/Chicago"])
    {
        userSourceTimeZone = @"CST";
    }
    else if([userLoginTimeZone isEqualToString:@"America/Denver"])
    {
        userSourceTimeZone = @"MST";
    }
    else if([userLoginTimeZone isEqualToString:@"America/Los_Angeles"])
    {
        userSourceTimeZone = @"PDT";
    }
    else if([userLoginTimeZone isEqualToString:@"America/Anchorage"])
    {
        userSourceTimeZone = @"AKST";
    }
    else if([userLoginTimeZone isEqualToString:@"Pacific/Honolulu"])
    {
    userSourceTimeZone = @"PST";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
   // [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dateFromString = [dateFormatter dateFromString:actualTime];
    NSDate* sourceDate = dateFromString;
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:userLoginTimeZone];
    NSTimeZone* destinationTimeZone = [NSTimeZone timeZoneWithAbbreviation:userSourceTimeZone];
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    [dateFormatter setDateFormat:@"M/dd/yyyy HH:mm:ss"];
    return [dateFormatter stringFromDate:destinationDate];
}


#pragma mark gettData from CoredataWithStringName

+(UIImage *) getImageFromDataBaseWithImageURL:(NSString *)imageURL{
    UIImage * image;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context =[delegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Images"];
    request.predicate = [NSPredicate predicateWithFormat:@"imageName == %@",imageURL];
  NSArray *results = [context executeFetchRequest:request error:nil];
    
    if (results.count != 0) {
        
        Images * imagesData = [results objectAtIndex:0];
        
        image = [UIImage imageWithData:imagesData.imageData];
    }
    return image;
}

+(void) saveImagesInDataBase:(NSDictionary *)dataDict{
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;

    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Images"];
    request.predicate = [NSPredicate predicateWithFormat:@"imageName == %@",[dataDict objectForKey:@"imageName"]];
    NSArray *results = [context executeFetchRequest:request error:nil];
    if (results.count == 0) {
        // Create a new managed object
        NSManagedObject *image = [NSEntityDescription insertNewObjectForEntityForName:@"Images" inManagedObjectContext:context];
        [image setValue:[dataDict objectForKey:@"imageData"] forKey:@"imageData"];
        [image setValue:[dataDict objectForKey:@"imageName"] forKey:@"imageName"];
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        
 
    }
    
   }


+(NSString*)displyTimeForComments:(NSString *)acutalDate{
    NSString * convertedDate = [Constants convertToUserTimeZone:acutalDate];
    
    
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"M/dd/yyyy HH:mm:ss"];
    NSString * currentDateString = [dateFormat1 stringFromDate:[NSDate date]];
    NSDate * currentDate = [dateFormat1 dateFromString:currentDateString];
    
    NSDate * userSendDate = [dateFormat1 dateFromString: [NSString stringWithFormat:@"%@ ",convertedDate]];
    NSComparisonResult result = [currentDate compare:userSendDate];
   
        if (NSOrderedSame == result) {
            
//            NSArray *convertedDateArr = [convertedDate componentsSeparatedByString:@" "];
//             NSArray *currentDateArr = [currentDateString componentsSeparatedByString:@" "];
            
            
           return @"";
        }
        else{
    
            NSArray *arr = [convertedDate componentsSeparatedByString:@" "];
            
            return [NSString stringWithFormat:@"%@ ",[arr objectAtIndex:0]];
       }
    
    

}

+(NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;

}

@end
