//
//  NormalActivityTableViewCell.h
//  Pinkflic
//
//  Created by Rabbit on 24/12/16.
//  Copyright © 2016 Rabbit          DevRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtnOutLet;

@end
