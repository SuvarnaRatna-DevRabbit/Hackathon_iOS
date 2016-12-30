//
//  ProfileViewController.m
//  Sample
//
//  Created by Rabbit on 23/12/16.
//  Copyright © 2016 Rabbit          DevRabbit. All rights reserved.
//

#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "APIWrapper.h"
#import "HomeViewController.h"
#import "Constants.h"
#import "ActivityViewController.h"
#import "VerificationViewController.h"
#import "UIImageView+AFNetworking.h"



@interface ProfileViewController ()
{
    UIImagePickerController * imagePicker;
}
@property (strong, nonatomic) IBOutlet UIScrollView *bGScrollView;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldMobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldEmail;

@property (strong, nonatomic) IBOutlet UIButton *btnSaveOutlet;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewProfile;

@property (strong, nonatomic) IBOutlet UIButton *editButonOutLrt;
@property (strong, nonatomic) IBOutlet UIView *bGVView;

@property NSString * userID;

@property (strong, nonatomic) IBOutlet UIButton *backBtnOutLet;


@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property UIToolbar * toolBar;
@property NSString * countryCodeREqut;
@property NSMutableArray * countryArray;
@property NSMutableArray * countryNames;
@property (strong, nonatomic) IBOutlet UILabel *codeLbl;

@property CGFloat y;

@property BOOL imagePicked;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imagePicked =  NO;
    _y = _bGVView.frame.origin.y;
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDate"];
    _userID = [[dict objectForKey:@"response_info"] objectForKey:@"user_id"];
    _counrtyCode =@"+91 ▼";
  
    
    // Do any additional setup after loading the view from its nib.
    [self designUI];
    
    UITapGestureRecognizer *gestureGetPicture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getPicture)];
    
    gestureGetPicture.numberOfTapsRequired = 1;
    
    [_imgViewProfile addGestureRecognizer:gestureGetPicture];
    
    [_imgViewProfile setUserInteractionEnabled:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    
    if (_imagePicked) {
        return;
    }
    _txtFieldMobileNumber.text  = _phoneNumber;
    _txtFieldMobileNumber.userInteractionEnabled = NO;
    _codeLbl.text =@"";
    _codeLbl.text = [NSString stringWithFormat:@"%@",_counrtyCode];

    if ([_iSFromEdit isEqualToString: @"YES"]) {
        _editButonOutLrt.hidden = NO;
        _backBtnOutLet.hidden = NO;
        _btnSaveOutlet.hidden = YES;
        _codeLbl.userInteractionEnabled = NO;
        _txtFieldFirstName.userInteractionEnabled = NO;
        _txtFieldLastName.userInteractionEnabled = NO;
        _txtFieldEmail.userInteractionEnabled = NO;
        _txtFieldMobileNumber.userInteractionEnabled = NO;
        _imgViewProfile.userInteractionEnabled  = NO;
       _txtFieldMobileNumber.userInteractionEnabled = NO;
        NSDictionary * dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDate"];
        NSLog(@"dict %@",dict);
        [_imgViewProfile setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_URL,[[dict objectForKey:@"response_info" ] objectForKey:@"profile_pic"]]]];
        _txtFieldMobileNumber.text =[[dict objectForKey:@"response_info"] objectForKey:@"phone_number"];
        _txtFieldFirstName.text =[[dict objectForKey:@"response_info"] objectForKey:@"first_name"];
        _txtFieldLastName.text =[[dict objectForKey:@"response_info"] objectForKey:@"last_name"];
        _txtFieldEmail.text =[[dict objectForKey:@"response_info"] objectForKey:@"email"];
        _codeLbl.text = [NSString stringWithFormat:@"+%@ ▼",[[dict objectForKey:@"response_info"] objectForKey:@"country_code"]];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [_codeLbl addGestureRecognizer:tapGestureRecognizer];
        UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        numberToolbar.barStyle = UIBarStyleBlackTranslucent;
        numberToolbar.items = @[
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                
                                [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)]
                                ];
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        
        [numberToolbar sizeToFit];
        _txtFieldMobileNumber.inputAccessoryView = numberToolbar;
        
    }
    
}
-(void)cancelNumberPad{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)updateServiceCall {
    
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    NSString * udidString =[oNSUUID UUIDString];
    NSData *imageData = UIImageJPEGRepresentation(_imgViewProfile.image, 1.0);
    NSString *encodedString = [imageData base64Encoding];
    
    NSString * countryCodestring  =[_codeLbl.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    countryCodestring = [countryCodestring stringByReplacingOccurrencesOfString:@"▼" withString:@""];
    NSDictionary * requestDict = @{
                                   @"first_name" :_txtFieldFirstName.text,
                                   @"last_name": _txtFieldLastName.text,
                                   @"email" : _txtFieldEmail.text,
                                   @"phone_number": [[[[NSUserDefaults standardUserDefaults] objectForKey:@"userDate"] objectForKey:@"response_info"] objectForKey:@"phone_number"],
                                   @"device_type" : @"iphone",
                                   @"device_token": udidString,
                                   @"country_code" : countryCodestring,
                                   @"user_id" :_userID,
                                   @"profile_pic":encodedString
                                   
                                   };
    
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
            
            
           // Settings updated successfully.
            [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"userDate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Profile updated successfully." preferredStyle:UIAlertControllerStyleAlert];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                [self dismissViewControllerAnimated:YES completion:^{
                }];
                
                ActivityViewController * home =[[ActivityViewController alloc] initWithNibName:@"ActivityViewController" bundle:nil];
                [self.navigationController pushViewController:home animated:YES];
                
            }]];
            
            
            [self presentViewController:actionSheet animated:YES completion:nil];
            return;

           
        }else{
            
          [[[UIAlertView alloc] initWithTitle:@"Oops!" message:[responseObject objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[APIWrapper shareHolder] stopActivityIndicator];
    }];
    

    
}


#pragma mark Action sheet Delegates



-(void)getPicture

{
    
    UIActionSheet *sheet = [[UIActionSheet alloc]
                            
            initWithTitle:@"Select Photo From"
                            
                            delegate:self
                            
                            cancelButtonTitle:@"Cancel"
                            
                            destructiveButtonTitle:nil
                            
                            otherButtonTitles:@"Camera", @"Photo Library", nil];
    
    [sheet showInView:_imgViewProfile];
    
}





- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex

{
    
    if (buttonIndex == 0)
        
    {
        
        NSLog(@"Camera");
        
        //Pick from Camera
        
        
        
        [self performSelectorOnMainThread:@selector(showCamera) withObject:nil waitUntilDone:YES];
        
    }
    
    else
        
        if (buttonIndex == 1)
            
        {
            
            
            
            imagePicker=[[UIImagePickerController alloc]init];
            
            imagePicker.allowsEditing=TRUE;
            
            imagePicker.delegate = self;
            
            
            
            if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
                
            {
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    
                    
                    // [self presentViewController:cameraUI animated:NO completion:nil];
                    
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                        
                    {
                        
                        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        
                        [self presentViewController:imagePicker animated:YES completion:nil];
                        
                        
                        
                    }
                    
                    else
                        
                    {
                        
                        UIAlertView * cameraAlert = [[UIAlertView alloc]initWithTitle:@"Photo Library not available." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                        
                        [cameraAlert show];
                        
                    }
                    
                    
                    
                }];
                
                
                
            }
            
            else{
                
                
                
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                    
                {
                    
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    
                    [self presentViewController:imagePicker animated:YES completion:nil];
                    
                    
                    
                }
                
                else
                    
                {
                    
                    UIAlertView * cameraAlert = [[UIAlertView alloc]initWithTitle:@"Photo Library not available." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    
                    [cameraAlert show];
                    
                }
                
            }
            
        }
    
        else
            
        {
            
            NSLog(@"cancelled");
            
        }
    
}



-(void)showCamera

{
    
    imagePicker=[[UIImagePickerController alloc]init];
    
    imagePicker.allowsEditing=TRUE;
    
    imagePicker.delegate = self;
    
    //Check Camera available or not
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
        
        [self presentViewController:imagePicker animated:YES completion:nil];
        
        
        
    }
    
    else
        
    {
        
        UIAlertView * cameraAlert = [[UIAlertView alloc]initWithTitle:@"Camera not available." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [cameraAlert show];
        
    }
    
    
    
}



#pragma mark image picker delegate methods



//Tells the delegate that the user cancelled the pick operation.

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
    
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker

        didFinishPickingImage:(UIImage *)image

                  editingInfo:(NSDictionary *)editingInfo

{
    
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    _imgViewProfile.layer.cornerRadius = _imgViewProfile.frame.size.width / 2;
    _imgViewProfile.clipsToBounds = YES;
    _imgViewProfile.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    _imagePicked = YES;
    
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)designUI
{
    
    _txtFieldFirstName.delegate = self;
    _txtFieldLastName.delegate = self;
    _txtFieldEmail.delegate  = self;
    _txtFieldMobileNumber.delegate = self;
    
    _btnSaveOutlet.layer.cornerRadius = 5.0f;
    _imgViewProfile.layer.cornerRadius = _imgViewProfile.frame.size.width/2;
    _imgViewProfile.layer.masksToBounds = YES;
    
}

-(void)setBorderbottomoftextField:(UITextField *)textField  validORnot:(NSString *)validationStr AndErrorString : (NSString *)ErrorString {
    
    //  NSLog(@"tecxt:%@",txtfieldTemp);
    
    [[[UIAlertView alloc] initWithTitle:@"Oops!" message:ErrorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
   
}
- (BOOL)validateEmailWithString:(NSString*)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}



-(BOOL)validateEmail:(NSString *)text{
    
    NSString *regEx = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    
    return [emailTest evaluateWithObject:text];
    
}






- (BOOL)Validations
{
   
    if(_txtFieldFirstName.text.length != 0 && (_txtFieldMobileNumber.text.length != 0 ||  !( _txtFieldMobileNumber.text.length >= 10 && _txtFieldMobileNumber.text.length <=15 )) && _txtFieldLastName.text.length != 0 && (_txtFieldEmail.text.length != 0  && [self validateEmailWithString:_txtFieldEmail.text])) {
        
        return YES;
        
    }
    else{
        
        if (_txtFieldFirstName.text.length == 0) {
            
            [self setBorderbottomoftextField:_txtFieldFirstName validORnot:@"NotValid" AndErrorString:@"Please enter first name." ];
            return NO;
        }
        
        
        
        
        if (_txtFieldLastName.text.length == 0) {
            
            [self setBorderbottomoftextField:_txtFieldLastName validORnot:@"NotValid" AndErrorString:@"Please enter last name." ];
            
            return NO;
        }
        
        if (_txtFieldMobileNumber.text.length == 0 ||  ( _txtFieldMobileNumber.text.length < 10 )) {
            
            NSString *str= ( _txtFieldMobileNumber.text.length < 10 ) ? @"Please enter valid mobile number." : @"Please enter mobile number.";
            [self setBorderbottomoftextField:_txtFieldMobileNumber validORnot:@"NotValid" AndErrorString:str ];
            return NO;
        }
        
        if (_txtFieldEmail.text.length  || ! [self validateEmailWithString:_txtFieldEmail.text] )
        {
            
            [self setBorderbottomoftextField:_txtFieldEmail validORnot:@"NotValid" AndErrorString:@"Please enter valid email id." ];
            return NO;
        }
 
        return NO;
    
    }
    
 }
-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}


-(IBAction)btnSaveClicked:(UIButton *)sender
{
    if ([_iSFromEdit isEqualToString:@"YES"]) {
        if (![self Validations]) {
            return;
        }
        
        if (![_txtFieldMobileNumber.text isEqualToString:[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userDate"] objectForKey:@"response_info"] objectForKey:@"phone_number"]]) {
            
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Do you want to change mobile number." preferredStyle:UIAlertControllerStyleAlert];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
               
            [self dismissViewControllerAnimated:YES completion:^{
                }];
                 [self updateServiceCall];
           
               
            }]];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            int randomNumber = [self getRandomNumberBetween:1000 to:9999];
            NSString * randomNumberStr = [NSString stringWithFormat:@"%d",randomNumber];
            
            NSString * countryCodestring  =[_codeLbl.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
            countryCodestring = [countryCodestring stringByReplacingOccurrencesOfString:@"▼" withString:@""];
            
            NSDictionary * requestDict = @{
                                           @"phone_number" : _txtFieldMobileNumber.text,
                                           @"country_code":countryCodestring,
                                           @"otp" : randomNumberStr
                                           };
            
            APIWrapper *sharedObject = [APIWrapper sharedHttpClient];
            if(![[APIWrapper shareHolder] isNetConnected])
            {
                [[APIWrapper shareHolder] showNetDisConnectedPopUp];
                return;
            }
            
            [[APIWrapper shareHolder] startActivityIndicator];
            
            
            [sharedObject serviceCalling:requestDict urlExtention:@"send-otp.php" success:^(id responseObject) {
                [[APIWrapper shareHolder] stopActivityIndicator];
                if ([[responseObject objectForKey:@"status"] intValue]== 1) {
                    
                    
                    
                    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
                    NSString * udidString =[oNSUUID UUIDString];
                    NSData *imageData = UIImageJPEGRepresentation(_imgViewProfile.image, 1.0);
                    NSString *encodedString = [imageData base64Encoding];
                    
                    
                    NSString * countryCodestring  =[_codeLbl.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
                    countryCodestring = [countryCodestring stringByReplacingOccurrencesOfString:@"▼" withString:@""];
                    
                    NSDictionary * requestSendDict = @{
                                                   @"first_name" :_txtFieldFirstName.text,
                                                   @"last_name": _txtFieldLastName.text,
                                                   @"email" : _txtFieldEmail.text,
                                                   @"phone_number": _txtFieldMobileNumber.text,
                                                   @"device_type" : @"iphone",
                                                   @"device_token": udidString,
                                                   @"country_code" :countryCodestring,
                                                   @"User_id" :_userID,
                                                   @"profile_pic":encodedString
                                                   
                                                   };
                    

                    
                    VerificationViewController * verify =[[VerificationViewController alloc] initWithNibName:@"VerificationViewController" bundle:nil];
                    verify.verificationCode= randomNumberStr;
                    verify.requestDict = requestSendDict;
                    verify.isFromEdit = @"YES";
                    [self.navigationController pushViewController:verify animated:YES];
                }else{
                    
                }
                
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [[APIWrapper shareHolder] stopActivityIndicator];
            }];

            }]];
            
            
            
        [self presentViewController:actionSheet animated:YES completion:nil];
            return;
            
        }
        
        [self updateServiceCall];
        return;
   }
    
    else{
    
    
    if (![self Validations]) {
        return;
    }
   
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    NSString * udidString =[oNSUUID UUIDString];

    NSData *imageData = UIImageJPEGRepresentation(_imgViewProfile.image, 1.0);
    NSString *encodedString = [imageData base64Encoding];
        NSString * countryCodestring  =[_codeLbl.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
        countryCodestring = [countryCodestring stringByReplacingOccurrencesOfString:@"▼" withString:@""];
    
    NSDictionary * requestDict = @{
                            @"first_name" :_txtFieldFirstName.text,
                            @"last_name": _txtFieldLastName.text,
                            @"email" : _txtFieldEmail.text,
                            @"phone_number": _txtFieldMobileNumber.text,
                            @"device_type" : @"iphone",
                            @"device_token": udidString,
                            @"country_code" : countryCodestring,
                            @"profile_pic":encodedString
                                   };
    
    APIWrapper *sharedObject = [APIWrapper sharedHttpClient];
    if(![[APIWrapper shareHolder] isNetConnected])
    {
        [[APIWrapper shareHolder] showNetDisConnectedPopUp];
        return;
    }
    
    [[APIWrapper shareHolder] startActivityIndicator];
    
    
    [sharedObject serviceCalling:requestDict urlExtention:@"create-profile.php" success:^(id responseObject) {
        [[APIWrapper shareHolder] stopActivityIndicator];
        if ([[responseObject objectForKey:@"status"] intValue]== 1) {
            
            
            [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"userDate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Profile updated successfully." preferredStyle:UIAlertControllerStyleAlert];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                [self dismissViewControllerAnimated:YES completion:^{
                }];
                
                ActivityViewController * home =[[ActivityViewController alloc] initWithNibName:@"ActivityViewController" bundle:nil];
                [self.navigationController pushViewController:home animated:YES];
                
            }]];
            
            
            [self presentViewController:actionSheet animated:YES completion:nil];
            return;
            
            
        }else{
            
            [[[UIAlertView alloc] initWithTitle:@"Oops!" message:[responseObject objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            
        }
//            
//            [[NSUserDefaults standardUserDefaults]  setObject:[responseObject objectForKey:@"response_info"] forKey:@"userDate"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//            ActivityViewController * home =[[ActivityViewController alloc] initWithNibName:@"ActivityViewController" bundle:nil];
//            [self.navigationController pushViewController:home animated:YES];
//        }else{
//            
//            ActivityViewController * home =[[ActivityViewController alloc] initWithNibName:@"ActivityViewController" bundle:nil];
//            [self.navigationController pushViewController:home animated:YES];
//            
//        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[APIWrapper shareHolder] stopActivityIndicator];
    }];
    

    }
    
 }




#pragma textFiled delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    _bGVView.frame = CGRectMake(_bGVView.frame.origin.x,_y,_bGVView.frame.size.width, _bGVView.frame.size.height);
    return YES;
}

- (IBAction)editBtnAction:(UIButton *)sender {
    _btnSaveOutlet.hidden = NO;
    _txtFieldFirstName.userInteractionEnabled = YES;
    _txtFieldLastName.userInteractionEnabled = YES;
    _txtFieldEmail.userInteractionEnabled = YES;
    _txtFieldMobileNumber.userInteractionEnabled = YES;
    _editButonOutLrt.hidden = YES;
    _codeLbl.userInteractionEnabled= YES;
    _imgViewProfile.userInteractionEnabled  = YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == _txtFieldMobileNumber) {
        NSString *trimmedSerchText = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (textField == _txtFieldMobileNumber) {
            return !([[trimmedSerchText stringByReplacingCharactersInRange:range withString:string] length] > 15);
        }
        
        return NO;
    }else{
        return YES;
    }
  
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.view endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.view];
    
    // If you want to remove the listener for the 2 notifications and nothing more, then use the following lines
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
  
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];

    
    if (IS_IPHONE_5) {
        
  
    if (textField == _txtFieldMobileNumber || textField == _txtFieldEmail) {
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
  
    }
 
    
  }
    if (IS_IPHONE_6 || IS_IPHONE_6P) {
        if (textField == _txtFieldEmail) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillShow)
                                                         name:UIKeyboardWillShowNotification
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillHide)
                                                         name:UIKeyboardWillHideNotification
                                                       object:nil];
        }
        
    }
    
    
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
    
    
    //Do stuff here...
}



-(void)keyboardWillShow {
    // Animate the current view out of the way
    
    [UIView animateWithDuration:0.3f animations:^ {
        if  (_bGVView.frame.origin.y >= 0)
        {
        _bGVView.frame = CGRectMake(_bGVView.frame.origin.x, _bGVView.frame.origin.y-160, _bGVView.frame.size.width, _bGVView.frame.size.height);
        }
    }];
}

-(void)keyboardWillHide {
    // Animate the current view back to its original position
    [UIView animateWithDuration:0.3f animations:^ {
       
            
       _bGVView.frame = CGRectMake(_bGVView.frame.origin.x, _y,_bGVView.frame.size.width, _bGVView.frame.size.height);
       
    }];
}



#pragma mark labelTapped



-(void)labelTapped{
    
    [self.view endEditing:YES];
    //countries.php
    APIWrapper *sharedObject = [APIWrapper sharedHttpClient];
    if(![[APIWrapper shareHolder] isNetConnected])
    {
        [[APIWrapper shareHolder] showNetDisConnectedPopUp];
        return;
    }
    
    [[APIWrapper shareHolder] startActivityIndicator];
    
    
    [sharedObject serviceCalling:nil urlExtention:@"countries.php" success:^(id responseObject) {
        [[APIWrapper shareHolder] stopActivityIndicator];
        if ([[responseObject objectForKey:@"status"] intValue]== 1) {
            
            
            
            _countryArray = [NSMutableArray new];
            _countryNames = [NSMutableArray new];
            
            for (NSDictionary * code in [responseObject objectForKey:@"response_info"]) {
                [_countryArray addObject:[code objectForKey:@"dial_code"]];
                [_countryNames addObject:[code objectForKey:@"country_name"]];
                
            }
            _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-_pickerView.frame.size.height,self.view.frame.size.width, 44)];
            _toolBar.barTintColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1.0];
            
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
            [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
            UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] ;
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouched:)];
            [cancelButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
            [_toolBar setItems:[NSArray arrayWithObjects:doneButton,flex,cancelButton, nil]];
            [self.view addSubview:_toolBar];
            [_pickerView setHidden:NO];
            [_pickerView reloadAllComponents];
            
            
        }else{
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[APIWrapper shareHolder] stopActivityIndicator];
    }];
    
    
    
}

- (void)doneTouched:(UIBarButtonItem *)sender
{
    _toolBar.hidden =YES;
    
    _pickerView.hidden =YES;
    _codeLbl.text= _counrtyCode;
    
}
- (void)cancelTouched:(UIBarButtonItem *)sender
{
    
    _toolBar.hidden =YES;
    _pickerView.hidden =YES;
    
    
}



# pragma mark PickerViewDelegates
- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return _countryArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@ %@",[_countryNames objectAtIndex:row],[_countryArray objectAtIndex:row]];
}


- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _counrtyCode = [NSString stringWithFormat:@"+%@ ▼",[_countryArray objectAtIndex:row]];
    //_recipentID = [_recepientIDArray objectAtIndex:row];
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
