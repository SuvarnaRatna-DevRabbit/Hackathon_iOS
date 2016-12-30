//
//  NormalActivitiesViewController.h
//  Pinkflic
//
//  Created by Rabbit on 24/12/16.
//  Copyright © 2016 Rabbit          DevRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIWrapper.h"

@interface NormalActivitiesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
//{
//    NSMutableArray *arrayNormal;
//}
@property(nonatomic, strong)NSMutableArray *arrayNormal;
@property NSMutableArray * contactsCarringArray;

@end
