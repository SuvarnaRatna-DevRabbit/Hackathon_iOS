//
//  VerificationViewController.m
//  Digital Jeevi
//
//  Created by DevRabbit on 23/12/16.
//  Copyright © 2016 DevRabbit. All rights reserved.
//

#import "VerificationViewController.h"
#import "ProfileViewController.h"
#import "APIWrapper.h"
#import "ActivityViewController.h"

@interface VerificationViewController ()
{
    
    IBOutlet UITextField *oTPTExtField;
    IBOutlet UIButton *verificationBtnOutLet;
    IBOutlet UIButton *resendBtnoutLet;
}

@end

@implementation VerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewUI];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
  // oTPTExtField.text = _verificationCode;
    
}
-(void)viewUI {
    verificationBtnOutLet.layer.cornerRadius = 5.0f;
    verificationBtnOutLet.layer.masksToBounds = YES;
    oTPTExtField.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)updateService{
   
    NSDictionary * requestDict = @{
                                   @"first_name" :[_requestDict objectForKey:@"first_name"],
                                   @"last_name": [_requestDict objectForKey:@"last_name"],
                                   @"email" : [_requestDict objectForKey:@"email"],
                                   @"phone_number": [_requestDict objectForKey:@"phone_number"],
                                 
                                   @"country_code" : [_requestDict objectForKey:@"country_code"],
                                   @"user_id" :[_requestDict objectForKey:@"User_id"],
                                   @"profile_pic":[_requestDict objectForKey:@"profile_pic"]
                                   
                                   };
    
    
//    { "first_name" : "naresh",
//        "last_name": "Babu",
//        "email" : "naresh.nookal@gmail.com",
//        "phone_number": "9490644170",
//        "country_code" : "91",
//        "profile_pic" : "sdadasd", (this is base64 image string)
//        “User_id” : 2
//    }
    
    APIWrapper *sharedObject = [APIWrapper sharedHttpClient];
    if(![[APIWrapper shareHolder] isNetConnected])
    {
        [[APIWrapper shareHolder] showNetDisConnectedPopUp];
        return;
    }
    
    [[APIWrapper shareHolder] startActivityIndicator];
    
    
    [sharedObject serviceCalling:requestDict urlExtention:@"update-profile.php" success:^(id responseObject) {
        [[APIWrapper shareHolder] stopActivityIndicator];
        if ([[responseObject objectForKey:@"status"] intValue]== 1){
            
                    
            if ([[responseObject objectForKey:@"response_info" ] isKindOfClass:[NSDictionary class]]) {
                        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"userDate"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        ActivityViewController * home =[[ActivityViewController alloc] initWithNibName:@"ActivityViewController" bundle:nil];
                        [self.navigationController pushViewController:home animated:YES];
                    }
                    
        }else{
            
          //  ActivityViewController * home =[[ActivityViewController alloc] initWithNibName:@"ActivityViewController" bundle:nil];
            //[self.navigationController pushViewController:home animated:YES];
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[APIWrapper shareHolder] stopActivityIndicator];
    }];
    
    
    
}
- (IBAction)verifyBtnAction:(id)sender {
    if (oTPTExtField.text.length !=0) {
        
        if([oTPTExtField.text isEqualToString:_verificationCode]){
            
            if ([_isFromEdit isEqualToString:@"YES"]) {
                [self updateService];
                
                
                return;
            }
        
            
            APIWrapper *sharedObject = [APIWrapper sharedHttpClient];
            if(![[APIWrapper shareHolder] isNetConnected])
            {
                [[APIWrapper shareHolder] showNetDisConnectedPopUp];
                return;
            }
            
            [[APIWrapper shareHolder] startActivityIndicator];
            
            NSDictionary * request =@{
                                      @"phone_number":[_requestDict objectForKey:@"phone_number"],
                                    @"country_code":[_requestDict objectForKey:@"country_code"]
                                      };
            
            [sharedObject serviceCalling:request urlExtention:@"get-user-details.php" success:^(id responseObject) {
                [[APIWrapper shareHolder] stopActivityIndicator];
                
               
                if ([[responseObject objectForKey:@"status"] intValue]== 1) {
                    
                    if ([[responseObject objectForKey:@"response_info" ] isKindOfClass:[NSDictionary class]]) {
                        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"userDate"];
                         [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isFirstTime"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        ActivityViewController * home =[[ActivityViewController alloc] initWithNibName:@"ActivityViewController" bundle:nil];
                        [self.navigationController pushViewController:home animated:YES];
                    }
                   
               else{
                    ProfileViewController * profile =[[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
                    profile.phoneNumber = [_requestDict objectForKey:@"phone_number"];
                   profile.counrtyCode = [NSString stringWithFormat:@"+%@ ▼",[_requestDict objectForKey:@"country_code"]];
                    [self.navigationController pushViewController:profile animated:YES];
                }
                }
                
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [[APIWrapper shareHolder] stopActivityIndicator];
            }];

            
            
            
    

        }else{
          [[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please enter valid OTP" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
            
        
    }else{
        [[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please enter OTP" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    
    
}


-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

- (IBAction)resendBtnAction:(id)sender {
    
    if (_requestDict.count == 0) {
        return;
    }
    APIWrapper *sharedObject = [APIWrapper sharedHttpClient];
    if(![[APIWrapper shareHolder] isNetConnected])
    {
        [[APIWrapper shareHolder] showNetDisConnectedPopUp];
        return;
    }
    
    int randomNumber = [self getRandomNumberBetween:1000 to:9999];
    NSString * randomNumberStr = [NSString stringWithFormat:@"%d",randomNumber];
    NSDictionary * request =@{
                    @"phone_number" : [_requestDict objectForKey:@"phone_number"],
                    @"country_code": [_requestDict objectForKey:@"country_code"],
                    @"otp" : randomNumberStr
    
                    };
    
    [[APIWrapper shareHolder] startActivityIndicator];

    [sharedObject serviceCalling:request urlExtention:@"send-otp.php" success:^(id responseObject) {
        [[APIWrapper shareHolder] stopActivityIndicator];
        if ([[responseObject objectForKey:@"status"] intValue]== 1) {
            _verificationCode = randomNumberStr;
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"OTP has been sent, please verify your number." preferredStyle:UIAlertControllerStyleAlert];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                [self dismissViewControllerAnimated:YES completion:^{
                }];
              
            }]];
            
            
            [self presentViewController:actionSheet animated:YES completion:nil];
            return;
            
            
        }else{
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Alert!" message:[responseObject objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                [self dismissViewControllerAnimated:YES completion:^{
                }];
                
            }]];
            
            
            [self presentViewController:actionSheet animated:YES completion:nil];
            return;
            
 
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[APIWrapper shareHolder] stopActivityIndicator];
    }];
    

    
}
- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    NSString *trimmedSerchText = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (textField == oTPTExtField) {
        return !([[trimmedSerchText stringByReplacingCharactersInRange:range withString:string] length] > 4);
    }
    
    return NO;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
}




- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
    
    //Do stuff here...
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
