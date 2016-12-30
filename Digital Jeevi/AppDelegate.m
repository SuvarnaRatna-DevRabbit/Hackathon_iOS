//
//  AppDelegate.m
//  Digital Jeevi
//
//  Created by DevRabbit on 30/08/16.
//  Copyright © 2016 DevRabbit. All rights reserved.
//

#import "AppDelegate.h"
#import "ActivityViewController.h";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIView appearance]setExclusiveTouch:YES];
    [[UIButton appearance]setExclusiveTouch:YES];
    [[UITextField appearance]setExclusiveTouch:YES];
    [[UITextView appearance]setExclusiveTouch:YES];
    [[UITableView appearance]setExclusiveTouch:YES];

    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDate"];
    
    if ([[dict objectForKey:@"response_info"] objectForKey:@"user_id"]!=nil) {
        ActivityViewController * home =[[ActivityViewController alloc] initWithNibName:@"ActivityViewController" bundle:nil];
        UINavigationController * navigation = [[UINavigationController alloc] initWithRootViewController:home];
        [self.window setRootViewController:navigation];
        navigation.navigationBar.hidden = YES;
        [self.window makeKeyAndVisible];
        
        return YES;

        
    }
    
    
    [self checkLocationAuthorization];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options; {
    return [[SCLFlicManager sharedManager] handleOpenURL:url];
}

- (void)checkLocationAuthorization
{
    
    if ([CLLocationManager locationServicesEnabled] == NO)
    {
        NSLog(@"locationServicesEnabled false");
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"Please go into Settings and enable Location Services." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        servicesDisabledAlert.tag =111;
        [servicesDisabledAlert show];
    } else
    {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted)
        {
            NSLog(@"authorizationStatus failed");
            UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for DeliveryMark disabled. To continue enable location services." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [servicesDisabledAlert show];
            [self.locationManager stopUpdatingLocation];
        } else
        {
            NSLog(@"authorizationStatus authorized");
            self.locationManager = [[CLLocationManager alloc] init];
            
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            
            if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [self.locationManager requestAlwaysAuthorization];
            }
            [self.locationManager startUpdatingLocation];
        }
    }
}

#pragma mark location manager delegate  methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    [[SCLFlicManager sharedManager] onLocationChange];
    
    // CLLocation *currentLocation = [locations lastObject];
    
    //    NSLog(@"before latitude:%@...longitude:%@",strCurrentLatitude,strCurrentLongitude);
    //
    //    strCurrentLatitude = [NSString stringWithFormat:@"%.8f",currentLocation.coordinate.latitude];
    //
    //    strCurrentLongitude =  [NSString stringWithFormat:@"%.8f",currentLocation.coordinate.longitude];
    //
    //    NSLog(@"after latitude:%@...longitude:%@",strCurrentLatitude,strCurrentLongitude);
    
    //    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
    NSLog(@"locationManager error:%@",error);
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your network connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"Please go into settings and enable Location Services." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag = 111;
            [alert show];
        }
            break;
        default:
        {
            
        }
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status; {
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager startMonitoringSignificantLocationChanges];
    }
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.devrabbit.Digital_Jeevi" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Digital_Jeevi" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Digital_Jeevi.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
