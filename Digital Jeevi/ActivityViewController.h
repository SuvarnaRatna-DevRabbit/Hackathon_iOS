//
//  ActivityViewController.h
//  Sample
//
//  Created by Rabbit on 23/12/16.
//  Copyright © 2016 Rabbit          DevRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <fliclib/fliclib.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
@interface ActivityViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource,SCLFlicManagerDelegate, SCLFlicButtonDelegate,UIAlertViewDelegate,CBCentralManagerDelegate,CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@end
