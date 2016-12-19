//
//  CustomNavigationController.h
//  youyue
//
//  Created by WeiHan on 12/3/15.
//  Copyright © 2015 DragonSource. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSBaseViewController.h"

@interface CustomNavigationController : UINavigationController

@property (nonatomic, assign) BOOL enableInteractivePopGesture; // default is YES

/**
 *    @brief    Pops view controllers until the specified view controller is at the top of the navigation stack. (UINavigationController -popToViewController:animated:)
 *
 *    @return   Return the top view controller after pop.
 */
- (UIViewController *)popToViewControllerClass:(Class)viewControllerClass animated:(BOOL)animated;

@end

@interface DSBaseViewController (Navigation)

- (UIViewController *)popToViewController:(Class)viewControllerClass; // with animation
- (UIViewController *)popToViewController:(Class)viewControllerClass animated:(BOOL)animated;

@end
