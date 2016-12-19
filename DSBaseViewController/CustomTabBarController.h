//
//  CustomTabBarController.h
//  DragonSourceCommon
//
//  Created by WeiHan on 12/23/15.
//  Copyright © 2015 DragonSource. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBarController : UITabBarController

@property (nonatomic, copy) BOOL (^ shouldSelectViewControllerBlock)(NSInteger index, UIViewController *viewController);

@end
