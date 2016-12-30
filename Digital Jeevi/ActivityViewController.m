//
//  ActivityViewController.m
//  Sample
//
//  Created by Rabbit on 23/12/16.
//  Copyright © 2016 Rabbit          DevRabbit. All rights reserved.
//

#import "ActivityViewController.h"
#import "CollectionViewCell.h"
#import "NormalActivitiesViewController.h"
#import "ProfileViewController.h"

# define FLIC_APP_ID  @"a3ddb2ce-86a2-4d2a-a810-e8eed6799165"
# define FLIC_APP_SECRET @"de3212b8-3f1e-486b-a8fe-96ff6f797fa8"
@interface ActivityViewController ()
{
    NSArray *images;
    NSArray *text;
}
@property (weak, nonatomic) IBOutlet UIView *vwBgActivity;
@property (weak, nonatomic) IBOutlet UICollectionView *settingsCollectionView;
@property (strong, nonatomic) IBOutlet UIView *settingsPinkView;

@property (strong, nonatomic) IBOutlet UIView *activityPinkView;


@property (strong, nonatomic) IBOutlet UIView *activityBGV;

@property (strong, nonatomic) IBOutlet UIView *settingsBGV;


@property (weak, nonatomic) IBOutlet UIButton *btnPinkflic;
@property (weak, nonatomic) IBOutlet UIButton *btnBluetooth;
@property (strong, nonatomic) IBOutlet UIView *vwBgPanic;
@property (strong, nonatomic) IBOutlet UIButton *btnSettings;
@property (strong, nonatomic) IBOutlet UIButton *btnActivityOutlet;

@property (strong, nonatomic) IBOutlet UIButton *emergencyBtnOutlet;
@property (strong, nonatomic) IBOutlet UIView *vwBgProfile;

@property (strong, nonatomic) IBOutlet UIButton *profileBtnAction;
@property CBCentralManager * bluetoothManager;
@property BOOL isBlthISActive;
@property NSString * userID;
@end

@implementation ActivityViewController

- (void)viewDidLoad {
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDate"];
    _userID = [[dict objectForKey:@"response_info"] objectForKey:@"user_id"];
    
  

[_settingsCollectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:[NSBundle mainBundle]]
              forCellWithReuseIdentifier:@"CollectionViewCell"];
   // [SCLFlicManager configureWithDelegate:self defaultButtonDelegate:self appID:FLIC_APP_ID appSecret:FLIC_APP_SECRET backgroundExecution:NO];
    
    [super viewDidLoad];
    images = [[NSArray alloc]initWithObjects:@"",@"", nil];
    text = [[NSArray alloc]initWithObjects:@"Danger",@"Profile", nil];
       _btnPinkflic.userInteractionEnabled = NO;
    _activityPinkView.hidden = YES;
    _settingsPinkView.hidden = NO;
    
 }


- (void)detectBluetooth
{
    if(!self.bluetoothManager)
    {
        // Put on main queue so we can call UIAlertView from delegate callbacks.
        self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    }
    [self centralManagerDidUpdateState:self.bluetoothManager]; // Show initial state
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSString *stateString = nil;
    switch(self.bluetoothManager.state)
    {
        case CBCentralManagerStateResetting: stateString = @"The connection with the system service was momentarily lost, update imminent."; break;
        case CBCentralManagerStateUnsupported: stateString = @"The platform doesn't support Bluetooth Low Energy."; break;
        case CBCentralManagerStateUnauthorized: stateString = @"The app is not authorized to use Bluetooth Low Energy."; break;
        case CBCentralManagerStatePoweredOff: stateString = @"Bluetooth is currently powered off.";
            _isBlthISActive = NO;
            break;
        case CBCentralManagerStatePoweredOn: stateString = @"Bluetooth is currently powered on and available to use.";
            _isBlthISActive = YES;
            break;
        default: stateString = @"State unknown, update imminent."; break;
    }
    
    if ([stateString isEqualToString:@"Bluetooth is currently powered off"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bluetooth state"
                                                        message:stateString
                                                       delegate:nil
                                              cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        return;
 
    }
    
   }


-(void)viewWillAppear:(BOOL)animated{
   
   
    if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstTime"] isEqualToString:@"YES"]) {
      
        [[[UIAlertView alloc] initWithTitle:@"Notice!" message:@"Please ensure bluetooth is turned on and you are connected to flic" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] show];
        return;
    }
}
- (IBAction)emergencyBtnActoin:(id)sender {
    if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstTime"] isEqualToString:@"YES"]) {
        
        [[[UIAlertView alloc] initWithTitle:@"Notice!" message:@"Please ensure bluetooth is turned on and you are connected to flic" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] show];
        return;
    }
    
    
    NormalActivitiesViewController * contact  =[[NormalActivitiesViewController alloc] initWithNibName:@"NormalActivitiesViewController" bundle:nil];
    [self.navigationController pushViewController:contact animated:YES];
  
}
- (IBAction)profilebtnAction:(id)sender {
    
    if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstTime"] isEqualToString:@"YES"]) {
        
        [[[UIAlertView alloc] initWithTitle:@"Notice!" message:@"Please ensure bluetooth is turned on and you are connected to flic" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] show];
        return;
    }
    ProfileViewController * profile =[[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
        profile.iSFromEdit = @"YES";
    [self.navigationController pushViewController:profile animated:YES];
    
}




-(IBAction)btnBlutoothSelected:(UIButton *)sender
{
        [SCLFlicManager configureWithDelegate:self defaultButtonDelegate:self appID:FLIC_APP_ID appSecret:FLIC_APP_SECRET backgroundExecution:NO];
    if ([SCLFlicManager sharedManager].knownButtons.count > 0) // button exists
    {
        [[SCLFlicManager sharedManager] forgetButton:[SCLFlicManager sharedManager].knownButtons.allValues.firstObject];
    }
    else
    {
        [[SCLFlicManager sharedManager] grabFlicFromFlicAppWithCallbackUrlScheme:@"flic-boilerplate-objc"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)btnActivityClicked:(UIButton *)sender
{
    _activityPinkView.hidden = NO;
    _settingsPinkView.hidden = YES;
    _settingsBGV.hidden = YES;
    [self.view bringSubviewToFront:_activityBGV];
    _settingsCollectionView.hidden = YES;

}

#pragma Synchronize Contacts Button Clicked Action

-(IBAction)btnSettingsClicked:(UIButton *)sender
{
    _activityPinkView.hidden = YES;
    _settingsPinkView.hidden = NO;
    _settingsBGV.hidden = NO;
  [self.view bringSubviewToFront:_settingsBGV];;

    
}

#pragma mark

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if ([SCLFlicManager sharedManager].knownButtons.count > 0) // button exists
        {
            [[SCLFlicManager sharedManager] forgetButton:[SCLFlicManager sharedManager].knownButtons.allValues.firstObject];
        }
        else
        {
                      [SCLFlicManager configureWithDelegate:self defaultButtonDelegate:self appID:FLIC_APP_ID appSecret:FLIC_APP_SECRET backgroundExecution:NO];
            if ([SCLFlicManager sharedManager].knownButtons.count > 0)
            {
                [[SCLFlicManager sharedManager] forgetButton:[SCLFlicManager sharedManager].knownButtons.allValues.firstObject];
            }
            else
            {
                [[SCLFlicManager sharedManager] grabFlicFromFlicAppWithCallbackUrlScheme:@"flic-boilerplate-objc"];
            }

        }

    }
}


#pragma collection view methods



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  //  return namesAsset.count;
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"CollectionViewCell";
    
    static BOOL nibMyCellloaded = NO;
    
    if(!nibMyCellloaded)
    {
        UINib *nib = [UINib nibWithNibName:@"CollectionViewCell" bundle: nil];
        [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        nibMyCellloaded = YES;
    }
    
    CollectionViewCell *cell = (CollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    
    return cell;
    

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        return CGSizeMake((collectionView.frame.size.width-65)/2,(collectionView.frame.size.width-70)/2);
    }
    else
    {
        // NSLog(@"screenlength:%f",self.view.frame.size.width);
        return CGSizeMake((self.view.frame.size.width -50)/2,(self.view.frame.size.width-50)/2);
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView
shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

#pragma mark 


- (void) flicManagerDidRestoreState:(SCLFlicManager *)manager; {
    
    
    if (manager.knownButtons.count > 0) // button exists
    {
        [manager forgetButton:[SCLFlicManager sharedManager].knownButtons.allValues.firstObject];
    }
    else
    {
        [manager grabFlicFromFlicAppWithCallbackUrlScheme:@"flic-boilerplate-objc"];
    }
}
-(void)flicManager:(SCLFlicManager *)manager didChangeBluetoothState:(SCLFlicManagerBluetoothState)state{
    NSLog(@"didChangeBluetoothstate = %ld",(long)state);
   if(state == 1){
          [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please enable bloothsate" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
   }
    
    
}
-(void)flicButton:(SCLFlicButton *)button didDisconnectWithError:(NSError *)error{
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"flickState"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [_btnBluetooth setImage:[UIImage imageNamed:@"Blutooth_unconnected.png"] forState:UIControlStateNormal];
    NSLog(@"didDisconnectWithError =%@",error.localizedDescription);
}
-(void)flicButtonDidConnect:(SCLFlicButton *)button{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"flickState"];
     [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isFirstTime"];
     [[NSUserDefaults standardUserDefaults]synchronize];
    [_btnBluetooth setImage:[UIImage imageNamed:@"Blutooth_conncted.png"] forState:UIControlStateNormal];
    NSLog(@"flick connected ...");
    
}

- (void) flicButton:(SCLFlicButton * _Nonnull) button didFailToConnectWithError:(NSError * _Nullable) error{
    
}

#pragma mark delegate methods

- (void)flicManager:(SCLFlicManager *)manager didGrabFlicButton:(SCLFlicButton *)button withError:(NSError *)error; {
    if (error) {
        NSLog(@"Could not grab: %@", error);
    }
    
    button.triggerBehavior = SCLFlicButtonTriggerBehaviorClickAndDoubleClickAndHold;
   }

- (void) flicButton:(SCLFlicButton * _Nonnull) button didReceiveButtonClick:(BOOL) queued age: (NSInteger) age{
    NSLog(@"single clicked");
    
    
}
- (void) flicButton:(SCLFlicButton * _Nonnull) button didReceiveButtonDoubleClick:(BOOL) queued age: (NSInteger) age{
    
    NSLog(@"double clicked");
    
    
}
- (void) flicButton:(SCLFlicButton * _Nonnull) button didReceiveButtonHold:(BOOL) queued age: (NSInteger) age{
    
    NSLog(@"hold clicked");
    
    
    
    if ([CLLocationManager locationServicesEnabled] == NO)
    {
        APIWrapper *sharedObject = [APIWrapper sharedHttpClient];
        if(![[APIWrapper shareHolder] isNetConnected])
        {
            [[APIWrapper shareHolder] showNetDisConnectedPopUp];
            return;
        }
        
        //int randomNumber = [self getRandomNumberBetween:1000 to:9999];
        //NSString * randomNumberStr = [NSString stringWithFormat:@"%d",randomNumber];
        
        
        NSDictionary * requestData = @{
                                       @"mode": @"0",
                                       @"user_id": _userID,
                                       @"latitude": @"0.0",
                                       @"longitude": @"0.0"
                                       };
        [[APIWrapper shareHolder] startActivityIndicator];
        
        [sharedObject serviceCalling:requestData urlExtention:@"flic-click.php" success:^(id responseObject) {
            [[APIWrapper shareHolder] stopActivityIndicator];
            if ([[responseObject objectForKey:@"status"] intValue]== 1) {
                
                
                
                // _verificationCode = randomNumberStr
                ;
            }else{
                
            }
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [[APIWrapper shareHolder] stopActivityIndicator];
        }];
        
        
        
        
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark location manager delegate  methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    //[[SCLFlicManager sharedManager] onLocationChange];
    
     CLLocation *currentLocation = [locations lastObject];
    [self.locationManager stopUpdatingLocation];

    
    APIWrapper *sharedObject = [APIWrapper sharedHttpClient];
    if(![[APIWrapper shareHolder] isNetConnected])
    {
        [[APIWrapper shareHolder] showNetDisConnectedPopUp];
        return;
    }
    
    NSDictionary * requestData = @{
                                   @"mode": @"0",
                                   @"user_id": _userID,
                                   @"latitude":[NSString stringWithFormat:@"%.8f",currentLocation.coordinate.latitude],
                                   @"longitude":[NSString stringWithFormat:@"%.8f",currentLocation.coordinate.longitude]
                                   };
    
    [[APIWrapper shareHolder] startActivityIndicator];
    
    [sharedObject serviceCalling:requestData urlExtention:@"flic-click.php" success:^(id responseObject) {
        [[APIWrapper shareHolder] stopActivityIndicator];
        if ([[responseObject objectForKey:@"status"] intValue]== 1) {
            }else{
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[APIWrapper shareHolder] stopActivityIndicator];
    }];
    
    
    
    
    
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



@end
