//
//  HomeViewController.m
//  Digital Jeevi
//
//  Created by DevRabbit on 23/12/16.
//  Copyright © 2016 DevRabbit. All rights reserved.
//

#import "HomeViewController.h"
# define FLIC_APP_ID  @"a3ddb2ce-86a2-4d2a-a810-e8eed6799165"
# define FLIC_APP_SECRET @"de3212b8-3f1e-486b-a8fe-96ff6f797fa8"


@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [SCLFlicManager configureWithDelegate:self defaultButtonDelegate:self appID:FLIC_APP_ID appSecret:FLIC_APP_SECRET backgroundExecution:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    
    if ([SCLFlicManager sharedManager].knownButtons.count > 0) // button exists
    {
        [[SCLFlicManager sharedManager] forgetButton:[SCLFlicManager sharedManager].knownButtons.allValues.firstObject];
    }
    else
    {
        [[SCLFlicManager sharedManager] grabFlicFromFlicAppWithCallbackUrlScheme:@"flic-boilerplate-objc"];
    }

    //    [[SCLFlicManager sharedManager] grabFlicFromFlicAppWithCallbackUrlScheme:@"flic-boilerplate-objc"];
    
   // [self bluetoothBtnAction:nil];
}

-(void)bluetoothBtnAction:(UIButton*)sender{

    if ([SCLFlicManager sharedManager].knownButtons.count > 0) // button exists
    {
        [[SCLFlicManager sharedManager] forgetButton:[SCLFlicManager sharedManager].knownButtons.allValues.firstObject];
    }
    else
    {
        [[SCLFlicManager sharedManager] grabFlicFromFlicAppWithCallbackUrlScheme:@"flic-boilerplate-objc"];
    }

}
- (void) flicManagerDidRestoreState:(SCLFlicManager *)manager; {
    
    
    if (manager.knownButtons.count > 0) // button exists
    {
        [manager forgetButton:[SCLFlicManager sharedManager].knownButtons.allValues.firstObject];
    }
    else
    {
        [manager grabFlicFromFlicAppWithCallbackUrlScheme:@"flic-boilerplate-objc"];
    }    // If you need to collect buttons or something else..
    // Set the delegate on all buttons if you have not set the default button delegate on the manager.
}


#pragma mark delegate methods

- (void)flicManager:(SCLFlicManager *)manager didGrabFlicButton:(SCLFlicButton *)button withError:(NSError *)error; {
    if (error) {
        NSLog(@"Could not grab: %@", error);
    }
    
    button.triggerBehavior = SCLFlicButtonTriggerBehaviorClickAndDoubleClickAndHold;
    
    // un-comment the following line if you need lower click latency for your application
    // this will consume more battery so don't over use it
    // button.lowLatency = YES;
}

- (void) flicButton:(SCLFlicButton * _Nonnull) button didReceiveButtonClick:(BOOL) queued age: (NSInteger) age{
    NSLog(@"single clicked");
    
    
}
- (void) flicButton:(SCLFlicButton * _Nonnull) button didReceiveButtonDoubleClick:(BOOL) queued age: (NSInteger) age{
    
    NSLog(@"double clicked");
    
    
}
- (void) flicButton:(SCLFlicButton * _Nonnull) button didReceiveButtonHold:(BOOL) queued age: (NSInteger) age{
    
    NSLog(@"hold clicked");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
