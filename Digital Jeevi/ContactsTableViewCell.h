//
//  ContactsTableViewCell.h
//  Digital Jeevi
//
//  Created by Rabbit on 23/12/16.
//  Copyright © 2016 DevRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgVwImage;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblContactNumber;

@end
