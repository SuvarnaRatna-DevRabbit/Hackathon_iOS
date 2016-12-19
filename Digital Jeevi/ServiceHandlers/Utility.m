//
//  Utility.m
//  side menu
//
//  Created by Suvarna Ratna on 01/04/16.
//  Copyright (c) 2016 Logictree. All rights reserved.
//

#import "Utility.h"

@implementation Utility
static Utility *util;

+(Utility*)shareHodler
{
    if(util == nil)
    {
        util = [[Utility alloc] init];
        
        return util;
    }
    return util;
}

-(id)init
{
    if(self == nil)
    {
        self = [super init];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeNavigationController) name:@"removeNavigationController" object:nil];
    
    return self;
}

-(void)showRightMenu:(UIViewController*)rightMenuController onController:(UIViewController*)baseController
{
    rightNavController.view.frame = CGRectMake(0,0, APP_DELEGATE.window.frame.size.width,  APP_DELEGATE.window.frame.size.height);
    [self removeNavigationController];
    rightNavController= [[UINavigationController alloc]initWithRootViewController:rightMenuController];
    [baseController addChildViewController:rightNavController];
    [baseController.view addSubview:rightNavController.view];
    [UIView animateWithDuration:0.5 animations:^{
    } completion:^(BOOL finished)
     {
         rightNavController.view.frame = CGRectMake(0, 0, APP_DELEGATE.window.frame.size.width,  APP_DELEGATE.window.frame.size.height);
     }];
    
}
-(void)removeNavigationController
{
    rightNavController.view = nil;
    rightNavController = nil;
}


@end
