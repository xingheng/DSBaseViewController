//
//  BaseTabBarController.h
//  DragonSourceCommon
//
//  Created by WeiHan on 12/23/15.
//  Copyright © 2015 DragonSource. All rights reserved.
//

#import "DSPublicController.h"

@interface BaseTabBarController : BASETABBARCONTROLLER

@property (nonatomic, copy) BOOL (^ shouldSelectViewControllerBlock)(NSInteger index, UIViewController *viewController);

@end
