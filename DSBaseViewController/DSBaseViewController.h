//
//  DSBaseViewController.h
//  youyue
//
//  Created by WeiHan on 12/3/15.
//  Copyright © 2015 DragonSource. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef LOG_MACRO
    #define DDLogError(frmt, ...)   NSLog(frmt, ## __VA_ARGS__)
    #define DDLogWarn(frmt, ...)    NSLog(frmt, ## __VA_ARGS__)
    #define DDLogInfo(frmt, ...)    NSLog(frmt, ## __VA_ARGS__)
    #define DDLogDebug(frmt, ...)   NSLog(frmt, ## __VA_ARGS__)
    #define DDLogVerbose(frmt, ...) NSLog(frmt, ## __VA_ARGS__)
#endif


#define InitForViewController(__statement__)                                                     \
    - (instancetype)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil \
    {                                                                                            \
        if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {                 \
            {                                                                                    \
                __statement__                                                                    \
            }                                                                                    \
        }                                                                                        \
        return self;                                                                             \
    }

typedef NSString * DSBaseViewControllerOptionKeyType;

FOUNDATION_EXPORT DSBaseViewControllerOptionKeyType const DSBaseViewControllerOptionBackgroundColor;
FOUNDATION_EXPORT DSBaseViewControllerOptionKeyType const DSBaseViewControllerOptionBackBarButtonImage;

typedef void (^AppearAnimationBlock)(BOOL);

@class DSBaseViewController;


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
 *      called when view controller is invisible and received some memory warnings.
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

@interface DSBaseViewController : UIViewController

@property (nonatomic, assign, readonly) BOOL visible;

@property (nonatomic, copy) AppearAnimationBlock willAppearBlock;
@property (nonatomic, copy) AppearAnimationBlock didAppearBlock;
@property (nonatomic, copy) AppearAnimationBlock willDisappearBlock;
@property (nonatomic, copy) AppearAnimationBlock didDisappearBlock;

- (void)pushViewController:(UIViewController *)viewController; // with animation
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (UIViewController *)popCurrentViewController; // with animation

+ (void)setupWithOption:(NSDictionary<DSBaseViewControllerOptionKeyType, id> *)options;

@end


// Should use this as base type for children view controllers.
typedef DSBaseViewController<BuildViewDelegate>   DSBASEVIEWCONTROLLER;


#ifdef DS_SHORTHAND
typedef DSBaseViewController                      BaseViewController;
typedef DSBASEVIEWCONTROLLER                      BASEVIEWCONTROLLER;

/**
   Use for easy to copy

 #pragma mark - BuildViewDelegate

   - (void)buildSubview:(UIView *)containerView controller:(BaseViewController *)viewController
   {
   }

   - (void)loadDataForController:(BaseViewController *)viewController
   {
   }

   - (void)tearDown:(BaseViewController *)viewController
   {
   }

   - (BOOL)shouldInvalidateDataForController:(BaseViewController *)viewController
   {
       return NO;
   }

 **/

#else

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

#endif
