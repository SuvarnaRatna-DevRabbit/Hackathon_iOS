//
//  NormalActivitiesViewController.m
//  Pinkflic
//
//  Created by Rabbit on 24/12/16.
//  Copyright © 2016 Rabbit          DevRabbit. All rights reserved.
//

#import "NormalActivitiesViewController.h"
#import "NormalActivityTableViewCell.h"
#import "ContactsViewController.h"
#import "ProfileViewController.h"

@interface NormalActivitiesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableVwNormalActivity;
@property  NSString * userID;
@property (strong, nonatomic) IBOutlet UIButton *btnSMS;
@property (strong, nonatomic) IBOutlet UIButton *btnEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnPush;
- (IBAction)btnBackClicked:(id)sender;
- (IBAction)saveBtnAction:(id)sender;

@end

@implementation NormalActivitiesViewController
@synthesize arrayNormal;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDate"];
     _userID = [[dict objectForKey:@"response_info"] objectForKey:@"user_id"];
    _contactsCarringArray = [NSMutableArray new];
    // Do any additional setup after loading the view from its nib.
    [_tableVwNormalActivity registerNib:[UINib nibWithNibName:@"NormalActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"normal"];
    _tableVwNormalActivity.delegate=self;
    _tableVwNormalActivity.dataSource= self;
    arrayNormal = [[NSMutableArray alloc]init];
     _tableVwNormalActivity.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    
    APIWrapper *sharedObject = [APIWrapper sharedHttpClient];
    if(![[APIWrapper shareHolder] isNetConnected])
    {
        [[APIWrapper shareHolder] showNetDisConnectedPopUp];
        return;
    }
    
    
    NSDictionary * requestData = @{
                                   @"user_id":_userID
                                   };
    [[APIWrapper shareHolder] startActivityIndicator];
    
    [sharedObject serviceCalling:requestData urlExtention:@"settings_contacts_info.php" success:^(id responseObject) {
        [[APIWrapper shareHolder] stopActivityIndicator];
        if ([[responseObject objectForKey:@"status"] intValue]== 1) {
            
            
            for (NSDictionary * tempDict in [[responseObject objectForKey:@"response_info"] objectForKey:@"contacts"]) {
                NSDictionary * contacts =[[NSDictionary alloc ]initWithObjectsAndKeys:[tempDict objectForKey:@"phone_string"],@"contact_mobile",[tempDict objectForKey:@"name"],@"contact_name",[tempDict objectForKey:@"email"],@"contact_email", nil];
                [arrayNormal addObject:contacts];
                
                if ([[[responseObject objectForKey:@"response_info"]objectForKey:@"send_email"] integerValue]==1) {
                    _btnEmail.tag=1;
                    [_btnEmail setImage:[UIImage imageNamed:@"Checkbox_selected.png"] forState:UIControlStateNormal];
                    [_btnEmail setSelected:YES];
                }
                if ([[[responseObject objectForKey:@"response_info"]objectForKey:@"send_sms"] integerValue]==1) {
                    _btnSMS.tag=1;
                    [_btnSMS setImage:[UIImage imageNamed:@"Checkbox_selected.png"] forState:UIControlStateNormal];
                    [_btnSMS setSelected:YES];
                }
                if ([[[responseObject objectForKey:@"response_info"]objectForKey:@"send_notification"] integerValue]==1) {
                    _btnPush.tag=1;
                    [_btnPush setImage:[UIImage imageNamed:@"Checkbox_selected.png"] forState:UIControlStateNormal];
                    [_btnPush setSelected:YES];
                }
                
                
                [_tableVwNormalActivity reloadData];
            }
           
        }else{
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[APIWrapper shareHolder] stopActivityIndicator];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(
                                                     receiveTestNotification:)
                                                 name:@"TestNotification"
                                               object:nil];
     [_tableVwNormalActivity reloadData];
    
}




- (void) receiveTestNotification:(NSNotification *) notification
{
//    _contactsCarringArray = [[notification object] mutableCopy];
//    for (NSDictionary * contatcs in _contactsCarringArray ) {
//        
//        [arrayNormal addObject:contatcs];
//    }
    arrayNormal = [[notification object] mutableCopy];
        [_tableVwNormalActivity reloadData];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TestNotification" object:nil];
    if ([[notification name] isEqualToString:@"TestNotification"])
        NSLog (@"Successfully received the test notification!");
}





- (IBAction)btnSmsSelected:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"Checkbox_selected.png"] forState:UIControlStateNormal];
        _btnSMS.tag =1;
    }        else
    {
        [sender setImage:[UIImage imageNamed:@"Checkbox_unselected.png"] forState:UIControlStateNormal];
        _btnSMS.tag =0;
    }
}
- (IBAction)btnEmailSelected:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"Checkbox_selected.png"] forState:UIControlStateNormal];
        _btnEmail.tag = 1;
        
    }        else
    {
        [sender setImage:[UIImage imageNamed:@"Checkbox_unselected.png"] forState:UIControlStateNormal];
        _btnEmail.tag =0;
    }
}

- (IBAction)btnPushSelected:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"Checkbox_selected.png"] forState:UIControlStateNormal];
        _btnPush.tag=1;
    }        else
    {
        [sender setImage:[UIImage imageNamed:@"Checkbox_unselected.png"] forState:UIControlStateNormal];
        _btnPush.tag =0;
    }
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)contactedtiBtnClicked:(id)sender {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(
                                                                receiveTestNotification:)
                                                 name:@"TestNotification"
                                               object:nil];

    ContactsViewController * contact = [[ContactsViewController alloc] initWithNibName:@"ContactsViewController" bundle:nil];
    contact.alreadySelectedContacts = [arrayNormal mutableCopy];
    [self presentViewController:contact animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma tableViewMethods
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    if (isSearching ) {
    //        return [searchResults count];
    //
    //    } else {
    //        return aryDeviceContacts.count ;
    return arrayNormal.count;
    NSLog(@"response:%lu",(unsigned long)arrayNormal.count);
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"normal";
    
    NormalActivityTableViewCell * cell = (NormalActivityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell ==nil) {
        [[NSBundle mainBundle] loadNibNamed:@"NormalActivityTableViewCell" owner:self options:nil];
    }
    //  NSLog(@"result:%@",aryDeviceContacts);
    NSDictionary *tempDict = [arrayNormal objectAtIndex:indexPath.row];
    cell.lblName.text = [tempDict valueForKey:@"contact_name"];
       cell.lblPhoneNumber.text =[tempDict  valueForKey:@"contact_mobile"];
    cell.deleteBtnOutLet.tag = indexPath.row;
    [cell.deleteBtnOutLet addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}


-(void)deleteBtn:(UIButton *)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Do you want delete this number." preferredStyle:UIAlertControllerStyleAlert];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"OK" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    [arrayNormal removeObjectAtIndex:sender.tag];
    [_tableVwNormalActivity reloadData];

    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
           [self dismissViewControllerAnimated:YES completion:^{
         }];
        
        
    }]];
    
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    return;
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    {
        return 67;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    return 1;
    self.tableVwNormalActivity.backgroundView = nil;
    NSInteger numOfSections = 0;
    if ([arrayNormal count]!=0)
    {
        self.tableVwNormalActivity.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                 = 1;
        self.tableVwNormalActivity.backgroundView   = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableVwNormalActivity.bounds.size.width, self.tableVwNormalActivity.bounds.size.height)];
        noDataLabel.text =@" No contacts selected.";
        //[noDataLabel setFont:[UIFont fontWithName:SUBJECT_FONT_TYPE size:15]];
       // [noDataLabel
         //setTextColor:HEADER_TEXT_COLOR];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        noDataLabel.numberOfLines =2;
        [noDataLabel sizeToFit];
        self.tableVwNormalActivity.backgroundView = noDataLabel;
        self.tableVwNormalActivity.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
    
}




-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
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

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveBtnAction:(id)sender {
    
    if ([arrayNormal count]!= 0 &&(_btnSMS.tag != 0 || _btnPush.tag != 0 || _btnSMS.tag != 0)) {
        APIWrapper *sharedObject = [APIWrapper sharedHttpClient];
        if(![[APIWrapper shareHolder] isNetConnected])
        {
            [[APIWrapper shareHolder] showNetDisConnectedPopUp];
            return;
        }
        
        
        NSMutableArray * dataArray =[NSMutableArray new];
        for (NSDictionary * data in arrayNormal) {
            NSDictionary * requst = @{
                                      @"name":([data objectForKey:@"contact_name"])?[data objectForKey:@"contact_name"]:@"",
                                      @"phone_number":([data objectForKey:@"contact_mobile"])?[data objectForKey:@"contact_mobile"]:@"",
                                      @"email":([data objectForKey:@"contact_email"])?[data objectForKey:@"contact_email"]:@""
                                      };
            [dataArray addObject:requst];
            
        }
        NSDictionary * request =@{
                                  @"send_sms" : [NSString stringWithFormat:@"%d",_btnSMS.tag],
                                  @"send_email": [NSString stringWithFormat:@"%d",_btnEmail.tag],
                                  @"send_notification" : [NSString stringWithFormat:@"%d",_btnPush.tag],
                                  @"share_location": @"1",
                                  @"allow_for_danger_nofity" : @"1",
                                  @"allow_for_normal_notify": @"0",
                                  @"user_id" : _userID,
                                  @"contacts" : dataArray
                                  };
        
        [[APIWrapper shareHolder] startActivityIndicator];
        
        [sharedObject serviceCalling:request urlExtention:@"settings.php" success:^(id responseObject) {
            [[APIWrapper shareHolder] stopActivityIndicator];
            if ([[responseObject objectForKey:@"status"] intValue]== 1) {
                
                UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Settings updated successfully." preferredStyle:UIAlertControllerStyleAlert];
                
                [actionSheet addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                    }];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }]];
                
                
                [self presentViewController:actionSheet animated:YES completion:nil];
                return;
                // _verificationCode = randomNumberStr
                ;
            }else{
                
            }
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [[APIWrapper shareHolder] stopActivityIndicator];
        }];
        

        
    }
    else{
        if ([arrayNormal count]==0) {
            [[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please add atleast one contact." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        }
        else{
           [[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please select notification settings to send notifications." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        }
    }
    
    }


@end
