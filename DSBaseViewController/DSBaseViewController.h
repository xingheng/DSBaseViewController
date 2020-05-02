//
//  DSBaseViewController.h
//  youyue
//
//  Created by WeiHan on 12/3/15.
//  Copyright © 2015 DragonSource. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSBaseViewController;

typedef NSString *DSBaseViewControllerOptionKeyType;

FOUNDATION_EXPORT DSBaseViewControllerOptionKeyType const DSBaseViewControllerOptionBackgroundColor;
FOUNDATION_EXPORT DSBaseViewControllerOptionKeyType const DSBaseViewControllerOptionBackBarButtonImage;

typedef void (^AppearAnimationBlock)(BOOL animated);
typedef void (^AppearStateBlock)(BOOL appear, BOOL finished, BOOL animated, __kindof DSBaseViewController *controller);

typedef void (^LoadViewControllerBlock)(__kindof DSBaseViewController *controller);

#pragma mark - BuildViewDelegate

@protocol BuildViewDelegate <NSObject>

/**
 *    @brief Called when view controller is loaded, it'd better build subviews
 *      programmatically within it.
 *
 *    @param containerView  view controller's root view (self.view)
 *    @param viewController current view controller
 */
- (void)buildSubview:(UIView *)containerView controller:(DSBaseViewController *)viewController;

@optional

/**
 *    @brief This method is used to load data for viewController, it will be
 *      called when view controller is loaded and shouldInvalidateDataForController
 *      returns NO, or appeared with receiving memory warning state.
 *      DO NOT call this method directly.
 */
- (void)loadDataForController:(DSBaseViewController *)viewController;

/**
 *    @brief This method is used to unload data for viewController, it will be
 *      called when view controller is invisible and/or received some memory warnings.
 *      DO NOT call this method directly.
 */
- (void)tearDown:(DSBaseViewController *)viewController;

/**
 *    @brief This method will be called when not receiving memory warning state
 *      in viewWillAppear and viewDidLoad.
 *
 *    @return return YES will call method tearDown to unload data for viewController
 *      and loadDataForController to reload data for viewController, otherwise,
 *      nothing will be done.
 */
- (BOOL)shouldInvalidateDataForController:(DSBaseViewController *)viewController;

@end


#pragma mark - DSBaseViewController

@interface DSBaseViewController : UIViewController <BuildViewDelegate>

@property (nonatomic, weak) id<BuildViewDelegate> buildDelegate; // defaults to the instance of itself.

@property (nonatomic, assign, readonly) BOOL visible;

@property (nonatomic, copy) AppearStateBlock appearStateBlock;

+ (void)setupWithOptionBlock:(LoadViewControllerBlock)loadOptionBlock;

@end


@interface DSBaseViewController (NavigationController)

- (void)pushViewController:(UIViewController *)viewController; // with animation
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (__kindof UIViewController *)popCurrentViewController; // with animation

@end


// Should use this as base type for children view controllers.
typedef DSBaseViewController<BuildViewDelegate> DSBASEVIEWCONTROLLER;

/**
   Use for easy to copy

 #pragma mark - BuildViewDelegate

   - (void)buildSubview:(UIView *)containerView controller:(DSBaseViewController *)viewController
   {
   }

   - (void)loadDataForController:(DSBaseViewController *)viewController
   {
   }

   - (void)tearDown:(DSBaseViewController *)viewController
   {
   }

   - (BOOL)shouldInvalidateDataForController:(DSBaseViewController *)viewController
   {
       return NO;
   }

 **/
