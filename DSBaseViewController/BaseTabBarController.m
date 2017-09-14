//
//  BaseTabBarController.m
//  DragonSourceCommon
//
//  Created by WeiHan on 12/23/15.
//  Copyright © 2015 DragonSource. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()<UITabBarControllerDelegate>

@end

@implementation BaseTabBarController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.tabBar.translucent = NO;
        self.delegate = self;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (self.shouldSelectViewControllerBlock) {
        NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
        return self.shouldSelectViewControllerBlock(index, viewController);
    }

    return YES;
}

@end
