//
//  BaseNavigationController.h
//  youyue
//
//  Created by WeiHan on 12/3/15.
//  Copyright © 2015 DragonSource. All rights reserved.
//

#import "DSBaseViewController.h"

@interface BaseNavigationController : UINavigationController

@property (nonatomic, assign) BOOL enableInteractivePopGesture; // default is YES

/**
 *    @brief    Pops view controllers until the specified view controller is at the top of the navigation stack. (UINavigationController -popToViewController:animated:)
 *
 *    @return   Return the top view controller after pop.
 */
- (__kindof UIViewController *)popToViewControllerClass:(Class)viewControllerClass animated:(BOOL)animated;

@end

@interface DSBaseViewController (Navigation)

- (__kindof UIViewController *)popToViewController:(Class)viewControllerClass; // with animation
- (__kindof UIViewController *)popToViewController:(Class)viewControllerClass animated:(BOOL)animated;

@end
