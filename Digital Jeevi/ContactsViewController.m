//
//  ContactsViewController.m
//  Pinkflic
//
//  Created by Rabbit on 24/12/16.
//  Copyright © 2016 Rabbit          DevRabbit. All rights reserved.
//

#import "ContactsViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ContactTableViewCell.h"

#import "NormalActivitiesViewController.h"

@interface ContactsViewController ()
{
    
    NSMutableArray *aryDeviceContacts;
    NSMutableArray *filteredcontactsArray;
    NSDictionary *tempDict;
    NSMutableArray *contactsSelectedArray;
      NSArray *searchResults;
    BOOL isSearching;

   
    __weak IBOutlet UIView *vwBgSearch;
}
- (IBAction)backBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldSearch;


@property (weak, nonatomic) IBOutlet UITableView *myContactsTableView;
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isSearching = NO;
    _txtFieldSearch.delegate  = self;
    // Do any additional setup after loading the view from its nib.
    aryDeviceContacts = [[NSMutableArray alloc]init];
     contactsSelectedArray = [[NSMutableArray alloc]init];
    [self InteractWithSystemContacts];
    [_myContactsTableView registerNib:[UINib nibWithNibName:@"ContactTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"Contact"];
    searchResults = [[NSArray alloc]init];
    

}

-(void)viewWillAppear:(BOOL)animated{
    contactsSelectedArray  =[_alreadySelectedContacts mutableCopy];
   // aryDeviceContacts= [_alreadySelectedContacts mutableCopy];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnEdit:(UIButton *)sender {
  //  vwBgSearch.hidden = NO;
 //   isSearching = YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    isSearching = YES;
    
   // [_myContactsTableView reloadData];
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    //keyboard will hide
   
}
//
- (IBAction)serachTextAction:(UITextField *)sender {
    
    [self filterContentForSearchText:_txtFieldSearch.text];
   
}

- (IBAction)btnSearchTapped:(UIButton *)sender {
  [self filterContentForSearchText:_txtFieldSearch.text];
}

-(void)InteractWithSystemContacts
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ) {
        NSLog(@"system Version is equal to 9.0 or above");
        
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if( status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted)
        {
            NSLog(@"access denied");
        }
        else
        {
            //Create repository objects contacts
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            
            
            NSArray *keys = [[NSArray alloc]initWithObjects:CNContactIdentifierKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey, CNContactPhoneNumbersKey, CNContactViewController.descriptorForRequiredKeys, nil];
            
            // Create a request object
            CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
            request.predicate = nil;
            
            [contactStore enumerateContactsWithFetchRequest:request
                                                      error:nil
                                                 usingBlock:^(CNContact* __nonnull contact, BOOL* __nonnull stop)
             {
                 // Contact one each function block is executed whenever you get
                 NSString *phoneNumber = @"";
                 NSString *email = @"";
                 if( contact.phoneNumbers)
                     phoneNumber = [[[contact.phoneNumbers firstObject] value] stringValue];
                 email = [[contact.emailAddresses firstObject] value] ;
                 //  email = [contact.emailAddresses valueForKey:@"value"];
                 NSString *str = [NSString stringWithFormat:@"%@ %@",contact.givenName,contact.familyName];
                 NSDictionary *detailsNonSync= [[NSDictionary alloc]initWithObjectsAndKeys:str,@"contact_name",phoneNumber,@"contact_mobile",email,@"contact_email",   nil];
                 NSLog(@"dict = %@", detailsNonSync);
                 
                 
                 [aryDeviceContacts addObject:detailsNonSync];
                 NSLog(@"res:%@",aryDeviceContacts);
                 
             }];
        }
        
    }
    else
    {
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        
        if (status == kABAuthorizationStatusDenied || status == kABAuthorizationStatusRestricted)
        {
            
        }
        
        CFErrorRef error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
        
        if (!addressBook) {
            NSLog(@"ABAddressBookCreateWithOptions error: %@", CFBridgingRelease(error));
            return;
        }
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (error) {
                NSLog(@"ABAddressBookRequestAccessWithCompletion error: %@", CFBridgingRelease(error));
            }
            
            if (granted) {
                // if they gave you permission, then just carry on
                
                [self listPeopleInAddressBook:addressBook];
            }
            else
            {
                // however, if they didn't give you permission, handle it gracefully, for example...
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // BTW, this is not on the main thread, so dispatch UI updates back to the main queue
                    
                    [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                });
            }
            CFRelease(addressBook);
        });
        NSLog(@"contactscount:%@",aryDeviceContacts);
    }
}

- (void)listPeopleInAddressBook:(ABAddressBookRef)addressBook
{
    NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    NSInteger numberOfPeople = [allPeople count];
    
    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = (__bridge ABRecordRef)allPeople[i];
        
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSLog(@"Name:%@ %@", firstName, lastName);
        
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSString *phoneNumber;
        CFIndex numberOfPhoneNumbers = ABMultiValueGetCount(phoneNumbers);
        for (CFIndex i = 0; i < numberOfPhoneNumbers; i++) {
            phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, i));
            NSLog(@"  phone:%@", phoneNumber);
        }
        NSString *email = @"";
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(person, kABPersonEmailProperty);
        if(ABMultiValueGetCount(eMail) > 0) {
            email = [NSString stringWithFormat:@"%@",ABMultiValueCopyValueAtIndex(eMail, 0)];
        }
        
        NSString *str = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
        NSDictionary *detailsNonSync = [[NSDictionary alloc]initWithObjectsAndKeys:str,@"contact_name",phoneNumber,@"contact_mobile",email,@"contact_email", nil];
        [aryDeviceContacts addObject:detailsNonSync];
        NSLog(@"dict = %@", detailsNonSync);
        CFRelease(phoneNumbers);
    }
}

#pragma tableViewMethods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearching ) {
        return [searchResults count];
        
    } else {
      return aryDeviceContacts.count ;
        
    }

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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   // ContactTableViewCell * cell = (ContactTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    ContactTableViewCell * cell = (ContactTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell" owner:self options:nil] objectAtIndex:0];
    cell.btnImage.tag =indexPath.row;
    
    if (cell ==nil) {
                [[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell" owner:self options:nil];
    }
    NSLog(@"result:%@",aryDeviceContacts);
    if (isSearching) {
        tempDict = [searchResults objectAtIndex:indexPath.row];

    }else{
    tempDict = [aryDeviceContacts objectAtIndex:indexPath.row];
    }
    

    cell.lblName.text = [tempDict valueForKey:@"contact_name"];
  //  cell.btnImage.image = [UIImage imageNamed:@"ic_picplaceholder.png"];
    
    [cell.btnImage addTarget:self action:@selector(checkBoxButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
 
    for (NSDictionary * contactsDict in contactsSelectedArray) {
       // NSString * contact = [[tempDict  valueForKey:@"contact_mobile"] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        
        if (indexPath.row ==1) {
            
            NSLog(@"IndexPath %@",indexPath);
        }
        if ([[contactsDict objectForKey:@"contact_mobile"]isEqualToString:[tempDict  valueForKey:@"contact_mobile"]]) {
            
           
            [cell.btnImage setImage:[UIImage imageNamed:@"Checkbox_selected.png"] forState:UIControlStateNormal];
            [cell.btnImage setSelected:YES];
        }
    }

    cell.lblPhoneNumber.text =[tempDict  valueForKey:@"contact_mobile"];
    //_myContactsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myContactsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    

return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(NSMutableArray *)predicateloctionsArray:(NSMutableArray *)serviceArray withPredicateArray:(NSMutableArray * )selectedArray {
    
    
    NSMutableArray * array = [serviceArray mutableCopy];
    
    for (NSString * str in selectedArray) {
        NSPredicate *bPredicate =
        [NSPredicate predicateWithFormat:@"contact_name contains  %@",str];
        
        NSArray * predicatedArray =  [array filteredArrayUsingPredicate:bPredicate];
        for (NSDictionary * predicateDict in predicatedArray) {
            [array removeObject:predicateDict];
        }
        
    }
    return array;
    
    
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    if ([searchText isEqualToString:@""]) {
        searchResults =[aryDeviceContacts mutableCopy];
        return;
    }
    
    [searchText caseInsensitiveCompare:searchText];
    NSArray *data = [NSArray arrayWithObject:[NSMutableDictionary dictionaryWithObject:searchText forKey:@"contact_name"]];
    NSArray *filtered = [data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(contact_name == %@)", searchText]];
    
    
    NSLog(@"%@", filtered);
     NSPredicate *p = [NSPredicate predicateWithFormat:
                      @"contact_name CONTAINS[cd] %@",searchText];
   searchResults = [aryDeviceContacts filteredArrayUsingPredicate:p];
      [_myContactsTableView reloadData];
    
    
    

}





-(IBAction)checkBoxButtonClicked:(UIButton *)sender
{
    
    
   sender.selected = !sender.selected;
    
 
        
 
  
    if (sender.selected) {

                 if ([contactsSelectedArray count] ==10)
                 {
                    // [sender setSelected:NO];

                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Can't add more than 10 contacts" delegate:@"self" cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
                return;
                 }

            [sender setImage:[UIImage imageNamed:@"Checkbox_selected.png"] forState:UIControlStateNormal];
        //[sender setSelected:NO];
        
        [contactsSelectedArray addObject:(isSearching)?[searchResults objectAtIndex:sender.tag]:[aryDeviceContacts objectAtIndex:sender.tag]];

              }
    else
    {
        
        [sender setImage:[UIImage imageNamed:@"Checkbox_unselected.png"] forState:UIControlStateNormal];
        NSDictionary  * dict =(isSearching)?[searchResults objectAtIndex:sender.tag]:[aryDeviceContacts objectAtIndex:sender.tag];
        [contactsSelectedArray removeObject:dict];
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     {
            return 67;
        }
}

-(IBAction)doneButtonTapped:(UIButton *)sender
{
    if (![contactsSelectedArray count] ) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select atleast one contact" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSLog(@"array %@",contactsSelectedArray);
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"TestNotification"
     object:contactsSelectedArray];
    
   

    [self dismissViewControllerAnimated:YES completion:^{
            
    }];
   
    
    
   
 //   NormalActivitiesViewController *controller = [[NormalActivitiesViewController alloc] loade];
   // controller.arrayNormal = contactsSelectedArray;//the array you want to pass
   // [self.navigationController pushViewController:controller animated:YES];

}


- (IBAction)backBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
