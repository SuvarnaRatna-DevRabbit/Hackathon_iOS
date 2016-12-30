//
//  ContactTableViewCell.h
//  Pinkflic
//
//  Created by Rabbit on 24/12/16.
//  Copyright © 2016 Rabbit          DevRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;

@end
