//
//  CustomNavigationController.m
//  youyue
//
//  Created by WeiHan on 12/3/15.
//  Copyright © 2015 DragonSource. All rights reserved.
//
//  Solution fix for custom left navigation bar disabled back swipe gesture:
//      http://keighl.com/post/ios7-interactive-pop-gesture-custom-back-button/
//      http://stackoverflow.com/questions/19054625/changing-back-button-in-ios-7-disables-swipe-to-navigate-back/20330647#20330647
//      http://www.cnblogs.com/angzn/p/3696901.html
//  References in future:
//      https://github.com/fastred/AHKNavigationController
//

#import "CustomNavigationController.h"

#define InteractivePopGesture 1 // hack!

#pragma mark - CustomNavigationController

@interface CustomNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation CustomNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self.enableInteractivePopGesture = YES;

    if (self = [super initWithRootViewController:rootViewController]) {
        // make the content views' vertical offset in view controller starts from navigation bar's bottom instead of top screen.
        self.navigationBar.translucent = NO;
        self.delegate = self;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

#if InteractivePopGesture

    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
    }

#endif
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
#if InteractivePopGesture
    [self setInteractivePopGestureState:NO];
#endif

    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }

    [super pushViewController:viewController animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.interactivePopGestureRecognizer.delegate = nil;
    self.delegate = nil;
}

#pragma mark - Public

- (__kindof UIViewController *)popToViewControllerClass:(Class)viewControllerClass animated:(BOOL)animated
{
    NSParameterAssert(viewControllerClass && [viewControllerClass isSubclassOfClass:[UIViewController class]]);

    NSArray<UIViewController *> *vcs = self.viewControllers;
    __block UIViewController *resultVC = nil;

    [vcs enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
        if ([viewController isKindOfClass:viewControllerClass]) {
            resultVC = viewController;
            *stop = YES;
        }
    }];

    if (resultVC) {
        [super popToViewController:resultVC animated:animated];
    }

    return resultVC;
}

#pragma mark - Private

#if InteractivePopGesture

- (void)setInteractivePopGestureState:(BOOL)state
{
    if (!self.enableInteractivePopGesture) {
        state = NO;
    }

    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = state;
    }
}

#endif

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
#if InteractivePopGesture
    // Enable the gesture again once the new controller is shown except for root view controller.
    [self setInteractivePopGestureState:navigationController.viewControllers.count > 1];
#endif
}

@end


#pragma mark - DSBaseViewController (Navigation)

@implementation DSBaseViewController (Navigation)

- (__kindof UIViewController *)popToViewController:(Class)viewControllerClass
{
    return [self popToViewController:viewControllerClass animated:YES];
}

- (__kindof UIViewController *)popToViewController:(Class)viewControllerClass animated:(BOOL)animated
{
    NSParameterAssert(viewControllerClass && [viewControllerClass isSubclassOfClass:[DSBaseViewController class]]);

    CustomNavigationController *naviVC = (CustomNavigationController *)self.navigationController;

    return [naviVC popToViewControllerClass:viewControllerClass animated:animated];
}

@end
