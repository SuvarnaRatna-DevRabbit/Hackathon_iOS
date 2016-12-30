//
//  VerificationViewController.h
//  Digital Jeevi
//
//  Created by DevRabbit on 23/12/16.
//  Copyright © 2016 DevRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerificationViewController : UIViewController<UITextFieldDelegate>

@property NSString * verificationCode;
@property NSDictionary * requestDict;
@property NSString * isFromEdit;

@end
