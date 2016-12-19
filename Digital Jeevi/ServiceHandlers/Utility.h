//
//  Utility.h
//  side menu
//
//  Created by Suvarna Ratna on 01/04/16.
//  Copyright (c) 2016 Logictree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject
{
    UINavigationController * rightNavController;
}
+(Utility*)shareHodler;
-(void)showRightMenu:(UIViewController*)rightMenuController onController:(UIViewController*)baseController;

@end
