//
//  ViewController.m
//  Digital Jeevi
//
//  Created by DevRabbit on 30/08/16.
//  Copyright © 2016 DevRabbit. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "VerificationViewController.h"
#import "APIWrapper.h"

@interface ViewController ()
@property NSMutableArray * countryArray;
@property NSMutableArray * countryNames;
@property (strong, nonatomic) IBOutlet UILabel *codeLbl;

@property (strong, nonatomic) IBOutlet UITextField *mobileNumberTF;

@property (strong, nonatomic) IBOutlet UIButton *loginBtnOutLet;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property UIToolbar * toolBar;
@property NSString * counrtyCode;
@property NSString * countryCodeREqut;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ViewUI];
    _counrtyCode =@"+91 ▼";
   // _countryCodeREqut = @"91";
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginButtonAction:(id)sender {
 
        if (!_mobileNumberTF.text.length || !(_mobileNumberTF.text.length >= 10 && _mobileNumberTF.text.length <= 15 )) {
        
        NSString *str=[NSString stringWithFormat:@"%@",(_mobileNumberTF.text.length==0)?@"Please enter mobile number.":@"Please enter valid mobile number."];
        
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Oops!" message:str preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                           
                                        }];
            
            
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
            

        return;
        
    }
    int randomNumber = [self getRandomNumberBetween:1000 to:9999];
    NSString * randomNumberStr = [NSString stringWithFormat:@"%d",randomNumber];
    NSString * countryCodestring  =[_codeLbl.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    countryCodestring = [countryCodestring stringByReplacingOccurrencesOfString:@"▼" withString:@""];
    
       NSDictionary * requestDict = @{
                                   @"phone_number" : _mobileNumberTF.text,
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
        VerificationViewController * verify =[[VerificationViewController alloc] initWithNibName:@"VerificationViewController" bundle:nil];
        verify.verificationCode= randomNumberStr;
        verify.requestDict = requestDict;
    [self.navigationController pushViewController:verify animated:YES];
        }else{
           [[[UIAlertView alloc] initWithTitle:@"Oops!" message:[responseObject objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
       
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    [[APIWrapper shareHolder] stopActivityIndicator];
       // [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Something went worng. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
      
        NSLog(@"error %@",[error localizedDescription]);

        
    }];
    
  
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

-(void)ViewUI{
    _loginBtnOutLet.layer.cornerRadius = 5.0;
    _loginBtnOutLet.layer.masksToBounds =YES;
    _mobileNumberTF.delegate = self;
    _pickerView.delegate=self;
    _pickerView.dataSource = self;
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, _mobileNumberTF.frame.size.height - 1, _mobileNumberTF.frame.size.width, 1.0f);
    bottomBorder.backgroundColor=[UIColor lightGrayColor].CGColor;
    _mobileNumberTF.layer.cornerRadius = 4.0;
    //[_mobileNumberTF.layer addSublayer:bottomBorder];
    _codeLbl.text = @"+91 ▼";
    
    //▼
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [_codeLbl addGestureRecognizer:tapGestureRecognizer];
    _codeLbl.userInteractionEnabled = YES;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)]
                            ];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    [numberToolbar sizeToFit];
    _mobileNumberTF.inputAccessoryView = numberToolbar;
    
    
    
    
}

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
            _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,  _pickerView.frame.origin.y-44,self.view.frame.size.width, 44)];
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

-(void)cancelNumberPad{
    [self.view endEditing:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    NSString *trimmedSerchText = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (textField == _mobileNumberTF) {
        return !([[trimmedSerchText stringByReplacingCharactersInRange:range withString:string] length] > 15);
    }
    
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _pickerView.hidden =YES;
    _toolBar.hidden = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];

    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
    
    //Do stuff here...
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


@end
