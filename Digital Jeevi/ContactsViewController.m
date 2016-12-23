//
//  ContactsViewController.m
//  Digital Jeevi
//
//  Created by DevRabbit on 23/12/16.
//  Copyright © 2016 DevRabbit. All rights reserved.
//

#import "ContactsViewController.h"

@interface ContactsViewController ()
{
    NSMutableArray *aryDeviceContacts;
    NSMutableArray *filteredcontactsArray;
    NSDictionary *tempDict;
}
@property (weak, nonatomic) IBOutlet UITableView *myContactsTableView;
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    aryDeviceContacts = [[NSMutableArray alloc]init];
    [self InteractWithSystemContacts];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return aryDeviceContacts.count ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ContactsTableViewCell * cell = (ContactsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Contact" forIndexPath:indexPath];
    if (cell== nil)
    {
        cell = [[ContactsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Contact"];
        
    }
    NSLog(@"result:%@",aryDeviceContacts);
    tempDict = [aryDeviceContacts objectAtIndex:indexPath.row];
    cell.lblName.text = [tempDict valueForKey:@"contact_name"];
    cell.imgVwImage.image = [UIImage imageNamed:@"ic_picplaceholder.png"];
    cell.lblContactNumber.text =[tempDict  valueForKey:@"contact_mobile"];
    _myContactsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        return 100;
    }
    return  60;
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
