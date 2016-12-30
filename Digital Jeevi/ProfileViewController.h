//
//  ProfileViewController.h
//  Sample
//
//  Created by Rabbit on 23/12/16.
//  Copyright © 2016 Rabbit          DevRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property NSString * counrtyCode;
@property NSString * phoneNumber;
@property NSString * iSFromEdit;

@end
